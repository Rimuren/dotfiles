-- wezterm/.config/wezterm/modules/02_events.lua

local wezterm = require("wezterm")
local colors = require("utils.constants").COLORS

return function(_config)
    wezterm.on("format-tab-title", function(tab)
        local pane = tab.active_pane
        local title = pane.title or ""
        local proc = pane.foreground_process_name or ""

        if proc ~= "" then proc = proc:gsub(".*/", "") end
        if title == "" then title = (proc ~= "" and proc or "Shell") end
        if #title > 20 then title = title:sub(1, 20) .. "…" end

        return { { Text = " " .. title .. " " } }
    end)

    -- Cache state per window agar tidak re-render tiap frame
    local last_left = {}
    local last_right = {}

    wezterm.on("update-status", function(window)
        local id = window:window_id()
        local leader = window:leader_is_active()
        if last_left[id] == leader then return end
        last_left[id] = leader
        if leader then
            window:set_left_status(wezterm.format({
                { Background = { Color = colors.BLUE } },
                { Foreground = { Color = colors.BLACK } },
                { Text = "  " },
            }))
        else
            window:set_left_status("")
        end
    end)

    wezterm.on("update-right-status", function(window)
        local id = window:window_id()
        local mode = window:active_key_table() or ""
        if last_right[id] == mode then return end
        last_right[id] = mode
        if mode == "" then
            window:set_right_status("")
            return
        end
        local txt = mode == "resize_pane" and " RESIZE: H J K L " or " MODE: " .. mode:upper() .. " "
        window:set_right_status(wezterm.format({
            { Foreground = { Color = colors.BLACK } },
            { Background = { Color = colors.PURPLE } },
            { Text = txt },
        }))
    end)

    -- gui-startup: focus window on launch (no-op if focus() unavailable)
    wezterm.on("gui-startup", function(cmd)
        local ok, _, _, win = pcall(wezterm.mux.spawn_window, cmd or {})
        if ok and win then
            local gw = win:gui_window()
            if gw and gw.focus then gw:focus() end
        end
    end)
end
