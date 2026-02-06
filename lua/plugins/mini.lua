return {
  -- editor
  {
    "nvim-mini/mini.ai",
    version = false,
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    opts = function()
      local ai = require "mini.ai"
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        },
      }
    end,
  },
  { "nvim-mini/mini.pairs", version = false, opts = {} },
  { "nvim-mini/mini.surround", version = false, opts = {} },

  -- core
  { "nvim-mini/mini.bracketed", version = false, opts = {} },
  { "nvim-mini/mini.hipatterns", version = false, opts = {} },
  {
    "nvim-mini/mini.sessions",
    version = false,
    opts = {
      autowrite = true,
    },
  },
}
