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
        },
        highlight = {
            search = "DiffChange",
            replace = "DiffAdd"
        },

      }

    end
  }

return M
