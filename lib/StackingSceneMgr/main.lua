-- You need to require the scene module and create a new scene manager.
-- This can be done in one of two ways. I prefer this one liner.
SSM = require "lib.StackingSceneMgr".newManager()

-- You can also seperate out the function call as shown in the comments below.
-- local SSM = require "lib.StackingSceneMgr"
-- local SSM = SSM.newManager()

function love.load()
  -- Set path of your scene files
  SSM.setPath("scenes/")

  -- Add scene "intro" to scene table
  SSM.add("intro")
end

function love.update(dt)
  -- Update the scene table
  SSM.update(dt)
end

function love.draw()
  -- Render the scene table
  SSM.draw()
end
