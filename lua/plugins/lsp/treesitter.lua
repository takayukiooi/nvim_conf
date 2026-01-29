-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  version = false,
  lazy = vim.fn.argc(-1) == 0, -- load treesitter immediately when opening a file from the cmdline
  dependencies = { { "nvim-treesitter/nvim-treesitter-textobjects", lazy = true } },
  cmd = {
    "TSInstall",
    "TSInstallFromGrammer",
    "TSUpdate",
    "TSUninstall",
    "TSLog",
  },
  build = ":TSUpdate",
  opts = {},
  init = function()
    local ensure_installed = {
      "go",
      "lua",
      "javascript",
      "scss",
      "typescript",
      "vim",
      "vue",
    }
    local isnt_installed = function(lang) return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0 end
    local to_install = vim.tbl_filter(isnt_installed, ensure_installed)
    if #to_install > 0 then require("nvim-treesitter").install(to_install) end

    -- Enable tree-sitter after opening a file for a target language
    local filetypes = {}
    for _, lang in ipairs(ensure_installed) do
      for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
        table.insert(filetypes, ft)
      end
    end
    local ts_start = function(ev) vim.treesitter.start(ev.buf) end
    vim.api.nvim_create_autocmd({ "FileType" }, {
      pattern = filetypes,
      callback = function(event) vim.treesitter.start() end,
      group = vim.api.nvim_create_augroup("treesitter", {}),
    })
  end,
}
