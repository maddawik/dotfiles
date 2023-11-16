return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    vim.list_extend(opts.ensure_installed, {
      "bash",
      "fish",
      "json",
      "lua",
      "query",
      "regex",
      "vim",
    })
  end,
}
