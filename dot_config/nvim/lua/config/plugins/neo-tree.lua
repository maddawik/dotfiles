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
		close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
		popup_border_style = "rounded",
		window = {
			mappings = {
				["<space>"] = "none",
				["<tab>"] = "toggle_node",
			},
		},
	},
}
