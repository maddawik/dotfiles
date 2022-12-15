local status_ok, neo_tree = pcall(require, "neo-tree")
if not status_ok then
  return
end

neo_tree.setup {
  close_if_last_window = true,
  source_selector = {
    winbar = true
  },
  window = {
    width = 30,
    mappings = {
      ["<space>"] = "none",
      ["<tab>"] = "toggle_node",
    }
  }
}
