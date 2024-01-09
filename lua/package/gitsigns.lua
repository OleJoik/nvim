
M = {
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',
  opts = {
    -- See `:help gitsigns.txt`
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    on_attach = function(bufnr)
      vim.keymap.set('n', '<leader>hp', require('gitsigns').prev_hunk, { buffer = bufnr, desc = 'go [H]unk ([P]revious)' })
      vim.keymap.set('n', '<leader>[h', require('gitsigns').prev_hunk, { buffer = bufnr })
      vim.keymap.set('n', '<leader>hn', require('gitsigns').next_hunk, { buffer = bufnr, desc = 'go [H]unk ([N]ext)' })
      vim.keymap.set('n', '<leader>]h', require('gitsigns').next_hunk, { buffer = bufnr })
      vim.keymap.set('n', '<leader>hd', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[H]unk [D]isplay' })
      vim.keymap.set('n', '<leader>hr', ':Gitsigns reset_hunk<CR>', { noremap = true, desc='[H]unk [R]evert' })
      vim.keymap.set('n', '<leader>hl', ":Gitsigns toggle_linehl<CR>:Gitsigns toggle_word_diff<CR>", {desc = 'display [H]unk [L]ines'})
    end,
  },
}
return M
