local line1 = {}
line1.x1 = love.mouse.getX()
line1.y1 = love.mouse.getY()
line1.x2 = 50
line1.y2 = 50
line1.color = {255,255,255,255}

local line2 = {}
line2.x1 = 600
line2.y1 = 100
line2.x2 = 500
line2.y2 = 400
line2.color = {255,255,255,255}

function love.update()
  line1.x1 = love.mouse.getX()
  line1.y1 = love.mouse.getY()

  if CL.segSeg(line1, line2) then
    line1.color = {255, 0, 0, 255}
    line2.color = {255, 0, 0, 255}
  else
    line1.color = {255, 255, 255, 255}
    line2.color = {255, 255, 255, 255}
  end
end

function love.draw()
  love.graphics.setColor(unpack(line1.color))
  love.graphics.line(line1.x1, line1.y1, line1.x2, line1.y2)

  love.graphics.setColor(unpack(line2.color))
  love.graphics.line(line2.x1, line2.y1, line2.x2, line2.y2)
end

