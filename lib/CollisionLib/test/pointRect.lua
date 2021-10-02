local point = {}
point.x = love.mouse.getX()
point.y = love.mouse.getY()

local rect2 = {}
rect2.x = 100
rect2.y = 100
rect2.w = 64
rect2.h = 64
rect2.color = {255,255,255,255}

function love.update()
  point.x = love.mouse.getX()
  point.y = love.mouse.getY()

  if CC.pointRect(point, rect2) then
    rect2.color = {255, 0, 0, 255}
  else
    rect2.color = {255, 255, 255, 255}
  end
end

function love.draw()
  love.graphics.setColor(unpack(rect2.color))
  love.graphics.rectangle("fill", rect2.x, rect2.y, rect2.w, rect2.h)
end
