return {
  {
    'echasnovski/mini.indentscope',
    version = '*',
    config = function()
      require('mini.indentscope').setup({
        draw = {
          delay = 20,
          animation = require('mini.indentscope').gen_animation.none()
        }
      })
    end
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {

      indent = { char = "╎" },
      scope = { enabled = false }   -- using mini.indentscope instead
    },
  }
}
