-- wezterm/.config/wezterm/modules/01_appearance.lua

local wezterm = require("wezterm")
local colors = require("utils.constants").COLORS

return function(config)
  config.color_scheme = "Catppuccin Mocha"
  config.window_background_opacity = 0.70

  config.colors = {
    tab_bar = {
      background = colors.BLACK,
      active_tab   = { bg_color = colors.PURPLE, fg_color = colors.DARK },
      inactive_tab = { bg_color = colors.DARK,   fg_color = colors.LIGHT },
      new_tab      = { bg_color = colors.BLACK,  fg_color = colors.LIGHT },
    },
  }

  config.window_padding = { left = 5, right = 5, top = 7, bottom = 7 }

  -- Primary font with broadly-available fallbacks:
  -- Mononoki (preferred) -> JetBrainsMono (Nerd) -> DejaVu (ships with most distros)
  -- -> Liberation (RHEL/Fedora/Debian/Arch) -> Noto emoji fallback
  config.font = wezterm.font_with_fallback({
    "Mononoki Nerd Font",
    "JetBrainsMono Nerd Font",
    "DejaVu Sans Mono",
    "Liberation Mono",
    "Noto Color Emoji",
  })

  config.font_size = 11
end
