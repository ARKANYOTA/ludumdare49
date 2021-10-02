local scene = {}

local font = love.graphics.newFont(20)
local x = 10

function scene.load()
  x = 10
end

function scene.update()
  -- Change scene on space pressed
  function love.keypressed(key, unicode)
    if key == "n" then
      SM.load("intro")
    end
  end

  x = x+2
end

function scene.draw()
  love.graphics.setColor(255,255,255,255)
  -- Info text
  love.graphics.setFont(font)
  love.graphics.print(
    "Scene file: \"game.lua\"\n\n"..
    "Scene called by SM.load(\"game\"), in \"scenes/title.lua\".\n"..
    "Hit `n` to go to the next scene.\n"..
    "All keys are mapped in \"scenes/game.lua\".",
    20,
    20
  )

  love.graphics.setColor(255,0,0,255)
  love.graphics.rectangle("fill", x, love.graphics.getHeight()/2-50, 300, 100)
end

return scene
