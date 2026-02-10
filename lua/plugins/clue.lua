return {
  {
    "nvim-mini/mini.clue",
    version = false,
    opts = function(_, opts)
      local miniclue = require "mini.clue"
      opts.window = {
        delay = 200,
        config = {
          width = 50,
        },
      }
      opts.triggers = {
        -- Leader triggers
        { mode = { "n", "x" }, keys = "<Leader>" },

        -- `[` and `]` keys
        { mode = "n", keys = "[" },
        { mode = "n", keys = "]" },

        -- Built-in completion
        { mode = "i", keys = "<C-x>" },

        -- `g` key
        { mode = { "n", "x" }, keys = "g" },

        -- Marks
        { mode = { "n", "x" }, keys = "'" },
        { mode = { "n", "x" }, keys = "`" },

        -- Registers
        { mode = { "n", "x" }, keys = '"' },
        { mode = { "i", "c" }, keys = "<C-r>" },

        -- Window commands
        { mode = "n", keys = "<C-w>" },

        -- `z` key
        { mode = { "n", "x" }, keys = "z" },

        -- textobjects
        { mode = { "v", "x", "o" }, keys = "a", desc = "around" },
        { mode = { "v", "x", "o" }, keys = "i", desc = "inside" },
      }

      opts.clues = {
        -- Enhance this by adding descriptions for <Leader> mapping groups
        miniclue.gen_clues.square_brackets(),
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),

        -- AI CLI
        { mode = "n", keys = "<Leader>a", desc = "AI" },

        -- Buffer
        { mode = "n", keys = "<Leader>b", desc = "Buffer" },

        -- Git
        { mode = "n", keys = "<Leader>g", desc = "Git" },

        -- LSP
        { mode = "n", keys = "<Leader>l", desc = "LSP" },

        -- Search with Snacks.picker
        { mode = "n", keys = "<Leader>s", desc = "Search" },
      }
    end,
  },
}
