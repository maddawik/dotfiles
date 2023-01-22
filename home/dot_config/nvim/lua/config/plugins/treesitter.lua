local M = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
}

function M.config()
  require("nvim-treesitter.configs").setup({
    ensure_installed = {
      "bash",
      "fish",
      "gitignore",
      "go",
      "help",
      "lua",
      "markdown",
      "markdown_inline",
      "python",
      "rust",
      "terraform",
      "yaml",
      "vhs",
    },

    ignore_install = { "" },
    sync_install = false,

    highlight = {
      enable = true, -- false will disable the whole extension
    },
    autopairs = {
      enable = true,
    },
    indent = {
      enable = true,
    },

    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
  })
end

return M
