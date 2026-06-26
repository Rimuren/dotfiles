-- wezterm/.config/wezterm/modules/06_backdrops.lua

local wezterm = require("wezterm")

local SUPER_REV = "ALT|CTRL"
local bg_dir = os.getenv("HOME") .. "/.config/wezterm/backgrounds"
local images = wezterm.glob(bg_dir .. "/*.{jpg,jpeg,png,gif}")
local current, show_image = 1, true

local image_hsb = {
    brightness = 0.3,
    hue = 1.0,
    saturation = 1.0,
}

local function set_background(win)
    if show_image and #images > 0 then
        win:set_config_overrides({
            window_background_image = images[current],
            window_background_image_hsb = image_hsb,
            window_background_opacity = 1.0,
        })
    else
        win:set_config_overrides({
            window_background_image = nil,
            window_background_opacity = 0.70,
        })
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
        set_background(win)
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
            key = a.key,
            mods = SUPER_REV,
            action = wezterm.action_callback(function(win)
                update_image(win, a.mode)
            end),
        })
    end
    -- Toggle On/Off
    table.insert(config.keys, {
        key = "3",
        mods = SUPER_REV,
        action = wezterm.action_callback(function(win)
            show_image = not show_image
            set_background(win)
        end),
    })
    -- Brightness cycle
    table.insert(config.keys, {
        key = "4",
        mods = SUPER_REV,
        action = wezterm.action_callback(function(win)
            if #images == 0 or not show_image then return end

            image_hsb.brightness = image_hsb.brightness + 0.2
            if image_hsb.brightness > 1.0 then
                image_hsb.brightness = 0.2
            end

            set_background(win)
        end),
    })
end
