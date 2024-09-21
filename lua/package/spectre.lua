M = {
    "nvim-pack/nvim-spectre",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require('spectre').setup{
        mapping = {
          ['run_replace'] = {
              map = "<C-r>",
              cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
              desc = "replace all"
          },
          ['toggle_ignore_case'] = {
            map = "I",
            cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
            desc = "toggle ignore case"
          },
          ['change_view_mode'] = {
              map = "t",
              cmd = "<cmd>lua require('spectre').change_view()<CR>",
              desc = "change result view mode"
          },
          ['toggle_ignore_hidden'] = {
            map = "H",
            cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
            desc = "toggle search hidden"
          },
        },
        highlight = {
            search = "DiffChange",
            replace = "DiffAdd"
        },

      }

    end
  }

return M
