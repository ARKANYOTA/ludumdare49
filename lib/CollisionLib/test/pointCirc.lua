local point = {}
point.x = love.mouse.getX()
point.y = love.mouse.getY()

local circ = {}
circ.x = 100
circ.y = 100
circ.r = 64
circ.color = {255,255,255,255}

function love.update()
  point.x = love.mouse.getX()
  point.y = love.mouse.getY()

  if CL.pointCirc(point, circ) then
    circ.color = {255, 0, 0, 255}
  else
    circ.color = {255, 255, 255, 255}
  end
end

function love.draw()
  love.graphics.setColor(unpack(circ.color))
  love.graphics.circle("fill", circ.x, circ.y, circ.r)
end
