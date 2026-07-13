-- wezterm/.config/wezterm/modules/06_backdrops.lua

local wezterm = require("wezterm")

local SUPER_REV = "ALT|CTRL"
local bg_dir = os.getenv("HOME") .. "/.config/wezterm/backgrounds"
local current, show_image = 1, true
local image_hsb = { brightness = 0.3, hue = 1.0, saturation = 1.0 }

-- Images are loaded lazily on first use to avoid yield-across-C-call errors
local images = nil

local function load_images()
    if images == nil then
        images = wezterm.glob(bg_dir .. "/*.{jpg,jpeg,png,gif}")
    end
    return images
end

local function refresh_images()
    images = wezterm.glob(bg_dir .. "/*.{jpg,jpeg,png,gif}")
    if current > #images then current = math.max(1, #images) end
    return images
end

local function set_background(win)
    local imgs = load_images()
    if show_image and #imgs > 0 then
        win:set_config_overrides({
            window_background_image = imgs[current],
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
    local imgs = load_images()
    if #imgs == 0 then return end
    show_image = true
    if mode == "prev" then
        current = current == 1 and #imgs or current - 1
    else
        current = current == #imgs and 1 or current + 1
    end
    set_background(win)
end

return function(config)
    local bindings = {
        { key = "1", mods = SUPER_REV, action = wezterm.action_callback(function(win) update_image(win, "prev") end) },
        { key = "2", mods = SUPER_REV, action = wezterm.action_callback(function(win) update_image(win, "next") end) },
        { key = "3", mods = SUPER_REV, action = wezterm.action_callback(function(win)
            show_image = not show_image
            set_background(win)
        end) },
        { key = "4", mods = SUPER_REV, action = wezterm.action_callback(function(win)
            local imgs = load_images()
            if #imgs == 0 or not show_image then return end
            image_hsb.brightness = image_hsb.brightness + 0.2
            if image_hsb.brightness > 1.0 then image_hsb.brightness = 0.2 end
            set_background(win)
        end) },
        { key = "5", mods = SUPER_REV, action = wezterm.action_callback(function(win)
            refresh_images()
            set_background(win)
        end) },
    }
    for _, b in ipairs(bindings) do
        table.insert(config.keys, b)
    end
end
