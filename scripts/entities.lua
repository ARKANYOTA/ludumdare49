-- vim: fdm=marker
-- FUNCTIONS {{{1
require "scripts/collision"

function block_create() --{{{2
    bl = {
        x = 500,
        y = 0,
        sprite = love.graphics.newImage("assets/stone.jpg"),
        scale_x = 0.5,
		scale_y = 0.5,

    }
    bl.w, bl.h  = bl.sprite:getWidth()*bl.scale_x, bl.sprite:getHeight()*bl.scale_y
    bl.x = 2*bl.w
    bl.y = 0*bl.h
    
end

function block_draw()--{{{2
    love.graphics.draw(bl.sprite, bl.x, bl.y, 0, bl.scale_y, bl.scale_y)
    coll_table[(bl.y/2)+1][bl.x/2] = 1
    
end


function bomb_create()--{{{2
    b = {
		x = 16,
		y = 16,
		dx = 0,
		dy = 0,

        timer = 0, -- In seconds

        sprite = love.graphics.newImage("assets/bomb.png"),
        scale_x = 0.2,
		scale_y = 0.2,
    }
    b.w, b.h  = b.sprite:getWidth()*b.scale_x, b.sprite:getHeight()*b.scale_y
    --b.h =sprite:getHeight()
end

function player_create() -- {{{2
    local cursor_img = love.graphics.newImage("assets/cursor.png")
	p = {
		x = 300,
		y = 300,
		dx = 0,
		dy = 0,
		speed = 70,
		friction = 0.8,
		sprite = love.graphics.newImage("assets/player01.png"),
		scale_x = 0.5,
		scale_y = 0.5,

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
    p.w, p.h  = p.sprite:getWidth()*p.scale_x, p.sprite:getHeight()*p.scale_y
end

function player_cursor(dt) -- {{{2
    local mx, my = love.mouse.getPosition()
    p.cursor.x, p.cursor.y = mx, my
end

function player_movement(dt) --{{{2
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

function player_draw()--{{{2
    love.graphics.draw(p.sprite, p.x, p.y, 0, p.scale_x, p.scale_y)
end

function draw_cursor()
    local c = p.cursor
    love.graphics.draw(c.sprite, c.x, c.y, 0, c.scale_x, c.scale_y, c.w/2, c.h/2)
end

function player_get_bomb() -- si collision, bomb s'accroche au mec --{{{2
    if collision(p.x, p.y, p.w, p.h, b.x, b.y, b.w, b.h) == true then
		b.x = p.x
		b.y = p.y-100
		p.getbomb = 1
    else
		p.getbomb = 0

    end
end

function throw_bomb()
    
end
