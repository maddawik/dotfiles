return {
  "olexsmir/gopher.nvim",
  ft = "go",
  config = true,
  build = function()
    vim.cmd([[silent! goinstalldeps]])
  end,
  keys = {
    { "<leader>ge", "<cmd> goiferr <cr>", desc = "goiferr" },
  },
}
