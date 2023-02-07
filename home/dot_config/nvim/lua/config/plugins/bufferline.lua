local M = {
  "akinsho/bufferline.nvim",
  event = "BufReadPre",
}

function M.config()
  require("bufferline").setup({
    options = {
      close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
      right_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
      offsets = {
        {
          filetype = "neo-tree",
          text = "Filetree",
          padding = 1,
          highlight = "Directory",
          text_align = "left",
        },
      },
      separator_style = "thick", -- | "thick" | "thin" | { 'any', 'any' },
    },
  })
end

return M
