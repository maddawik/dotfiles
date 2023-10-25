return {
  "renerocksai/telekasten.nvim",
  keys = {
    { "<leader>zb", "<cmd>Telekasten show_backlinks<CR>", desc = "Show Backlinks" },
    { "<leader>zd", "<cmd>Telekasten goto_today<CR>", desc = "Todays Note" },
    { "<leader>zf", "<cmd>Telekasten find_notes<CR>", desc = "Find Notes" },
    { "<leader>zF", "<cmd>Telekasten find_friend_notes<CR>", desc = "Friend Notes" },
    { "<leader>zg", "<cmd>Telekasten search_notes<CR>", desc = "Grep Notes" },
    { "<leader>zi", "<cmd>Telekasten insert_link<CR>", desc = "Insert Link" },
    { "<leader>zn", "<cmd>Telekasten new_note<CR>", desc = "New Note" },
    { "<leader>zN", "<cmd>Telekasten new_templated_note<CR>", desc = "Templated Note" },
    { "<leader>zp", "<cmd>Telekasten panel<CR>", desc = "Command Palette" },
    { "<leader>zr", "<cmd>Telekasten rename_note<CR>", desc = "Rename Note" },
    { "<leader>zw", "<cmd>Telekasten goto_thisweek<CR>", desc = "Weeks Note" },
    { "<leader>zy", "<cmd>Telekasten yank_link_to_note<CR>", desc = "Yank Link" },
    { "<leader>zz", "<cmd>Telekasten follow_link<CR>", desc = "Follow Link" },
  },
  init = function()
    require("which-key").register({ z = { name = "+zettelkasten" } }, { prefix = "<leader>" })
  end,
  opts = {
    auto_set_filetype = false,
    home = vim.fn.expand("~/.nb/zettelkasten"),
    template_new_note = vim.fn.expand("~/.nb/zettelkasten/templates/basenote.md"),
    template_new_daily = vim.fn.expand("~/.nb/zettelkasten/templates/daily.md"),
    template_new_weekly = vim.fn.expand("~/.nb/zettelkasten/templates/weekly.md"),
  },
}
