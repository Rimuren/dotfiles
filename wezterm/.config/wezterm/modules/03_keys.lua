local wezterm = require("wezterm")
local act = wezterm.action

return function(config)

local SUPER_WEZ = "CTRL"
local SUPER_REV = "ALT|CTRL"

config.leader = { key = "q", mods = "ALT", timeout_milliseconds = 3500 }

config.keys = {

	{ key="t", mods=SUPER_WEZ, action=act.SpawnTab("CurrentPaneDomain") },
	{ key="n", mods="CTRL|SHIFT", action=act.SpawnWindow },

	{ key="w", mods=SUPER_WEZ, action=act.CloseCurrentPane{confirm=true} },
	{ key="w", mods=SUPER_REV, action=act.CloseCurrentTab{confirm=true} },

	{ key="/", mods=SUPER_WEZ, action=act.SplitHorizontal{} },
	{ key="/", mods=SUPER_REV, action=act.SplitVertical{} },

	{ key="z", mods="LEADER", action="TogglePaneZoomState" },
	{ key="s", mods=SUPER_REV, action=act.PaneSelect{mode="SwapWithActive"} },

	{ key="h", mods=SUPER_WEZ, action=act.ActivatePaneDirection"Left" },
	{ key="j", mods=SUPER_WEZ, action=act.ActivatePaneDirection"Down" },
	{ key="k", mods=SUPER_WEZ, action=act.ActivatePaneDirection"Up" },
	{ key="l", mods=SUPER_WEZ, action=act.ActivatePaneDirection"Right" },

	{ key="[", mods=SUPER_WEZ, action=act.ActivateTabRelative(-1) },
	{ key="]", mods=SUPER_WEZ, action=act.ActivateTabRelative(1) },

	{ key="[", mods=SUPER_REV, action=act.MoveTabRelative(-1) },
	{ key="]", mods=SUPER_REV, action=act.MoveTabRelative(1) },

	{ key="r", mods="LEADER",
		action=act.ActivateKeyTable{name="resize_pane", one_shot=false}
	},

	{ key="c", mods="CTRL|SHIFT", action=act.CopyTo"Clipboard" },
	{ key="v", mods="CTRL|SHIFT", action=act.PasteFrom"Clipboard" },

	{ key="f", mods="LEADER", action=act.Search{CaseSensitiveString=""} },
	{ key="p", mods=SUPER_WEZ, action=act.ActivateCommandPalette },

	{ key="F11", action="ToggleFullScreen" },
	{ key="x", mods="LEADER", action=act.ActivateCopyMode },

}

end
