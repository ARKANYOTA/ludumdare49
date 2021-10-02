-- You need to require the scene module and create a new scene manager.
-- This can be done in one of two ways. I prefer this one liner.
TM = require "lib.TransitionMgr".newManager()

-- You can also seperate out the function call as shown in the comments below.
-- local TM = require "lib.TransitionMgr"
-- local TM = TM.newManager()

function love.load()
  -- Set the path of your transition files
  TM.setPath("transitions")

  -- Load a transition
  TM.load(
    "fade-in",                           -- effect -- (the transition visuals)
    love.event.quit,                     -- call   -- (runs when `effect` ends)
    0                                    -- params -- (passed to `call` can be a table
  )
end

function love.update(dt)
  -- Update the transition
  TM.update(dt)
end

function love.draw()
  -- Random text and block
  love.graphics.setColor(255,255,0,255)
  love.graphics.print("Some sample text, that will be transitioned out of.", 10, 200)
  love.graphics.rectangle("fill",300,20,100,100)

  -- The transition effect
  TM.draw()
end
