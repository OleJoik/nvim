
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

        -- Needed due to an issue with flash
        FlashBackdrop = { fg = c.vscGray },
        FlashLabel = { bg = "#fd0178" },
    }
})

vim.opt.termguicolors = true
vim.cmd.colorscheme "vscode"


vim.cmd("highlight LineNr guifg=#505050")

vim.cmd("highlight DebugBreakpointLine guibg=#DC143C")

vim.cmd("highlight DiffAdd guibg=#145A32")
vim.cmd("highlight DiffChange guibg=#7D6608")
vim.cmd("highlight DiffDelete guibg=#6E2C00")
vim.cmd("highlight DiffText guibg=#E4DA00 guifg=black")


