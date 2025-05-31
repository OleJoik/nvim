vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.cursorline = true

vim.o.tabstop = 4      -- Set the width of a tab to 4 spaces
vim.o.shiftwidth = 4   -- Set the width of an indent to 4 spaces
vim.o.expandtab = true -- Convert tabs to spaces
vim.wo.number = true

vim.o.clipboard = "unnamedplus"

vim.o.mouse = "a"

-- Winbar set with autocommand instead, to avoid settings it for neotree, terminals, etc
-- vim.o.winbar =

vim.o.undofile = true

vim.cmd([[
    highlight NonText guifg=#3c3c3c gui=nocombine
]])

vim.cmd([[
    highlight Whitespace guifg=#3c3c3c gui=nocombine
]])

vim.opt.list = true
vim.opt.listchars = { space = "·", eol = "↵", tab = "»·" }

vim.o.exrc = true
