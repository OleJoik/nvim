local function get_basename(path)
	return path:match("^.+/(.+)$")
end

local function find_buffer_by_name(name)
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		local buf_name = vim.api.nvim_buf_get_name(buf)
		local bn = get_basename(buf_name)

		if bn == name then
			return buf
		end
	end
	return nil
end

local function make_buffer(name)
	local buf = find_buffer_by_name(name)

	if not buf then
		buf = vim.api.nvim_create_buf(true, true)
		vim.api.nvim_buf_set_name(buf, name)
	end
	vim.api.nvim_buf_set_option(buf, "modifiable", true)
	vim.api.nvim_buf_set_option(buf, "readonly", false)

	return buf
end

local function open_filediff(hash, file_name)
	-- local fm = "--git-dir ~/repos/work/field-manager-data-api/.git"

	-- local cmd1 = "git diff --color-words " .. hash .. "^ " .. hash .. " -- " .. file_name
	-- local output = vim.split(vim.fn.system(cmd1), "\n")
	vim.cmd("G diff " .. hash .. "^ " .. hash .. " -- " .. file_name)
	local win_id = vim.api.nvim_get_current_win()
	local buf_id = vim.api.nvim_get_current_buf()
	vim.cmd("wincmd p")

	local cursor = vim.api.nvim_win_get_cursor(0)
	local win_id2 = vim.api.nvim_open_win(buf_id, true, {
		relative = "win",
		width = 100,
		height = 30,
		bufpos = cursor,
		border = { "+", "-", "+", "|", "+", "-", "+", "|" },
	})
	vim.api.nvim_win_close(win_id, true)

	local function close_diff_view()
		if vim.api.nvim_win_is_valid(win_id2) then
			vim.api.nvim_win_close(win_id2, true)
		end
		if vim.api.nvim_buf_is_valid(buf_id) then
			vim.api.nvim_buf_delete(buf_id, { force = true })
		end
	end

	vim.keymap.set("n", "q", function()
		close_diff_view()
	end, { buffer = buf_id })
end

local function open_commit(hash, line, col)
	local cmd1 = "git --no-pager show " .. hash .. " -s"
	local cmd2 = "git diff-tree --no-commit-id --name-status " .. hash .. " -r"

	local output = vim.split(vim.fn.system(cmd1), "\n")
	local file_lines = vim.split(vim.fn.system(cmd2), "\n")

	for _, file_line in ipairs(file_lines) do
		table.insert(output, file_line)
	end

	local buf_id = make_buffer("[Commit " .. hash .. "]")
	vim.api.nvim_buf_set_lines(buf_id, 0, -1, true, output)
	vim.api.nvim_buf_set_option(buf_id, "modifiable", false)
	vim.api.nvim_buf_set_option(buf_id, "readonly", true)
	local min_width = 80

	local win_id = vim.api.nvim_open_win(buf_id, true, {
		relative = "win",
		width = min_width,
		height = 15,
		bufpos = { line, col },
		border = { "+", "-", "+", "|", "+", "-", "+", "|" },
	})
	vim.api.nvim_win_set_option(win_id, "wrap", true)
	vim.api.nvim_win_set_option(win_id, "linebreak", true)

	local function close_commit_window()
		if vim.api.nvim_win_is_valid(win_id) then
			vim.api.nvim_win_close(win_id, true)
		end
		if vim.api.nvim_buf_is_valid(buf_id) then
			vim.api.nvim_buf_delete(buf_id, { force = true })
		end
	end

	vim.keymap.set("n", "q", function()
		close_commit_window()
	end, { buffer = buf_id })

	vim.keymap.set("n", "<CR>", function()
		local file_line = vim.api.nvim_get_current_line()
		file_line = string.sub(file_line, 3)
		open_filediff(hash, file_line)
	end, { buffer = buf_id })

	-- vim.api.nvim_create_autocmd("WinLeave", {
	-- 	buffer = buf_id,
	-- 	once = true,
	-- 	callback = function()
	-- 		close_commit_window()
	-- 	end,
	-- })
end

local function open_graph()
	local buf1 = make_buffer("[Git Graph]")
	local buf2 = make_buffer("[Git Log]")

	vim.api.nvim_set_current_buf(buf1)
	vim.api.nvim_buf_set_option(buf1, "filetype", "terminal")
	vim.wo.concealcursor = "nc"
	vim.api.nvim_buf_set_option(buf1, "number", false)
	vim.api.nvim_buf_set_option(buf1, "relativenumber", false)
	vim.api.nvim_buf_set_option(buf1, "scrollbind", true)
	local win1 = vim.api.nvim_get_current_win()

	local lines = vim.split(vim.fn.system('git-graph --style round --format="" --color always -w none'), "\n")

	local log_lines = vim.split(
		vim.fn.system('git-graph --style round --format="X|;;|%H|;;|%as|;;|%cn|;;|%d" --color never -w none'),
		"\n"
	)

	for i, str in ipairs(log_lines) do
		for j = 1, #str do
			if string.sub(str, j, j) == "X" then
				log_lines[i] = string.sub(str, j)
				break
			end
		end
	end

	for i, str in ipairs(log_lines) do
		if string.sub(str, 1, 1) ~= "X" then
			log_lines[i] = ""
		end
	end

	local tree_width = 20

	vim.api.nvim_buf_set_lines(buf1, 0, -1, true, lines)
	vim.api.nvim_buf_set_lines(buf2, 0, -1, true, log_lines)
	local current_width = vim.api.nvim_win_get_width(0)
	vim.cmd("vsplit")
	vim.cmd("wincmd p")
	vim.api.nvim_win_set_width(0, tree_width)
	vim.cmd("normal! 0")

	vim.cmd("wincmd p")
	vim.api.nvim_set_current_buf(buf2)
	vim.api.nvim_win_set_width(0, current_width - tree_width - 1)
	vim.api.nvim_buf_set_option(buf2, "number", false)
	vim.api.nvim_buf_set_option(buf2, "relativenumber", false)
	vim.api.nvim_buf_set_option(buf2, "scrollbind", true)
	local win2 = vim.api.nvim_get_current_win()

	vim.keymap.set("n", "<CR>", function()
		local cursor = vim.api.nvim_win_get_cursor(0)
		local line = vim.api.nvim_get_current_line()
		line = string.sub(line, 2)

		local hash_id = string.match(line, "%w+")
		open_commit(hash_id, cursor[1], 10)
	end, { buffer = buf2 })

	vim.keymap.set("n", "q", function()
		if vim.api.nvim_win_is_valid(win1) then
			vim.api.nvim_win_close(win1, true)
		end

		if vim.api.nvim_buf_is_valid(buf1) then
			vim.api.nvim_buf_delete(buf1, { force = true })
		end
		if vim.api.nvim_buf_is_valid(buf2) then
			vim.api.nvim_buf_delete(buf2, { force = true })
		end
	end, { buffer = buf2 })
end

--
-- open_graph()
--
return {
	open_graph = open_graph,
}
