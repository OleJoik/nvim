
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.o.clipboard = "unnamedplus"

require("globals")



local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end


vim.opt.rtp:prepend(lazypath)

require('lazy').setup({

  "tpope/vim-fugitive",
  'Mofiqul/vscode.nvim',
  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    }
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
    },
  },


  "mg979/vim-visual-multi",

  "nvim-pack/nvim-spectre",

  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end
  },

  {
    "windwp/nvim-ts-autotag",
    config = function()
      require('nvim-ts-autotag').setup()
    end
  },

  "nvimtools/none-ls.nvim",

  -- deletes buffers without fucking up the window layout
  'famiu/bufdelete.nvim',

  "sindrets/diffview.nvim",
  "petertriho/nvim-scrollbar",

  { import = "package" },

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  "yamatsum/nvim-cursorline",
}, {})



-- Setup neovim lua configuration
--

require('neodev').setup()


require("lsp")

require("scrollbar").setup()


require("play")
require("floating")

vim.api.nvim_create_autocmd("FileType", {
    pattern = "help",
    callback = function()
        vim.cmd("wincmd H")
        vim.cmd("vert resize 90")
    end,
})
require('nvim-cursorline').setup {
  cursorline = {
    enable = true,
    timeout = 300,
    number = false,
  },
  cursorword = {
    enable = true,
    min_length = 3,
    hl = { underline = true },
  }
}
