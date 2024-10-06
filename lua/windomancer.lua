M = {}

M._state = {}

M.augroup = vim.api.nvim_create_augroup("windomancer", {
	clear = false,
})

local function get_buffer_offset()
	local number_width = vim.api.nvim_win_get_option(0, "numberwidth")
	-- local sign_column = vim.wo.signcolumn
	-- local sign_width = 0
	-- if sign_column == 'yes' then
	--   sign_width = 2
	-- elseif sign_column == 'auto' then
	--   sign_width = 2
	-- end

	-- local fold_width = vim.wo.foldcolumn
	--
	-- local total_offset = number_width + fold_width -- + sign_width
	return number_width
end

M.is_windo_window = function(win)
	if M._state[win] == nil then
		return false
	end

	return true
end

M.remove_buffer_from_windo = function(buf)
	for _, state in pairs(M._state) do
		local windomancer_bufs = state["bufs"]
		if windomancer_bufs ~= nil then
			for _, b in ipairs(windomancer_bufs) do
				if b.buf ~= nil then
					windomancer_bufs[buf] = nil
				end
			end
		end
	end
end

M.focus_buffer = function(focused_win_id, focused_buf_id)
	for win_id, state in pairs(M._state) do
		local windomancer_bufs = state["bufs"]
		if windomancer_bufs ~= nil then
			local is_focused_window = win_id == focused_win_id

			if is_focused_window then
				for _, b in ipairs(windomancer_bufs) do
					if b.buf == focused_buf_id then
						b["active"] = "focused"
					else
						b["active"] = "inactive"
					end
				end
			else
				for _, b in ipairs(windomancer_bufs) do
					if b["active"] == "focused" then
						b["active"] = "selected"
					end
				end
			end
		end
	end
end

M.move_buffer = function(from_win, to_win, buf)
	local previous_buffer = nil
	for win_id, state in pairs(M._state) do
		local windomancer_bufs = state["bufs"]
		if windomancer_bufs ~= nil then
			local is_from_window = win_id == from_win

			if is_from_window then
				for i, b in ipairs(windomancer_bufs) do
					if b.buf == buf then
						windomancer_bufs[i] = nil
						break
					end
					previous_buffer = b.buf
				end
			end
		end
	end

	if not previous_buffer then
		previous_buffer = vim.api.nvim_create_buf(true, false)
		M.add_buffer_to_window(from_win, previous_buffer, "dirtyfix/[Empty]")
	end

	local cursor = vim.api.nvim_win_get_cursor(from_win)
	vim.api.nvim_win_set_buf(from_win, previous_buffer)
	vim.api.nvim_win_set_buf(to_win, buf)
	vim.api.nvim_win_set_cursor(to_win, cursor)
end

M.add_buffer_to_window = function(win, buf, filename)
	if not vim.api.nvim_win_is_valid(win) then
		vim.notify("Window is not valid, cannot add buffer.", vim.log.levels.WARN)
		return
	end

	if not vim.api.nvim_buf_is_valid(buf) then
		vim.notify("Buffer is not valid, cannot add to window.", vim.log.levels.WARN)
		return
	end

	if not M.is_windo_window(win) then
		vim.notify("Window is not in windomancer, cannot add buffer to it", vim.log.levels.WARN)
		return
	end

	local windomancer_bufs = M._state[win]["bufs"]
	if windomancer_bufs == nil then
		vim.notify("Window bufs not found in win windomancer state. Cannot add buffer.", vim.log.levels.WARN)
		return
	end

	for _, b in ipairs(windomancer_bufs) do
		if b.buf == buf then
			-- buffer is already in window. Doing nothing
			return
		end
	end

	table.insert(M._state[win]["bufs"], { buf = buf, file = filename, active = "inactive" })
end

M.create = function()
	local win = vim.api.nvim_get_current_win()
	local buf = vim.api.nvim_get_current_buf()
	local filename = vim.api.nvim_buf_get_name(buf)
	M._state[win] = { bufs = {} }
	M.add_buffer_to_window(win, buf, filename)
	M.focus_buffer(win, buf)
	M.update()

	vim.api.nvim_create_autocmd("BufEnter", {
		pattern = "*",
		group = M.augroup,
		callback = function(evt)
			local evt_win = vim.api.nvim_get_current_win()
			if not M.is_windo_window(evt_win) then
				return
			end

			M.add_buffer_to_window(evt_win, evt.buf, evt.file)
			M.focus_buffer(evt_win, evt.buf)
			M.update()
		end,
	})

	vim.api.nvim_create_autocmd("BufModifiedSet", {
		pattern = "*",
		group = M.augroup,
		callback = function(evt)
			M.update()
		end,
	})

	vim.api.nvim_create_autocmd("BufWipeout", {
		pattern = "*",
		group = M.augroup,
		callback = function(evt)
			M.remove_buffer_from_windo(evt.buf)
			M.update()
		end,
	})

	vim.api.nvim_create_autocmd("WinEnter", {
		pattern = "*",
		group = M.augroup,
		callback = function(_)
			local entering_win = vim.api.nvim_get_current_win()
			local entering_buf = vim.api.nvim_get_current_buf()

			if M.is_windo_window(entering_win) then
				M.focus_buffer(entering_win, entering_buf)
				M.update()
			end
		end,
	})

	vim.api.nvim_create_autocmd("WinLeave", {
		pattern = "*",
		group = M.augroup,
		callback = function(_)
			local leaving_win = vim.api.nvim_get_current_win()

			if M.is_windo_window(leaving_win) then
				local called = false
				local win_new_cmd_id = vim.api.nvim_create_autocmd("WinNew", {
					pattern = "*",
					group = M.augroup,
					callback = function(_)
						called = true
						local new_win = vim.api.nvim_get_current_win()
						if not M.is_windo_window(new_win) then
							vim.wo[new_win].winbar = nil
						end
					end,
					once = true,
				})

				vim.defer_fn(function()
					if not called then
						vim.api.nvim_del_autocmd(win_new_cmd_id)
					end
				end, 200)
			end
		end,
	})
end

M.update = function()
	for win, state in pairs(M._state) do
		local offset = get_buffer_offset()
		local spaces = string.rep(" ", offset - 2)
		local winline = spaces

		for _, buf in ipairs(state["bufs"]) do
			if vim.api.nvim_buf_is_valid(buf.buf) then
				local filename = buf.file:match("^.+[\\/](.+)$")
				local is_modified = vim.api.nvim_buf_get_option(buf.buf, "modified")

				local tab = ""
				if is_modified then
					tab = tab .. " " .. filename .. " + "
				else
					tab = tab .. "  " .. filename .. " "
				end

				if buf.active == "inactive" then
					winline = winline .. "%#WindomancerInactive#" .. tab .. " "
				elseif buf.active == "selected" then
					winline = winline .. "%#WindomancerSelected#" .. tab .. "%#WindomancerInactive# "
				else
					winline = winline .. "%#WindomancerFocused#" .. tab .. "%#WindomancerInactive# "
				end
			else
				vim.notify("Bufs state broken: buf " .. buf.buf .. " is not valid", vim.log.levels.WARN)
			end
		end

		winline = winline .. "%#Normal#"

		vim.wo[win].winbar = winline
	end
end

M.reset = function()
	for win, _ in pairs(M._state) do
		vim.wo[win].winbar = nil
	end

	vim.api.nvim_clear_autocmds({
		event = "BufEnter",
		pattern = "*",
		group = M.augroup,
	})

	vim.api.nvim_clear_autocmds({
		event = "BufModifiedSet",
		pattern = "*",
		group = M.augroup,
	})

	M._state = {}
end

return M
