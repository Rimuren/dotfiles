-- wezterm/.config/wezterm/modules/07_cheatsheet.lua
-- Buka: LEADER+h (ALT+q lalu h)  |  Tutup: Escape

local wezterm = require("wezterm")

local C  = "CTRL"
local CA = "CTRL+ALT"
local CS = "CTRL+SHIFT"
local L  = "ALT+q"

-- Format: "[Section]  key" atau "key   desc"
local entries = {
  { label = "── Tabs & Windows ──────────────────────────", id = "" },
  { label = C.."+t              New tab",                  id = "" },
  { label = CS.."+n             New window",               id = "" },
  { label = C.."+[ / ]          Prev / next tab",          id = "" }, 
  { label = CA.."+[ / ]         Move tab left / right",    id = "" },
  { label = C.."+w              Close pane",               id = "" },
  { label = CA.."+w             Close tab",                id = "" },
  { label = "── Panes ────────────────────────────────────", id = "" },
  { label = C.."+/              Split horizontal",         id = "" },
  { label = CA.."+/             Split vertical",           id = "" },
  { label = C.."+h/j/k/l        Navigate panes",           id = "" },
  { label = CA.."+s             Swap pane with active",    id = "" },
  { label = "── Leader  ("..L..") ─────────────────────────", id = "" },
  { label = L.."+z              Zoom pane toggle",         id = "" },
  { label = L.."+r              Resize mode  (h/j/k/l)",  id = "" },
  { label = L.."+f              Search in pane",           id = "" },
  { label = L.."+x              Copy mode",                id = "" },
  { label = "── Backdrops ────────────────────────────────", id = "" },
  { label = CA.."+1 / 2         Prev / next backdrop",     id = "" },
  { label = CA.."+3             Toggle backdrop",          id = "" },
  { label = CA.."+4             Cycle brightness",         id = "" },
  { label = CA.."+5             Refresh list",             id = "" },
  { label = "── Misc ─────────────────────────────────────", id = "" },
  { label = C.."+p              Command palette",          id = "" },
  { label = CS.."+c             Copy",                     id = "" },
  { label = CS.."+v             Paste",                    id = "" },
  { label = "CTRL+wheel         Font size up / down",       id = "" },
  { label = "F11                Fullscreen toggle",         id = "" },
  { label = L.."+h              This cheat sheet",          id = "" },
}

return function(config)
  table.insert(config.keys, {
    key  = "h",
    mods = "LEADER",
    action = wezterm.action.InputSelector {
      title  = "Cheat Sheet",
      choices = entries,
      fuzzy  = true,
      -- Pilih apapun tidak melakukan apa-apa, hanya referensi
      action = wezterm.action_callback(function() end),
    },
  })
end