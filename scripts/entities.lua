-- vim: fdm=marker
-- FUNCTIONS {{{1
require "scripts/collision"
require "scripts/particle"

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
        max_timer = 5,
        active = false,

        sprite = love.graphics.newImage("assets/bomb.png"),
        scale_x = 0.2,
		scale_y = 0.2,

        throwspeed = 300,
        catchcooldown = 0,
        max_catchcooldown = 1, 
    }
    b.w, b.h  = b.sprite:getWidth()*b.scale_x, b.sprite:getHeight() * b.scale_y
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
        angle = 0,

		sprite = love.graphics.newImage("assets/player01.png"),
		scale_x = 0.2,
		scale_y = 0.2,

        bomb = b,
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
    p.w = p.sprite:getWidth() * p.scale_x 
    p.h = p.sprite:getHeight() * p.scale_y
end



function player_update()
    local dt = love.timer.getDelta()
    player_movement(dt)
    coll_check = collision(p.x,p.y,p.w,p.h,b.x,b.y,b.w,b.h)
    player_get_bomb()
    player_cursor()
    throw_bomb()
    update_bomb(dt)
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

function draw_player()--{{{2
    love.graphics.draw(p.sprite, p.x, p.y, 0, p.scale_x, p.scale_y)
end

function player_cursor(dt) -- {{{2
    local mx, my = love.mouse.getPosition()
    local click = love.mouse.isDown(1)
    p.cursor.x, p.cursor.y = mx, my
    p.cursor.active = click

    local x = mx - (p.x + p.w/2)
    local y = my - (p.y + p.h/2)
    p.angle = math.atan2(y, x)
end

function draw_cursor()
    local c = p.cursor
    love.graphics.draw(c.sprite, c.x, c.y, 0, c.scale_x, c.scale_y, c.w/2, c.h/2)
end



function player_get_bomb() -- si collision, bomb s'accroche au mec --{{{2
    if collision(p.x, p.y, p.w, p.h, b.x, b.y, b.w, b.h) == true and b.catchcooldown <= 0 then
		p.hasBomb = true
    else
		p.hasBomb = false
    end
end

function throw_bomb()
    if p.cursor.active and p.hasBomb then
        p.hasBomb = false
        b.dx = math.cos(p.angle) * b.throwspeed
        b.dy = math.sin(p.angle) * b.throwspeed
        b.catchcooldown = b.max_catchcooldown
        b.timer = b.max_timer
    end
end

function update_bomb(dt)
    b.catchcooldown = math.max(b.catchcooldown - dt, 0)
    b.timer = math.max(b.timer - dt, 0)
    b.active = not p.hasBomb
    if b.active then
        b.x = b.x + b.dx * dt
        b.y = b.y + b.dy * dt
        if love.math.random() <= (b.timer%1) / 2 then
            spawn_smoke(b.x, b.y)
        end
    else
        b.x = p.x - p.w/2
        b.y = p.y - 80
    end
end

function draw_bomb()
    love.graphics.draw(b.sprite, b.x - b.w/2, b.y - b.h/2, 0, b.scale_x, b.scale_y)
end