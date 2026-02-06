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
      for _, lang in ipairs(opts.ensure_installed) do
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
  -- {
  --   "nvim-treesitter/nvim-treesitter-textobjects",
  --   branch = "main",
  --   commit = "a0e182ae21fda68c59d1f36c9ed45600aef50311",
  --   dependencies = { "nvim-treesitter/nvim-treesitter" },
  --   init = function() vim.g.no_plugin_maps = true end,
  --   opts = {
  --     select = {
  --       enable = true,
  --       lookahead = true,
  --       include_surrounding_whitespace = false,
  --       keymaps = {
  --         ["ak"] = { query = "@block.outer", desc = "around block" },
  --         ["ik"] = { query = "@block.inner", desc = "inside block" },
  --         ["ac"] = { query = "@class.outer", desc = "around class" },
  --         ["ic"] = { query = "@class.inner", desc = "inside class" },
  --         ["a?"] = { query = "@conditional.outer", desc = "around conditional" },
  --         ["i?"] = { query = "@conditional.inner", desc = "inside conditional" },
  --         ["af"] = { query = "@function.outer", desc = "around function " },
  --         ["if"] = { query = "@function.inner", desc = "inside function " },
  --         ["ao"] = { query = "@loop.outer", desc = "around loop" },
  --         ["io"] = { query = "@loop.inner", desc = "inside loop" },
  --         ["aa"] = { query = "@parameter.outer", desc = "around argument" },
  --         ["ia"] = { query = "@parameter.inner", desc = "inside argument" },
  --       },
  --     },
  --   },
  --   config = function(_, opts)
  --     local select_map = function(key, query, desc)
  --       vim.keymap.set(
  --         { "v", "x", "o" },
  --         key,
  --         function() require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects") end,
  --         { desc = desc }
  --       )
  --     end
  --     for key, tbl in ipairs(opts.select.keymaps) do
  --       select_map(key, tbl.query, tbl.desc)
  --     end
  --     require("nvim-treesitter-textobjects").setup(opts)
  --   end,
  -- },
}
