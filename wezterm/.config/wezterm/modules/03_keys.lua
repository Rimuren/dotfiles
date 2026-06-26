-- wezterm/.config/wezterm/modules/03_keys.lua

local wezterm = require("wezterm")
local act = wezterm.action
local disable = act.DisableDefaultAssignment
local SUPER_WEZ = "CTRL"
local SUPER_REV = "ALT|CTRL"

return function(config)
    config.leader = { key = "q", mods = "ALT", timeout_milliseconds = 3500 }

    config.keys = {
        -- Tabs & Windows
        { key = "t",     mods = SUPER_WEZ,           action = act.SpawnTab("CurrentPaneDomain") },
        { key = "n",     mods = "CTRL|SHIFT",        action = act.SpawnWindow },

        -- Close
        { key = "w",     mods = SUPER_WEZ,           action = act.CloseCurrentPane { confirm = true } },
        { key = "w",     mods = SUPER_REV,           action = act.CloseCurrentTab { confirm = true } },

        -- Splits
        { key = "/",     mods = SUPER_WEZ,           action = act.SplitHorizontal {} },
        { key = "/",     mods = SUPER_REV,           action = act.SplitVertical {} },

        -- Pane navigation
        { key = "h",     mods = SUPER_WEZ,           action = act.ActivatePaneDirection "Left" },
        { key = "j",     mods = SUPER_WEZ,           action = act.ActivatePaneDirection "Down" },
        { key = "k",     mods = SUPER_WEZ,           action = act.ActivatePaneDirection "Up" },
        { key = "l",     mods = SUPER_WEZ,           action = act.ActivatePaneDirection "Right" },

        -- Tab navigation
        { key = "[",     mods = SUPER_WEZ,           action = act.ActivateTabRelative(-1) },
        { key = "]",     mods = SUPER_WEZ,           action = act.ActivateTabRelative(1) },
        { key = "[",     mods = SUPER_REV,           action = act.MoveTabRelative(-1) },
        { key = "]",     mods = SUPER_REV,           action = act.MoveTabRelative(1) },

        -- Leader commands
        { key = "z",     mods = "LEADER",            action = "TogglePaneZoomState" },
        { key = "r",     mods = "LEADER",            action = act.ActivateKeyTable { name = "resize_pane", one_shot = false } },
        { key = "f",     mods = "LEADER",            action = act.Search { CaseSensitiveString = "" } },
        { key = "x",     mods = "LEADER",            action = act.ActivateCopyMode },

        -- Misc
        { key = "s",     mods = SUPER_REV,           action = act.PaneSelect { mode = "SwapWithActive" } },
        { key = "p",     mods = SUPER_WEZ,           action = act.ActivateCommandPalette },
        { key = "c",     mods = "CTRL|SHIFT",        action = act.CopyTo "Clipboard" },
        { key = "v",     mods = "CTRL|SHIFT",        action = act.PasteFrom "Clipboard" },
        { key = "F11",   action = "ToggleFullScreen" },

        -- Disable SUPER + number (1-9)
        { key = "1",     mods = "SUPER",             action = disable },
        { key = "2",     mods = "SUPER",             action = disable },
        { key = "3",     mods = "SUPER",             action = disable },
        { key = "4",     mods = "SUPER",             action = disable },
        { key = "5",     mods = "SUPER",             action = disable },
        { key = "6",     mods = "SUPER",             action = disable },
        { key = "7",     mods = "SUPER",             action = disable },
        { key = "8",     mods = "SUPER",             action = disable },
        { key = "9",     mods = "SUPER",             action = disable },

        -- Disable SUPER combinations
        { key = "n",     mods = "SUPER",             action = disable },
        { key = "t",     mods = "SUPER",             action = disable },
        { key = "w",     mods = "SUPER",             action = disable },
        { key = "f",     mods = "SUPER",             action = disable },
        { key = "r",     mods = "SUPER",             action = disable },
        { key = "-",     mods = "SUPER",             action = disable },
        { key = "=",     mods = "SUPER",             action = disable },
        { key = "0",     mods = "SUPER",             action = disable },

        -- Disable ALT combinations
        { key = "Enter", mods = "ALT",               action = disable },

        -- Disable CTRL+SHIFT combinations
        { key = "t",     mods = "CTRL|SHIFT",        action = disable },
        { key = "w",     mods = "CTRL|SHIFT",        action = disable },
        { key = "f",     mods = "CTRL|SHIFT",        action = disable },
        { key = "x",     mods = "CTRL|SHIFT",        action = disable },
        { key = "p",     mods = "CTRL|SHIFT",        action = disable },
        { key = "_",     mods = "CTRL|SHIFT",        action = disable },
        { key = "+",     mods = "CTRL|SHIFT",        action = disable },
        { key = "0",     mods = "CTRL|SHIFT",        action = disable },
        { key = ")",     mods = "CTRL|SHIFT",        action = disable },
    }

    config.key_tables = {
        resize_pane = {
            { key = "h",      action = act.AdjustPaneSize { "Left", 1 } },
            { key = "j",      action = act.AdjustPaneSize { "Down", 1 } },
            { key = "k",      action = act.AdjustPaneSize { "Up", 1 } },
            { key = "l",      action = act.AdjustPaneSize { "Right", 1 } },
            { key = "Escape", action = act.PopKeyTable },
            { key = "q",      action = act.PopKeyTable },
        },
    }
end
