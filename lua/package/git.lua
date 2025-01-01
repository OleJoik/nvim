return { {
  "kdheepak/lazygit.nvim",
  config = function()
    vim.g.lazygit_floating_window_scaling_factor = 0.95
    vim.cmd [[
      if has('nvim') && executable('nvr')
        let $GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
      endif
    ]]
  end
},
  {
    "FabijanZulj/blame.nvim",
    lazy = false,
    config = function()
      local virtual_view = require("blame.views.virtual_view")

      ---@type FormatFn
      local date_author_fn = function(line_porcelain, config, idx)
        local hash = string.sub(line_porcelain.hash, 0, 7)
        local line_with_hl = {}
        local is_commited = hash ~= "0000000"
        if is_commited then
          line_with_hl = {
            idx = idx,
            values = {
              {
                textValue = os.date(config.date_format, line_porcelain.committer_time),
                hl = hash,
              },
              {
                textValue = line_porcelain.author,
                hl = hash,
              },
            },
            format = "%s  %s  %s",
          }
        else
          line_with_hl = {
            idx = idx,
            values = {
              {
                textValue = "Not commited",
                hl = "Comment",
              },
            },
            format = "%s",
          }
        end
        return line_with_hl
      end

      ---@diagnostic disable-next-line: missing-fields
      require("blame").setup({
        views = {
          default = virtual_view,
        },
        format_fn = date_author_fn,
      })

      vim.keymap.set("n", "<leader>bt", function()
        vim.cmd("BlameToggle")
      end, { desc = "[T]oggle Blame" })
    end,
  }
}
