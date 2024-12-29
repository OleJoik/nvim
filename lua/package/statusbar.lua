return {
  "kevinhwang91/nvim-ufo",
  dependencies = {
    "kevinhwang91/promise-async",
    {
      "luukvbaal/statuscol.nvim",
      config = function()
        local builtin = require("statuscol.builtin")
        require("statuscol").setup({
          relculright = true,
          segments = {
            {
              sign = { namespace = { "diagnostic/signs" }, maxwidth = 1, auto = false },
              click = "v:lua.ScSa"
            },
            { text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },
            { text = { builtin.lnumfunc },      click = "v:lua.ScLa", },
            {
              sign = { namespace = { ".*" }, maxwidth = 1, colwidth = 1, auto = false, wrap = true },
              click = "v:lua.ScSa"
            },
            { text = { " " } },
          },
          ft_ignore = { "neo-tree" },
          bt_ignore = { "terminal" },
        })
      end,
    },
  },
  config = function()
    vim.o.foldcolumn = "1"
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
    vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

    ---@diagnostic disable-next-line: missing-fields
    require('ufo').setup({
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
    })
  end,
}
