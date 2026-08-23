return {
  {
    "nvim-mini/mini.notify",
    event = "VeryLazy",
    opts = {
      -- noice already renders LSP $/progress; don't let mini.notify's own
      -- automatic progress handler compete for the same lsp.handlers slot.
      lsp_progress = { enable = false },
    },
  },
}
