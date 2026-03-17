-- Exit insert mode with jk
vim.keymap.set("i", "jk", "<ESC>")

-- Backspace into insert, helpful for snippets
vim.keymap.set("s", [[<BS>]], [[<BS>i]])

-- Pick a plugin file
vim.keymap.set("n", "<leader>sP", function()
  LazyVim.pick("files", { cwd = vim.fn.expand("~") .. "/.local/share/nvim/lazy/" })()
end, { desc = "Search All Plugins", silent = true })

-- Save all files after symbol rename
vim.keymap.set("n", "<leader>cw", function()
  local orig = vim.lsp.handlers["textDocument/rename"]
  vim.lsp.handlers["textDocument/rename"] = function(...)
    orig(...)
    vim.cmd("silent! wall")
    vim.lsp.handlers["textDocument/rename"] = orig
  end
  vim.lsp.buf.rename()
end, { desc = "Rename (LSP) + save all" })

-- Open gh dash in a floating terminal
vim.keymap.set("n", "<leader>gH", function()
  Snacks.terminal.open("gh dash")
end, { desc = "GitHub Dashboard" })
