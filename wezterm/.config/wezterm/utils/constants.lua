local wezterm = require("wezterm")

return {
  -- Key modifiers
  SUPER_WEZ = "CTRL",
  SUPER_REV = "ALT|CTRL",
  
  -- Colors
  COLORS = {
    BLUE = "#4E61D3",
    PURPLE = "#87a5ff",
    DARK = "#1e1e2e",
    LIGHT = "#a6accd",
    BLACK = "#000000",
  },
  
  -- Paths
  HOME = os.getenv("HOME"),
  BACKGROUNDS_DIR = os.getenv("HOME") .. "/.config/wezterm/backgrounds/",
  
  -- Image settings
  IMAGE_HSB = {
    brightness = 0.3,
    hue = 1.0,
    saturation = 1.0,
  },
}