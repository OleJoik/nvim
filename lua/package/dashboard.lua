M = {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	config = function()
		require("dashboard").setup({
			config = {
				header = {
					" ██████╗  ██╗      ██████╗  ██╗     ██╗   ██╗ ██╗ ███╗   ███╗",
					"██╔═══██╗ ██║     ██╔═══██╗ ██║     ██║   ██║ ██║ ████╗ ████║",
					"██║   ██║ ██║     ██║   ██║ ██║     ██║   ██║ ██║ ██╔████╔██║",
					"██║   ██║ ██║     ██║   ██║ ██║     ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
					"╚██████╔╝ ███████╗╚██████╔╝ ███████╗ ╚████╔╝  ██║ ██║ ╚═╝ ██║",
					" ╚═════╝  ╚══════╝ ╚═════╝  ╚══════╝  ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
					"                                                             ",
					"               https://github.com/OleJoik/nvim              ",
					"                                                             ",
				},
				shortcut = {
					{
						desc = "  Filetree ",
						group = "DashboardShortCut",
						action = function()
							vim.cmd("Bwipeout")
							vim.bo.buflisted = false
							require("sidebar").open_explorer()
						end,
						key = "e",
					},
					{
						desc = "󰂓 Tests ",
						group = "DashboardShortCut",
						action = function()
							vim.cmd("Bwipeout")
							vim.bo.buflisted = false
							require("neotest").summary.toggle()
						end,
						key = "t",
					},
					{
						desc = "󰊢 Git status ",
						group = "DashboardShortCut",
						action = function()
							vim.cmd("Bwipeout")
							vim.bo.buflisted = false
							require("sidebar").open_git()
							vim.cmd("wincmd p")
							require("git_graph").open_graph()
						end,
						key = "g",
					},
					{ desc = "󰘬 Branches ", group = "DashboardShortCut", action = "", key = "b" },
					{ desc = "󰩈 Exit ", group = "DashboardShortCut", action = "lua vim.cmd('qa')", key = "q" },
				},
				week_header = { enable = false },
				packages = { enable = false },
				project = { enable = false },
				mru = { cwd_only = true },
				footer = { "", "0.24 seconds faster per action" },
			},
			shortcut_type = "number",
		})
	end,
	dependencies = { { "nvim-tree/nvim-web-devicons" } },
}

return M
