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
    { ' ', color='black', bgcolor='black', passable=false, id='earth' },
    { '#', color='gray', bgcolor='black', passable=false, id='wall' },
    { '.', color='yellow', bgcolor='black', passable=true, id='floor' }
  }
  
  map = {}
  mapX = 40
  mapY = 16
  maxRooms = 10
  
  -- first fill floor in
  for y = 1, mapY do
    map[y] = {}
    for x = 1, mapX do
      table.insert(map[y], tiles[1])
    end
  end
  
  -- for first room, until last room
  -- repeat while 
  
  for i = 1, maxRooms do
    local roomDone = false
    while not roomDone do
      -- pick a random position and size
      local randomPos = {}
      randomPos.x = math.random(2, mapX)
      randomPos.y = math.random(2, mapY)
      local roomSize = {}
      roomSize.x = math.random(2,6)
      roomSize.y = math.random(2,6)
      local badRoom = false
      
      -- now loop through and see if any part of room is floor or would extend beyond map size
      for y = randomPos.y, randomPos.y + roomSize.y do
        for x = randomPos.x, randomPos.x + roomSize.x do
          if y > mapY or x > mapX then
            badRoom = true
          elseif map[y][x].passable then
            badRoom = true
          end
        end
      end
      
      -- if badRoom is still false, then make the room
      if not badRoom then
        for y = randomPos.y, randomPos.y + roomSize.y do
          for x = randomPos.x, randomPos.x + roomSize.x do
            -- remove earth and insert floor
            table.remove(map[y], x)
            table.insert(map[y], x, tiles[3])
            -- now for each adjacent tile that is not floor, remove and insert wall
            for wy = -1, 1 do
              for wx = -1, 1 do
                if map[y + wy][x + wx].id ~= 'floor' then
                  table.remove(map[y + wy], x + wx)
                  table.insert(map[y + wy], x + wx, tiles[2])
                end
              end
            end
          end
        end
        roomDone = true
      end
      
    end
  end



  -- fill map with unpassable tile
  -- pick random position
  -- see if a room can be made there
  -- make the room
  -- pick random position until adjacent to a floor tile
  -- make corridor
  
  
  player = { '@', color='fuchsia', bgcolor='black' }
  local pos = findRandomTile()
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

-- generate a random tile and see if its id corresponds to arg id
-- if no arg is passed then simply search for a passable tile
function findRandomTile(id)
  local t = { x,y }
  if id == nil then
    repeat
      t.x = math.random(mapX)
      t.y = math.random(mapY)
    until map[t.y][t.x].passable
  else
    repeat
      t.x = math.random(mapX)
      t.y = math.random(mapY)
    until map[t.y][t.x].id == id
  end
  return t
end
