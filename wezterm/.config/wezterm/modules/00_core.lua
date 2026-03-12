local wezterm = require("wezterm")

return function(config)

-- performance friendly (CPU only)
config.front_end = "Software"
config.max_fps = 30
config.animation_fps = 30

-- startup
config.default_prog = { "zsh", "-l" }
config.check_for_updates = false
config.automatically_reload_config = true

-- window
config.window_decorations = "NONE"
config.initial_cols = 120
config.initial_rows = 32
config.window_close_confirmation = "AlwaysPrompt"

-- tabs
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_and_split_indices_are_zero_based = false

-- wayland off (stable GNOME + CPU)
config.enable_wayland = false

end
