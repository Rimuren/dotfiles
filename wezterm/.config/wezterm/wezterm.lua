-- wezterm/.config/wezterm/wezterm.lua

local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Load modules in order
local modules = {
  "modules.00_core",        -- Basic settings
  "modules.01_appearance",  -- UI, colors, fonts
  "modules.02_events",      -- Event handlers
  "modules.03_keys",        -- Keybindings
  "modules.04_keytables",   -- Key tables
  "modules.05_mouse",       -- Mouse bindings
  "modules.06_backdrops",   -- Background switcher
  "modules.07_disable",     -- Disable default keys
}

for _, module_name in ipairs(modules) do
  local ok, module = pcall(require, module_name)
  if not ok then
    wezterm.log_error("Failed to load " .. module_name .. ": " .. module)
  elseif type(module) == "function" then
    module(config)
  end
end

return config