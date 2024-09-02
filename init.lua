
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.o.clipboard = "unnamedplus"



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

print("hello")



vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
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

  {
      "ThePrimeagen/harpoon",
      branch = "harpoon2",
      dependencies = { "nvim-lua/plenary.nvim" }
  },
  "nvimtools/none-ls.nvim",

  -- deletes buffers without fucking up the window layout
  'famiu/bufdelete.nvim',

  "sindrets/diffview.nvim",
  "petertriho/nvim-scrollbar",

  { import = "package" },

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',
  'shaunsingh/nord.nvim',

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },
}, {})


require("setup.templ")

require("setup.colors")
require("setup.options")
require("setup.keymaps")


require("setup.yank-highlight")

require("setup.telescope")
require("setup.harpoon")

require("setup.treesitter")

-- Setup neovim lua configuration
require('neodev').setup()

require("lsp.setup_servers").setup_servers()

require("lsp.nvim-cmp")
require("lsp.null_ls")

require("setup.markdown-preview")

require("setup.noice")
require("scrollbar").setup()

