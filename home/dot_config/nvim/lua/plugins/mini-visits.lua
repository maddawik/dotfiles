return {
  "echasnovski/mini.visits",
  opts = {},
  init = function()
    require("which-key").register({ v = { name = "+visit" } }, { prefix = "<leader>" })
  end,
  keys = {
    { "<leader>vv", "<cmd>lua MiniVisits.add_label()<cr>", desc = "Add label" },
    { "<leader>vV", "<cmd>lua MiniVisits.remove_label()<cr>", desc = "Remove label" },
    { "<leader>vl", '<cmd>lua MiniVisits.select_label("", "")<cr>', desc = "Select label (all)" },
    { "<leader>vL", "<cmd>lua MiniVisits.select_label()<cr>", desc = "Select label (cwd)" },
    { "<leader>vr", "<cmd>lua MiniVisits.select_path()<cr>", desc = "Select recent" },
  },
}
