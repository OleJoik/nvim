local function _print(text)
	vim.notify(text, vim.log.levels.INFO)
end

local function toggle_winbar()
	--   vim.notify("Hello", vim.log.levels.INFO)
	vim.w.winbar_text = "%#Title# Click %@v:lua.on_button_click@[Button]%@"

	if vim.w.test then
		vim.w.test = false
		vim.wo.winbar = ""
	else
		vim.w.test = true
		vim.wo.winbar = vim.w.winbar_text
	end
end

local function find_first_available_id()
	local id = 1
	while _G.click_handler_lookup[tostring(id)] do
		id = id + 1
	end
	return id
end

local function add_entry_to_lookup(win_id, buf_id)
	local id = find_first_available_id()
	_G.click_handler_lookup[tostring(id)] = { win_id = win_id, buf_id = buf_id }
	return id
end

local function delete_entry_from_lookup(win_id, buf_id)
	for id, entry in pairs(_G.click_handler_lookup or {}) do
		if entry.win_id == win_id and entry.buf_id == buf_id then
			_G.click_handler_lookup[id] = nil
			return
		end
	end
end

local function update(win_id, buffers)
	local buf_strings = {}
	for _, value in ipairs(buffers) do
		local formatted_string = "%" .. value.global_id .. "@v:lua.on_button_click@" .. value.short_name .. "%T"
		table.insert(buf_strings, formatted_string)
	end

	vim.api.nvim_win_set_option(win_id, "winbar", "(" .. tostring(win_id) .. ") " .. table.concat(buf_strings, " | "))
end

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	callback = function()
		win_id = vim.api.nvim_get_current_win()
		local success, buffers = pcall(vim.api.nvim_win_get_var, win_id, "winbarbar_buffers")

		if success then
			local buf_id = vim.api.nvim_get_current_buf()
			local buf_name = vim.api.nvim_buf_get_name(buf_id)
			local short_buf_name = vim.fn.fnamemodify(buf_name, ":t")

			if buf_name ~= "" then
				found = false
				for _, value in ipairs(buffers) do
					if value.buf_id == buf_id then
						found = true
						break
					end
				end

				if not found then
					local global_id = add_entry_to_lookup(win_id, buf_id)
					table.insert(buffers, { global_id = global_id, buf_id = buf_id, short_name = short_buf_name })

					vim.api.nvim_win_set_var(win_id, "winbarbar_buffers", buffers)
				end

				update(win_id, buffers)
			end
		end
	end,
})

local function remove_buffer_from_win(win_id, buf_id)
	buffers = vim.api.nvim_win_get_var(win_id, "winbarbar_buffers")

	_print("Removing win_id: " .. win_id .. " buf_id: " .. buf_id)

	for id, entry in pairs(buffers) do
		if entry.win_id == win_id and entry.buf_id == buf_id then
			buffers[id] = nil
		end
	end

	vim.api.nvim_win_set_var(win_id, "winbarbar_buffers", buffers)

	_print(vim.inspect(buffers))

	update(win_id, buffers)
end

_G.click_handler_lookup = _G.click_handler_lookup or {}

local function on_button_click(selected_global_id)
	out = _G.click_handler_lookup[tostring(selected_global_id)]
	if vim.api.nvim_buf_is_loaded(out.buf_id) then
		vim.api.nvim_win_set_buf(out.win_id, out.buf_id)
	end
end
_G.on_button_click = on_button_click

local function _split(command)
	local scratch_buf = vim.api.nvim_create_buf(false, true) -- (listed, scratch)

	vim.cmd(command)

	vim.api.nvim_win_set_buf(0, scratch_buf)
	win_id = vim.api.nvim_get_current_win()

	vim.api.nvim_win_set_var(win_id, "winbarbar_buffers", {})
	vim.api.nvim_win_set_option(win_id, "winbar", "Window " .. win_id)

	vim.bo[scratch_buf].buftype = "nofile"
	vim.bo[scratch_buf].bufhidden = "wipe"
	vim.bo[scratch_buf].swapfile = false
	vim.bo[scratch_buf].modifiable = true
end

local function winbarbar_split_left()
	_split("leftabove vsplit")
end
local function winbarbar_split_down()
	_split("split")
end
local function winbarbar_split_up()
	_split("leftabove split")
end
local function winbarbar_split_right()
	_split("vsplit")
end

local function is_winbarbar_window(win_id)
	local success, buffers = pcall(vim.api.nvim_win_get_var, win_id, "winbarbar_buffers")
	if success then
		return buffers
	end

	return false
end

local function winbarbar_move_right()
	local buf_id = vim.api.nvim_get_current_buf()
	local previous_window_buffers = is_winbarbar_window(0)
	local old_win_id = vim.api.nvim_get_current_win()

	vim.cmd("wincmd l")

	local new_window_buffers = is_winbarbar_window(0)

	if new_window_buffers then
		local new_win_id = vim.api.nvim_get_current_win()

		if new_win_id == old_win_id then
			return
		end

		if previous_window_buffers then
			delete_entry_from_lookup(old_win_id, buf_id)
			remove_buffer_from_win(old_win_id, buf_id)
		end

		local buf_name = vim.api.nvim_buf_get_name(buf_id)
		local short_buf_name = vim.fn.fnamemodify(buf_name, ":t")

		if buf_name ~= "" then
			found = false
			for _, value in ipairs(new_window_buffers) do
				if value.buf_id == buf_id then
					found = true
					break
				end
			end

			if not found then
				local global_id = add_entry_to_lookup(win_id, buf_id)
				table.insert(buffers, { global_id = global_id, buf_id = buf_id, short_name = short_buf_name })

				vim.api.nvim_win_set_var(win_id, "winbarbar_buffers", buffers)
			end

			update(win_id, buffers)
		end
	end
end

local function find_buffer_indx(buffers, win_id, buf_id)
	for indx, value in ipairs(buffers) do
		if value.win_id == win_id and value.buf_id == buf_id then
			return indx
		end
	end
end

local function count_non_floating_windows()
	local count = 0

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local config = vim.api.nvim_win_get_config(win)
		local buftype = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win), "buftype")
		local filetype = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win), "filetype")

		-- Check if the window is not floating and not a special buffer like Neotree
		if not config.relative or config.relative == "" then
			if buftype == "" and filetype ~= "neo-tree" then
				count = count + 1
			end
		end
	end

	return count
end

local function remove_buffer()
	win_id = vim.api.nvim_get_current_win()
	local success, buffers = pcall(vim.api.nvim_win_get_var, win_id, "winbarbar_buffers")

	if success then
		local buf_id = vim.api.nvim_get_current_buf()
		local indx = find_buffer_indx(buffers, win_id, buf_id)
		local window_buffer_count = #buffers
		if window_buffer_count <= 1 then
			local window_count = count_non_floating_windows()
			if window_count > 1 then
				delete_entry_from_lookup(win_id, buf_id)
				vim.api.nvim_win_close(win_id, false)
			end

			return
		end

		delete_entry_from_lookup(win_id, buf_id)
		remove_buffer_from_win(win_id, buf_id)
	end
end

vim.keymap.set("n", "mg", function()
	vim.notify(vim.inspect(_G.click_handler_lookup), vim.log.levels.INFO)
end, { noremap = true, silent = true })

vim.keymap.set("n", "mp", function()
	win_ids = vim.api.nvim_list_wins()
	local handled_windows = {}

	for _, win_id in ipairs(win_ids) do
		local success, buffers = pcall(vim.api.nvim_win_get_var, win_id, "winbarbar_buffers")
		if success then
			table.insert(handled_windows, { win_id = win_id, buffers = buffers })
		end
	end

	vim.notify(vim.inspect(handled_windows), vim.log.levels.INFO)
end, { noremap = true, silent = true })

-- vim.keymap.set('n', '<C-f>h', winbarbar_split_left, { noremap = true, silent = true })
-- vim.keymap.set('n', '<C-f>j', winbarbar_split_down, { noremap = true, silent = true })
-- vim.keymap.set('n', '<C-f>k', winbarbar_split_up, { noremap = true, silent = true })
-- vim.keymap.set('n', '<C-f>l', winbarbar_split_right, { noremap = true, silent = true })
--
-- vim.keymap.set('n', '<leader>l', winbarbar_move_right, { noremap = true, silent = true })

local function winfo()
	local all_windows = vim.api.nvim_list_wins()

	for _, win_id in ipairs(all_windows) do
		_print(vim.inspect(win_id) .. vim.inspect(vim.api.nvim_win_get_position(win_id)))
	end
end

vim.keymap.set("n", "mw", winfo, { noremap = true, silent = true })

-- vim.keymap.set('n', '<C-x>', remove_buffer, { noremap = true, silent = true  })
