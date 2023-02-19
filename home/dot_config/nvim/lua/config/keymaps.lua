-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
local opts = { silent = true }

-- Exit insert mode with jk
vim.keymap.set("i", "jk", "<ESC>", opts)

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<cmd>SmartCursorMoveLeft<cr>", opts)
vim.keymap.set("n", "<C-j>", "<cmd>SmartCursorMoveDown<cr>", opts)
vim.keymap.set("n", "<C-k>", "<cmd>SmartCursorMoveUp<cr>", opts)
vim.keymap.set("n", "<C-l>", "<cmd>SmartCursorMoveRight<cr>", opts)

-- Better terminal navigation
vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
vim.keymap.set("t", "<C-h>", [[<cmd>wincmd h<CR>]], opts)
vim.keymap.set("t", "<C-j>", [[<cmd>wincmd j<CR>]], opts)
vim.keymap.set("t", "<C-k>", [[<cmd>wincmd k<CR>]], opts)
vim.keymap.set("t", "<C-l>", [[<cmd>wincmd l<CR>]], opts)

-- Resize with arrows
vim.keymap.set("n", "<C-Up>", "<cmd>SmartResizeUp<cr>", opts)
vim.keymap.set("n", "<C-Down>", "<cmd>SmartResizeDown<cr>", opts)
vim.keymap.set("n", "<C-Left>", "<cmd>SmartResizeLeft<cr>", opts)
vim.keymap.set("n", "<C-Right>", "<cmd>SmartResizeRight<cr>", opts)
