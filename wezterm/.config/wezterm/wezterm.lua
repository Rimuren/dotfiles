local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

local modules = {
  "modules.00_core",
  "modules.01_ui",
  "modules.02_events",
  "modules.03_keys",
  "modules.04_keytables",
  "modules.05_mouse",
  "modules.06_disable",
}

for _, m in ipairs(modules) do
  require(m)(config)
end

return config
