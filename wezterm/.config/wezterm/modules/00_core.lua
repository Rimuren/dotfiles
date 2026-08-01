-- wezterm/.config/wezterm/modules/00_core.lua

return function(config)
  -- Renderer: WebGpu di semua platform (Wayland/X11/iGPU/dGPU).
  -- LowPower = tidak throttle di battery/iGPU.
  -- Wezterm otomatis fallback ke OpenGL -> Software jika WebGpu gagal.
  config.front_end = "WebGpu"
  config.webgpu_power_preference = "LowPower"

  -- animation_fps = 1: hemat GPU, animasi UI wezterm hampir tidak terlihat.
  -- Naikkan max_fps ke 120 jika pakai monitor high refresh.
  config.max_fps = 60
  config.animation_fps = 1

  config.term = "wezterm"
  config.scrollback_lines = 5000

  -- Matikan fitur yang tidak dipakai agar tidak load saat startup
  config.check_for_updates = false
  config.automatically_reload_config = true
  config.audible_bell = "Disabled"
  config.visual_bell = { fade_in_duration_ms = 0, fade_out_duration_ms = 0 }

  -- Startup: respect $SHELL
  local shell = os.getenv("SHELL") or "zsh"
  config.default_prog = { shell, "-l" }

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

  -- Wayland jika tersedia, X11 sebagai fallback
  config.enable_wayland = os.getenv("WAYLAND_DISPLAY") ~= nil
end
