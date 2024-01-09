-- for linux, do: xset r rate 200 30 

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


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
  {
    "kdheepak/lazygit.nvim",
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    }
  },

  "yamatsum/nvim-cursorline",
  "sindrets/diffview.nvim",
  "petertriho/nvim-scrollbar",

  require("package.noice"),

  require("package.nvim-tree"),


  require("package.barbar"),


  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  require("package.nvim-lspconfig"),
  require("package.nvim-cmp"),

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },

  require("package.gitsigns"),


  'Mofiqul/vscode.nvim',

  require("package.lualine"),
  require("package.markdown-preview"),

  require("package.indent-blankline"),

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  require("package.telescope"),
  require("package.treesitter"),

  require("package.debug")
}, {})




require("setup.colors")
require("setup.options")
require("setup.keymaps")


require("setup.yank-highlight")

require("setup.telescope")

require("setup.treesitter")

-- Setup neovim lua configuration
require('neodev').setup()

require("lsp.setup_servers").setup_servers()

require("lsp.nvim-cmp")

require("setup.markdown-preview")

require("setup.nvim-cursorline")

require("setup.noice")
require("setup.notify")

require("scrollbar").setup()
require('gitsigns').setup({})

require("dap-python").setup('~/.virtualenvs/debugpy/bin/python')
require('dap-python').test_runner = 'pytest'
