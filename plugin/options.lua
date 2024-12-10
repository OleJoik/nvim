-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
--

-- Set highlight on search
--
vim.o.hlsearch = false
vim.o.tabstop = 4 -- Set the width of a tab to 4 spaces
vim.o.showtabline = 1
vim.o.shiftwidth = 4 -- Set the width of an indent to 4 spaces
vim.o.expandtab = true -- Convert tabs to spaces

vim.cmd([[
    highlight NonText guifg=#3c3c3c gui=nocombine
]])

vim.cmd([[
    highlight Whitespace guifg=#3c3c3c gui=nocombine
]])

vim.opt.list = true
vim.opt.listchars = { space = "·", eol = "↵" }

vim.opt.cursorline = true

-- Enable search highlighting
vim.o.hlsearch = true
vim.o.incsearch = true
-- Make line numbers default
-- vim.wo.number = true
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = "unnamedplus"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

vim.g.netrw_banner = 0
-- netrw_menu=0

-- use number column as signcolumn
-- vim.opt.signcolumn = "number"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- https://github.com/rmagatti/auto-session?tab=readme-ov-file#recommended-sessionoptions-config
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.exrc = true
