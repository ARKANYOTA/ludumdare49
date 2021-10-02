local scene = {}

local font = love.graphics.newFont(20)
local x = 34
local y = love.graphics.getHeight()-42
local self = SSM.current
local color = {}
color.r = 255
color.g = 255
color.b = 0

-- This is just for getting colors to work across love versions
-- In love 11 colors are values of 0-1, unlike earlier versions.
local major, minor, revision, _ = love.getVersion()

-- In this modify function we take the flags then go through by key value
-- if our k is "x" then we set it to v
-- if our k is "y" then we set it to v
-- This is a flexable system for modifying data about your scene on the fly
function scene.modify(flags)
  for k, v in pairs(flags) do
    if k == "x" then
      x = v
    elseif k == "y" then
      y = v
    end
  end

  if major == 11 and minor >= 0 and revision >= 0 then
    color.r = math.random()
    color.g = math.random()
    color.b = math.random()
  else
    color.r = math.random()*255
    color.g = math.random()*255
    color.b = math.random()*255
  end
end

function scene.load()
end

function scene.update()
  function love.keypressed(key, unicode)
    if key == "n" then
      -- We could call SSM.remove("intro") and SSM.remove("inventory") to remove the
      -- currently loaded scenes from our scene table. Though rather than making two
      -- calls to remove all of our scenes we can just call SSM.removeAll() to remove
      -- all loaded scenes.
      SSM.removeAll()
      -- Calling purge resets a scenes state, we are leaving "intro" unpurged to show
      -- how state can be persistent if you choose to let it be.
      SSM.purge("inventory")
      SSM.add("game")
    elseif key == "m" then
      -- Calling modify with a key value pair.
      -- you can also just pass a value and handle the variable setting based on that.
      SSM.modify(self, {x = 34, y = love.graphics.getHeight()-42})
    elseif key == "f" then
      -- In this we are not freezing/unfreezing the current scene, but rather the
      -- previous scene.
      if SSM.isFrozen(SSM.previous) == true then
        SSM.setFrozen(SSM.previous, false)
      else
        SSM.setFrozen(SSM.previous, true)
      end
    end
  end

  if SSM.isFrozen(SSM.current) ~= true then
    x = x+0.5
    y = y-0.1
  end
end

function scene.draw()
  -- Fixing color for newer versions of love
  if major == 11 and minor >= 0 and revision >= 0 then
    love.graphics.setColor(50/255,50/255,50/255,255/255)
  else
    love.graphics.setColor(50,50,50,255)
  end
  love.graphics.rectangle("fill", 32, 320, love.graphics.getWidth()-64, love.graphics.getHeight()-64)
  love.graphics.setColor(255,255,255,255)
  -- Info text
  love.graphics.setFont(font)
  love.graphics.print(
    "Scene file: \"inventory.lua\"\n\n"..
    "Scene called by SSM.add(\"inventory\") in \"scenes/intro.lua\".\n"..
    "Press `f` to freeze and unfreeze the PREVIOUS scene.\n"..
    "Press `m` to call the scenes modify function (watch the yellow block).\n"..
    "Press `n` to call removeAll emptying the scene table of all scenes.\n",
    40,
    330
  )

  love.graphics.setColor(color.r,color.g,color.b,255)
  love.graphics.rectangle("fill", x, y, 32, 32)
end

return scene
