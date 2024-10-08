local actions = require("telescope.actions")

local state = require("telescope.state")
local action_state = require("telescope.actions.state")

local slow_scroll = function(prompt_bufnr, direction)
	local previewer = action_state.get_current_picker(prompt_bufnr).previewer
	local status = state.get_status(prompt_bufnr)

	-- Check if we actually have a previewer and a preview window
	if type(previewer) ~= "table" or previewer.scroll_fn == nil or status.preview_win == nil then
		return
	end

	previewer:scroll_fn(1 * direction)
end

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require("telescope").setup({
	defaults = {
		mappings = {
			i = {
				["<C-j>"] = function(bufnr)
					slow_scroll(bufnr, 1)
				end,
				["<C-k>"] = function(bufnr)
					slow_scroll(bufnr, -1)
				end,
			},
			n = {
				["<C-j>"] = function(bufnr)
					slow_scroll(bufnr, 1)
				end,
				["<C-k>"] = function(bufnr)
					slow_scroll(bufnr, -1)
				end,
			},
		},

		path_display = { "smart" },
	},
	pickers = {
		find_files = {
			theme = "dropdown",
			previewer = false,
			layout_config = {
				prompt_position = "top",
				anchor = "N",
			},
		},
		buffers = {
			theme = "dropdown",
			previewer = false,
			layout_config = {
				prompt_position = "top",
				anchor = "N",
			},
			mappings = {
				i = {
					["<c-x>"] = actions.delete_buffer + actions.move_to_top,
				},
				n = {
					["<c-x>"] = actions.delete_buffer + actions.move_to_top,
				},
			},
		},
	},
})

-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")

local open_file = function()
	-- win_id = vim.api.nvim_get_current_win()
	--
	-- vim.notify("win_id" .. vim.inspect(win_id), vim.log.levels.INFO)

	require("telescope.builtin").find_files()

	-- -- Get the current buffer ID
	-- local buf_id = vim.api.nvim_get_current_buf()
	--
	-- -- Get the current buffer name
	-- local buf_name = vim.api.nvim_buf_get_name(buf_id)
	-- vim.notify("buf" .. vim.inspect(buf_id) .. " " .. vim.inspect(buf_name), vim.log.levels.INFO)
	-- vim.api.nvim_win_set_var(win_id, "winbarbar", true)
end

-- See `:help telescope.builtin`
--

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>?", builtin.oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", builtin.buffers, { desc = "[ ] Find existing buffers" })

vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = "[F]ind [G]it files" })
vim.keymap.set("n", "<C-p>", open_file, { desc = "[F]ind [F]iles" })
vim.keymap.set(
	"n",
	"<leader>ff",
	':lua require"telescope.builtin".find_files({ hidden = true })<CR>',
	{ desc = "[F]ind all [F]iles" }
)
vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[F]ind current [W]ord" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind by [G]rep" })
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })

vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })

vim.keymap.set("n", "<leader>fc", builtin.git_bcommits, { desc = "[F]ind [C]ommit" })

vim.keymap.set("n", "<leader>fk", function()
	builtin.keymaps({ show_plug = false })
end, { desc = "Telescope [F]ind [K]eymap" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

-- builtin.git_bcommits
