
local function print_in_split(data)
  vim.cmd("vnew") -- opens a new vertical split
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(vim.inspect(data), "\n"))
end

local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local previewers = require('telescope.previewers')
local conf = require('telescope.config').values

local function grep_tests()
    return function()
        local results = {}
        local fd = io.popen("grep -rnw 'tests/' -e 'async def test'")
        for line in fd:lines() do
            print(line)
            table.insert(results, line)
        end
        fd:close()

        print_in_split(vim.inspect(results))

        return results
    end
end


local M = {}

function M.open_picker()
    -- pickers.new({}, {
    --     prompt_title = 'Pytest Tests',
    --     finder = finders.new_table {
    --         results = grep_tests(),
    --         entry_maker = function(entry)
    --             local filename, lnum, content = string.match(entry, "([^:]+):(%d+) (.*)")
    --             return {
    --                 value = entry,
    --                 display = content,
    --                 ordinal = content,
    --                 lnum = tonumber(lnum),
    --                 filename = filename
    --             }
    --         end
    --     },
    --     sorter = conf.generic_sorter({}),
    --     previewer = previewers.vim_buffer_cat.new({}),
    --     attach_mappings = function(prompt_bufnr, map)
    --         actions.select_default:replace(function()
    --             actions.close(prompt_bufnr)
    --             local selection = action_state.get_selected_entry()
    --             vim.cmd('edit ' .. selection.filename)
    --             vim.api.nvim_win_set_cursor(0, {selection.lnum, 0})
    --         end)
    --         return true
    --     end
    -- }):find()
    print("Picker opened!")  -- Replace this with your actual function code
end

return M

-- return test_picker
