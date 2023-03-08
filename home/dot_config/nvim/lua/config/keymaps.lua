-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

-- Exit insert and terminal mode with jk
vim.keymap.set("i", "jk", "<ESC>")

-- Better terminal navigation
vim.keymap.set("t", "<C-h>", [[<cmd>wincmd h<CR>]])
vim.keymap.set("t", "<C-j>", [[<cmd>wincmd j<CR>]])
vim.keymap.set("t", "<C-k>", [[<cmd>wincmd k<CR>]])
vim.keymap.set("t", "<C-l>", [[<cmd>wincmd l<CR>]])

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<cmd>SmartCursorMoveLeft<CR>")
vim.keymap.set("n", "<C-j>", "<cmd>SmartCursorMoveDown<CR>")
vim.keymap.set("n", "<C-k>", "<cmd>SmartCursorMoveUp<CR>")
vim.keymap.set("n", "<C-l>", "<cmd>SmartCursorMoveRight<CR>")

-- Resize with arrows
vim.keymap.set("n", "<C-Up>", "<cmd>SmartResizeUp<CR>")
vim.keymap.set("n", "<C-Down>", "<cmd>SmartResizeDown<CR>")
vim.keymap.set("n", "<C-Left>", "<cmd>SmartResizeLeft<CR>")
vim.keymap.set("n", "<C-Right>", "<cmd>SmartResizeRight<CR>")

-- Telekasten
require("which-key").register({
  z = {
    name = "+telekasten",
    p = { "<cmd>Telekasten panel<CR>", "Command palette" },
    f = { "<cmd>Telekasten find_notes<CR>", "Find Notes" },
    g = { "<cmd>Telekasten search_notes<CR>", "Grep Notes" },
    n = { "<cmd>Telekasten new_note<CR>", "New Note" },
    d = { "<cmd>Telekasten goto_today<CR>", "Todays Note" },
    w = { "<cmd>Telekasten goto_thisweek<CR>", "Weeks Note" },
    z = { "<cmd>Telekasten follow_link<CR>", "Follow Link" },
    b = { "<cmd>Telekasten show_backlinks<CR>", "Show Backlinks" },
    c = { "<cmd>Telekasten show_calendar<CR>", "Show Calendar" },
    t = { "<cmd>Telekasten toggle_todo<CR>", "Toggle Todo" },
  },
}, { prefix = "<leader>" })
