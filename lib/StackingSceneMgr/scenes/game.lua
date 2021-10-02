local scene = {}

local font, x

-- Our variables are defined above, but actually get set in
-- the scenese load funciton. This is because this scene doesn't
-- have persistent state.
function scene.load()
  font = love.graphics.newFont(20)
  x = 200
end

function scene.update()
  function love.keypressed(key, unicode)
    if key == "n" then
      SSM.remove("game")
      SSM.add("intro")
    end
  end

  if SSM.isFrozen(SSM.current) ~= true then
    x = x+1
  end
end

function scene.draw()
  love.graphics.setColor(255,255,255,255)
  -- Info text
  love.graphics.setFont(font)
  love.graphics.print(
    "Scene file: \"game.lua\"\n\n"..
    "Scene called by SSM.add(\"game\"), in \"scenes/inventory.lua\",\n"..
    "Press `n` add the next scene, and remove the current scene.\n"..
    "All keys are mapped in \"scenes/game.lua\".\n\n"..
    "For more info on SSM please refer to the README or source code, thanks.",
    20,
    20
  )

  love.graphics.setColor(255,0,0,255)
  love.graphics.rectangle("fill", x, love.graphics.getHeight()/2-50, 300, 100)
end

return scene
