rect1 = {}
rect1.x = love.mouse.getX()
rect1.y = love.mouse.getY()
rect1.w = 64
rect1.h = 64
rect1.color = {255,255,255,255}

rect2 = {}
rect2.x = 100
rect2.y = 100
rect2.w = 64
rect2.h = 64
rect2.color = {255,255,255,255}

function love.update()
  rect1.x = love.mouse.getX()-rect1.w/2
  rect1.y = love.mouse.getY()-rect1.h/2

  if CL.rectRect(rect1, rect2) then
    rect1.color = {255, 0, 0, 255}
    rect2.color = {255, 0, 0, 255}
  else
    rect1.color = {255, 255, 255, 255}
    rect2.color = {255, 255, 255, 255}
  end
end

function love.draw()
  love.graphics.setColor(unpack(rect1.color))
  love.graphics.rectangle("fill", rect1.x, rect1.y, rect1.w, rect1.h)

  love.graphics.setColor(unpack(rect2.color))
  love.graphics.rectangle("fill", rect2.x, rect2.y, rect2.w, rect2.h)
end
