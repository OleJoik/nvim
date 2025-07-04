_G.skip_formatting_buffers = {}
_G.auto_format_on_save = true

function ToggleFormatOnSave()
  _G.auto_format_on_save = not _G.auto_format_on_save
end

vim.keymap.set("n", "<leader>ft", ToggleFormatOnSave, { desc = "[T]oggle Format on Save", noremap = true, silent = true })

local function should_format(buf)
  if _G.auto_format_on_save == false then
    return false
  end

  if _G.skip_formatting_buffers[buf] == true then
    return false
  end

  return true
end



vim.keymap.set("n", "<leader>S", function()
  local bufnr = vim.api.nvim_get_current_buf()
  _G.skip_formatting_buffers[bufnr] = true
  vim.cmd("write")
  _G.skip_formatting_buffers[bufnr] = false
end, { noremap = true, silent = true, desc = "[S]ave without formatting" })

local on_attach = function(client, bufnr)
  local signs = {
    Error = { symbol = "󰅙 ", severity = 100 },
    Warn = { symbol = " ", severity = 80 },
    Hint = { symbol = "󰌵 ", severity = 70 },
    Info = { symbol = "󰋼 ", severity = 60 }
  }
  for type, sign in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = sign.symbol, texthl = hl, numhl = hl, severity = sign.severity })
  end

  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

  nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
  nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
  nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
  -- nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- Lesser used LSP functionality
  nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
  nmap("<leader>rr", ":LspRestart<CR>", "LSP Restart")
  nmap("<leader>fo", vim.lsp.buf.format, "[FO]rmat buffer")

  nmap("<C-æ>", function()
    vim.diagnostic.goto_next({ float = false })
    vim.lsp.buf.hover()
  end, "Next [D]iagnostic")
  nmap("<C-å>", function()
    vim.diagnostic.goto_prev({ float = false })
    vim.lsp.buf.hover()
  end, "Previous [D]iagnostic")

  if client.name == "ruff_lsp" then
    -- Disable hover in favor of Pyright
    client.server_capabilities.hoverProvider = false
  end


  nmap("<leader>io", function()
    if vim.bo[bufnr].filetype == "python" then
      vim.lsp.buf.code_action({
        ---@diagnostic disable-next-line: missing-fields
        context = { only = { "source.organizeImports" } },
        apply = true,
      })
      vim.wait(100)
    end
  end, "[O]rganize Imports")



  -- local focus_id = "test-focuser"
  local hover_handler = function(_, hover_data)
    local current_line = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())[1]
    local diagnostics = vim.diagnostic.get(0, { lnum = current_line - 1 })

    local severity_to_hl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticFloatingError",
      [vim.diagnostic.severity.WARN] = "DiagnosticFloatingWarn",
      [vim.diagnostic.severity.INFO] = "DiagnosticFloatingInfo",
      [vim.diagnostic.severity.HINT] = "DiagnosticFloatingHint",
    }

    local messages = {}
    local highlights = {}
    for _, d in ipairs(diagnostics) do
      if d.message ~= nil then
        local msg = d.message
        if d.severity ~= nil then
          local hl_group = severity_to_hl[d.severity]
          table.insert(highlights, { line = #messages, col_start = 0, col_end = #d.message, hl_group = hl_group })
        end

        if d.code ~= nil or d.source ~= nil then
          msg = msg .. " ("
        end

        if d.code ~= nil then
          msg = msg .. "code: `" .. d.code .. "`"
        end

        if d.code ~= nil and d.source ~= nil then
          msg = msg .. ", "
        end

        if d.source ~= nil then
          msg = msg .. "source: `" .. d.source .. "`"
        end

        if d.code ~= nil or d.source ~= nil then
          msg = msg .. ")"
        end
        table.insert(messages, msg)
      end
    end


    local hover = nil
    if hover_data ~= nil and hover_data.contents ~= nil and hover_data.contents.value ~= nil then
      hover = hover_data.contents.value
    end


    local hover_content = ""
    if #diagnostics > 0 then
      hover_content = hover_content .. "Diagnostics:\n"
      hover_content = hover_content .. table.concat(messages, "\n")
    end

    if #diagnostics > 0 and hover ~= nil then
      hover_content = hover_content .. "\n\n------------------------------\n\n"
    end

    if hover ~= nil then
      hover_content = hover_content .. hover .. "\n"
    end

    if #hover_content > 0 then
      local buf = vim.lsp.util.open_floating_preview(
        { hover_content },
        "markdown",
        {}
      -- { focus_id = focus_id }
      )

      for _, hl in ipairs(highlights) do
        vim.api.nvim_buf_add_highlight(buf, -1, hl.hl_group, hl.line + 1, hl.col_start, hl.col_end)
      end
    end
  end

  -- See `:help K` for why this keymap
  nmap("K", vim.lsp.buf.hover, "[K]eywordprg")
  vim.lsp.handlers["textDocument/hover"] = hover_handler
end

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
      {
        "folke/lazydev.nvim",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      vim.diagnostic.config({ virtual_text = false })

      local capabilities = require("blink.cmp").get_lsp_capabilities()
      require("lspconfig").lua_ls.setup({ capabilities = capabilities, on_attach = on_attach, })
      require("lspconfig").ts_ls.setup({ capabilities = capabilities, on_attach = on_attach })
      require("lspconfig").eslint.setup({ capabilities = capabilities, on_attach = on_attach })
      require 'lspconfig'.gopls.setup { capabilities = capabilities, on_attach = on_attach }
      require("lspconfig").ruff.setup({
        init_options = {
          settings = {
            -- Any extra CLI arguments for `ruff` go here.
            args = {},
          },
        },
        on_attach = on_attach,
        capabilities = capabilities,
      })

      require("lspconfig").pyright.setup({
        settings = {
          pyright = {
            -- Using Ruff's import organizer
            disableOrganizeImports = true,
          },
        },
        on_attach = on_attach,
        capabilities = capabilities,
      })


      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local c = vim.lsp.get_client_by_id(args.data.client_id)
          if not c then return end

          vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*.go",
            callback = function()
              if should_format(args.buf) == false then
                return
              end

              local params = vim.lsp.util.make_range_params()
              params.context = { only = { "source.organizeImports" } }
              -- buf_request_sync defaults to a 1000ms timeout. Depending on your
              -- machine and codebase, you may want longer. Add an additional
              -- argument after params if you find that you have to write the file
              -- twice for changes to be saved.
              -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
              local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
              for cid, res in pairs(result or {}) do
                for _, r in pairs(res.result or {}) do
                  if r.edit then
                    local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                    vim.lsp.util.apply_workspace_edit(r.edit, enc)
                  end
                end
              end
              vim.lsp.buf.format({ async = false })
            end
          })

          if vim.bo.filetype == "lua" then
            -- Format the current buffer on save
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = args.buf,
              callback = function()
                if should_format(args.buf) == false then
                  return
                end

                vim.lsp.buf.format({ bufnr = args.buf, id = c.id })
                -- re-enable diagnostic after formatting
                -- https://www.reddit.com/r/neovim/comments/15dfx4g/help_lsp_diagnostics_are_not_being_displayed/
                vim.diagnostic.enable()
              end,
            })
          else
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = args.buf,
              callback = function()
                if should_format(args.buf) then
                  vim.lsp.buf.format({ async = false })
                end
              end,
            })
          end
        end,
      })
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    config = function()
      local null_ls = require("null-ls")

      local sources = {
        null_ls.builtins.formatting.prettierd
      }

      if vim.fn.executable("mypy") == 1 then
        print("mypy is loaded with null-ls")
        table.insert(sources, null_ls.builtins.diagnostics.mypy)
      end

      if #sources > 0 then
        null_ls.setup({
          sources = sources,
        })
      end
    end
  }
}
