-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-- Exit insert and terminal mode with jk
map("i", "jk", "<ESC>")
map("t", "jk", [[<C-\><C-n>]])

-- Better window navigation
map("n", "<C-h>", "<cmd>SmartCursorMoveLeft<cr>")
map("n", "<C-j>", "<cmd>SmartCursorMoveDown<cr>")
map("n", "<C-k>", "<cmd>SmartCursorMoveUp<cr>")
map("n", "<C-l>", "<cmd>SmartCursorMoveRight<cr>")

-- Better terminal navigation
map("t", "<C-h>", [[<cmd>wincmd h<CR>]])
map("t", "<C-j>", [[<cmd>wincmd j<CR>]])
map("t", "<C-k>", [[<cmd>wincmd k<CR>]])
map("t", "<C-l>", [[<cmd>wincmd l<CR>]])

-- Resize with arrows
map("n", "<C-Up>", "<cmd>SmartResizeUp<cr>")
map("n", "<C-Down>", "<cmd>SmartResizeDown<cr>")
map("n", "<C-Left>", "<cmd>SmartResizeLeft<cr>")
map("n", "<C-Right>", "<cmd>SmartResizeRight<cr>")
