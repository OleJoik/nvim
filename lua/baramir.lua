---@alias BufferState { active: boolean, filename: string }
---@alias FloatState { win_id: integer, buffer: integer }
---@alias WindowState { buffers: table<string, BufferState|nil>, float: FloatState|nil }
---@alias State { windows: table<string, WindowState|nil> }

---@type State
M._state = { windows = {} }

function M.state()
  return M._state
end

local function _is_normal_buffer(bufnr)
  if vim.bo[bufnr].buflisted == 0 then
    return false
  end

  -- Skip special buftypes (like terminal, quickfix, etc)
  local buftype = vim.bo[bufnr].buftype
  if buftype ~= "" then
    return false
  end

  local filetype = vim.bo[bufnr].filetype
  local skip_filetypes = {
    ["oil"] = true,
    ["NvimTree"] = true,
    ["neo-tree"] = true,
    ["toggleterm"] = true,
    ["alpha"] = true,
    ["lazy"] = true,
    ["Outline"] = true,
    ["fugitive"] = true,
    ["qf"] = true,
    ["help"] = true,
  }

  if skip_filetypes[filetype] then
    return false
  end

  return true
end

function M._create_float(win_id)
  local float_buf = vim.api.nvim_create_buf(false, true) -- [listed=false, scratch=true]
  local parent_width = vim.api.nvim_win_get_width(win_id)
  vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, {})

  local float_win = vim.api.nvim_open_win(float_buf, false, {
    relative = "win",
    win = win_id,
    anchor = "NE",
    row = 0,
    col = parent_width,
    width = 20,
    height = 1,
    focusable = false
  })

  vim.api.nvim_set_option_value("number", false, { win = float_win })
  vim.api.nvim_set_option_value("relativenumber", false, { win = float_win })
  vim.api.nvim_set_option_value("signcolumn", "no", { win = float_win })
  vim.api.nvim_set_option_value("foldcolumn", "0", { win = float_win })
  vim.api.nvim_set_option_value("cursorline", false, { win = float_win })
  vim.api.nvim_set_option_value("cursorcolumn", false, { win = float_win })
  vim.api.nvim_set_option_value("spell", false, { win = float_win })
  vim.api.nvim_set_option_value("wrap", false, { win = float_win })
  return { win_id = float_win, buffer = float_buf }
end

function M.register(win_id, buf_id)
  if vim.fn.win_gettype(win_id) ~= "" then
    return
  end


  if _is_normal_buffer(buf_id) == false then
    return
  end

  local w = tostring(win_id)
  local b = tostring(buf_id)

  local float = M._create_float(win_id)

  local full_name = vim.api.nvim_buf_get_name(buf_id)
  local filename = vim.fn.fnamemodify(full_name, ":t")

  if M._state.windows[w] == nil then
    M._state.windows[w] = { buffers = { [b] = { active = true, filename = filename } }, float = float }
  else
    M._state.windows[w].buffers[b] = { active = true, filename = filename }
  end

  M._set_active(w, b)
end

function M.activate(win_id, buf_id)
  local w = tostring(win_id)
  local b = tostring(buf_id)

  if M._state.windows[w] == nil then
    return
  end

  if M._state.windows[w].buffers[b] == nil then
    return
  end

  M._set_active(w, b)
end

function M.close_win(win_id)
  local w = tostring(win_id)
  if M._state.windows[w] == nil then
    return
  end
  if M._state.windows[w].float ~= nil then
    vim.api.nvim_win_close(M._state.windows[w].float.win_id, true)
  end
  M._state.windows[w] = nil
end

-- Assumes the window buffer is registered.. Will give index errors if not
function M._set_active(w, b)
  for _, win in pairs(M._state.windows) do
    for _, buf in pairs(win.buffers) do
      buf.active = false
    end
  end

  M._state.windows[w].buffers[b].active = true
  M.render_floats()
end

function M.update_float_position(win_id)
  local w = tostring(win_id)
  if M._state.windows[w] == nil then
    return
  end

  local parent_width = vim.api.nvim_win_get_width(win_id)
  local float_id = M._state.windows[w].float.win_id
  if float_id == nil then
    return
  end
  local cfg = vim.api.nvim_win_get_config(float_id)
  cfg.col = parent_width
  vim.api.nvim_win_set_config(M._state.windows[w].float.win_id, cfg)
end

function M.render_floats()
  for _, window in pairs(M._state.windows) do
    local bufs = {}
    for _, buf in pairs(window.buffers) do
      table.insert(bufs, buf.filename)
    end
    vim.api.nvim_buf_set_lines(window.float.buffer, 0, -1, false, bufs)
    local cfg = vim.api.nvim_win_get_config(window.float.win_id)
    cfg.height = #bufs
    vim.api.nvim_win_set_config(window.float.win_id, cfg)
  end
end

return M
