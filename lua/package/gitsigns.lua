-- local is_diffing = false

local function diffthis()
  local gitsigns = require('gitsigns')
  -- print(vim.bo.filetype)
  -- print(vim.wo.diff)
  -- if not is_diffing then
      gitsigns.diffthis()
  --     is_diffing = true
  -- else
      -- vim.cmd('wincmd p | q')
      -- is_diffing = false
  -- end
end

local next_hunk = function ()
  local gitsigns = require('gitsigns')
  gitsigns.nav_hunk("next", { preview = false })
  vim.defer_fn(function ()
    gitsigns.preview_hunk_inline()
  end, 50)
end

local prev_hunk = function ()
  local gitsigns = require('gitsigns')
  gitsigns.nav_hunk("prev", { preview = false })
  vim.defer_fn(function ()
    gitsigns.preview_hunk_inline()
  end, 50)
end

local reset_hunk = function ()
  local gitsigns = require('gitsigns')
  gitsigns.reset_hunk()
end


M = {
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',
  opts = {
    -- See `:help gitsigns.txt`
    numhl = true,
    signcolumn = false,
    diff_opts = {
      internal = true
    },
    word_diff = false,
    on_attach = function(_)
      vim.keymap.set('n', '<leader>hn', next_hunk, { noremap = true, desc='[N]ext hunk (<C-j>)' })
      vim.keymap.set('n', '<C-j>', next_hunk, { desc = 'Next Hunk' })
      vim.keymap.set('n', '<leader>hp', next_hunk, { noremap = true, desc='[P]revious hunk (<C-k>)' })
      vim.keymap.set('n', '<C-k>', prev_hunk, { desc = 'Previous Hunk' })
      vim.keymap.set('n', '<leader>hr', reset_hunk, { noremap = true, desc='[R]eset hunk' })
      vim.keymap.set('n', '<leader>hR', require('gitsigns').reset_buffer, { noremap = true, desc='[R]eset to ~HEAD' })
      vim.keymap.set('n', '<leader>hs', require('gitsigns').stage_hunk, { noremap = true, desc='[S]tage hunk' })
      vim.keymap.set('n', '<leader>ha', require('gitsigns').stage_buffer, { noremap = true, desc='Stage [A]ll hunks (buffer)' })
      vim.keymap.set('n', '<leader>hu', require('gitsigns').reset_buffer_index, { noremap = true, desc='[U]nstage all hunks (buffer)' })
      vim.keymap.set('n', '<leader>l', diffthis, {desc = 'display [H]unk [L]ines'})
    end,
  },
}
return M
