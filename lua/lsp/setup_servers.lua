M = {
	setup_servers = function()
		local lsp_servers = require("lsp.servers").servers
		local on_attach = require("lsp.on_attach").on_attach

		-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

		-- Ensure the servers above are installed
		local mason_lspconfig = require("mason-lspconfig")

		mason_lspconfig.setup({
			-- ensure_installed = vim.tbl_keys(lsp_servers),
		})

		mason_lspconfig.setup_handlers({
			function(server_name)
				require("lspconfig")[server_name].setup({
					capabilities = capabilities,
					on_attach = on_attach,
					settings = (lsp_servers[server_name] or {}).settings,
					filetypes = (lsp_servers[server_name] or {}).filetypes,
					handlers = (lsp_servers[server_name] or {}).handlers,
					init_options = (lsp_servers[server_name] or {}).init_options,
				})
			end,
		})

		require("lspconfig").clangd.setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		require("lspconfig").ts_ls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		require("lspconfig").ruff.setup({
			init_options = {
				settings = {
					-- Any extra CLI arguments for `ruff` go here.
					args = {},
				},
			},
			on_attach = on_attach,
			capabilities = capabilities,
		})

		require("lspconfig").pyright.setup({
			settings = {
				pyright = {
					-- Using Ruff's import organizer
					disableOrganizeImports = true,
				},
				python = {
					analysis = {
						-- Ignore all files for analysis to exclusively use Ruff for linting
						ignore = { "*" },
					},
				},
				analysis = {
					autoSearchPaths = true,
					diagnosticMode = "openFilesOnly",
					useLibraryCodeForTypes = true,
				},
			},
			on_attach = on_attach,
			capabilities = capabilities,
		})

		require("lspconfig").lua_ls.setup({
			settings = {
				Lua = {
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
					diagnostics = {
						globals = { "vim" },
					},
				},
			},
		})
		require("lspconfig").terraformls.setup({})

		require("lspconfig").tailwindcss.setup({
			filetypes = {
				"css",
				"scss",
				"sass",
				"html",
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"htmldjango",
				"python",
				"templ",
			},
			settings = {
				includeLanguages = {
					typescript = "javascript",
					typescriptreact = "javascript",
					htmldjango = "html",
					python = "html",
				},
				tailwindCSS = {

					-- 	classAttributes = {
					-- 		"class",
					-- 		"className",
					-- 		"class_",
					-- 	},
					experimental = {
						classRegex = {
							-- Single line strings:
							[[class_="([^"]*)]], -- for double quoted strings
							[[class_='([^']*)]], -- for single quoted strings

							-- Multi-line strings:
							[[class_="""([^"]*)"""]], -- for multi-line double quoted strings
							[[class_='''([^']*)''']], -- for multi-line single quoted strings
						},
					},
				},
			},
		})
	end,
}

return M
