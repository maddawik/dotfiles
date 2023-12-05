return {
  "olexsmir/gopher.nvim",
  ft = "go",
  config = true,
  build = function()
    vim.cmd([[silent! GoInstallDeps]])
  end,
  keys = {
    { "<leader>ce", "<cmd> GoIfErr <cr>", desc = "GoIfErr" },
  },
}
