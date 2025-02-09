vim.api.nvim_create_autocmd("BufWinEnter", {
  group = vim.api.nvim_create_augroup("userconfig", { clear = true }),
  pattern = "*",
  callback = function()
    vim.cmd("silent! normal! g`\"zv")
  end,
  desc = "Return cursor to last position when reopening a file",
})


vim.api.nvim_create_autocmd({ "VimEnter", "BufWinEnter" }, {
  callback = function()
    if vim.bo.buftype == "" then
      vim.wo.winbar = "      %{%v:lua.get_oil_winbar()%} %m%h"
    end
  end,
})
