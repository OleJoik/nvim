M = {}

local default_width = 50
local spectre_width = 60

local find_explorer = function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local buf_filetype = vim.api.nvim_buf_get_option(buf, 'filetype')
    
    if buf_filetype == 'neo-tree' then
      width = vim.api.nvim_win_get_width(win)
      return {buf = buf, win = win}
    end
  end

  return nil
end

local close_explorer = function()
  local width = nil
  local ex = find_explorer()
  if ex then
    width = vim.api.nvim_win_get_width(ex.win)
  end

  vim.cmd("Neotree action=close")
  return width
end

local find_git = function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].filetype == 'fugitive' then
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == buf then
          out = {buf=buf, win=win}
          return {buf = buf, win=win}
        end
      end
    end
  end

  return nil
end

local focus_git = function()
  local git_buf = find_git()

  if git_buf then
    vim.api.nvim_set_current_win(git_buf.win)
    return true
  end

  return false
end

local close_git = function()
  local git_buf = find_git()

  if git_buf then
      fugitive_width = vim.api.nvim_win_get_width(git_buf.win)
      vim.api.nvim_buf_delete(git_buf.buf, { force = true })
      return fugitive_width
  end

  return nil
end

local find_spectre = function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local buf_filetype = vim.api.nvim_buf_get_option(buf, 'filetype')

    if buf_filetype == "spectre_panel" then
      return {buf=buf, win=win}
    end
  end

  return nil
end

local focus_spectre = function()
  local location = find_spectre()

  if location then
    vim.api.nvim_set_current_win(location.win)
    return true
  end

  return false
end

local close_spectre = function()
  local location = find_spectre()
  if location then
    vim.api.nvim_buf_delete(location.buf, { force = true })
  end
end

M.open_explorer = function()
    close_spectre()
    width = close_git()
    require('neo-tree.command').execute({ 
        position = 'right',
        action= "focus",
    })
    local current_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_width(current_win, width or default_width)
end

M.open_git = function()
    if focus_git() then
        return
    end

    close_spectre()
    local other_width = close_explorer()
    local width = other_width or default_width
    vim.cmd('vert Git | wincmd L | vert resize ' .. width)
    -- vim.api.nvim_set_keymap('n', '<leader>o', ':Gedit <cfile> | wincmd h<CR>', { noremap = true, silent = true })
    return 5
end

local function clear_namespace_across_all_buffers(ns_id)
  local buffers = vim.api.nvim_list_bufs()

  for _, buf in ipairs(buffers) do
    if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
      vim.api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)
    end
  end
end

local open_spectre_file = function(file_path, cursor, search, replace)
  vim.cmd("e " .. vim.fn.fnameescape(file_path))
  local ns_id = vim.api.nvim_create_namespace("SearchReplace")
  clear_namespace_across_all_buffers(ns_id)
  vim.api.nvim_buf_add_highlight(0, ns_id, "@diff.delta", cursor.lnum - 1, cursor.col - 1, cursor.col + string.len(search) - 1)
  vim.api.nvim_win_set_cursor(0, {cursor.lnum, cursor.col - 1})
  vim.cmd("normal! zz")
end


local preview_search_replace_buf = function(row)
    if row.filename then
      vim.api.nvim_win_set_cursor(0, {row.line, 5})
      vim.cmd("wincmd p")

      local query = require("spectre.actions").get_state().query
      open_spectre_file(row.filename, row.cursor, query.search_query, query.replace_query)
      vim.cmd("wincmd p")
    end
end

local previous_spectre_line = function()
    local cursor_line_n = vim.api.nvim_win_get_cursor(0)[1]
    local prev = cursor_line_n
    local filename = nil
    local cursor = nil
    for _,val in ipairs(require('spectre.actions').get_all_entries()) do
      display_line = val["display_lnum"] + 1
      
      if display_line < cursor_line_n and (prev < display_line or prev == cursor_line_n) then
        prev = display_line
        filename = val["filename"]
        cursor = {lnum = val["lnum"], col=val["col"]}
      end
    end  

  return {line=prev, filename=filename, cursor=cursor}
end

local next_spectre_line = function()
    local cursor_line_n = vim.api.nvim_win_get_cursor(0)[1]
    local next = cursor_line_n
    local filename = nil
    local cursor = nil
    for _,val in ipairs(require('spectre.actions').get_all_entries()) do
      display_line = val["display_lnum"] + 1
      
      if display_line > cursor_line_n and (next > display_line or next == cursor_line_n) then
        next = display_line
        filename = val["filename"]
        cursor = {lnum = val["lnum"], col=val["col"]}
      end
    end  

  return {line=next, filename=filename, cursor=cursor}
end


M.spectre_next = function()
    focus_spectre()
    local row = next_spectre_line()
    preview_search_replace_buf(row)
    return 
end

M.spectre_previous = function()
    focus_spectre()
    local row = previous_spectre_line()
    preview_search_replace_buf(row)
    return 
end

M.open_spectre = function(search_text)
  if focus_spectre() then
      return
  end

  local width = close_git()
  if not width then
    width = close_explorer()
  end

  if not width or width < spectre_width then
    width = spectre_width
  end

  local is_insert_mode = true
  if string.len(search_text) > 0 then
    is_insert_mode = false
  end

  require('spectre').open({
    is_insert_mode = is_insert_mode,
    search_text=search_text,
  })

  local loc = find_spectre()
  local sidebar = require("sidebar")

  vim.keymap.set("n", "<C-j>", sidebar.spectre_next, { silent = true, noremap = true, buffer = loc.buf })
  vim.keymap.set("n", "<C-k>", sidebar.spectre_previous, { silent = true, noremap = true, buffer = loc.buf })
  vim.api.nvim_win_set_width(loc.win, width)
end


local buf = vim.api.nvim_create_buf(true, true)
vim.api.nvim_set_current_buf(buf)

return M

