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
        scroll_down_alt = {
          char = "<C-d>",
          func = function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-f>", true, true, true), "n", false)
          end,
        },
        scroll_up_alt = {
          char = "<C-u>",
          func = function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-b>", true, true, true), "n", false)
          end,
        },
        delete_left = "<C-z>",
      },
      window = {
        config = { border = "rounded" },
        prompt_caret = "▏",
        prompt_prefix = " ",
      },
    },
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
