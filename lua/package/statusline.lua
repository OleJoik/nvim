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

function Venv()
  local filetype = vim.bo.filetype
  local python_path = vim.fn.exepath("python")
  if python_path == '' then
    return ""
  end

  -- Check if this python is from a venv (look for pyvenv.cfg)
  local bin_dir = vim.fn.fnamemodify(python_path, ":h")
  local venv_dir = vim.fn.fnamemodify(bin_dir, ":h")
  local pyvenv_cfg = venv_dir .. "/pyvenv.cfg"

  local is_venv = vim.fn.filereadable(pyvenv_cfg) == 1

  if not is_venv and filetype ~= "python" then
    return ""
  end

  local parent = vim.fn.fnamemodify(venv_dir, ":h:t")
  local name = vim.fn.fnamemodify(venv_dir, ":t")
  return string.format(" %s/%s", parent, name)
end

return { {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    -- Disable showing mode messages in command line (lualine gots it!)
    -- vim.opt.showmode = false

    -- Disables the % of file and row/column from command line
    vim.opt.ruler = false

    require('lualine').setup({
      sections = {
        lualine_a = { 'branch' },
        lualine_b = { 'diff' },
        lualine_c = { 'diagnostics' },
        lualine_x = { Venv, FormatOnSave, },
        lualine_y = { 'encoding' },
        lualine_z = { 'location' }
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
      },
    })
  end
} }
