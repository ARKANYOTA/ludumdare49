-- You need to require the camera module and create a new camera manager.
-- This can be done in one of two ways. I prefer this one liner.
local CM = require "lib.CameraMgr".newManager()

-- You can also seperate out the function call as shown in the comments below.
-- local CM = require "lib.CameraMgr"
-- local CM = CM.newManager()

local player = {}

function love.load()
  -- Player vars
  player.w = 64
  player.h = 64
  player.x = (love.graphics.getWidth()/2)-(player.w/2)
  player.y = (love.graphics.getHeight()/2)-(player.h/2)
  player.spd = 4

  -- Camera vars
  CM.setScale(0.85) -- Should be set before others (some calls depend on the scale)
  CM.setBounds(-310,-210,love.graphics.getWidth()+310,love.graphics.getHeight()+210)
  CM.setDeadzone(-64,-64,64,64)

  CM.setLerp(0.1)

  CM.setOffset(0)

  CM.setCoords(player.x+player.w/2, player.y+player.h/2) -- initial position
end

function love.update(dt)
  -- Movement for player
  if love.keyboard.isDown("a","left") then
    player.x = player.x - player.spd
  end
  if love.keyboard.isDown("d","right") then
    player.x = player.x + player.spd
  end
  if love.keyboard.isDown("w","up") then
    player.y = player.y - player.spd
  end
  if love.keyboard.isDown("s","down") then
    player.y = player.y + player.spd
  end

  -- Check what bounds have been collided with
  -- could be used to change how the CM works when at a boundry, or make
  -- some kind of event happen like a transition, etc
  local x, y = CM.getCoords()
  local bx, by, bw, bh = CM.getBounds()
  local w, h = CM.getSize()

  if x == bx+w/2 then print("at bound x") end
  if y == by+h/2 then print("at bound y") end
  if x+w/2 == bw then print("at bound w") end
  if y+h/2 == bh then print("at bound h") end

  -- Keep player in "room" bounds
  player.x = math.min(math.max(player.x, 0), love.graphics.getWidth()  - player.w)
  player.y = math.min(math.max(player.y, 0), love.graphics.getHeight() - player.h)

  -- Set Target to the players center
  CM.setTarget(player.x+player.w/2, player.y+player.h/2)

  -- Update CM
  CM.update(dt)
end

function love.draw()
  CM.attach() -- Start Camera

  -- random "objects"
  love.graphics.setColor(255,0,0,255)
  love.graphics.rectangle("fill", 500, 100, 32, 32)
  love.graphics.rectangle("fill", 150, 400, 32, 32)
  love.graphics.rectangle("fill", 400, 550, 32, 32)
  love.graphics.rectangle("fill", 650, 300, 32, 32)
  love.graphics.rectangle("fill", 850, 100, 32, 32)

  -- "room" outline
  love.graphics.setColor(100,100,100,255)
  love.graphics.setLineWidth(4)
  love.graphics.rectangle("line", 0, 0, love.graphics.getWidth(), love.graphics.getHeight());

  -- player
  love.graphics.setColor(0,255,0,255)
  love.graphics.rectangle("fill", player.x, player.y ,player.w, player.h)

  CM.detach() -- End Camera

  CM.debug() -- Shows CM debug info
end
