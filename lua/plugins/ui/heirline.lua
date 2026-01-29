return {
  -- heirline-components.nvim [ui components]
  -- https://github.com/Zeioth/heirline-components.nvim
  -- Collection of components to use on your heirline config.
  {
    "zeioth/heirline-components.nvim",
    opts = {},
  },
  {
    "rebelot/heirline.nvim",
    dependencies = { "zeioth/heirline-components.nvim" },
    opts = function()
      local lib = require "heirline-components.all"
      local hl = require "heirline-components.core.hl"
      local snacks = require "snacks"
      return {
        opts = {},
        tabline = {
          lib.component.tabline_conditional_padding(),
          lib.component.tabline_buffers {
            close_button = {
              hl = function(self) return hl.get_attributes(self.tab_type .. "_close") end,
              padding = { left = 1, right = 1 },
              on_click = {
                callback = function(_, bufnr)
                  if not bufnr or bufnr == 0 then bufnr = vim.api.nvim_get_current_buf() end
                  snacks.bufdelete()
                end,
                minwid = function(self) return self.bufnr end,
                name = "heirline_tabline_close_buffer_callback",
              },
            },
          },
          lib.component.fill { hl = { bg = "tabline_bg" } },
          lib.component.tabline_tabpages(),
        },
        winbar = {},
        statusline = {
          hl = { fg = "fg", bg = "bg" },
          lib.component.mode { mode_text = { pad_text = "center" } },
          lib.component.git_branch { git_branch = { icon = { kind = "GitBranch", padding = { right = 1 } } } },
          lib.component.file_info(),
          lib.component.git_diff(),
          lib.component.diagnostics(),
          lib.component.fill(),
          lib.component.cmd_info(),
          lib.component.fill(),
          lib.component.lsp(),
          lib.component.compiler_state(),
          lib.component.virtual_env(),
          lib.component.nav(),
          lib.component.mode { surround = { separator = "right" } },
        },
        statuscolumn = { -- UI left column
          init = function(self) self.bufnr = vim.api.nvim_get_current_buf() end,
          lib.component.foldcolumn(),
          lib.component.numbercolumn(),
          lib.component.signcolumn(),
        } or nil,
      }
    end,
    config = function(_, opts)
      local heirline = require "heirline"
      local heirline_components = require "heirline-components.all"

      -- Setup
      heirline_components.init.subscribe_to_events()
      heirline.load_colors(heirline_components.hl.get_colors())
      heirline.setup(opts)
    end,
  },
}
