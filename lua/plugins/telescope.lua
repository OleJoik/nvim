local M = {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
      dependencies = { 
          'nvim-lua/plenary.nvim',
          'BurntSushi/ripgrep'
  }
}

function M.config()
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
    vim.keymap.set('n', '<C-p>', builtin.git_files, {})
    vim.keymap.set('n', '<leader>ps', builtin.live_grep, {})
end

return M
