local log_file_path = vim.fn.stdpath("data") .. "/windomancer_logs.txt"
M = {}

local LogLevel = {
	DEBUG = 1,
	INFO = 2,
	WARN = 3,
	ERROR = 4,
}

local log_level_text = function(log_level)
	if log_level == 2 then
		return "INFO"
	elseif log_level == 3 then
		return "WARN"
	elseif log_level == 4 then
		return "ERROR"
	elseif log_level == 0 then
		return "DEBUG"
	end

	return ""
end

local code_log_level = LogLevel.INFO

M._state = {}

-- @param message string: The message to log.
-- @param log_level number: The log level (use LogLevel enum).
M.write_log = function(message, log_level)
	if log_level == nil then
		log_level = LogLevel.INFO
	end

	if log_level < code_log_level then
		return
	end

	local log_file = io.open(log_file_path, "a")

	if log_file then
		local time = os.date("%Y-%m-%d %H:%M:%S")
		log_file:write(string.format("[%s] %s: %s\n", time, log_level_text(log_level), message))
		log_file:close()
	end
end

local function error_handler(err)
	local trace = debug.traceback(tostring(err), 2)
	M.write_log(trace, LogLevel.ERROR)
	return trace
end

local function err_handler(fn)
	local success, result = xpcall(fn, error_handler)
	if not success then
		vim.notify(result, vim.log.levels.ERROR)
	end
end

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

M.bwipeout = function(buf)
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

M.close_win = function(win)
	local win_data = M._state[win]
	if win_data == nil then
		M.write_log("Attempted to close win " .. win .. " but it is not known to windomancer.", LogLevel.WARN)
		return
	end

	local bufs = win_data["bufs"]
	if bufs == nil then
		M.write_log("Attempted to close win " .. win .. " but could not find buffers.", LogLevel.WARN)
		return
	end

	local error_closing_buf = false
	for i, b in ipairs(bufs) do
		local window_buffers = vim.fn.win_findbuf(b.buf)
		if #window_buffers == 1 then
			M.write_log(
				"buf " .. b.buf .. " (" .. b.file .. ") is dangling after closing win " .. win .. ". Closing buf..."
			)

			local success, err = pcall(vim.api.nvim_buf_delete, b.buf, {})
			if not success and err ~= nil then
				M.write_log(err, LogLevel.ERROR)
				vim.notify(err, vim.log.levels.ERROR)
				error_closing_buf = true
			else
				win_data["bufs"][i] = nil
				M.write_log("Successfully closed buffer " .. b.buf)
			end
		end
	end

	if error_closing_buf then
		M.write_log("close_win had an error closing a buffer. Updating UI and returning.")
		M.update()
		return
	end

	M._state[win] = nil
	if vim.api.nvim_win_is_valid(win) then
		local success, err = pcall(vim.api.nvim_win_close, win, false)
		if not success and err ~= nil then
			M._state[win] = win_data
			vim.notify(err, vim.log.levels.ERROR)

			M.write_log("close_win had an error the window. Updating UI and returning.")
			M.update()
			return
		end
	else
		M.write_log("Attempted to close win " .. win .. ", but it is not a valid window.", LogLevel.WARN)
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

	M.write_log(string.format("Adding Buffer To Window - win: %s, file: %s", win, filename))

	table.insert(M._state[win]["bufs"], { buf = buf, file = filename, active = "inactive" })
end

M.create = function()
	local win = vim.api.nvim_get_current_win()
	local buf = vim.api.nvim_get_current_buf()
	local filename = vim.api.nvim_buf_get_name(buf)
	M.write_log("Creating Windo!: win: " .. win .. " buf: " .. buf .. " file: " .. filename)
	M._state[win] = { bufs = {} }
	if filename ~= "" then
		M.add_buffer_to_window(win, buf, filename)
		M.focus_buffer(win, buf)
		M.update()
	end
end

M.update = function()
	for win, state in pairs(M._state) do
		local offset = get_buffer_offset()
		local spaces = string.rep(" ", offset - 2)
		local winline = spaces .. win .. " "

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

-- M.reset = function()
-- 	for win, _ in pairs(M._state) do
-- 		vim.wo[win].winbar = nil
-- 	end
--
-- 	vim.api.nvim_clear_autocmds({
-- 		event = "BufEnter",
-- 		pattern = "*",
-- 		group = M.augroup,
-- 	})
--
-- 	vim.api.nvim_clear_autocmds({
-- 		event = "BufModifiedSet",
-- 		pattern = "*",
-- 		group = M.augroup,
-- 	})
--
-- 	M._state = {}
-- end

M.setup = function()
	vim.api.nvim_create_autocmd("VimEnter", {
		pattern = "*",
		group = M.augroup,
		callback = function(_)
			err_handler(function()
				M.write_log("VimEnter", LogLevel.INFO)
				M.create()
			end)
		end,
	})

	vim.api.nvim_create_autocmd("BufEnter", {
		pattern = "*",
		group = M.augroup,
		callback = function(evt)
			local evt_win = vim.api.nvim_get_current_win()
			local is_windo = M.is_windo_window(evt_win)
			local null_buffer = evt.file == ""
			M.write_log(string.format("BufEnter: window_id: %s, is_windo: %s", evt_win, tostring(is_windo)))
			if not is_windo or null_buffer then
				return
			end

			M.write_log(string.format("BufEnterAddFocusUpdate: file: %s", evt.file))
			M.add_buffer_to_window(evt_win, evt.buf, evt.file)
			M.focus_buffer(evt_win, evt.buf)
			M.update()
		end,
	})

	vim.api.nvim_create_autocmd("BufModifiedSet", {
		pattern = "*",
		group = M.augroup,
		callback = function(_)
			err_handler(function()
				M.update()
			end)
		end,
	})

	vim.api.nvim_create_autocmd("BufWipeout", {
		pattern = "*",
		group = M.augroup,
		callback = function(evt)
			err_handler(function()
				M.bwipeout(evt.buf)
				M.update()
			end)
		end,
	})

	vim.api.nvim_create_autocmd("WinEnter", {
		pattern = "*",
		group = M.augroup,
		callback = function(ev)
			err_handler(function()
				local entering_win = vim.api.nvim_get_current_win()
				local entering_buf = vim.api.nvim_get_current_buf()
				local is_windo = M.is_windo_window(entering_win)

				M.write_log(
					"WinEnter: " .. entering_win .. ", is_windo:" .. tostring(is_windo) .. ", file: " .. ev.file
				)

				if is_windo then
					M.focus_buffer(entering_win, entering_buf)
					M.update()
					-- else
					-- 	local buftype = vim.bo.buftype
					-- 	if buftype == "" and ev.file ~= "" then
					-- 		M.write_log('Buftype "" and ev.file ~= "". Creating WINDO!')
					-- 		M.create()
					-- 	end
				end
			end)
		end,
	})

	vim.api.nvim_create_autocmd("WinLeave", {
		pattern = "*",
		group = M.augroup,
		callback = function(_)
			local leaving_win = vim.api.nvim_get_current_win()
			local TIMEOUT = 50 -- ms

			M.write_log("Leaving window: " .. leaving_win)

			if M.is_windo_window(leaving_win) then
				local window_created = false
				local new_buf_entered = false

				local win_new_cmd_id = vim.api.nvim_create_autocmd("WinNew", {
					pattern = "*",
					group = M.augroup,
					callback = function(_)
						window_created = true
						local new_win = vim.api.nvim_get_current_win()
						local bufname = vim.api.nvim_buf_get_name(0)
						M.write_log("WinNew after WinLeave: " .. new_win .. " bufname: " .. bufname)
						if not M.is_windo_window(new_win) then
							vim.wo[new_win].winbar = nil
						end

						local buf_add_cmd_id = vim.api.nvim_create_autocmd("BufEnter", {
							pattern = "*",
							group = M.augroup,
							callback = function(ev)
								new_buf_entered = true
								M.write_log("BufEnter after WinNew: buf: " .. ev.buf .. ", file: " .. ev.file)
								-- Detected a new buffer opened in a new window.
								-- MAKE DECISION: Should a new WINDO be made???
							end,
							once = true,
						})

						vim.defer_fn(function()
							if not new_buf_entered then
								M.write_log(
									"BufEnter NOT CALLED after WinNew. Assume same buffer, split command called"
								)
								M.create()
								vim.api.nvim_del_autocmd(buf_add_cmd_id)
							end
						end, TIMEOUT)
					end,
					once = true,
				})

				vim.defer_fn(function()
					if not window_created then
						vim.api.nvim_del_autocmd(win_new_cmd_id)
					end
				end, TIMEOUT)
			end
		end,
	})
end

return M
