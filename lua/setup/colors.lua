
-- COLORS
local c = require('vscode.colors').get_colors()
require('vscode').setup({
    -- Alternatively set style in setup
    style = 'dark',

    -- Enable transparent background
    transparent = true,

    -- Enable italic comment
    italic_comments = true,

    -- Disable nvim-tree background color
    disable_nvimtree_bg = true,

    -- Override colors (see ./lua/vscode/colors.lua)
    color_overrides = {
        vscLineNumber = '#FFFFFF',
    },

    -- Override highlight groups (see ./lua/vscode/theme.lua)
    group_overrides = {
        -- this supports the same val table as vim.api.nvim_set_hl
        -- use colors from this colorscheme by requiring vscode.colors!
        Cursor = { fg=c.vscDarkBlue, bg=c.vscLightGreen, bold=true },
    }
})
require('vscode').load()
vim.opt.termguicolors = true

-- Change the background color for added lines
vim.cmd("highlight GitSignsAddLn guibg=#004400")
-- Change the background color for changed lines
vim.cmd("highlight GitSignsChangeLn guibg=#222200")
-- Change the background color for deleted lines
vim.cmd("highlight GitSignsDeleteLn guibg=#440000")

vim.cmd("highlight LineNr guifg=#505050")

vim.cmd("highlight DebugBreakpointLine guibg=#DC143C")
