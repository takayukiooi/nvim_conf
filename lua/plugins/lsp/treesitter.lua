-- Customize Treesitter

return {
  ---@type LazySpec
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    branch = "main",
    lazy = false,
    cmd = {
      "TSInstall",
      "TSInstallFromGrammer",
      "TSUpdate",
      "TSUninstall",
      "TSLog",
    },
    build = ":TSUpdate",
    opts_extend = { "ensure_installed" },
    ---@class OTSConfig: TSConfig
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      folds = { enable = false },
      ensure_installed = {
        "go",
        "lua",
        "javascript",
        "scss",
        "typescript",
        "vim",
        "vue",
        "terraform",
        "ruby",
      },
    },
    ---@param opts OTSConfig: TSConfig
    config = function(_, opts)
      local TS = require "nvim-treesitter"
      local installed = {}
      for _, lang in ipairs(TS.get_installed "parsers") do
        installed[lang] = true
      end
      local to_install = vim.tbl_filter(function(what)
        local lang = vim.treesitter.language.get_lang(what)
        if lang == nil or installed[lang] == nil then return true end
        return false
      end, opts.ensure_installed)
      if #to_install > 0 then TS.install(to_install) end

      -- Enable tree-sitter after opening a file for a target language
      local filetypes = {}
      for lang, _ in pairs(installed) do
        for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
          table.insert(filetypes, ft)
        end
      end
      local ts_start = function(ev)
        if opts.highlight.enable then vim.treesitter.start() end
        if opts.indent.enable then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
        if opts.folds.enable then
          vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.wo[0][0].foldmethod = "expr"
        end
      end
      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = filetypes,
        callback = ts_start,
        group = vim.api.nvim_create_augroup("treesitter", {}),
      })
      TS.setup {}
    end,
  },
}
