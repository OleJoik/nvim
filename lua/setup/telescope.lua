local actions = require "telescope.actions"
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
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = function(bufnr) slow_scroll(bufnr, 1) end,
        ["<C-k>"] = function(bufnr) slow_scroll(bufnr, -1) end,
      },
      n = {
        ["<C-j>"] = function(bufnr) slow_scroll(bufnr, 1) end,
        ["<C-k>"] = function(bufnr) slow_scroll(bufnr, -1) end,
      },
    },

    path_display={"smart"}
  },
  pickers = {
    find_files = {
      theme = "dropdown",
      previewer = false,
      layout_config = {
        prompt_position = "top",
        anchor = "N"
      }
    },
    buffers = {
      theme = "dropdown",
      previewer = false,
      layout_config = {
        prompt_position = "top",
        anchor = "N"
      },
      mappings = {
        i = {
          ["<c-x>"] = actions.delete_buffer + actions.move_to_top,
        },
        n = {
          ["<c-x>"] = actions.delete_buffer + actions.move_to_top,
        },
      },
    }
  }
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    --winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>fg', require('telescope.builtin').git_files, { desc = '[F]ind [G]it files' })
vim.keymap.set('n', '<C-p>', require('telescope.builtin').find_files, { desc = '[F]ind [F]iles' })
vim.keymap.set('n', '<leader>ff', ':lua require"telescope.builtin".find_files({ hidden = true })<CR>', { desc = '[F]ind all [F]iles' })
vim.keymap.set('n', '<leader>fw', require('telescope.builtin').grep_string, { desc = '[F]ind current [W]ord' })
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = '[F]ind by [G]rep' })
vim.keymap.set('n', '<leader>fd', require('telescope.builtin').diagnostics, { desc = '[F]ind [D]iagnostics' })
vim.keymap.set('n', '<C-g>', require('telescope.builtin').git_status)


vim.keymap.set('n', '<leader>fc', require('telescope.builtin').git_bcommits, { desc = '[F]ind [C]ommit' })

-- builtin.git_bcommits
