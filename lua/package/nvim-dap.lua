local function open_hover_repl()
	local dap = require("dap")
	local width = 80

	local winopts = {
		width = width,
	}

	dap.repl.toggle(winopts, "50vsplit new")
end

local function DebugPythonFile()
	local dap = require("dap")
	for _, cfg in ipairs(dap.configurations.python) do
		if cfg.name == "Launch file" then
			Selected = cfg
		end
	end

	dap.run(Selected)
end

local function DebugProject()
	local dap = require("dap")

	if dap.configurations.project_config == nil or #dap.configurations.project_config == 0 then
		vim.notify("No dap project configurations.\nMay be added in nvim-dap.lua")
		return
	end

	if #dap.configurations.project_config == 1 then
		local selected = dap.configurations.project_config[1]
		print("Running with configuration: " .. selected.name)

		dap.run(selected)

		return
	end

	local configurations = ""
	for i, cfg in ipairs(dap.configurations.project_config) do
		configurations = configurations .. i .. ": " .. cfg.name .. "\n"
	end
	configurations = string.sub(configurations, 1, -2)

	local input = vim.fn.input(configurations .. "\nEnter a number: ")
	local number = tonumber(input)
	if number then
		if number > 0 and number <= #dap.configurations.project_config then
			local selected = dap.configurations.project_config[number]
			dap.run(selected)

			return
		end

		vim.api.nvim_echo({
			{ "ERROR! ", "ErrorMsg" },
			{ "You entered: " .. number .. ", not a valid configuration.", "Normal" },
		}, false, {})
	else
		vim.api.nvim_echo({
			{ "ERROR! ", "ErrorMsg" },
			{ "INVALID INPUT! Please enter a valid number.", "Normal" },
		}, false, {})
	end
end

M = {
	{
		"mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")

			require("dap.ext.vscode").load_launchjs(nil, { debugpy = { "project_config" } })

			vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "[B]reakpoint" })
			vim.keymap.set("n", "<C-s>b", dap.toggle_breakpoint, { desc = "[B]reakpoint" })
			vim.keymap.set("n", "<C-c><C-c>", dap.continue, { desc = "[C]ontinue" })
			vim.keymap.set("n", "<C-s><C-c>", dap.continue, { desc = "[C]ontinue" })
			vim.keymap.set("n", "<C-s><C-s>", dap.terminate, { desc = "[S]top" })
			vim.keymap.set("n", "<C-s><C-i>", dap.step_into, { desc = "[I]nto" })
			vim.keymap.set("n", "<C-s><C-o>", dap.step_over, { desc = "[O]ver" })
			vim.keymap.set("n", "<C-s><C-r>", open_hover_repl, { noremap = true, silent = true, desc = "[R]epl" })

			vim.keymap.set({ "n", "v" }, "<C-s><C-h>", require("dap.ui.widgets").hover, { desc = "[H]over DAP" })
			vim.keymap.set("n", "<C-s><C-v>", require("sidebar").open_dap_scopes, { desc = "[V]ariables (scopes)" })

			vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })
			vim.fn.sign_define(
				"DapStopped",
				{ text = " ", texthl = "ErrorMsg", linehl = "DebugBreakpointLine", numhl = "" }
			)

			vim.keymap.set(
				"n",
				"<C-s><C-t>",
				require("dap-python").test_method,
				{ noremap = true, silent = true, desc = "[T]est" }
			)
			vim.keymap.set("n", "<C-s><C-f>", DebugPythonFile, { noremap = true, silent = true, desc = "[F]ile" })
			vim.keymap.set("n", "<C-s><C-p>", DebugProject, { noremap = true, silent = true, desc = "[P]roject" })

			vim.keymap.set("n", "<C-s><C-b>", function()
				local foo = require("dap.breakpoints").get()

				local lines = {}
				for buf_id, bps in pairs(foo) do
					local buffer_name = vim.fn.bufname(buf_id)
					table.insert(lines, "")
					table.insert(lines, "### " .. buf_id .. ": " .. buffer_name)

					for _, bp in ipairs(bps) do
						local line = vim.api.nvim_buf_get_lines(buf_id, bp.line - 1, bp.line, false)[1]
						table.insert(lines, "- " .. bp.line .. ": " .. line)
					end

					local buf = vim.api.nvim_create_buf(false, true)
					vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
					vim.api.nvim_set_current_buf(buf)
				end
			end, { noremap = true, silent = true, desc = "List [B]reakpoints" })

			dap.defaults.fallback.terminal_win_cmd = "15split new"
		end,
	},
	{
		"mfussenegger/nvim-dap-python",
		config = function()
			local dap = require("dap")
			require("dap-python").setup("/home/olol/.nix-profile/bin/python")
			require("dap-python").test_runner = "pytest"

			local debug_python_file = dap.configurations.python[1]
			dap.configurations.python = { debug_python_file }
		end,
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		config = function()
			require("nvim-dap-virtual-text").setup({
				enabled_commands = true,
				virt_text_win_col = 40,
				highlight_changed_variables = true,
				all_references = true,
			})
		end,
	},
}

return M
