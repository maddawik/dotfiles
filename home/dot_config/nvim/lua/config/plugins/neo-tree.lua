vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
return {
	"nvim-neo-tree/neo-tree.nvim",
	cmd = "Neotree",
	keys = {
		{ "<leader>e", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },
	},
	config = {
		filesystem = {
			follow_current_file = true,
		},
		close_if_last_window = true,
		popup_border_style = "rounded",
		window = {
			mappings = {
				["<space>"] = "none",
				["<tab>"] = "toggle_node",
			},
      width = 30,
		},
	},
}
