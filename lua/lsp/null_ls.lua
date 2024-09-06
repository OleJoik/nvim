local null_ls = require("null-ls")

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

_G.skip_formatting_buffers = {}

null_ls.setup({
    sources = {
        -- null_ls.builtins.formatting.djhtml,
        null_ls.builtins.formatting.djlint,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.ruff,
        null_ls.builtins.formatting.golines,
        null_ls.builtins.formatting.alejandra,
        null_ls.builtins.code_actions.statix,
        null_ls.builtins.diagnostics.statix
    },
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    if not _G.skip_formatting_buffers[bufnr] then
                        vim.lsp.buf.format({ async = false })
                    end
                end,
            })
        end
    end,
})

vim.api.nvim_set_keymap('n', '<leader>S', ':lua SaveWithoutFormatting()<CR>', { noremap = true, silent = true, desc="[S]ave without formatting" })

function SaveWithoutFormatting()
    local bufnr = vim.api.nvim_get_current_buf()
    _G.skip_formatting_buffers[bufnr] = true
    vim.cmd('write')
    _G.skip_formatting_buffers[bufnr] = false
end

