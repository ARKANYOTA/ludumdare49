-- FUNCTIONS {{{1
--Player {{{2
function bomb_create()
    b = {
		x = 16,
		y = 16,
		dx = 0,
		dy = 0,
        scale_x = 0.2,
		scale_y = 0.2,
		sprite = love.graphics.newImage("assets/bomb.png")
    }
    b.w, b.h  = b.sprite:getWidth()*b.scale_x, b.sprite:getHeight()*b.scale_y
    --b.h =sprite:getHeight()
end

function player_create() -- {{{3
	p = {
		x = 200,
		y = 200,
		dx = 0,
		dy = 0,
		speed = 70,
		friction = 0.8,

		sprite = love.graphics.newImage("assets/player01.png"),
		scale_x = 1,
		scale_y = 1
	}
    p.w, p.h  = p.sprite:getWidth()*p.scale_x, p.sprite:getHeight()*p.scale_y
end

function player_movement(dt) --{{{3
	local dir_vector = {x = 0, y = 0}
    if love.keyboard.isDown("q") or love.keyboard.isDown("a") or love.keyboard.isDown("left") then
        dir_vector.x = dir_vector.x - 1
    end 
    if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
        dir_vector.x = dir_vector.x + 1
    end 
    if love.keyboard.isDown("z") or love.keyboard.isDown("w") or love.keyboard.isDown("up") then
        dir_vector.y = dir_vector.y - 1
    end 
    if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
        dir_vector.y = dir_vector.y + 1
    end 
    -- Normalize the direction vector
    local norm = math.sqrt(dir_vector.x * dir_vector.x + dir_vector.y * dir_vector.y) + 0.0001
    dir_vector.x = dir_vector.x / norm
    dir_vector.y = dir_vector.y / norm

    p.dx = (p.dx + dir_vector.x * p.speed) * p.friction
    p.dy = (p.dy + dir_vector.y * p.speed) * p.friction

    p.x = p.x + p.dx * dt
    p.y = p.y + p.dy * dt
end

function collision(x1,y1,w1,h1,x2,y2,w2,h2)

end