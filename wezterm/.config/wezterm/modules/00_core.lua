-- wezterm/.config/wezterm/modules/00_core.lua

return function(config)
  -- Performance
  -- WebGpu is fastest; fallback to Software only if unavailable
  config.front_end = "WebGpu"
  config.webgpu_power_preference = "HighPerformance"
  config.max_fps = 60
  config.animation_fps = 60
  config.term = "wezterm"
  config.scrollback_lines = 10000

  -- Startup: respect user's $SHELL, fallback to zsh then sh
  local shell = os.getenv("SHELL") or "zsh"
  config.default_prog = { shell, "-l" }
  config.check_for_updates = false
  config.automatically_reload_config = true

  -- Window
  config.window_decorations = "NONE"
  config.initial_cols = 120
  config.initial_rows = 32
  config.window_close_confirmation = "AlwaysPrompt"

  -- Tabs
  config.enable_tab_bar = true
  config.use_fancy_tab_bar = false
  config.tab_bar_at_bottom = true
  config.tab_and_split_indices_are_zero_based = false

  -- Display server auto-detection:
  -- Enable Wayland only when WAYLAND_DISPLAY is set, fall back to X11 otherwise.
  -- This ensures the config works on pure X11, pure Wayland, and XWayland setups.
  local wayland = os.getenv("WAYLAND_DISPLAY") ~= nil
  config.enable_wayland = wayland
end
