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
config.color_scheme = "Catppuccin Mocha"
-- config.color_scheme = 'Solarized Dark (Gogh)'
config.font = wezterm.font("JetBrains Mono")
-- config.font = wezterm.font("PlemolJP Console NF")

config.enable_kitty_graphics = true

-- config.window_background_opacity = 0.95

config.font_size = 22
config.enable_tab_bar = false
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.window_decorations = "RESIZE"

-- and finally, return the configuration to wezterm
return config
