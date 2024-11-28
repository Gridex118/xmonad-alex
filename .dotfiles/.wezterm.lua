local wezterm = require('wezterm')
local config = wezterm.config_builder()

config.color_scheme = 'dawnfox'
config.font = wezterm.font 'MesloLGS NF'
config.font_size = 14

return config
