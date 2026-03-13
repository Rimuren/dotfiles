-- wezterm/.config/wezterm/utils/helpers.lua

local wezterm = require("wezterm")
local constants = require("utils.constants")

local M = {}

-- Cache get_image_list
local image_cache = nil
local last_scan = 0
local CACHE_TTL = 60  -- Cache timeout in seconds

function M.get_image_list(force_refresh)
  -- Refresh every 60 seconds or when forced
  local now = os.time()
  if not force_refresh and image_cache and (now - last_scan < CACHE_TTL) then
    return image_cache
  end

  local files = {}
  -- Use portable path separator
  local bg_dir = constants.BACKGROUNDS_DIR:gsub("/$", "")  -- Remove trailing slash
  local cmd = string.format('test -d "%s" && ls "%s" 2>/dev/null | grep -iE "\\.(jpg|jpeg|png|gif)$"" | sort || true', 
    bg_dir, bg_dir)
  
  local handle = io.popen(cmd)
  if handle then
    for file in handle:lines() do
      if file and file ~= "" then
        table.insert(files, bg_dir .. "/" .. file)
      end
    end
    handle:close()
  end

  if #files == 0 then
    wezterm.log_warn("No images found in " .. bg_dir)
  end

  image_cache = files
  last_scan = now
  return files
end

-- Extract filename from path (works with both / and \)
function M.get_filename(path)
  return path:match("([^/\\]+)$")
end

return M