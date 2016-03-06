local M = {}

local Colors = {
  -- basic colors
  white = { r = 255, g = 255, b = 255 },
  silver = { r = 192, g = 192, b = 192 },
  gray = { r = 128, g = 128, b = 128 },
  black = { r = 0, g = 0, b = 0 },
  red = { r = 255, g = 0, b = 0},
  maroon = { r = 128, g = 0, b = 0 },
  lime = { r = 0, g = 255, b = 0 },
  green = { r = 0, g = 128, b = 0 },
  blue = { r = 0, g = 0, b = 255 },
  navy = { r = 0, g = 0, b = 128 },
  yellow = { r = 255, g = 255, b = 0 },
  orange = { r = 255, g = 128, b = 0 },
  olive = { r = 128, g = 128, b = 0 },
  aqua = { r = 0, g = 255, b = 255 },
  teal = { r = 0, g = 128, b = 128 },
  fuchsia = { r = 255, g = 0, b = 255 },
  purple = { r = 128, g = 0, b = 128 },
  
  -- special colors
  ochre = { r = 204, g = 119, b = 34 },
  indigo = { r = 75, g = 0, b = 130 }
}

function M.setRGB(color)
  if Colors[color] then
    love.graphics.setColor(Colors[color].r, Colors[color].g, Colors[color].b)
  end
end

return M
