-- wezterm/.config/wezterm/modules/02_events.lua

local wezterm = require("wezterm")
local colors = require("utils.constants").COLORS
local last_status = ""

return function(config)
  wezterm.on("format-tab-title", function(tab)
    local pane = tab.active_pane
    local title = pane.title or ""
    local proc = pane.foreground_process_name or ""
  
    if proc ~= "" then proc = proc:gsub(".*/", "") end
    if title == "" then title = (proc ~= "" and proc or "Shell") end
    if #title > 20 then title = title:sub(1,20).."…" end
  
    return { { Text = " "..title.." " } }
  end)

  wezterm.on("update-status", function(window)
    if window:leader_is_active() then
      if last_status ~= "leader" then
        window:set_left_status(wezterm.format({
          { Background = { Color = colors.BLUE } },
          { Foreground = { Color = colors.BLACK } },
          { Text = " 🦢 " },
        }))
        last_status = "leader"
      end
    elseif last_status ~= "" then
      window:set_left_status("")
      last_status = ""
    end
  end)

  wezterm.on("update-right-status", function(window)
    local mode = window:active_key_table()
    local txt = " NORMAL "

    if mode == "resize_pane" then
      txt = " RESIZE: H J K L "
    elseif mode then
      txt = " MODE: "..mode:upper().." "
    end

    window:set_right_status(wezterm.format({
      { Foreground = { Color = colors.BLACK } },
      { Background = { Color = colors.PURPLE } },
      { Text = txt },
    }))
  end)

  wezterm.on("gui-startup", function(cmd)
    local _,_,win = wezterm.mux.spawn_window(cmd or {})
    win:gui_window():focus()
  end)

  wezterm.on("window-close-request", function() wezterm.mux.exit() end)
  wezterm.on("window-focus-changed", function(w) w:clear_selection_text() end)
  wezterm.on("pane-focus-changed", function(w) w:clear_selection_text() end)
end
