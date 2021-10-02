local point = {}
point.x = love.mouse.getX()
point.y = love.mouse.getY()
point.color = {255,255,255,255}

local seg = {}
seg.x1 = 300
seg.y1 = 100
seg.x2 = 500
seg.y2 = 400
seg.color = {255,255,255,255}

-- love.graphics.point is no long a funciton in versions of love past
-- 0.10.0, so we need to correct that call for more recent versions.
local major, minor, revision, _ = love.getVersion()

-- Point seg collision is pixel perfect, this is often too
-- precise, so you need a buffer value to loosen the precision.
local buffer = 0.25

function love.update()
  point.x = love.mouse.getX()
  point.y = love.mouse.getY()

  if CL.pointSeg(point, seg, buffer) then
    point.color = {255, 0, 0, 255}
    seg.color = {255, 0, 0, 255}
  else
    point.color = {255, 255, 255, 255}
    seg.color = {255, 255, 255, 255}
  end
end

function love.draw()
  love.graphics.setLineWidth(5)
  love.graphics.setColor(unpack(point.color))

  -- correcting this function call, it had an updated name in more recent
  -- love2d versions.
  if major == 11 and minor >= 0 and revision >= 0 then
    love.graphics.points(point.x, point.y)
  elseif major == 0 and minor == 10 and revision >= 0 then
    love.graphics.points(point.x, point.y)
  else
    love.graphics.point(point.x, point.y)
  end

  love.graphics.setColor(unpack(seg.color))
  love.graphics.line(seg.x1, seg.y1, seg.x2, seg.y2)
end

