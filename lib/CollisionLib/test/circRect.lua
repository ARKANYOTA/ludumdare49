local circ = {}
circ.x = love.mouse.getX()
circ.y = love.mouse.getY()
circ.r = 64
circ.color = {255,255,255,255}

local rect = {}
rect.x = 200
rect.y = 200
rect.w = 64
rect.h = 64
rect.color = {255,255,255,255}

function love.update()
  circ.x = love.mouse.getX()
  circ.y = love.mouse.getY()

  if CL.circRect(circ, rect) then
    circ.color = {255, 0, 0, 255}
    rect.color = {255, 0, 0, 255}
  else
    circ.color = {255, 255, 255, 255}
    rect.color = {255, 255, 255, 255}
  end
end

function love.draw()
  love.graphics.setColor(unpack(circ.color))
  love.graphics.circle("fill", circ.x, circ.y, circ.r)

  love.graphics.setColor(unpack(rect.color))
  love.graphics.rectangle("fill", rect.x, rect.y, rect.w, rect.h)
end

