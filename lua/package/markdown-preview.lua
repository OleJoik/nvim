M = {
  "iamcco/markdown-preview.nvim",
  config = function()
    vim.fn["mkdp#util#install"]()
  end,
}

return M
