

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
--
-- local python_path = vim.fn.system("which python"):gsub("\n", "")

M = {
  servers = {
    -- clangd = {},
    -- gopls = {},
    pyright = {
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            diagnosticMode = "openFilesOnly",
            useLibraryCodeForTypes = true,
          },
        },
      },
    },
    -- mypy = {
    -- },
    -- rust_analyzer = {},
    tsserver = {},
    html = { filetypes = { 'html', 'twig', 'hbs'} },
    emmet_ls = {},

    lua_ls = {
      settings = {
        Lua = {
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      }
    },
    tailwindcss = {
      filetypes = {
        "css",
        "scss",
        "sass",
        "html",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "htmldjango",
        "python"
      },
      init_options = {
        userLanguages = {
          python = "html",
        },
      },
      settings = {
        includeLanguages = {
          typescript = "javascript",
          typescriptreact = "javascript",
          htmldjango = "html",
          python = "html"
        },
        tailwindCSS = {
          experimental = {
            classRegex = {
              [[class_="([^"]*)]],
            },
          }
        }
      },
    }
  }
}
return M
