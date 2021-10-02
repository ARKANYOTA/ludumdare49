local scene = {}

local x = 10
local font = love.graphics.newFont(20)
local cur = SSM.current

-- Stacking Scene Manager can be used to call a scenes modify function.
-- The modify function is intended to be used for changing specific
-- parts of a scene defined in the flags table. Each scene can have a
-- unique modify function that handles received flags respectively.
--
-- The modify function is not intended to restart a scene, to do this
-- first purge then add the scene again.
function scene.modify(flags)
end

-- Stacking Scene Manager can all a scenes load function. The purpose of
-- this function is to initialize variables. Though they can also be
-- initialized outside of the load function for persistent state.
function scene.load()
end

-- Scene updates loop
function scene.update()
  function love.keypressed(key, unicode)
    if key == "n" then
      -- next scene
      SSM.add("inventory")
    elseif key == "r" then
      -- effectively restart a scene
      SSM.purge("intro")
      SSM.add("intro")
    elseif key == "f" then
      -- Freeze and unfreeze a scene
      if SSM.isFrozen(cur) == true then
        SSM.setFrozen(cur, false)
      else
        SSM.setFrozen(cur, true)
      end
    end
  end

  -- Only run when scene isn't locked
  if SSM.isFrozen(cur) ~= true then
    x = x+0.5
  end
end

-- Scene draw loop
function scene.draw()
  love.graphics.setColor(255,255,255,255)
  love.graphics.setFont(font)
  love.graphics.print(
    "Scene file: \"intro.lua\"\n\n"..
    "Scene called by SSM.add(\"intro\"), in main.lua.\n"..
    "Press `f` to freeze and unfreeze the scene.\n"..
    "Press `r` to purge and add the scene current (effectively restarting \"intro\").\n"..
    "Press `n` add the next scene, but not remove the current scene.\n"..
    "All keys are mapped in \"scenes/intro.lua\".",
    20,
    20
  )

  love.graphics.setColor(255,255,255,255)
  love.graphics.rectangle("fill", x, 200, 150, 100)
end

return scene
