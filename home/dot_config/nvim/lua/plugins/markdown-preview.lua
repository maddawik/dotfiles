return {
  "iamcco/markdown-preview.nvim",
  build = "cd app && npm install",
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
    require("which-key").register({ m = { name = "+markdown" } }, { prefix = "<leader>" })
  end,
  ft = { "markdown" },
  keys = {
    { "<leader>mp", "<esc><cmd>MarkdownPreview<cr>", desc = "Preview" },
    { "<leader>mt", "<esc><cmd>MarkdownPreviewToggle<cr>", desc = "Toggle" },
    { "<leader>ms", "<esc><cmd>MarkdownPreviewStop<cr>", desc = "Stop" },
  },
}
