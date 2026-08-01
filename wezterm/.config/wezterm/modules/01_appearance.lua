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

  config.font = wezterm.font_with_fallback({
    "Maple Mono NF",
    "Mononoki Nerd Font",
    "JetBrainsMono Nerd Font",
  })
  config.warn_about_missing_glyphs = false
  config.font_size = 12.5
end
