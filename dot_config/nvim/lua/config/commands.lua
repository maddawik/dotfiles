-- Open Alpha Dashboard when all other buffers are closed
local alpha_on_empty = vim.api.nvim_create_augroup("alpha_on_empty", { clear = true })
vim.api.nvim_create_autocmd("User", {
	pattern = "BDeletePost*",
	group = alpha_on_empty,

	callback = function(event)
		local fallback_name = vim.api.nvim_buf_get_name(event.buf)
		local fallback_ft = vim.api.nvim_buf_get_option(event.buf, "filetype")
		local fallback_on_empty = fallback_name == "" and fallback_ft == ""
		if fallback_on_empty then
			local ok, _ = pcall(require, "neo-tree")

			if not ok then
				vim.cmd("packadd neo-tree")
				-- Use the latest recommended approach to handle Neotree. See the docs for info:
				-- https://github.com/nvim-neo-tree/neo-tree.nvim/blob/ab8ca9fac52949d7a741b538c5d9c3898cd0f45a/doc/neo-tree.txt#L140
				vim.cmd("Neotree close")
			end

			vim.cmd("Alpha")
			vim.cmd(event.buf .. "bwipeout")
		end
	end,
})
