-- vim: fdm=marker
-- FUNCTIONS {{{1
require "scripts/collision"
require "scripts/particle"
require "scripts/utility"
require "scripts/constants"
require "scripts/sound"
require "scripts/textures"

function player_create() -- {{{2
	local cursor_img = love.graphics.newImage("assets/cursor.png")
	p = {
		x = 300,
		y = 300,
		dx = 0,
		dy = 0,
		speed = 80,
		friction = 0.9,
		angle = 0,
		bounce = 0.6,

		sprite = love.graphics.newImage("assets/player01.png"),
		scale_x = 0.15,
		scale_y = 0.15,

		bomb = b,
		hasBomb = true,
		timer_bomb = 0,
		life = 3,
		max_life = 3,
		iframes = 1,
		max_iframes = 1,
		score = 0,
		max_score = 0,
		coeff_score = 1,

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

function bomb_create()--{{{2
	b = {
		x = 300,
		y = 300,
		dx = 0,
		dy = 0,

		timer = 0, -- In seconds
		max_timer = 6,
		active = false,

		sprite = love.graphics.newImage("assets/bomb.png"),
		scale_x = 0.1,
		scale_y = 0.1,
        redshift = 0,
        r = 0,
        dr = 1,
		can_bounce = true,

		throwspeed = 300,
		catch_cooldown = 0,
		max_catch_cooldown = 1,
		
		beep_timer = 0,
		beep_pitch = 1,
		max_beep_timer = 2,
		default_max_beep_timer = 1,
		
		isred = false,
	}
	b.w, b.h  = b.sprite:getWidth() * b.scale_x, b.sprite:getHeight() * b.scale_y
	--b.h =sprite:getHeight() 
end

function player_update()
	local dt = love.timer.getDelta()
	player_movement(dt)
	coll_check = collision(p.x, p.y, p.w, p.h, b.x, b.y, b.w, b.h)
	player_get_bomb()
	player_cursor()
	throw_bomb()
	update_bomb(dt)
	for i, enemy in ipairs(total_enemy) do --vacciné
		if collision(enemy.x,enemy.y,enemy.w,enemy.h,p.x,p.y,p.w,p.h) then
			if enemy.hp > 0 then
				if p.iframes < 0 then
					--color = 0
					p.life = p.life - 1
					p.iframes = p.max_iframes
				end

				p.iframes = p.iframes - dt
			end
		
		end
	end
	if p.life <= 0 or p.y < 10 then
		start_menu("game_over")
	end
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

	local norm = math.sqrt(dir_vector.x * dir_vector.x + dir_vector.y * dir_vector.y) + 0.0001
	dir_vector.x = dir_vector.x / norm
	dir_vector.y = dir_vector.y / norm

	p.dx = p.dx + (dir_vector.x * p.speed)
	p.dy = p.dy + (dir_vector.y * p.speed)

	p.dx = p.dx * p.friction
	p.dy = p.dy * p.friction

	-- Collisions
	local tpx,tpy,cord,tpxf,tpyf
	local nextx = p.x + p.dx * dt
	local nexty = p.y + p.dy * dt

	if nextx < 0 then
		p.dx = 0
	end
	if nexty < 0 then
		p.dy = 0
	end

	local bw = blockw
	if is_solid_rect(map, nextx/bw, (p.y + CameraY)/bw,   p.w/bw, p.h/bw) then 
		p.dx = 0
	end
	if is_solid_rect(map, p.x/bw,   (nexty + CameraY)/bw, p.w/bw, p.h/bw) then
		p.dy = 0
	end

	-- Apply movement
	p.x = p.x + p.dx * dt
	p.y = p.y + p.dy * dt
end

function draw_player()--{{{2
	love.graphics.setColor(color,color,color)
	love.graphics.draw(p.sprite, p.x, p.y, 0, p.scale_x, p.scale_y)
	love.graphics.setColor(0,0,0)
end

function player_cursor(dt) -- {{{2
	local mx, my = love.mouse.getPosition()
	p.cursor.scrx, p.cursor.scry = mx, my
	p.cursor.x, p.cursor.y = mx, my
	if menu == "in_game" and in_game_timer > 0.3 then
		p.cursor.active = love.mouse.isDown(1)
	else
		p.cursor.active = false
	end

	local x = mx - (p.x + p.w/2)
	local y = my - (p.y + p.h/2)
	p.angle = math.atan2(y, x)
end

function draw_cursor()
	local c = p.cursor
	love.graphics.draw(c.sprite, c.x, c.y, 0, c.scale_x, c.scale_y, c.w/2, c.h/2)
end

-- Bomb

function player_get_bomb() -- si collision, bomb s'accroche au mec --{{{2
	if collision(p.x, p.y, p.w, p.h, b.x, b.y, b.w, b.h) == true and b.catch_cooldown <= 0 then
		p.hasBomb = true
		p.coeff_score = 1 --reset le combo
	end
end

function throw_bomb()
	if p.cursor.active and p.hasBomb then
		p.hasBomb = false
		b.beep_timer = b.max_beep_timer

		b.x = p.x 
		b.y = p.y 
		b.dx = math.cos(p.angle) * b.throwspeed
		b.dy = math.sin(p.angle) * b.throwspeed
		
		
		b.catch_cooldown = b.max_catch_cooldown
		b.timer = b.max_timer

		play_random_pitch(snd_throw)
	end
end

function update_bomb(dt)
	local throwspeed_save = b.throwspeed
	b.catch_cooldown = math.max(b.catch_cooldown - dt, 0)
	b.timer = math.max(b.timer - dt, 0)
	b.active = not p.hasBomb
	if b.active then
		local bw = blockw
		local nextx = b.x + b.dx * dt
		local nexty = b.y + b.dy * dt
		local bounce = false 
		if is_solid_rect(map, nextx/bw, (b.y + CameraY)/bw,   b.w/bw, b.h/bw) then
			b.dx = -b.dx
			bounce = true
			b.throwspeed = b.throwspeed + 20
			p.coeff_score = p.coeff_score + 0.5
			test = b.dy
		end
		if is_solid_rect(map, b.x/bw,   (nexty + CameraY)/bw, b.w/bw, b.h/bw) then
			b.dy = -b.dy
			bounce = true
			b.throwspeed = b.throwspeed + 20

			p.coeff_score = p.coeff_score + 0.5
			test = p.dy
		end

		if bounce then
			play_random_pitch(snd_bombbounce)
		end
		--Damage enemies with bomb
		for i , enemy in ipairs(total_enemy) do 
			if collision(enemy.x,enemy.y,enemy.w,enemy.h,b.x,(b.y),b.w,b.h) == true and b.can_bounce == true then
				b.dx = -b.dx
				b.dy = -b.dy
				b.can_bounce = false
				enemy.hp = enemy.hp - 1
				p.score = p.score + 50*p.coeff_score
				p.coeff_score = p.coeff_score + 1
				test = p.dy
				b.throwspeed = b.throwspeed + 20
			
				
				-- Knockback
				local direction = math.atan2(b.dy, b.dx)
				enemy.dx = math.cos(direction) * enemy.knockback
				enemy.dy = math.sin(direction) * enemy.knockback
				play_random_pitch(snd_enemydamage)
				
				enemy.flashtimer = enemy.max_flashtimer
			elseif math.abs(enemy.x - b.x) > enemy.w+40 or math.abs(enemy.y - (b.y)) > enemy.h+40 then
				b.can_bounce = true
			end
		end
		-- Apply movement 
		b.x = b.x + b.dx * dt
		b.y = b.y + b.dy * dt

	


		if love.math.random() <= (b.timer%1) / 2 then
			spawn_smoke(b.x + b.w/2, b.y + b.h/2 )
		end

		-- Game over
		if b.timer <= 0 then
			play_random_pitch(snd_bombboom)
			start_menu("game_over")
		end

		-- Beeping (I'm pretty sure there's a better way to do this)
		b.beep_timer = b.beep_timer - dt
		if b.beep_timer < 0 then
			b.max_beep_timer = b.max_beep_timer * 0.5 -- Make it faster
			b.beep_timer = b.max_beep_timer -- Reset timer
			
			b.beep_pitch = b.beep_pitch + 0.001

			b.isred = not b.isred
		
			snd_bombbeep:setPitch(b.beep_pitch)
			snd_bombbeep:play()
		end
	else
		for i,enemy in ipairs(total_enemy) do --vacciné
			if math.abs(enemy.x - b.x) > enemy.w+40 or math.abs(enemy.y - (b.y)) > enemy.h+40 then
				b.can_bounce = true
			end
		b.x = p.x  + math.cos(p.angle) * 30
		b.y = p.y  + math.sin(p.angle) * 30
		
		b.max_beep_timer = b.default_max_beep_timer
		b.beep_pitch = 1
		b.isred = false
		b.throwspeed = throwspeed_save
		end
	end
	
end

function draw_bomb()
    love.graphics.setColor(1,1,1)
	if b.isred then
		love.graphics.setColor(1,0,0)
	end
	love.graphics.draw(b.sprite, b.x - b.w/b.sprite:getWidth(), b.y - b.h/b.sprite:getHeight(), b.r, b.scale_x, b.scale_y)
	love.graphics.setColor(1,1,1)
end
