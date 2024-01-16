return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup {
      close_if_last_window = true,
      use_default_mappings = false,
      filesystem = {
        window = {
          mappings = {
            ["<cr>"] = "open",
            ["a"] = "add",
            ["d"] = "delete",
            ["c"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["r"] = "rename",
            ["f"] = "fuzzy_finder",
            ["?"] = "show_help",
            ["y"] = {
              function(state)
                local node = state.tree:get_node()
                local filename = node.name
                vim.fn.setreg('+', filename)
                vim.notify("Copied: " .. filename)
              end,
              desc = "Yank name to clipboard"
            },
            ["Y"] = {
              function(state)
                local node = state.tree:get_node()
                local filepath = node:get_id()
                vim.fn.setreg('"', filepath)
                vim.notify("Copied: " .. filepath)
              end,
              desc = "Yank full path to clipboard"
            },
            ["<esc>"] = "cancel",
          },
      },
      follow_current_file = { enabled = true },
      hijack_netrw_behavior = "open_current",
     },
      buffers = {
        window = {
          mappings = {
            ["<cr>"] = "open",
            ["?"] = "show_help",
            ["q"] = {
              function(state)
                local content = state.tree:get_node()
                require('bufdelete').bufdelete(content.extra.bufnr)
                vim.notify('bufnr '..content.extra.bufnr..' deleted')
              end,
              desc = "buffer_delete"
            },
            ["r"] = "rename",
            ["y"] = {
              function(state)
                local node = state.tree:get_node()
                local filename = node.name
                vim.fn.setreg('+', filename)
                vim.notify("Copied: " .. filename)
              end,
              desc = "Yank name to clipboard"
            },
            ["Y"] = {
              function(state)
                local node = state.tree:get_node()
                local filepath = node:get_id()
                vim.fn.setreg('"', filepath)
                vim.notify("Copied: " .. filepath)
              end,
              desc = "Yank full path to clipboard"
            },
          }
        }
      },
      default_component_configs = {
        git_status = {
          symbols = {
            -- Change type
            added     = "A",
            deleted   = "D",
            modified  = "M",
            renamed   = "R",
            -- Status type
            untracked = "?",
            ignored   = "!",
            unstaged  = "U",
            staged    = "A",
            conflict  = "E",
          }
        }
      }
    }
  end
}


