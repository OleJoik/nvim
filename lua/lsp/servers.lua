-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
--
-- local python_path = vim.fn.system("which python"):gsub("\n", "")

M = {
	servers = {
		-- clangd = {},
		gopls = {},
		templ = {},
		nixd = {},
		-- mypy = {
		-- },
		-- rust_analyzer = {},
		tsserver = {},
		html = { filetypes = { "html", "twig", "hbs", "templ" } },
		emmet_ls = {},
	},
}
return M
