M = {
    "nvim-pack/nvim-spectre",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require('spectre').setup{
        -- mapping={
        --   ['hello'] = {
        --     map = "<C-j>",
        --     cmd = "<cmd>lua require('spectre').resume_last_search()<CR>",
        --     desc = "repeat last search"
        --   }
        -- }
        highlight = {
            search = "DiffChange",
            replace = "DiffAdd"
        },

      }

    end
  }

return M
