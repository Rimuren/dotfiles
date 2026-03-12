local wezterm = require("wezterm")
local act = wezterm.action

return function(config)

config.mouse_bindings = {
	{ event={Down={streak=1,button={WheelUp=1}}}, mods="CTRL", action=act.IncreaseFontSize },
	{ event={Down={streak=1,button={WheelDown=1}}}, mods="CTRL", action=act.DecreaseFontSize },
	{ event={Up={streak=1,button="Left"}}, mods="CTRL", action=act.OpenLinkAtMouseCursor },
	{ event={Down={streak=1,button="Left"}}, mods="CTRL", action=act.Nop },
}

end
