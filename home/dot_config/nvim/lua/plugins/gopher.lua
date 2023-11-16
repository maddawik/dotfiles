return {
  "olexsmir/gopher.nvim",
  ft = "go",
  config = true,
  build = function()
    vim.cmd([[silent! goinstalldeps]])
  end,
  keys = {
    { "<leader>ce", "<cmd> GoIfErr <cr>", desc = "GoIfErr" },
  },
}
