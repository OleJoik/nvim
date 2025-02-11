_G.statusline_enabled = true

function ToggleStatusline()
  if statusline_enabled then
    vim.o.foldcolumn = "0"
    vim.wo.number = false
    vim.o.laststatus = 0
  else
    vim.o.foldcolumn = "1"
    vim.wo.number = true
    vim.o.laststatus = 2
  end
  _G.statusline_enabled = not _G.statusline_enabled
end

vim.keymap.set("n", "<leader>s", ToggleStatusline, { desc = "[S]tatusline toggle", noremap = true, silent = true })

function FormatOnSave()
  if _G.auto_format_on_save then
    return " fmt  "
  end

  return " fmt  "
end

return { {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    -- Disable showing mode messages in command line (lualine gots it!)
    -- vim.opt.showmode = false

    require('lualine').setup({
      sections = {
        lualine_a = { 'branch' },
        lualine_b = { 'diff' },
        lualine_c = { 'diagnostics' },
        lualine_x = { FormatOnSave },
        lualine_y = { 'encoding' },
        lualine_z = { 'location' }
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
      },
    })
  end
} }
