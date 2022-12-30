local M = {
  -- "rebelot/kanagawa.nvim",
  "folke/tokyonight.nvim",
  lazy = false
}

function M.config()
  require("tokyonight").setup({})

  vim.cmd("colorscheme tokyonight-moon")
end

return M
