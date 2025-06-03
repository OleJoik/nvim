---@alias State { windows: table<string, WindowState|nil> }
---@alias WindowState { buffers: table<string, BufferState|nil>, float: FloatState|nil }
---@alias FloatState { window: integer, buffer: integer }
---@alias BufferState { active: boolean }

---@type State
M._state = { windows = {} }

function M.state()
  return M._state
end

function M._create_float(win_id)
  local float_buf = vim.api.nvim_create_buf(false, true) -- [listed=false, scratch=true]
  local parent_width = vim.api.nvim_win_get_width(win_id)
  vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, { "Info", "Status" })

  local float_win = vim.api.nvim_open_win(float_buf, false, {
    relative = "win",
    win = win_id,
    anchor = "NE",
    row = -1,
    col = parent_width,
    width = 20,
    height = 2,
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
  return { window = float_win, buffer = float_buf }
end

function M.register(win_id, buf_id)
  if vim.fn.win_gettype(win_id) ~= "" then
    return
  end

  local w = tostring(win_id)
  local b = tostring(buf_id)

  local float = M._create_float(win_id)

  M._state.windows[w] = { buffers = { [b] = { active = true } }, float = float }
  M._set_active(w, b)
end

-- Includes guards in case window/buffer isn't already registered
-- Might want to log these cases to look for errors..
-- Errors would be cases when the user attempts to activate a buffer not in baramir.
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
    vim.api.nvim_win_close(M._state.windows[w].float.window, true)
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
end

function M.update_float_position(win_id)
  local w = tostring(win_id)
  if M._state.windows[w] == nil then
    return
  end

  local parent_width = vim.api.nvim_win_get_width(win_id)
  local float_id = M._state.windows[w].float.window
  if float_id == nil then
    return
  end
  local cfg = vim.api.nvim_win_get_config(float_id)
  cfg.col = parent_width
  vim.api.nvim_win_set_config(M._state.windows[w].float.window, cfg)
end

return M
