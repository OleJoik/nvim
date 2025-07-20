vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("package_manager")

require("terminal")
require("colors").set_colors()

-- must happen after fzf is installed with package manager
require("telescope").load_extension("fzf")
