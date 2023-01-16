local M = {
  "akinsho/toggleterm.nvim",
  cmd = { "ToggleTerm" },
}

function M.config()
  require("toggleterm").setup({
    size = function(term)
      if term.direction == "horizontal" then
        return 15
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
    open_mapping = [[<c-\>]],
    shading_factor = 2,
    direction = "float",
    float_opts = {
      border = "curved",
    },
  })
end

return M
