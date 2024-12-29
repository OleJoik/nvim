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

local next_hunk = function()
  local gitsigns = require('gitsigns')
  gitsigns.nav_hunk("next", { preview = false })
  vim.defer_fn(function()
    gitsigns.preview_hunk_inline()
  end, 50)
end

local prev_hunk = function()
  local gitsigns = require('gitsigns')
  gitsigns.nav_hunk("prev", { preview = false })
  vim.defer_fn(function()
    gitsigns.preview_hunk_inline()
  end, 50)
end

local reset_hunk = function()
  local gitsigns = require('gitsigns')
  gitsigns.reset_hunk()
end

return {
  "kevinhwang91/nvim-ufo",
  dependencies = {
    "kevinhwang91/promise-async",
    {
      "luukvbaal/statuscol.nvim",
      config = function()
        local builtin = require("statuscol.builtin")
        require("statuscol").setup({
          relculright = true,
          segments = {
            {
              sign = { namespace = { "diagnostic/signs" }, maxwidth = 1, auto = false },
              click = "v:lua.ScSa"
            },
            { text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },
            { text = { builtin.lnumfunc },      click = "v:lua.ScLa", },
            {
              sign = { namespace = { ".*" }, maxwidth = 1, colwidth = 1, auto = false, wrap = true },
              click = "v:lua.ScSa"
            },
            { text = { " " } },
          },
          ft_ignore = { "neo-tree" },
          bt_ignore = { "terminal" },
        })
      end,
    },
    {
      -- Adds git related signs to the gutter, as well as utilities for managing changes
      'lewis6991/gitsigns.nvim',
      opts = {
        -- See `:help gitsigns.txt`
        numhl = true,

        -- signs = {
        --   add          = { text = '┃' },
        --   change       = { text = '┃' },
        --   delete       = { text = '_' },
        --   topdelete    = { text = '‾' },
        --   changedelete = { text = '~' },
        --   untracked    = { text = '┆' },
        -- },
        -- signcolumn = true,
        -- diff_opts = {
        --   internal = true
        -- },
        -- word_diff = false,
        -- on_attach = function(_)
        --   vim.keymap.set('n', '<leader>hn', next_hunk, { noremap = true, desc = '[N]ext hunk (<C-j>)' })
        --   vim.keymap.set('n', '<A-j>', next_hunk, { desc = 'Next Hunk' })
        --   vim.keymap.set('n', '<leader>hp', next_hunk, { noremap = true, desc = '[P]revious hunk (<C-k>)' })
        --   vim.keymap.set('n', '<A-k>', prev_hunk, { desc = 'Previous Hunk' })
        --   vim.keymap.set('n', '<leader>hr', reset_hunk, { noremap = true, desc = '[R]eset hunk' })
        --   vim.keymap.set('n', '<leader>hR', require('gitsigns').reset_buffer,
        --     { noremap = true, desc = '[R]eset to ~HEAD' })
        --   vim.keymap.set('n', '<leader>hs', require('gitsigns').stage_hunk, { noremap = true, desc = '[S]tage hunk' })
        --   vim.keymap.set('n', '<leader>s', require('gitsigns').stage_hunk, { noremap = true, desc = '[S]tage hunk' })
        --   vim.keymap.set('n', '<leader>ha', require('gitsigns').stage_buffer,
        --     { noremap = true, desc = 'Stage [A]ll hunks (buffer)' })
        --   vim.keymap.set('n', '<leader>hu', require('gitsigns').reset_buffer_index,
        --     { noremap = true, desc = '[U]nstage all hunks (buffer)' })
        --   vim.keymap.set('n', '<leader>bb', function() require('gitsigns').blame {} end, {
        --     noremap = true,
        --     desc =
        --     "Blame"
        --   })
        --   vim.keymap.set('n', '<leader>hl', diffthis, { desc = 'display [H]unk [L]ines' })
        -- end,
      },
    }
  },
  config = function()
    vim.o.foldcolumn = "1"
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
    vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

    ---@diagnostic disable-next-line: missing-fields
    require('ufo').setup({
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
    })
  end,
}
