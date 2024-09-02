M = {
  setup_servers = function()
    local lsp_servers = require("lsp.servers").servers
    local on_attach = require("lsp.on_attach").on_attach

    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    -- Ensure the servers above are installed
    local mason_lspconfig = require('mason-lspconfig')

    mason_lspconfig.setup {
      -- ensure_installed = vim.tbl_keys(lsp_servers),
    }

    mason_lspconfig.setup_handlers {
      function(server_name)
        require('lspconfig')[server_name].setup {
          capabilities = capabilities,
          on_attach = on_attach,
          settings = (lsp_servers[server_name] or {}).settings,
          filetypes = (lsp_servers[server_name] or {}).filetypes,
          handlers =(lsp_servers[server_name] or {}).handlers,
          init_options =(lsp_servers[server_name] or {}).init_options,
        }
      end
    }

    require('lspconfig').clangd.setup {
      capabilities = capabilities,
      on_attach = on_attach
    }
  end
}



return M
