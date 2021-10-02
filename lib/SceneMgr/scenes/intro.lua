local scene = {}

local x = 10
local font = love.graphics.newFont(20)


-- This function is intended to reset *specific* state when called.
-- Different than the load function in that it is used for intentional
-- resetting. E.g. you might want to reload player, and enemys, but keep
-- the games score set to what it originally was after going into a death
-- scene.
function scene.modify(flags)
end

-- Setting states when the scene is called
-- Generally not to be used for scenes that need maintain something
-- in a persistent state across scene changes.
-- E.g. if you went from gameplay to a item selection screen you wouldn't
-- want to reset a bunch of things about the gameplay -- player position,
-- player states, enemy position, etc.
function scene.load()
end

-- Scene updates loop
function scene.update()
  -- Change scene on space pressed
  function love.keypressed(key, unicode)
    if key == "n" then
      SM.load("title")
    elseif key == "r" then
      SM.unload("intro")
      SM.load("intro")
    end
  end

  x = x+0.5
end

-- Scene draw loop
function scene.draw()
  -- Info text
  love.graphics.setColor(255,255,255,255)
  love.graphics.setFont(font)
  love.graphics.print(
    "Scene file: \"intro.lua\"\n\n"..
    "Scene called by SM.load(\"intro\"), in \"main.lua\".\n"..
    "Hit `n` to go to the next scene.\n"..
    "Hit `r` to unload and reload the scene.\n"..
    "All keys are mapped in \"scenes/intro.lua\".",
    20,
    20
  )

  -- moving square
  love.graphics.setColor(255,255,255,255)
  love.graphics.rectangle("fill", x, 180, 150, 100)
end

return scene
