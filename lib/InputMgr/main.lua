IM = require "lib.InputMgr"

function love.load()
end

function love.update(dt)

  if love.keyboard.isPressed("a") then
    print "\"a\" was pressed."
  end

  if love.keyboard.isReleased("a") then
    print "\"a\" was released."
  end

  if love.mouse.isReleased("left") then
    print "\"left\" was released."
  end

  -- Always run this at the end of the update loop
  love.keyboard.resetInputStates()
end

function love.render()
end
