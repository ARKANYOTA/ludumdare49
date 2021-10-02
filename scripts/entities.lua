-- FUNCTIONS {{{1
--Player {{{2
function bomb_create()
    b = {
		x = 0,
		y = 0,
		dx = 0,
		dy = 0,

		sprite = love.graphics.newImage("assets/bomb.png"),

        timer = 0, -- In seconds
    }
end

function player_create() -- {{{3
    local cursor_img = love.graphics.newImage("assets/cursor.png")
	p = {
		x = 200,
		y = 200,
		dx = 0,
		dy = 0,
		speed = 70,
		friction = 0.8,

		sprite = love.graphics.newImage("assets/player01.png"),
		scale_x = 1,
		scale_y = 1,

        bomb = {},
        hasBomb = false,

        cursor = {
            x = 0,
            y = 0,
            scrx = 0,
            scry = 0,

            sprite = cursor_img,
            w = cursor_img:getWidth(),
            h = cursor_img:getHeight(),
            scale_x = 0.1,
            scale_y = 0.1,

            active = false,
        },
	}
end

function player_cursor(dt)
    local mx, my = love.mouse.getPosition()
    p.cursor.x, p.cursor.y = mx, my
end

function player_movement(dt) --{{{3
	local dir_vector = {x = 0, y = 0}
    if love.keyboard.isScancodeDown("a") or love.keyboard.isScancodeDown("left") then
        dir_vector.x = dir_vector.x - 1
    end 
    if love.keyboard.isScancodeDown("d") or love.keyboard.isScancodeDown("right") then
        dir_vector.x = dir_vector.x + 1
    end 
    if love.keyboard.isScancodeDown("w") or love.keyboard.isScancodeDown("up") then
        dir_vector.y = dir_vector.y - 1
    end 
    if love.keyboard.isScancodeDown("s") or love.keyboard.isScancodeDown("down") then
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

function player_draw()
    love.graphics.draw(p.sprite, p.x, p.y, 0, p.scale_x, p.scale_y)
    local c = p.cursor
    love.graphics.draw(c.sprite, c.x, c.y, 0, c.scale_x, c.scale_y, c.w/2, c.h/2)
end