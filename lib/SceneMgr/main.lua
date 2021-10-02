SM = require "lib.SceneMgr"

function love.load()
  -- Set path of your scene files
  SM.setPath("scenes/")

  -- Add scene "intro" to scene table
  SM.load("intro")
end

function love.update(dt)
  -- Run your scene files update function
  SM.update(dt)
end

function love.draw()
  -- Run your scene files render function
  SM.draw()
end

