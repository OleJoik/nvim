-- https://mbaraa.com/blog/setting-up-go-templ-with-tailwind-htmx-docker#toc_3
-- ~/.config/nvim/after/plugin/templ.lua
-- IDK where is the neovim configuration on Mac or Windows, so you need to do some research :)

local function setup_templ()
    local lspconfig = require 'lspconfig'
    local configs = require 'lspconfig.configs'

    -- start the templ language server for go projects with .templ files
    configs.templ = {
        default_config = {
            cmd = { "templ", "lsp", "-http=localhost:7474", "-log=/tmp/templ.log" },
            filetypes = { "templ" },
            root_dir = lspconfig.util.root_pattern("go.mod", ".git"),
            settings = {},
        },
    }
    lspconfig.templ.setup{}
    vim.filetype.add({ extension = { templ = "templ" } })

    vim.api.nvim_create_autocmd({ "BufWritePost" }, { -- IDK the docs said to do the format before saving the file, but it only makes the formatter freak out.
        pattern = { "*.templ" },
        callback = function()
            local file_name = vim.api.nvim_buf_get_name(0) -- Get file name of file in current buffer
            vim.cmd(":silent !templ fmt " .. file_name)

            local bufnr = vim.api.nvim_get_current_buf()
            if vim.api.nvim_get_current_buf() == bufnr then
                vim.cmd('e!')
            end
        end
    })
end

setup_templ()
