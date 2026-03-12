local wezterm = require("wezterm")

return function(config)

config.color_scheme = "Catppuccin Mocha"
config.window_background_opacity = 0.85

config.colors = {
  tab_bar = {
    background = "#000000",
    active_tab = { bg_color = "#87a5ff", fg_color = "#1e1e2e" },
    inactive_tab = { bg_color = "#1e1e2e", fg_color = "#a6accd" },
    new_tab = { bg_color = "#000000", fg_color = "#a6accd" },
  },
}

config.window_padding = {
  left = 5,
  right = 5,
  top = 7,
  bottom = 7,
}

config.font = wezterm.font_with_fallback({
  { family = "MononokiNerdFont", scale = 1.0 },
  "CaskaydiaCove Nerd Font Mono",
})

config.font_size = 11

end
