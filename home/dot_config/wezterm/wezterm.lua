-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.max_fps = 240
config.window_background_opacity = 0.84

-- For example, changing the color scheme:

--config.color_scheme = "Kanagawa (Gogh)"

config.force_reverse_video_cursor = true

config.font = wezterm.font("Hack")
config.font_size = 12
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0", "zero" }
-- and finally, return the configuration to wezterm

return config
