local M = {
	"akinsho/toggleterm.nvim",
	cmd = { "ToggleTerm" },
}

function M.config()
	require("toggleterm").setup({
		open_mapping = [[<c-\>]],
		shading_factor = 2,
		direction = "float",
		float_opts = {
			border = "curved",
		},
	})
end

return M
