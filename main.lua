-- main.lua

debug = true

local utils = require 'utils'

G = love.graphics
setRGB = utils.setRGB

function love.load()

  font = G.newFont('Hack.ttf', 16)
  G.setFont(font)
  
  margin = { x = 0, y = 0 }
  getHeight, getWidth = G.getHeight(), G.getWidth()
  fontHeight = font:getHeight()
  fontWidth = font:getWidth('a')
  maxLines = math.floor((getHeight - margin.y * 2) / fontHeight)
  maxChars = math.floor((getWidth - margin.x * 2) / fontWidth)
  
  -- { '', color='', bgcolor = '', passable= },
  tiles = {
    { ' ', color='black', bgcolor='black', passable=false },
    { '#', color='gray', bgcolor='black', passable=false },
    { '.', color='yellow', bgcolor='black', passable=true }
  }
  
  mapX = 40
  mapY = 16
  
  map = {}
  for y = 1, mapY do
    map[y] = {}
    for x = 1, mapX do
      table.insert(map[y], tiles[math.random(1, #tiles)])
    end
  end
  
  -- dig the floor
  
  player = { '@', color='fuchsia', bgcolor='black' }
  local pos = findRandomFloor()
  player.x = pos.x
  player.y = pos.y
  
  if debug then
    print(fontHeight .. ' is the pixel height of the font.')
    print(fontWidth .. ' is the pixel width of the font.')
    print(maxLines .. ' is the maximum number of lines.')
    print(maxChars .. ' is the maximum number of characters.')
  end

end

function love.keypressed(key)
  if key == 'y' then
    -- move northwest
    movePlayer(-1, -1)
  elseif key == 'u' then
    -- move northeast
    movePlayer(1, -1)
  elseif key == 'h' then
    -- move west
    movePlayer(-1, 0)
  elseif key == 'j' then
    -- move south
    movePlayer(0, 1)
  elseif key == 'k' then
    -- move north
    movePlayer(0, -1)
  elseif key == 'l' then
    -- move east
    movePlayer(1, 0)
  elseif key == 'b' then
    -- move southwest
    movePlayer(-1, 1)
  elseif key == 'n' then
    -- move southeast
    movePlayer(1, 1)
  end
end

function love.update(dt) end

function love.draw()
  -- y axis
  for y,_ in ipairs(map) do
    -- x axis
    for x,v in ipairs(map[y]) do
      setRGB(v.bgcolor)
      G.rectangle('fill', margin.x + fontWidth * x, margin.y + fontHeight * y, fontWidth, fontHeight)
      setRGB(v.color)
      G.print(v[1], margin.x + fontWidth * x, margin.y + fontHeight * y)
    end
  end
  
  setRGB(player.bgcolor)
  G.rectangle('fill', margin.x + fontWidth * player.x, margin.y + fontHeight * player.y, fontWidth, fontHeight)
  setRGB(player.color)
  G.print(player[1], margin.x + fontWidth * player.x, margin.y + fontHeight * player.y)
  
end

function movePlayer(x, y)
  local newY, newX = player.y + y, player.x + x
  -- first make sure player would not fall off world
  if newY >= 1 and newY <= mapY and newX >= 1 and newX <= mapX then
    -- now see if tile is passable
    if map[player.y + y][player.x + x].passable then
      player.y = player.y + y
      player.x = player.x + x
    end
  end
end

-- find a random passable position and return a table with the coordinates
function findRandomFloor()
  local t = { x,y }
  
  repeat
    t.x = math.random(mapX)
    t.y = math.random(mapY)
  until map[t.y][t.x].passable
  return t
end