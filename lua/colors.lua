return {
    set_colors = function()
        vim.cmd("colorscheme terafox")
        vim.api.nvim_set_hl(0, "Whitespace", { fg = "#182b2f" })
        vim.api.nvim_set_hl(0, "NonText", { fg = "#182b2f" })
        vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#28474d" })
        vim.api.nvim_set_hl(0, "SatelliteBar", { bg = "#182b2f" })
        -- vim.api.nvim_set_hl(0, "SatelliteCursor", { bg = "#182b2f", fg = "#ffffff" })
        vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#ff8349" })
    end
}
