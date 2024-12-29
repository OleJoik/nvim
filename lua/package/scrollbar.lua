return {
  "lewis6991/satellite.nvim",
  config = function()
    require('satellite').setup {
      current_only = false,
      winblend = 50,
      zindex = 40,
      excluded_filetypes = {},
      width = 2,
      handlers = {
        ---@diagnostic disable-next-line: missing-fields
        cursor = {
          enable = false,
          -- symbols = { '⎻', '⎼' }
          -- Highlights:
          -- - SatelliteCursor (default links to NonText)
        },
        search = {
          enable = true,
          -- Highlights:
          -- - SatelliteSearch (default links to Search)
          -- - SatelliteSearchCurrent (default links to SearchCurrent)
        },
        diagnostic = {
          enable = true,
          signs = {
            error = {'󰅙 '},
            warn = {' '},
            info = {'󰋼 '},
            hint = {'󰌵 '}
          },
          min_severity = vim.diagnostic.severity.HINT,
          -- Highlights:
          -- - SatelliteDiagnosticError (default links to DiagnosticError)
          -- - SatelliteDiagnosticWarn (default links to DiagnosticWarn)
          -- - SatelliteDiagnosticInfo (default links to DiagnosticInfo)
          -- - SatelliteDiagnosticHint (default links to DiagnosticHint)
        },
        gitsigns = {
          enable = true,
          signs = { -- can only be a single character (multibyte is okay)
            add = "│",
            change = "│",
            delete = "-",
          },
          -- Highlights:
          -- SatelliteGitSignsAdd (default links to GitSignsAdd)
          -- SatelliteGitSignsChange (default links to GitSignsChange)
          -- SatelliteGitSignsDelete (default links to GitSignsDelete)
        },
        ---@diagnostic disable-next-line: missing-fields
        marks = {
          enable = false,
        },
        ---@diagnostic disable-next-line: missing-fields
        quickfix = {
          signs = { '-', '=', '≡' },
          -- Highlights:
          -- SatelliteQuickfix (default links to WarningMsg)
        }
      },
    }
  end

}
