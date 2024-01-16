M = {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup {
      view = {
        side = "right",
        width = 40
      },

      renderer = {
        icons = {
          git_placement = "after",
          modified_placement = "after",
          git = {
            unstaged  = "U",
            staged    = "A",
            unmerged  = "M",
            renamed   = "R",
            untracked = "?",
            deleted   = "D",
            ignored   = "!"
          }
        }
      },

      filters = {
        dotfiles = false
      },

      live_filter = {
        prefix = "[FILTER]: ",
        always_show_folders = false,
      },

      on_attach = function (bufnr)
        local api = require "nvim-tree.api"

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- api.config.mappings.default_on_attach(bufnr)
        vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
        vim.keymap.set('n', 'a', api.fs.create, opts('Create File Or Directory'))
        vim.keymap.set('n', 'd', api.fs.remove, opts('Delete'))
        vim.keymap.set('n', 'c', api.fs.copy.node, opts('Copy'))
        vim.keymap.set('n', 'x', api.fs.cut, opts('Cut'))
        vim.keymap.set('n', 'p', api.fs.paste, opts('Paste'))
        vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
        vim.keymap.set('n', 'f', api.live_filter.start, opts('Live Filter: Start'))
        vim.keymap.set('n', 'F', api.fs.copy.absolute_path, opts('Copy Absolute Path'))
        vim.keymap.set('n', 'b', api.tree.toggle_no_buffer_filter, opts('Toggle Buffer Filter'))

        vim.keymap.set('n', 'eq', api.tree.close, opts('Close'))
        vim.keymap.set('n', 'g?', api.tree.toggle_help, opts('Help'))
      end
    }

  end,
}

return M
