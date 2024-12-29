return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "go",
                    "templ",
                    "python",
                    "tsx",
                    "typescript",
                    "terraform",
                    "hcl",
                    "sql",
                },

                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end
    },
}
