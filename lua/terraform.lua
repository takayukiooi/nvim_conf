local M = {}

---@param cmd table
---@return table: out, err
local function run_cmd(cmd)
  local result = vim.system(cmd, { text = true }):wait()
  local out = vim.fn.split(result.stdout, "\n")
  local err = vim.fn.split(result.stderr, "\n")
  return { out = out, err = err }
end

---@param text string
---@return table: path string, num number
local function find_resource(text)
  local address = vim.fn.split(text, "\\.")

  local resource = address[#address - 1]
  local name = string.gsub(address[#address], "%[.*%]", "")
  local pattern = string.format('%s" "%s', resource, name)
  local matches = run_cmd {
    "rg",
    pattern,
    vim.fn.getcwd(),
    "--color=never",
    "--with-filename",
    "--line-number",
    "--no-heading",
  }
  if #matches.out == 0 then
    Snacks.notify("No result in grep", "warn")
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
  local state = run_cmd { "terraform", "state", "list" }

  if #state.out == 0 then
    Snacks.notify("No resources found in terraform state", "warn")
    return
  end

  for i, line in ipairs(state.out) do
    table.insert(items, {
      idx = i,
      source = i,
      text = line,
    })
  end

  local cwd = vim.fn.expand "%:h"
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

      local res = find_resource(item.text)
      vim.api.nvim_command("e +" .. res.num .. " " .. res.path)
    end,
    preview = function(ctx)
      local res = find_resource(ctx.item.text)
      if not res.path then return false end

      ctx.item.file = res.path
      ctx.item.pos = { res.num, 0 }
      Snacks.picker.preview.file(ctx)

      return true
    end,
  }
end
return M
