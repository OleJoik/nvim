local statusline_enabled = true

function ToggleStatusline()
  if statusline_enabled then
    vim.o.laststatus = 0
  else
    vim.o.laststatus = 2
  end
  statusline_enabled = not statusline_enabled
end

vim.keymap.set("n", "<leader>ss", ToggleStatusline, { desc = "[S]tatusline toggle", noremap = true, silent = true })

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
        lualine_b = { 'diff', 'diagnostics' },
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
