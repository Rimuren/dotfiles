-- wezterm/.config/wezterm/modules/03_keys.lua

local wezterm = require("wezterm")
local act = wezterm.action
local constants = require("utils.constants")
local SUPER_WEZ = constants.SUPER_WEZ
local SUPER_REV = constants.SUPER_REV

return function(config)
  config.leader = { key = "q", mods = "ALT", timeout_milliseconds = 3500 }

  config.keys = {
    -- Tabs & Windows
    { key = "t", mods = SUPER_WEZ, action = act.SpawnTab("CurrentPaneDomain") },
    { key = "n", mods = "CTRL|SHIFT", action = act.SpawnWindow },

    -- Close
    { key = "w", mods = SUPER_WEZ, action = act.CloseCurrentPane { confirm = true } },
    { key = "w", mods = SUPER_REV, action = act.CloseCurrentTab { confirm = true } },

    -- Splits
    { key = "/", mods = SUPER_WEZ, action = act.SplitHorizontal {} },
    { key = "/", mods = SUPER_REV, action = act.SplitVertical {} },

    -- Pane navigation
    { key = "h", mods = SUPER_WEZ, action = act.ActivatePaneDirection "Left" },
    { key = "j", mods = SUPER_WEZ, action = act.ActivatePaneDirection "Down" },
    { key = "k", mods = SUPER_WEZ, action = act.ActivatePaneDirection "Up" },
    { key = "l", mods = SUPER_WEZ, action = act.ActivatePaneDirection "Right" },

    -- Tab navigation
    { key = "[", mods = SUPER_WEZ, action = act.ActivateTabRelative(-1) },
    { key = "]", mods = SUPER_WEZ, action = act.ActivateTabRelative(1) },
    { key = "[", mods = SUPER_REV, action = act.MoveTabRelative(-1) },
    { key = "]", mods = SUPER_REV, action = act.MoveTabRelative(1) },

    -- Leader commands
    { key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
    { key = "r", mods = "LEADER", action = act.ActivateKeyTable { name = "resize_pane", one_shot = false } },
    { key = "f", mods = "LEADER", action = act.Search { CaseSensitiveString = "" } },
    { key = "x", mods = "LEADER", action = act.ActivateCopyMode },

    -- Misc
    { key = "s", mods = SUPER_REV, action = act.PaneSelect { mode = "SwapWithActive" } },
    { key = "p", mods = SUPER_WEZ, action = act.ActivateCommandPalette },
    { key = "c", mods = "CTRL|SHIFT", action = act.CopyTo "Clipboard" },
    { key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom "Clipboard" },
    { key = "F11", action = "ToggleFullScreen" },
  }
end