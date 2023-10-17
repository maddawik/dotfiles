return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    vim.list_extend(opts.ensure_installed, {
      "bash",
      "clojure",
      "dockerfile",
      "fish",
      "gdscript",
      "go",
      "hcl",
      "html",
      "javascript",
      "json",
      "lua",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "regex",
      "ruby",
      "rust",
      "terraform",
      "tsx",
      "typescript",
      "vhs",
      "vim",
      "yaml",
    })
    -- vim.treesitter.language.register("markdown", "telekasten")
  end,
}
