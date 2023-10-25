return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    close_if_last_window = true,
    window = {
      mappings = {
        ["<space>"] = "none",
        ["<tab>"] = "toggle_node",
      },
      width = 30,
    },
  },
}
