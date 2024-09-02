
vim.cmd[[colorscheme nord]]
-- Example config in lua
vim.g.nord_contrast = false
vim.g.nord_borders = true
vim.g.nord_disable_background = true
vim.g.nord_italic = true
vim.g.nord_uniform_diff_background = false
vim.g.nord_bold = false

-- Load the colorscheme
require('nord').set()

vim.opt.termguicolors = true


vim.cmd("highlight LineNr guifg=#505050")

vim.cmd("highlight DebugBreakpointLine guibg=#DC143C")

vim.cmd("highlight DiffAdd guibg=#145A32")
vim.cmd("highlight DiffChange guibg=#7D6608")
vim.cmd("highlight DiffDelete guibg=#6E2C00")
vim.cmd("highlight DiffText guibg=#E4DA00 guifg=black")


