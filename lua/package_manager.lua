local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

---@diagnostic disable-next-line: undefined-field
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { import = "package" },
  "OleJoik/icebar.nvim",
  "famiu/bufdelete.nvim",
  "mg979/vim-visual-multi",
  {
    "folke/ts-comments.nvim", -- Excellent plugin that among other things fixes comments in tsx files
    opts = {},
    event = "VeryLazy",
    enabled = vim.fn.has("nvim-0.10.0") == 1,
  }
  -- "OleJoik/diff.nvim",
  -- { "OleJoik/resize-border.nvim", opts = {} }
}, {
  change_detection = {
    notify = false,
  },
  dev = {
    path = "~/repos/personal",
    patterns = { "OleJoik" },
    fallback = true,
  },
})
