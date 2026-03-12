local wezterm = require("wezterm")

return function(config)

wezterm.on("format-tab-title", function(tab)
  local pane = tab.active_pane
  local title = pane.title
  local proc = pane.foreground_process_name

  if proc then proc = proc:gsub(".*/", "") end
  if not title or title == "" then title = proc or "Shell" end
  if #title > 20 then title = title:sub(1,20).."…" end

  return { { Text = " "..title.." " } }
end)

local leader_prefix = " 🦢 "

wezterm.on("update-status", function(window)
  if window:leader_is_active() then
    window:set_left_status(wezterm.format({
      { Background = { Color = "#4E61D3" } },
      { Foreground = { Color = "#000000" } },
      { Text = leader_prefix },
    }))
  else
    window:set_left_status("")
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
    { Foreground = { Color = "#000000" } },
    { Background = { Color = "#87a5ff" } },
    { Text = txt },
  }))
end)

wezterm.on("gui-startup", function(cmd)
  local _,_,win = wezterm.mux.spawn_window(cmd or {})
  win:gui_window():focus()
end)

wezterm.on("window-close-request", function()
  wezterm.mux.exit()
end)

wezterm.on("window-focus-changed", function(w) w:clear_selection_text() end)
wezterm.on("pane-focus-changed", function(w) w:clear_selection_text() end)

end
