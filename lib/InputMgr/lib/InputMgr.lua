local inputStates = {}

--          --
--------------
-- GENERICS --
--------------
--          --
local inputPressed = function(input, cur)
  if inputStates[input] then
    local last = inputStates[input].last
    inputStates[input].cur = cur
    -- If they input is "cur" down, and it was up "last" frame it was pressed
    return cur and not last
  else
    inputStates[input] = {cur = cur, last = false}
    return cur
  end
end

local inputReleased = function(input, cur)
  if inputStates[input] then
    local last = inputStates[input].last
    inputStates[input].cur = cur
    -- if the input is not "cur" down but the "last" frame it was we released
    return not cur and last
  else
    inputStates[input] = {cur = cur, last = false}
    return cur
  end
end

--          --
--------------
-- KEYBOARD --
--------------
--          --
love.keyboard.isPressed = function(key)
  return inputPressed(key, love.keyboard.isDown(key))
end

love.keyboard.isReleased = function(key)
  return inputReleased(key, love.keyboard.isDown(key))
end

--       --
-----------
-- MOUSE --
-----------
--       --
local mouseStringToValue = function(button)
  if button == "left" then
    button = 1
  elseif button == "right" then
    button = 2
  elseif button == "middle" then
    button = 3
  end

  return button
end

love.mouse.isPressed = function(button)
  button = mouseStringToValue(button)
  return inputPressed(button, love.mouse.isDown(button))
end

love.mouse.isReleased = function(button)
  button = mouseStringToValue(button)
  return inputReleased(button, love.mouse.isDown(button))
end

--       --
-----------
-- RESET --
-----------
--       --
love.keyboard.resetInputStates = function()
  -- keyboard
  for key, _ in pairs(inputStates) do
    inputStates[key].last = inputStates[key].cur
  end
end
