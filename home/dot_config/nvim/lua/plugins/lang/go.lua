if vim.fn.executable("go") ~= 1 then
  return {}
end

return {
  {
    "ray-x/go.nvim",
    ft = "go",
    dependencies = { "ray-x/guihua.lua" },
    keys = {
      { "<leader>ce", "<cmd>GoIfErr<cr>", ft = "go", desc = "Go Error Snippet" },
    },
    opts = {
      lsp_inlay_hints = { enable = false },
      lsp_cfg = false,
    },
    config = function(_, opts)
      require("go").setup(opts)
    end,
  },

  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {},
  },
}
