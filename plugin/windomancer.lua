vim.api.nvim_create_user_command("WindoCreate", function()
	require("windomancer").create()
end, {})

vim.api.nvim_create_user_command("WindoUpdate", function()
	require("windomancer").update()
end, {})

vim.api.nvim_create_user_command("WindoReset", function()
	require("windomancer").reset()
end, {})

vim.api.nvim_set_hl(0, "WindomancerInactive", { fg = "#938588", bg = "#282a43", bold = false })
vim.api.nvim_set_hl(0, "WindomancerSelected", { fg = "#1f1f1f", bg = "#5498D2", bold = true })
vim.api.nvim_set_hl(0, "WindomancerFocused", { fg = "#1f1f1f", bg = "#F79961", bold = true })

local move = function(dir)
	local windo = require("windomancer")
	local old_win = vim.api.nvim_get_current_win()
	local buf = vim.api.nvim_get_current_buf()

	vim.cmd("wincmd" .. dir)
	local new_win = vim.api.nvim_get_current_win()

	windo.move_buffer(old_win, new_win, buf)
	windo.focus_buffer(new_win, buf)
	windo.update()
end

vim.keymap.set("n", "<leader>l", function()
	move("l")
end)

vim.keymap.set("n", "<leader>k", function()
	move("k")
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>j", function()
	move("j")
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>h", function()
	move("h")
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>ws", function()
	local windo = require("windomancer")
	local output = vim.inspect(windo._state)
	windo.write_log(output)
	print(output)
end, { noremap = true, silent = true })
