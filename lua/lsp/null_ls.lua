local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        -- null_ls.builtins.formatting.djhtml,
        null_ls.builtins.formatting.djlint,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.golines,
        null_ls.builtins.formatting.alejandra,
        null_ls.builtins.code_actions.statix,
        null_ls.builtins.diagnostics.statix
    },
    on_attach = require("lsp.on_attach").on_attach
})
