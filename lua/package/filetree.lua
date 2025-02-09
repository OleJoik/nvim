function _G.get_oil_winbar()
  local cwd = vim.fn.getcwd()
  local cwd_basename = vim.fn.fnamemodify(cwd, ':t')
  local oil_path = vim.fn.expand('%:p'):gsub("^oil://", "")
  local rel_path = vim.fn.fnamemodify(oil_path, ':~:.')


  if not rel_path:match("^[/~]") and rel_path ~= "" then
    rel_path = "./" .. rel_path
  end
  if rel_path == '' or rel_path == '.' then
    rel_path = ''
  end

  return "[  " .. cwd_basename .. " ] " .. rel_path
end

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<C-e>", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        use_default_mappings = false,
        filesystem = {
          hijack_netrw_behaviour = "disabled",
          use_libuv_file_watcher = true,
          window = {
            position = "right",
            mappings = {
              ["<cr>"] = "open",
              ["<2-LeftMouse>"] = "open",
              ["a"] = "add",
              ["d"] = "delete",
              ["c"] = "copy_to_clipboard",
              ["x"] = "cut_to_clipboard",
              ["p"] = "paste_from_clipboard",
              ["r"] = "rename",
              ["f"] = "fuzzy_finder",
              ["?"] = "show_help",
              ["H"] = "toggle_hidden",
              ["y"] = {
                function(state)
                  local node = state.tree:get_node()
                  local filename = node.name
                  vim.fn.setreg("+", filename)
                  vim.notify("Copied: " .. filename)
                end,
                desc = "Yank name to clipboard",
              },
              ["Y"] = {
                function(state)
                  local node = state.tree:get_node()
                  local filepath = node:get_id()
                  vim.fn.setreg('+', filepath)
                  vim.notify("Copied: " .. filepath)
                end,
                desc = "Yank full path to clipboard",
              },
              ["<esc>"] = "cancel",
            },
          },
          follow_current_file = { enabled = false },
          filtered_items = {
            visible = false,
            show_hidden_count = true,
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_by_name = {
              ".git",
              ".next",
              "node_modules",
              "__pycache__",
              ".pytest_cache",
              ".venv",
              ".devenv",
              ".direnv",
              ".mypy_cache",
              ".ruff_cache",

              -- '.DS_Store',
              -- 'thumbs.db',
            },
            never_show = {},
          },
        },
        default_component_configs = {
          git_status = {
            symbols = {
              -- Change type
              added = "A",
              deleted = "D",
              modified = "M",
              renamed = "R",
              -- Status type
              untracked = "?",
              ignored = "!",
              unstaged = "U",
              staged = "A",
              conflict = "E",
            },
          },
          file_size = {
            enabled = false,
            -- required_width = 64, -- min width of window required to show this column
          },
          type = {
            enabled = false,
            -- required_width = 122, -- min width of window required to show this column
          },
          last_modified = {
            enabled = false,
            -- required_width = 88, -- min width of window required to show this column
          },
        },
      })
    end,
  },
  {
    "OleJoik/oil-git-status.nvim",
    branch = "fs-events",
    dependencies = {
      {
        'stevearc/oil.nvim',
        dependencies = {
          { "echasnovski/mini.icons", opts = {} },
        },
        config = function()
          require("oil").setup({
            default_file_explorer = true,
            skip_confirm_for_simple_edits = true,
            watch_for_changes = true,
            columns = {},
            keymaps = {
              ["g?"] = { "actions.show_help", mode = "n" },
              ["<CR>"] = "actions.select",
              ["<C-s>"] = { "actions.select", opts = { vertical = true } },
              ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
              ["<C-t>"] = { "actions.select", opts = { tab = true } },
              ["<C-p>"] = false,
              ["<C-c>"] = { "actions.close", mode = "n" },
              ["<C-l>"] = false,
              ["<C-r>"] = "actions.refresh",
              ["-"] = { "actions.parent", mode = "n" },
              ["_"] = { "actions.open_cwd", mode = "n" },
              ["`"] = { "actions.cd", mode = "n" },
              ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
              ["gs"] = false,
              ["gx"] = "actions.open_external",
              ["th"] = { "actions.toggle_hidden", mode = "n" },
              ["g\\"] = { "actions.toggle_trash", mode = "n" },
            },

            win_options = {
              winbar = " [g?] %{%v:lua.get_oil_winbar()%}",
              signcolumn = "yes:2",
              foldcolumn = "2",
              number = true
            },

          })

          vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
        end
      }
    },

    config = {
      watch_for_changes = true
    },
  },

}
