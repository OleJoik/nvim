return { {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
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
    vim.keymap.set("n", "<C-e>", function()
      vim.cmd("Neotree toggle")
    end
    )
  end,
},
  { {
    'stevearc/oil.nvim',
    dependencies = {
      { "echasnovski/mini.icons", opts = {} },

      -- {
      --   "refractalize/oil-git-status.nvim",
      --
      --   dependencies = {
      --     "stevearc/oil.nvim",
      --   },
      --
      --   config = function()
      --     require('oil-git-status').setup({
      --       show_ignored = true -- show files that match gitignore with !!
      --     })
      --   end,
      -- },
    },
    config = function()
      require("oil").setup({

        skip_confirm_for_simple_edits = true,
        keymaps = {
          ["g?"] = { "actions.show_help", mode = "n" },
          ["<CR>"] = "actions.select",
          ["<C-s>"] = { "actions.select", opts = { vertical = true } },
          ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
          ["<C-t>"] = { "actions.select", opts = { tab = true } },
          ["<C-p>"] = false,
          ["<C-c>"] = { "actions.close", mode = "n" },
          ["<C-l>"] = "actions.refresh",
          ["-"] = { "actions.parent", mode = "n" },
          ["_"] = { "actions.open_cwd", mode = "n" },
          ["`"] = { "actions.cd", mode = "n" },
          ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
          ["gs"] = false,
          ["gx"] = "actions.open_external",
          ["th"] = { "actions.toggle_hidden", mode = "n" },
          ["g\\"] = { "actions.toggle_trash", mode = "n" },
        }
      })

      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end
  },
  }
}
