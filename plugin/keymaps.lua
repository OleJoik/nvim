require("git_functions")

local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<C-a>", function()
	vim.api.nvim_exec("normal! ggVG", false)
end, { desc = "Select [A]ll" })

vim.keymap.set("n", "<C-BS>", "dvb")
vim.keymap.set("i", "<C-BS>", "<C-W>")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "J", "5jzz")
vim.keymap.set("n", "K", "5kzz")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", ">", ">>")
vim.keymap.set("n", "<", "<<")
vim.keymap.set("x", ">", ">gv")
vim.keymap.set("x", "<", "<gv")
-- map('n', '<C-l>', '<Cmd>BufferNext<CR>', opts)
-- map('n', '<C-h>', '<Cmd>BufferPrevious<CR>', opts)
-- map('n', '<C-<>', '<Cmd>BufferMovePrevious<CR>', opts)
-- map('n', '<C->>', '<Cmd>BufferMoveNext<CR>', opts)

vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<C-w>j', ':split<CR><C-w>j', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<C-w>l', ':vsplit<CR><C-w>l', { noremap = true, silent = true })

local close_window = function()
	-- local bbouncer = require("bufbouncer")
	-- local bbouncer_cmd = require("bufbouncer.commands")
	-- local win = vim.api.nvim_get_current_win()
	-- if bbouncer.is_bouncer_window(win) then
	-- 	bbouncer_cmd.close_win(win)
	-- else
	vim.cmd("q")
	-- end
end
vim.keymap.set("n", "<C-q>", close_window, { noremap = true, silent = true })

local close_buf = function()
	-- local bbouncer = require("bufbouncer")
	-- local commands = require("bufbouncer.commands")
	-- local win = vim.api.nvim_get_current_win()
	-- local buf = vim.api.nvim_get_current_buf()
	-- if bbouncer.is_bouncer_window(win) then
	-- 	commands.remove_buf_from_win(buf, win, { close_buffer_if_unused = true })
	-- else
	vim.cmd("Bwipeout")
	-- end
end
vim.keymap.set("n", "<C-x>", close_buf, opts)

-- vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "[P]aste without overwriting" })
-- vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "[Y]ank to clipboard" })
-- vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "[Y]ank line to clipboard" })
-- vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "[D]elete into the void" })
-- vim.keymap.set({ "n", "v" }, "<leader>v", '"+p', { desc = "[v] Paste from clipboard" })
vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
-- vim.keymap.set('n', '<leader>p', ':bprev<CR>')
-- vim.keymap.set('n', '<leader>n', ':bnext<CR>')
-- vim.keymap.set('n', '<leader>ga', Git_add, {desc='Treeview [G]it [A]dd'})
-- vim.keymap.set('n', '<leader>gr', Git_restore, {desc='Treeview [G]it [R]restore (Revert)'})
-- vim.keymap.set({ "n", "v" }, "<leader>go", ":DiffviewOpen<CR>", { desc = "[G]it [O]pen" })
-- vim.keymap.set({ "n", "v" }, "<leader>gc", ":DiffviewClose<CR>", { desc = "[G]it [C]lose" })
vim.keymap.set("n", "<C-g><C-l>", ":LazyGit<CR>", { desc = "[L]azygit" })
vim.keymap.set("n", "<leader>gf", ":LazyGitFilterCurrentFile<CR>", { desc = "[G]it commits in current [F]ile" })

-- vim.api.nvim_set_keymap("n", "<leader>ta", ":$tabnew<CR>", { noremap = true })
-- vim.api.nvim_set_keymap("n", "<leader>tc", ":tabclose<CR>", { noremap = true })
-- vim.api.nvim_set_keymap("n", "<leader>to", ":tabonly<CR>", { noremap = true })
-- vim.api.nvim_set_keymap("n", "<leader>tn", ":tabn<CR>", { noremap = true })
-- vim.api.nvim_set_keymap("n", "<leader>tp", ":tabp<CR>", { noremap = true })
-- -- move current tab to previous position
-- vim.api.nvim_set_keymap("n", "<leader>tmp", ":-tabmove<CR>", { noremap = true })
-- -- move current tab to next position
-- vim.api.nvim_set_keymap("n", "<leader>tmn", ":+tabmove<CR>", { noremap = true })

-- Removes the search highlight (but keeps the search on)
-- vim.api.nvim_set_keymap('n', '<ESC>', ':nohlsearch<CR>', { noremap = true, silent = true })
-- Search for whatever is selected
vim.api.nvim_set_keymap("v", "/", 'y/\\V<C-R>"<CR>', { noremap = true })
-- Clear search completely
vim.api.nvim_set_keymap("n", "<leader>/", ':let @/ = ""<CR>:nohlsearch<CR>', { noremap = true, desc = "[C]lear [/]" })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- vim.api.nvim_set_keymap("n", "<C-e>", ":NvimTreeFocus<CR>", {silent = true, noremap = true})
-- vim.api.nvim_set_keymap("n", "<leader>eq", ":NvimTreeToggle<CR>", {silent = true, noremap = true, desc="Toggle nvim filetree"})
-- vim.api.nvim_set_keymap("n", "<leader>ef", ":NvimTreeFindFile<CR>", {silent = true, noremap = true, desc="Find file in filetree"})

-- vim.api.nvim_set_keymap("n", "<C-e>", function() require("sidebar").open_explorer() end, { silent = true, noremap = true })

vim.api.nvim_set_keymap(
	"n",
	"<C-b>",
	":Neotree action=focus source=buffers position=right<CR>",
	{ silent = true, noremap = true }
)

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

vim.keymap.set("n", "<leader>md", ":MarkdownPreviewToggle<CR>", { desc = "Toggle [M]ark[D]own preview" })

-- vim.keymap.set('n', '<leader>dt', ":lua require('dap-python').test_method()<CR>", { desc = '[D]ebug [T]est' })
-- vim.keymap.set('n', '<leader>di', ":lua require('dap').step_into()<CR>", { desc = '[D]ebug step [I]nto' })
-- vim.keymap.set('n', '<leader>do', ":lua require('dap').step_over()<CR>", { desc = '[D]ebug step [O]ver' })
-- vim.keymap.set('n', '<leader>dl', ":lua require('dap.ext.vscode').load_launchjs(nil, {debugpy={'py'}})<CR>",
--   { desc = '[D]ebug [L]load config' })

vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww ~/scripts/tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>mx", "<cmd>!chmod +x %<CR>", { silent = true, desc = "[M]ake e[X]ecutable" })

vim.keymap.set("n", "<leader>rl", "<cmd>e<CR>", { desc = "Buffer [R]e[L]oad" })
vim.keymap.set(
	"n",
	"<leader>tp",
	"<cmd>lua require('test_picker').open_picker()<CR>",
	{ noremap = true, silent = true }
)

vim.keymap.set("n", "<C-e>", require("sidebar").open_explorer, { silent = true, noremap = true })
vim.keymap.set("n", "<C-g><C-o>", require("sidebar").open_git, { silent = true, noremap = true, desc = "[O]pen git" })
local search_replace = function()
	require("sidebar").open_spectre("")
end
vim.keymap.set("n", "<C-f>", search_replace, { silent = true, noremap = true })
vim.keymap.set("n", "<C-m>", require("sidebar").spectre_next, { silent = true, noremap = true })
vim.keymap.set("n", "<C-,>", require("sidebar").spectre_previous, { silent = true, noremap = true })

function RunFile()
	local filetype = vim.bo.filetype
	if filetype == "python" then
		vim.cmd("!python3 %")
	else
		vim.cmd("source %")
	end
end

vim.keymap.set("n", "<leader><leader>x", RunFile, { desc = "Execute the current file" })
vim.keymap.set("n", "<Tab>", ":b#<CR>", { noremap = true, silent = true })
