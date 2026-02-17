local M = {}

---@param cmd table
---@param cwd string?
---@return table: out, err
local function run_cmd(cmd, cwd)
  if cwd then vim.cmd("cd" .. cwd) end
  local result = vim.system(cmd, { text = true }):wait()
  local out = vim.fn.split(result.stdout, "\n")
  local err = vim.fn.split(result.stderr, "\n")
  return { out = out, err = err }
end

---@param text string
---@param cwd string?
---@return table: path string, num number
local function find_resource(text, cwd)
  local address = vim.fn.split(text, "\\.")

  local resource = address[#address - 1]
  local name = string.gsub(address[#address], "%[.*%]", "")
  local pattern = string.format('%s" "%s', resource, name)
  local matches = run_cmd {
    "rg",
    pattern,
    cwd or vim.fn.getcwd(),
    "--color=never",
    "--with-filename",
    "--line-number",
    "--no-heading",
  }
  if #matches.out == 0 then
    Snacks.notify.warn "No result in grep"
    return {}
  end

  local path
  local num
  for _, line in ipairs(matches.out) do
    path, num = line:match "(.*):(%d+):.*"
  end
  return { path = path, num = tonumber(num) }
end

function M.terraform_state()
  local picker = require "snacks.picker"

  ---@type snacks.picker.finder.Item[]
  local items = {}

  local cwd = vim.fn.expand "%:h"
  local state = run_cmd({ "terraform", "state", "list" }, cwd)

  if #state.err ~= 0 then
    for _, error in ipairs(state.err) do
      Snacks.notify.error(error)
    end
    return
  end

  if #state.out == 0 then
    Snacks.notify.warn "No resources found in terraform state"
    return
  end

  for i, line in ipairs(state.out) do
    table.insert(items, {
      idx = i,
      source = i,
      text = line,
    })
  end

  ---@type snacks.picker.Config
  picker.pick {
    source = "terraform",
    cwd = cwd,
    items = items,
    format = function(item, _)
      local ret = {}
      ret[#ret + 1] = { item.text }
      return ret
    end,
    confirm = function(pick, item)
      pick:close()
      if not item then return end

      local res = find_resource(item.text, cwd)
      vim.api.nvim_command("e +" .. res.num .. " " .. res.path)
    end,
    preview = function(ctx)
      local res = find_resource(ctx.item.text, cwd)
      if not res.path then return false end

      ctx.item.file = res.path
      ctx.item.pos = { res.num, 0 }
      Snacks.picker.preview.file(ctx)

      return true
    end,
  }
end
return M
