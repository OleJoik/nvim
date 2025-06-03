ENABLE = false

vim.api.nvim_create_user_command("Bara", function()
  print(vim.inspect(require("baramir").state()))
end, {})

vim.api.nvim_create_user_command("BaraRender", function()
  require("baramir").render_floats()
end, {})

if ENABLE then
  vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    callback = function()
      local win_id = vim.api.nvim_get_current_win()
      local buf_id = vim.api.nvim_get_current_buf()
      require("baramir").register(win_id, buf_id)
    end,
  })


  -- catches edge cases not caught by BufWinEnter:
  -- :split doesn't trigger BufWinEnter
  vim.api.nvim_create_autocmd({ "WinNew" }, {
    callback = function()
      local win_id = vim.api.nvim_get_current_win()
      local buf_id = vim.api.nvim_get_current_buf()
      require("baramir").register(win_id, buf_id)
    end,
  })


  vim.api.nvim_create_autocmd({ "WinEnter" }, {
    callback = function()
      local win_id = vim.api.nvim_get_current_win()
      local buf_id = vim.api.nvim_get_current_buf()
      require("baramir").activate(win_id, buf_id)
    end,
  })


  vim.api.nvim_create_autocmd({ "WinClosed" }, {
    callback = function(args)
      local closing_winid_str = args.file
      local closing_winid = tonumber(closing_winid_str)
      require("baramir").close_win(closing_winid)
    end,
  })


  vim.api.nvim_create_autocmd({ "WinClosed" }, {
    callback = function(args)
      local closing_winid_str = args.file
      local closing_winid = tonumber(closing_winid_str)
      require("baramir").close_win(closing_winid)
    end,
  })


  vim.api.nvim_create_autocmd({ "WinResized" }, {
    callback = function()
      local windows = vim.v.event.windows or {}
      for _, winid in ipairs(windows) do
        require("baramir").update_float_position(winid)
      end
    end,
  })
end
