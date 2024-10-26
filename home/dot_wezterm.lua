-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = 'tokyonight_moon'
-- config.color_scheme = "Catppuccin Mocha"
config.color_scheme = "rose-pine-moon"

config.font = wezterm.font_with_fallback({ "JetBrains Mono", "Symbols Nerd Font Mono" })

config.enable_kitty_graphics = true

config.audible_bell = "Disabled"

config.window_background_opacity = 0.86

config.macos_window_background_blur = 15

config.font_size = 20
config.enable_tab_bar = false
config.window_padding = {
	left = 5,
	right = 5,
	top = 5,
	bottom = 5,
}
config.window_decorations = "RESIZE"

-- and finally, return the configuration to wezterm
return config
