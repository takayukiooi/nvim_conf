vim.keymap.set({ "n" }, "<Leader>/", "gcc", { remap = true })
vim.keymap.set({ "v", "x" }, "<Leader>/", "gc", { remap = true })

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
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
nmap_leader("gy", function() Snacks.gitbrowse.get_url() end, "Git URL")
nmap_leader("gg", function() Snacks.lazygit() end, "Lazygit")
-- Grep
nmap_leader("sB", function() Snacks.picker.grep_buffers() end, "Grep Open Buffers")
nmap_leader("sw", function() Snacks.picker.grep_word() end, "Visual selection or word")
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
nmap_leader("sk", function() Snacks.picker.keymaps() end, "Keymaps")
nmap_leader("sm", function() Snacks.picker.marks() end, "Marks")
nmap_leader("sq", function() Snacks.picker.qflist() end, "Quickfix List")
nmap_leader("su", function() Snacks.picker.undo() end, "Undo History")
-- Other
nmap_leader("c", function() Snacks.bufdelete() end, "Delete Buffer")
nmap_leader("lR", function() Snacks.rename.rename_file() end, "Rename File")
nmap_leader("un", function() Snacks.notifier.hide() end, "Dismiss All Notifications")

vim.keymap.set({ "n", "t" }, "]]", function() Snacks.words.jump(vim.v.count1) end, { desc = "Next Reference" })
vim.keymap.set({ "n", "t" }, "[[", function() Snacks.words.jump(-vim.v.count1) end, { desc = "Prev Reference" })
