vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.clipboard = "unnamedplus"

require("globals")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ import = "package" },
}, {
	change_detection = {
		notify = false,
	},
	dev = {
		path = "~/repos/personal",
		patterns = { "OleJoik" },
		fallback = false,
	},
})

require("neodev").setup()

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

require("terminal").setup()
require("git_graph")
