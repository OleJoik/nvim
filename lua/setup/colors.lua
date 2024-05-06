
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


vim.cmd("highlight LineNr guifg=#505050")

vim.cmd("highlight DebugBreakpointLine guibg=#DC143C")

local green = "#067209"
local yellow = "#E7ED09"
local bright_yellow = "#AAB40E"
-- local dark_yellow = "#676D09"
local dark_yellow = "NONE"
local crazy = "#0CFCFC80"

-- Used for the text of 'add' signs.
vim.cmd("highlight GitSignsAdd guifg=" .. green)

-- Used for the text of 'change' signs.
vim.cmd("highlight GitSignsChange guifg=" .. yellow)



-- -- Used for buffer line (when `config.linehl == true`) of 'change' signs.
-- vim.cmd("highlight GitSignsChangeLn guibg=" .. dark_yellow .. " guifg=NONE")
--
-- Used for changed word diff regions when `config.word_diff == true`.
vim.cmd("highlight GitSignsChangeLnInline guibg=" .. bright_yellow .. " guifg=black")

-- Used for buffer line (when `config.linehl == true`) of 'change' signs.
vim.cmd("highlight GitSignsChangeLn guibg=" .. dark_yellow .. " guifg=NONE")

-- Used for added word diff regions when `config.word_diff == true`.
-- vim.cmd("highlight GitSignsAddLnInline guibg=" .. crazy .. " guifg=blue")
--



-- GitSignsDelete
--         -- Used for the text of 'delete' signs.
--         -- Fallbacks: `GitGutterDelete`, `SignifySignDelete`, `DiffRemovedGutter`, `diffRemoved`, `DiffDelete`
--         --                                                 *hl-GitSignsChangedelete*
-- GitSignsChangedelete
--         -- Used for the text of 'changedelete' signs.
--         -- Fallbacks: `GitSignsChange`
--         --                                                 *hl-GitSignsTopdelete*
-- GitSignsTopdelete
--         -- Used for the text of 'topdelete' signs.
--         -- Fallbacks: `GitSignsDelete`
--         --                                                 *hl-GitSignsUntracked*
-- GitSignsUntracked
--         -- Used for the text of 'untracked' signs.
--         -- Fallbacks: `GitSignsAdd`
--         --                                                 *hl-GitSignsAddNr*
-- GitSignsAddNr
--         -- Used for number column (when `config.numhl == true`) of 'add' signs.
--         -- Fallbacks: `GitGutterAddLineNr`, `GitSignsAdd`
--         --                                                 *hl-GitSignsChangeNr*
-- GitSignsChangeNr
--         -- Used for number column (when `config.numhl == true`) of 'change' signs.
--         -- Fallbacks: `GitGutterChangeLineNr`, `GitSignsChange`
--         --                                                 *hl-GitSignsDeleteNr*
-- GitSignsDeleteNr
--         -- Used for number column (when `config.numhl == true`) of 'delete' signs.
--         -- Fallbacks: `GitGutterDeleteLineNr`, `GitSignsDelete`
--         --                                                 *hl-GitSignsChangedeleteNr*
-- GitSignsChangedeleteNr
--         -- Used for number column (when `config.numhl == true`) of 'changedelete' signs.
--         -- Fallbacks: `GitSignsChangeNr`
--         --                                                 *hl-GitSignsTopdeleteNr*
-- GitSignsTopdeleteNr
--         -- Used for number column (when `config.numhl == true`) of 'topdelete' signs.
--         -- Fallbacks: `GitSignsDeleteNr`
--         --                                                 *hl-GitSignsUntrackedNr*
-- GitSignsUntrackedNr
--         -- Used for number column (when `config.numhl == true`) of 'untracked' signs.
--         -- Fallbacks: `GitSignsAddNr`
--         --                                                 *hl-GitSignsAddLn*
-- GitSignsAddLn
--         -- Used for buffer line (when `config.linehl == true`) of 'add' signs.
--         -- Fallbacks: `GitGutterAddLine`, `SignifyLineAdd`, `DiffAdd`
--     --
--         --                                                 *hl-GitSignsChangeLn*
-- GitSignsChangeLn
--         -- Used for buffer line (when `config.linehl == true`) of 'change' signs.
--         -- Fallbacks: `GitGutterChangeLine`, `SignifyLineChange`, `DiffChange`
--     --
--         --                                                 *hl-GitSignsChangedeleteLn*
-- GitSignsChangedeleteLn
--         -- Used for buffer line (when `config.linehl == true`) of 'changedelete' signs.
--         -- Fallbacks: `GitSignsChangeLn`
--     --
--         --                                                 *hl-GitSignsUntrackedLn*
-- GitSignsUntrackedLn
--         -- Used for buffer line (when `config.linehl == true`) of 'untracked' signs.
--         -- Fallbacks: `GitSignsAddLn`
--         --                                                 *hl-GitSignsAddPreview*
-- GitSignsAddPreview
--         -- Used for added lines in previews.
--         -- Fallbacks: `GitGutterAddLine`, `SignifyLineAdd`, `DiffAdd`
--         --                                                 *hl-GitSignsDeletePreview*
-- GitSignsDeletePreview
--         -- Used for deleted lines in previews.
--         -- Fallbacks: `GitGutterDeleteLine`, `SignifyLineDelete`, `DiffDelete`
--         --                                                 *hl-GitSignsCurrentLineBlame*
-- GitSignsCurrentLineBlame
--         -- Used for current line blame.
--         -- Fallbacks: `NonText`
--         --                                                 *hl-GitSignsAddInline*
-- GitSignsAddInline
--         -- Used for added word diff regions in inline previews.
--         -- Fallbacks: `TermCursor`
--     --
--         --                                                 *hl-GitSignsDeleteInline*
-- GitSignsDeleteInline
--         -- Used for deleted word diff regions in inline previews.
--         -- Fallbacks: `TermCursor`
--         --                                                 *hl-GitSignsChangeInline*
-- GitSignsChangeInline
--         -- Used for changed word diff regions in inline previews.
--         -- Fallbacks: `TermCursor`
--     --
--         --                                                 *hl-GitSignsAddLnInline*
-- GitSignsAddLnInline
--         -- Used for added word diff regions when `config.word_diff == true`.
--         -- Fallbacks: `GitSignsAddInline`
--     --
--         --                                                 *hl-GitSignsChangeLnInline*
-- GitSignsChangeLnInline
--         -- Used for changed word diff regions when `config.word_diff == true`.
--         -- Fallbacks: `GitSignsChangeInline`
--     --
--         --                                                 *hl-GitSignsDeleteLnInline*
-- GitSignsDeleteLnInline
--         -- Used for deleted word diff regions when `config.word_diff == true`.
--         -- Fallbacks: `GitSignsDeleteInline`
--     --
--                                                         -- *hl-GitSignsDeleteVirtLn*
-- GitSignsDeleteVirtLn
--         -- Used for deleted lines shown by inline `preview_hunk_inline()` or `show_deleted()`.
--         -- Fallbacks: `GitGutterDeleteLine`, `SignifyLineDelete`, `DiffDelete`
--                                                         -- *hl-GitSignsDeleteVirtLnInLine*
-- GitSignsDeleteVirtLnInLine
--         -- Used for word diff regions in lines shown by inline `preview_hunk_inline()` or `show_deleted()`.
--         -- Fallbacks: `GitSignsDeleteLnInline`
--                                                         -- *hl-GitSignsVirtLnum*
-- GitSignsVirtLnum
--         -- Used for line numbers in inline hunks previews.
--         -- Fallbacks: `GitSignsDeleteVirtLn`

