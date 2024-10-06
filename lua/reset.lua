local windo = require("windomancer")

local reset = function()
	for win, _ in pairs(M._state) do
		vim.wo[win].winbar = nil
	end

	windo._state = {}

	vim.api.nvim_clear_autocmds({
		event = "BufEnter",
		pattern = "*",
		group = windo.augroup,
	})
	-- vim.w.windomancer = { win = win, bufs = {} }
end

reset()
