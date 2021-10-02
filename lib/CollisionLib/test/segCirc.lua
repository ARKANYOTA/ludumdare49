local circ = {}
circ.x = love.mouse.getX()
circ.y = love.mouse.getY()
circ.r = 64
circ.color = {255,255,255,255}

local seg = {}
seg.x1 = 300
seg.y1 = 100
seg.x2 = 500
seg.y2 = 400
seg.color = {255,255,255,255}

local buffer = 5

function love.update()
  circ.x = love.mouse.getX()
  circ.y = love.mouse.getY()

  if CL.segCirc(seg, circ, buffer) then
    circ.color = {255, 0, 0, 255}
    seg.color = {255, 0, 0, 255}
  else
    circ.color = {255, 255, 255, 255}
    seg.color = {255, 255, 255, 255}
  end
end

function love.draw()
  love.graphics.setLineWidth(10)
  love.graphics.setColor(unpack(circ.color))
  love.graphics.circle("fill", circ.x, circ.y, circ.r)

  love.graphics.setColor(unpack(seg.color))
  love.graphics.line(seg.x1, seg.y1, seg.x2, seg.y2)
end

