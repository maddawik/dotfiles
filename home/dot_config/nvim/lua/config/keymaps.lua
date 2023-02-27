-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

-- Exit insert and terminal mode with jk
vim.keymap.set("i", "jk", "<ESC>")
vim.keymap.set("t", "jk", [[<C-\><C-n>]])

-- Better terminal navigation
vim.keymap.set("t", "<C-h>", [[<cmd>wincmd h<CR>]])
vim.keymap.set("t", "<C-j>", [[<cmd>wincmd j<CR>]])
vim.keymap.set("t", "<C-k>", [[<cmd>wincmd k<CR>]])
vim.keymap.set("t", "<C-l>", [[<cmd>wincmd l<CR>]])

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<cmd>SmartCursorMoveLeft<cr>")
vim.keymap.set("n", "<C-j>", "<cmd>SmartCursorMoveDown<cr>")
vim.keymap.set("n", "<C-k>", "<cmd>SmartCursorMoveUp<cr>")
vim.keymap.set("n", "<C-l>", "<cmd>SmartCursorMoveRight<cr>")

-- Resize with arrows
vim.keymap.set("n", "<C-Up>", "<cmd>SmartResizeUp<cr>")
vim.keymap.set("n", "<C-Down>", "<cmd>SmartResizeDown<cr>")
vim.keymap.set("n", "<C-Left>", "<cmd>SmartResizeLeft<cr>")
vim.keymap.set("n", "<C-Right>", "<cmd>SmartResizeRight<cr>")
