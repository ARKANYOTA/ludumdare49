-- FUNCTIONS {{{1
--Player {{{2
function bomb_create()
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

function player_create() -- {{{3
    local cursor_img = love.graphics.newImage("assets/cursor.png")
	p = {
		x = 300,
		y = 300,
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
    p.w, p.h  = p.sprite:getWidth()*p.scale_x, p.sprite:getHeight()*p.scale_y
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

function player_get_bomb() -- si collision, bomb s'accroche au mec
    if collision(p.x, p.y, p.w, p.h, b.x, b.y, b.w, b.h) == true then
		b.x = p.x
		b.y = p.y-40
		p.getbomb = 1
    else
		p.getbomb = 0

    end
end


function collision(x1,y1,w1,h1,x2,y2,w2,h2) -- si collision entre deux objets, return true
    return (x1+w1 > x2 and x1 < x2 + w2 and
       y1 < y2 + h2 and y1 + h1 > y2)
end

function draw_collision(x,y,w,h)
	love.graphics.rectangle("fill",x,y,4,h) -- vertical left
	love.graphics.rectangle("fill",x+w,y,4,h) -- vert right
	love.graphics.rectangle("fill",x,y,w,4)
	love.graphics.rectangle("fill",x,y+w,w,4)
end