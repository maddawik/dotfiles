local M = {
  "rebelot/kanagawa.nvim",
  lazy = false
}

function M.config()
  require("kanagawa").setup({
    transparent = false,
  })

  vim.cmd("colorscheme kanagawa")
end

return M
