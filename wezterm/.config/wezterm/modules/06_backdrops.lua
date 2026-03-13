-- wezterm/.config/wezterm/modules/07_backdrops.lua

local wezterm = require("wezterm")
local constants = require("utils.constants")
local helpers = require("utils.helpers")

local SUPER_REV = constants.SUPER_REV
local images = helpers.get_image_list()
local current, show_image = 1, true

-- Cache
local last_image = nil
local last_brightness = nil

local image_hsb = {
  brightness = 0.2,
  hue = 1.0,
  saturation = 1.0,
}

local function set_background(win, force)
  local should_update = force or
    last_image ~= images[current] or
    last_brightness ~= image_hsb.brightness

  if not should_update then return end

  if show_image and #images > 0 then
    win:set_config_overrides({
      window_background_image = images[current],
      window_background_image_hsb = image_hsb,
      window_background_opacity = 1.0,
    })
    last_image = images[current]
    last_brightness = image_hsb.brightness
  else
    win:set_config_overrides({
      window_background_image = nil,
      window_background_opacity = 0.70,
    })
    last_image = nil
  end
end

local function update_image(win, mode)
  if #images == 0 then return false end

  show_image = true
  local old = current
  
  if mode == "prev" then
    current = current == 1 and #images or current - 1
  else -- next
    current = current == #images and 1 or current + 1
  end

  if old ~= current then
    set_background(win, true)
  end
  return true
end

return function(config)
  -- Previous/Next
  local actions = {
    { key = "1", mode = "prev" },
    { key = "2", mode = "next" },
  }

  for _, a in ipairs(actions) do
    table.insert(config.keys, {
      key = a.key, mods = SUPER_REV,
      action = wezterm.action_callback(function(win)
        update_image(win, a.mode)
      end),
    })
  end
  -- Toggle On/Off
  table.insert(config.keys, {
    key = "3", mods = SUPER_REV,
    action = wezterm.action_callback(function(win)
      show_image = not show_image
      set_background(win, true)
    end),
  })
  -- Brightness cycle
  table.insert(config.keys, {
    key = "4", mods = SUPER_REV,
    action = wezterm.action_callback(function(win)
      if #images == 0 or not show_image then return end

      image_hsb.brightness = image_hsb.brightness + 0.2
      if image_hsb.brightness > 1.0 then
        image_hsb.brightness = 0.2
      end
      
      set_background(win, true)
    end),
  })
end