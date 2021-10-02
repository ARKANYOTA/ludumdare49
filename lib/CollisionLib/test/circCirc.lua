local circ1 = {}
circ1.x = love.mouse.getX()
circ1.y = love.mouse.getY()
circ1.r = 64
circ1.color = {255,255,255,255}

local circ2 = {}
circ2.x = 300
circ2.y = 300
circ2.r = 64
circ2.color = {255,255,255,255}

function love.update()
  circ1.x = love.mouse.getX()
  circ1.y = love.mouse.getY()

  if CL.circCirc(circ1, circ2) then
    circ1.color = {255, 0, 0, 255}
    circ2.color = {255, 0, 0, 255}
  else
    circ1.color = {255, 255, 255, 255}
    circ2.color = {255, 255, 255, 255}
  end
end

function love.draw()
  love.graphics.setColor(unpack(circ1.color))
  love.graphics.circle("fill", circ1.x, circ1.y, circ1.r)

  love.graphics.setColor(unpack(circ2.color))
  love.graphics.circle("fill", circ2.x, circ2.y, circ2.r)
end

