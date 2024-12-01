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

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "help" },
	callback = function()
		local buf_help = vim.api.nvim_get_current_buf()
		local win_help = vim.api.nvim_get_current_win()

		vim.cmd("wincmd p")

		local win_old = vim.api.nvim_get_current_win()

		vim.api.nvim_win_set_buf(win_old, buf_help)
		vim.api.nvim_win_close(win_help, true)

		-- This doesnt quite work. Sometimes, the buffer is unlisted and I cannot close it.
		-- Check if maybe the contents can be loaded into a listed buffer first,
		-- And also scratch, perhaps. Checky checky.
	end,
})
