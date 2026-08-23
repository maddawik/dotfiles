return {
  {
    "nvim-mini/mini.pick",
    lazy = true,
    dependencies = { "nvim-mini/mini.input" },
    opts = {
      mappings = {
        move_down_alt = {
          char = "<C-j>",
          func = function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-n>", true, true, true), "n", false)
          end,
        },
        move_up_alt = {
          char = "<C-k>",
          func = function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-p>", true, true, true), "n", false)
          end,
        },
      },
    },
    config = function(_, opts)
      require("mini.pick").setup(opts)
      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniPickStart",
        callback = function()
          vim.schedule(function()
            vim.cmd("redraw")
          end)
        end,
      })
    end,
  },
  {
    "nvim-mini/mini.input",
    event = "VeryLazy",
    opts = {},
  },
  {
    "nvim-mini/mini.extra",
    lazy = true,
    dependencies = { "nvim-mini/mini.pick" },
    opts = {},
  },
}
