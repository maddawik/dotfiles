return {
  "echasnovski/mini.files",
  opts = {
    options = {
      use_as_default_explorer = true,
    },
  },
  keys = {
    {
      "-",
      function()
        require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
      end,
      desc = "Open files (directory of current file)",
    },
    {
      "<leader>e",
      function()
        require("mini.files").open(require("lazyvim.util.root").get(), true)
      end,
      desc = "Open files (root dir)",
    },
    {
      "<leader>E",
      function()
        require("mini.files").open(vim.loop.cwd(), true)
      end,
      desc = "Open files (cwd)",
    },
  },
}
