-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
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
vim.keymap.set('n', '<C-p>', require('telescope.builtin').find_files, {})
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = '[F]ind [F]iles' })
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = '[F]ind [H]elp' })
vim.keymap.set('n', '<leader>fw', require('telescope.builtin').grep_string, { desc = '[F]ind current [W]ord' })
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = '[F]ind by [G]rep' })
vim.keymap.set('n', '<leader>fd', require('telescope.builtin').diagnostics, { desc = '[F]ind [D]iagnostics' })

local function find_directory_and_focus()
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  local nvim_tree_api = require("nvim-tree")

  local function open_nvim_tree(prompt_bufnr, _)
    actions.select_default:replace(function()
      actions.close(prompt_bufnr)
      local selection = action_state.get_selected_entry()
      nvim_tree_api.tree.open()
      nvim_tree_api.tree.find_file(selection.cwd .. "/" .. selection.value)
    end)
    return true
  end

  require("telescope.builtin").find_files({
    find_command = { "fd", "--type", "directory", "--hidden", "--exclude", ".git/*" },
    attach_mappings = open_nvim_tree,
  })
end

vim.keymap.set("n", "<leader>fd", find_directory_and_focus, { desc = '[F]ind [D]irectory' })

