local colorscheme = "kanagawa"

require("kanagawa").setup({
    transparent = true, -- Kanagawa and Tokyonight
    -- transparent_background = true -- Catppuccin
})


function ColorMeSilly(color)
	color = color or colorscheme
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

    local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
    if not status_ok then
        vim.notify("colorscheme " .. colorscheme .. " not found!?")
        return
    end
end

ColorMeSilly()
