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
      { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  },

  {
    "mg979/vim-visual-multi",
  },

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

  "yamatsum/nvim-cursorline",
  "sindrets/diffview.nvim",
  "petertriho/nvim-scrollbar",
  'theHamsta/nvim-dap-virtual-text',

  require("package.noice"),

  -- require("package.nvim-tree"),

  require("package.neo-tree"),

  -- require("package.barbar"),


  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  require("package.nvim-lspconfig"),
  require("package.nvim-cmp"),

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',  opts = {} },

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
require("lsp.null_ls")

require("setup.markdown-preview")

require("setup.nvim-cursorline")

require("setup.noice")
require("setup.notify")

require("scrollbar").setup()
require('gitsigns').setup({})

require("dap-python").setup('~/.virtualenvs/debugpy/bin/python')
require('dap-python').test_runner = 'pytest'
require("setup.dap")
require("nvim-dap-virtual-text").setup()
