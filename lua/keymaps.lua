vim.keymap.set({ "n" }, "<Leader>/", "gcc", { remap = true })
vim.keymap.set({ "v", "x" }, "<Leader>/", "gc", { remap = true })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

--- @param lhs string
--- @param rhs string | function
--- @param desc string
local nmap = function(lhs, rhs, desc) vim.keymap.set("n", lhs, rhs, { desc = desc }) end
nmap("<C-h>", "<C-w><C-h>", "Move focus to the left window")
nmap("<C-l>", "<C-w><C-l>", "Move focus to the right window")
nmap("<C-j>", "<C-w><C-j>", "Move focus to the lower window")
nmap("<C-k>", "<C-w><C-k>", "Move focus to the upper window")

--- Navigate left and right by n places in the bufferline
---@param n integer The number of tabs to navigate to (positive = right, negative = left)
function nav(n)
  local current = vim.api.nvim_get_current_buf()
  for i, v in ipairs(vim.t.bufs) do
    if current == v then
      local new_buf = vim.t.bufs[(i + n - 1) % #vim.t.bufs + 1]
      if new_buf ~= current then vim.api.nvim_set_current_buf(new_buf) end
      return
    end
  end
end
nmap("<C-f>", function() nav(vim.v.count > 0 and vim.v.count or 1) end, "Next buffer")
nmap("<C-b>", function() nav(-(vim.v.count > 0 and vim.v.count or 1)) end, "Previous buffer")

--- @param suffix string
--- @param rhs string | function
--- @param desc string
local nmap_leader = function(suffix, rhs, desc) vim.keymap.set("n", "<Leader>" .. suffix, rhs, { desc = desc }) end

-- Top Pickers & Explorer
nmap_leader("n", function() Snacks.picker.notifications() end, "Notification History")
nmap_leader("e", function() Snacks.explorer() end, "File Explorer")
-- Buffer
nmap_leader("bb", function() Snacks.picker.buffers() end, "Buffers")
nmap_leader("br", function() Snacks.picker.recent() end, "Recent")
-- Diagnostic keymaps
nmap_leader("q", vim.diagnostic.setloclist, "Open diagnostic Quickfix list")
-- Git
nmap_leader("gB", function() Snacks.gitbrowse() end, "Git Browse")
nmap_leader("gg", function() Snacks.lazygit() end, "Lazygit")
-- LSP
nmap_leader("ln", vim.lsp.buf.rename, "Rename")
nmap_leader("la", vim.lsp.buf.code_action, "Code Action")
nmap_leader("ld", function() Snacks.picker.lsp_definitions() end, "Definition")
nmap_leader("lD", function() Snacks.picker.lsp_declarations() end, "Declaration")
nmap_leader("lr", function() Snacks.picker.lsp_references() end, "References")
nmap_leader("lI", function() Snacks.picker.lsp_implementations() end, "Implementation")
nmap_leader("ly", function() Snacks.picker.lsp_type_definitions() end, "Type Definition")
nmap_leader("li", function() Snacks.picker.lsp_incoming_calls() end, "Calls Incoming")
nmap_leader("lo", function() Snacks.picker.lsp_outgoing_calls() end, "Calls Outgoing")
nmap_leader("ls", function() Snacks.picker.lsp_symbols() end, "Symbols")
nmap_leader("lS", function() Snacks.picker.lsp_workspace_symbols() end, "Workspace Symbols")
-- Search
nmap_leader('s"', function() Snacks.picker.registers() end, "Registers")
nmap_leader("s/", function() Snacks.picker.search_history() end, "Search History")
nmap_leader("sa", function() Snacks.picker.autocmds() end, "Autocmds")
nmap_leader("sc", function() Snacks.picker.command_history() end, "Command History")
nmap_leader("sC", function() Snacks.picker.commands() end, "Commands")
nmap_leader("sd", function() Snacks.picker.diagnostics() end, "Diagnostics")
nmap_leader("sD", function() Snacks.picker.diagnostics_buffer() end, "Buffer Diagnostics")
nmap_leader("sf", function() Snacks.picker.files() end, "Files")
nmap_leader("sg", function() Snacks.picker.grep() end, "Grep")
nmap_leader("sG", function() Snacks.picker.grep_buffers() end, "Grep Open Buffers")
nmap_leader("sk", function() Snacks.picker.keymaps() end, "Keymaps")
nmap_leader("sm", function() Snacks.picker.marks() end, "Marks")
nmap_leader("sq", function() Snacks.picker.qflist() end, "Quickfix List")
nmap_leader("su", function() Snacks.picker.undo() end, "Undo History")
nmap_leader("sw", function() Snacks.picker.grep_word() end, "Visual selection or word")
-- Other
nmap_leader("c", function() Snacks.bufdelete() end, "Delete Buffer")
nmap_leader("lR", function() Snacks.rename.rename_file() end, "Rename File")
nmap_leader("un", function() Snacks.notifier.hide() end, "Dismiss All Notifications")

vim.keymap.set({ "n", "t" }, "]]", function() Snacks.words.jump(vim.v.count1) end, { desc = "Next Reference" })
vim.keymap.set({ "n", "t" }, "[[", function() Snacks.words.jump(-vim.v.count1) end, { desc = "Prev Reference" })

-- Sidekick
vim.keymap.set("n", "<tab>", function()
  if not require("sidekick").nes_jump_or_apply() then return "<Tab>" end
end, { expr = true, desc = "Goto/Apply Next Edit Suggestion" })
vim.keymap.set(
  { "n", "t", "i", "x" },
  "<c-.>",
  function() require("sidekick.cli").toggle() end,
  { desc = "Sidekick Toggle" }
)
nmap_leader("aa", function() require("sidekick.cli").toggle() end, "Sidekick Toggle CLI")
nmap_leader("as", function() require("sidekick.cli").select() end, "Select CLI")
nmap_leader("ad", function() require("sidekick.cli").close() end, "Detach a CLI Session")
vim.keymap.set(
  { "x", "n" },
  "<leader>at",
  function() require("sidekick.cli").send { msg = "{this}" } end,
  { desc = "Send This" }
)
nmap_leader("af", function() require("sidekick.cli").send { msg = "{file}" } end, "Send File")
vim.keymap.set(
  "x",
  "<leader>av",
  function() require("sidekick.cli").send { msg = "{selection}" } end,
  { desc = "Send Visual Selection" }
)
vim.keymap.set(
  { "n", "x" },
  "<leader>ap",
  function() require("sidekick.cli").prompt() end,
  { desc = "Sidekick Select Prompt" }
)
nmap_leader(
  "ac",
  function() require("sidekick.cli").toggle { name = "copilot", focus = true } end,
  "Sidekick Toggle Claude"
)

-- nmap_leader("st", function() require("terraform").terraform_state() end, "Terraform State")
-- nmap_leader("sp", function() require("picker").picker() end, "sample")
