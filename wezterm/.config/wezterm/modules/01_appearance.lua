-- wezterm/.config/wezterm/modules/01_ui.lua

local wezterm = require("wezterm")
local colors = require("utils.constants").COLORS

return function(config)
  -- Color scheme
  config.color_scheme = "Catppuccin Mocha"
  config.window_background_opacity = 0.70

  -- Tab bar colors
  config.colors = {
    tab_bar = {
      background = colors.BLACK,
      active_tab = { bg_color = colors.PURPLE, fg_color = colors.DARK },
      inactive_tab = { bg_color = colors.DARK, fg_color = colors.LIGHT },
      new_tab = { bg_color = colors.BLACK, fg_color = colors.LIGHT },
    },
  }

  -- Padding
  config.window_padding = {
    left = 5, right = 5, top = 7, bottom = 7,
  }

  -- Fonts
  config.font = wezterm.font_with_fallback({
    "MononokiNerdFont",
    "CaskaydiaCove Nerd Font Mono",
    "FiraCode Nerd Font",
  })

  config.font_rules = {
    {
      intensity = "Normal",
      italic = false,
      font = wezterm.font_with_fallback({
        "MononokiNerdFont",
        "CaskaydiaCove Nerd Font Mono",
        "Noto Color Emoji",
      }),
    },
  }

  config.font_size = 11
end
