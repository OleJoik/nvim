return {
  {
    'nvim-telescope/telescope.nvim',
    -- For path_display filename_first
    branch = 'master',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',

        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
      'mollerhoj/telescope-recent-files.nvim',
    },
    config = function()
      require('telescope').setup {
        pickers = {
          find_files = {
            theme = "ivy"
          }
        },
        extensions = {
          fzf = {},
        }
      }

      require('telescope').load_extension('fzf')
      require("telescope").load_extension("recent-files")

      vim.keymap.set("n", "<space>fh", function()
        require('telescope.builtin').help_tags(
          {
            layout_config = {
              width = { padding = 0 },
              height = { padding = 0 },
              prompt_position = "top",
              preview_width = 0.7,
              preview_cutoff = 50,
            },
            sorting_strategy = "ascending",
          })
      end
      )

      vim.keymap.set('n', '<C-p>', function()
        require('telescope').extensions['recent-files'].recent_files(require("telescope.themes").get_dropdown {
          layout_config = {
            prompt_position = "top",
            anchor = "N"
          },
          previewer = false,
          path_display = {
            filename_first = {
              reverse_directories = false
            }
          },
        })
      end, { noremap = true, silent = true })

      vim.keymap.set("n", "<C-f>", require("telescope.builtin").live_grep, { desc = "[F]ind by [G]rep" })
    end
  }
}
