-- wezterm/.config/wezterm/modules/07_disable.lua

local wezterm = require("wezterm")
local disable = wezterm.action.DisableDefaultAssignment

return function(config)
  -- Disable SUPER + number (1-9)
  for i = 1, 9 do
    table.insert(config.keys, {
      key = tostring(i),
      mods = "SUPER",
      action = disable
    })
  end

  -- Disable specific key combinations
  local disable_list = {
    -- SUPER combinations
    { "n", "SUPER" }, { "t", "SUPER" }, { "w", "SUPER" },
    { "f", "SUPER" }, { "r", "SUPER" }, { "-", "SUPER" },
    { "=", "SUPER" }, { "0", "SUPER" },
    
    -- ALT combinations
    { "Enter", "ALT" },
    
    -- CTRL+SHIFT combinations
    { "t", "CTRL|SHIFT" }, { "w", "CTRL|SHIFT" }, { "f", "CTRL|SHIFT" },
    { "x", "CTRL|SHIFT" }, { "p", "CTRL|SHIFT" }, { "_", "CTRL|SHIFT" },
    { "+", "CTRL|SHIFT" }, { "0", "CTRL|SHIFT" }, { ")", "CTRL|SHIFT" },
  }

  for _, item in ipairs(disable_list) do
    table.insert(config.keys, {
      key = item[1],
      mods = item[2],
      action = disable
    })
  end
end