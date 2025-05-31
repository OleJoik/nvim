-- vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")

-- Because terminals can't be closed with wqa...
vim.cmd [[cabbrev wqa wa\|qa]]

vim.keymap.set("n", "<C-a>", function()
  vim.cmd("normal! ggVG", false)
end, { desc = "Select [A]ll" })


vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Simple jump to another window
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)
-- jump to other window while in terminal mode (aborts terminal mode...)
vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], opts)
vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], opts)


vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], opts)
vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], opts)
-- moving windows
vim.keymap.set("n", "<A-h>", [[<C-w>h<C-w>x]], opts)
vim.keymap.set("n", "<A-j>", [[<C-w>J]], opts)
vim.keymap.set("n", "<A-k>", [[<C-w>K]], opts)
vim.keymap.set("n", "<A-l>", [[<C-w>x<C-w>l]], opts)
vim.keymap.set("n", "<A-m>", [[<C-w>T]], opts)
-- moving windows while in terminal mode (aborts terminal mode...)
vim.keymap.set("t", "<A-h>", [[<C-\><C-n><C-w>h<C-w>xa]], opts)
vim.keymap.set("t", "<A-j>", [[<C-\><C-n><C-w>Ja]], opts)
vim.keymap.set("t", "<A-k>", [[<C-\><C-n><C-w>Ka]], opts)
vim.keymap.set("t", "<A-l>", [[<C-\><C-n><C-w>x<C-w>la]], opts)
vim.keymap.set("t", "<A-m>", [[<C-\><C-n><C-w>Ta]], opts)

vim.keymap.set("n", ">", ">>")
vim.keymap.set("n", "<", "<<")
vim.keymap.set("x", ">", ">gv")
vim.keymap.set("x", "<", "<gv")

-- Closing windows/buffers
vim.keymap.set("n", "<C-q>", function() vim.cmd("q") end, { noremap = true, silent = true })
vim.keymap.set("t", "<C-q>", [[<C-\><C-n><C-w>c]], opts)
vim.keymap.set("n", "<C-x>", function() vim.cmd("Bwipeout") end, { noremap = true, silent = true })


-- Key bindings for tabs
vim.keymap.set("n", "<leader>ta", ":$tabnew<CR>", { noremap = true })
vim.keymap.set("n", "<leader>tq", ":tabclose<CR>", { noremap = true })
vim.keymap.set("n", "<leader>to", ":tabonly<CR>", { noremap = true })
vim.keymap.set("n", "<leader>tn", ":tabn<CR>", { noremap = true })
vim.keymap.set("n", "<leader>tp", ":tabp<CR>", { noremap = true })
-- move current tab to previous position
vim.keymap.set("n", "<leader>t-", ":-tabmove<CR>", { noremap = true })
-- move current tab to next position
vim.keymap.set("n", "<leader>t+", ":+tabmove<CR>", { noremap = true })


-- Search for whatever is selected
vim.keymap.set("v", "/", 'y/\\V<C-R>"<CR><S-n>', { noremap = true })
-- Clear search completely
vim.keymap.set("n", "<leader>/", ':let @/ = ""<CR>:nohlsearch<CR>', { noremap = true, desc = "[C]lear [/]" })


function ExecuteFile()
  local filetype = vim.bo.filetype
  if filetype == "python" then
    vim.cmd("!python3 %")
  else
    vim.cmd("source %")
  end
end

vim.keymap.set("n", "<leader><leader>x", ExecuteFile, { desc = "Execute the current file" })

-- Toggle previous buffer
vim.keymap.set("n", "<Tab>", ":b#<CR>", { noremap = true, silent = true })

-- Git
vim.keymap.set("n", "<C-g><C-l>", ":LazyGit<CR>", { desc = "[L]azygit" })
