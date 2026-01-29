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
  opts_extend = { "ensure_installed" },
  opts = {
    ensure_installed = {
      "go",
      "lua",
      "javascript",
      "scss",
      "typescript",
      "vim",
      "vue",
    },
  },
  config = function(_, opts)
    local TS = require "nvim-treesitter"
    local ensure_installed = {
      "go",
      "lua",
      "javascript",
      "scss",
      "typescript",
      "vim",
      "vue",
    }
    local installed = {}
    for _, lang in ipairs(TS.get_installed "parsers") do
      installed[lang] = true
    end
    local to_install = vim.tbl_filter(function(what)
      local lang = vim.treesitter.language.get_lang(what)
      if lang == nil or installed[lang] == nil then return true end
      return false
    end, ensure_installed)
    if #to_install > 0 then TS.install(to_install) end

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
      callback = ts_start,
      group = vim.api.nvim_create_augroup("treesitter", {}),
    })
  end,
}
