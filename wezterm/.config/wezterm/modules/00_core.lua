-- wezterm/.config/wezterm/modules/00_core.lua

return function(config)
  -- Performance
  config.front_end = "Software"
  config.max_fps = 60
  config.animation_fps = 60
  config.term = "wezterm"
  config.scrollback_lines = 10000

  -- Startup
  config.default_prog = { "zsh", "-l" }
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

  -- Wayland
  config.enable_wayland = false
end
