function IsCursorInPythonTest()
    local parsers = require'nvim-treesitter.parsers'
    local ts_utils = require'nvim-treesitter.ts_utils'

    local bufnr = vim.api.nvim_get_current_buf()

    local parser = parsers.get_parser(bufnr, "python")
    if not parser then
        return false
    end

    local node = ts_utils.get_node_at_cursor()

    while node do
        if node:type() == "function_definition" then
            local first_child = node:child(1)
            if first_child and first_child:type() == "identifier" then
                local func_name = ts_utils.get_node_text(first_child)[1]
                if func_name:match("^test_") then
                    return func_name
                end
            end
        end
        node = node:parent()
    end

    return false
end

function PythonDebugBrowser()
  local func_name = IsCursorInPythonTest()
  if not func_name then
    return
  end

  print("Running ".. func_name .. " in pytest (playwright debug mode)")
  local command = "term PWDEBUG=1 pytest -s -k " .. func_name
  vim.cmd(command)
end

function PythonTestSlow()
  local func_name = IsCursorInPythonTest()
  if not func_name then
    return
  end

  print("Running ".. func_name .. " in pytest (playwright slow motion)")
  local command = "term pytest --slowmo 500 --headed -s -k " .. func_name
  vim.cmd(command)
end

local function open_hover_repl()
  local dap = require('dap')
  local width = 80

  local winopts = {
      width = width,
  }

  dap.repl.toggle(winopts, '50vsplit new')
end

local function DebugPythonFile()
  local dap = require('dap')
  for _, cfg in ipairs(dap.configurations.python) do
      if cfg.name == "Launch file" then
         Selected = cfg
      end
  end

  dap.run(Selected)
end

M = {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require('dap')
      vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = '[B]reakpoint' })
      vim.keymap.set('n', '<leader>dc', dap.continue, { desc = '[D]ebug [C]ontinue' })
      vim.keymap.set('n', '<leader>ds', dap.terminate, { desc = '[D]ebug [S]top' })
      vim.keymap.set('n', '<leader>dr', open_hover_repl, {noremap = true, silent = true, desc = "[D]ebug [R]epl"})

      vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
        require('dap.ui.widgets').hover()
      end, { desc = "[H]over selection (DAP)"})
      vim.keymap.set('n', '<Leader>di', function()
        local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets.scopes)
      end, { desc = "[I]nspect scopes (DAP)"})

      dap.defaults.fallback.terminal_win_cmd = '15split new'
    end
  },
  {
    "mfussenegger/nvim-dap-python",
    config = function()
      require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')
      require('dap-python').test_runner = 'pytest'

      vim.keymap.set('n', '<leader>tb', PythonDebugBrowser, {noremap = true, silent = true, desc = "Run [T]est in [B]rowser"})
      vim.keymap.set('n', '<leader>ts', PythonTestSlow, {noremap = true, silent = true, desc = "Run [T]est [S]lowly (Browser)"})
      vim.keymap.set('n', '<leader>td', require('dap-python').test_method, {noremap = true, silent = true, desc = "[D]ebug test"})
      vim.keymap.set('n', '<leader>dpf', DebugPythonFile, {noremap = true, silent = true, desc = "[D]ebug [P]ython [F]ile"})
    end
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    config = function()
      require("nvim-dap-virtual-text").setup({
        virt_text_win_col = 80,
        highlight_changed_variables = true
      })
    end
  }
}

return M
