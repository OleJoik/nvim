local buf_id = nil
local win_id = nil
local job_id = nil

local create_term_win = function()
  vim.cmd.vnew()
  vim.cmd.wincmd("L")
  win_id = vim.api.nvim_get_current_win()
end

local create_term = function()
  vim.cmd.term()
  job_id = vim.bo.channel
  buf_id = vim.api.nvim_get_current_buf()
end


local focus_term = function()
  if win_id ~= nil then
    vim.api.nvim_set_current_win(win_id)
  end

  if buf_id ~= nil then
    vim.api.nvim_set_current_buf(buf_id)
  end
end



vim.keymap.set({ "n" }, "ø", function()
  if win_id == nil or vim.api.nvim_win_is_valid(win_id) == false then
    create_term_win()
  end
  if buf_id == nil or vim.api.nvim_buf_is_valid(buf_id) == false then
    create_term()
  end

  focus_term()
  vim.cmd("startinsert")
end)

vim.keymap.set({ "n" }, "<leader>ti", function()
  local current_win = vim.api.nvim_get_current_win()
  local should_defer = false
  if win_id == nil or vim.api.nvim_win_is_valid(win_id) == false then
    create_term_win()
  end
  if buf_id == nil or vim.api.nvim_buf_is_valid(buf_id) == false then
    create_term()
    should_defer = true
  end

  focus_term()
  vim.cmd("$")
  vim.api.nvim_set_current_win(current_win)

  if should_defer then
    vim.defer_fn(function()
      vim.fn.chansend(job_id, { "echo 'terraform init'\r\n" })
    end, 300)
  else
    vim.fn.chansend(job_id, { "echo 'terraform init'\r\n" })
  end
end, { desc = "[I]nit terraform" })

vim.keymap.set({ "n" }, "å", function()
  local path = vim.api.nvim_buf_get_name(0)
  local dir = vim.fn.fnamemodify(path, ":h")
  local editor_width = vim.o.columns
  local editor_height = vim.o.lines
  local win_width = 80
  local win_height = 30
  local row = math.floor((editor_height - win_height) / 2)
  local col = math.floor((editor_width - win_width) / 2)

  vim.api.nvim_open_win(0, true,
    { relative = 'editor', row = row, col = col, width = win_width, height = win_height }
  )
  vim.cmd.term()
  vim.cmd("startinsert")
  vim.fn.chansend(vim.bo.channel, { "cd " .. dir .. "\r\nclear\r\n" })
end)
