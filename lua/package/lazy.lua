return {
	{
		"kdheepak/lazygit.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	"ellisonleao/dotenv.nvim",
	"Mofiqul/vscode.nvim",
	"norcalli/nvim-terminal.lua",
	"tpope/vim-fugitive",
	"mg979/vim-visual-multi",

	"nvim-pack/nvim-spectre",

	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end,
	},

	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},

	"nvimtools/none-ls.nvim",

	-- deletes buffers without fucking up the window layout
	"famiu/bufdelete.nvim",

	"sindrets/diffview.nvim",
	"petertriho/nvim-scrollbar",

	-- Detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth",

	-- "gc" to comment visual regions/lines
	{ "numToStr/Comment.nvim", opts = {} },

	-- },
	-- {
	-- 	"OleJoik/bufbouncer.nvim",
	-- 	config = function()
	-- 		require("bufbouncer").setup({
	-- 			debug = {
	-- 				show_win_nr = false,
	-- 				show_buf_nr = false,
	-- 			},
	-- 		})
	-- 	end,
	-- },
	-- {
	-- 	"OleJoik/gitgraph.nvim",
	-- 	config = function()
	-- 		require("gitgraph").setup()
	-- 	end,
	-- },

	{
		"OleJoik/squeel.nvim",
	},
}
