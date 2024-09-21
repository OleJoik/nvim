local Winline = {}

function Winline:open()
  parent = vim.api.nvim_get_current_win()
  geom = self:get_win_geom(parent)
  wincfg = self:get_win_config(geom)

  vim.notify(vim.inspect(geom), vim.log.levels.INFO)
  _buf = vim.api.nvim_create_buf(false, true)

  self._win = vim.api.nvim_open_win(_buf, true, wincfg)
end

function Winline:get_win_geom(parent)
  local win_width = vim.api.nvim_win_get_width(parent)
  local win_pos = vim.api.nvim_win_get_position(parent)
  local geom = {}
  geom.height = 3
  geom.width = win_width
  geom.row = win_pos[1]
  geom.col = win_pos[2]
  return geom
end

function Winline:get_win_config(geom)
  return {
    zindex = 50,
    width = geom.width,
    height = geom.height,
    row = geom.row,
    col = geom.col,
    relative = 'editor',
    -- style = 'minimal',
    focusable = true,
  }
end

vim.o.scrolloff = 10

vim.keymap.set('n', 'mf', function() Winline:open() end, { noremap = true, silent = true })


