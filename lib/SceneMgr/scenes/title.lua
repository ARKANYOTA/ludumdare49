local scene = {}

local font = love.graphics.newFont(20)
local x = 10
local y = love.graphics.getHeight()-42

-- Refresh functions can be dynamic
function scene.modify(flags)
  for k, v in pairs(flags) do
    if v == "x" then
      x = 10
    end
  end
end

function scene.load()
end

function scene.update()
  -- Change scene on space pressed
  function love.keypressed(key, unicode)
    if key == "n" then
      SM.unload("title")
      SM.load("game")
    elseif key == "r" then
      SM.unload("title")
      SM.load("title")
    elseif key == "m" then
      SM.modify("title", {"x"})
    end
  end

  x = x+0.5
  y = y-0.5
end

function scene.draw()
  love.graphics.setColor(255,255,255,255)
  -- Info text
  love.graphics.setFont(font)
  love.graphics.print(
    "Scene file: \"title.lua\"\n\n"..
    "Scene called by SM.load(\"title\") in \"scenes/intro.lua\".\n"..
    "Hit `n` to go to the next scene.\n"..
    "Hit `r` to unload and reload the scene.\n"..
    "Hit `m` to modify the x variable of this scene.\n"..
    "All keys are mapped in \"scenes/title.lua\".",
    20,
    20
  )

  love.graphics.setColor(255,255,0,255)
  love.graphics.rectangle("fill", x, y, 32, 32)
end

return scene
