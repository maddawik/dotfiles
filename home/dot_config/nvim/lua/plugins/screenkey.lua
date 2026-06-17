return {
  {
    "NStefan002/screenkey.nvim",
    lazy = false,
    version = "*",
    cmd = "Screenkey",
    keys = {
      { "<leader>uk", "<cmd>Screenkey toggle<cr>", desc = "Toggle Screenkey" },
    },
    opts = {
      win_opts = {
        relative = "editor",
        anchor = "SW",
        row = vim.o.lines - vim.o.cmdheight - 1,
        col = math.floor((vim.o.columns - 40) / 2),
        width = 30,
        height = 3,
        title = "Keys",
        title_pos = "center",
      },
    },
  },
}
