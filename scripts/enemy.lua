function enemy_create(sprite,pos,speed,size)-- vacciné
	local enemy = {
		hp = 3,
		x = pos.x,
		y= pos.y,
		dx = 0,
		dy = 0,
		speed = 3,
		sprite = love.graphics.newImage("assets/enemy_potato_1.png"),
		sprite_flash = love.graphics.newImage("assets/enemy_potato_1_white.png"),
		speed = speed,
		scale_x = 0.25,
		scale_y = 0.25,
		angle = 0,
		knockback = 4,
		flashtimer = 0,
		max_flashtimer = 0.1
	}
	enemy.w, enemy.h  = enemy.sprite:getWidth()*enemy.scale_x, enemy.sprite:getHeight() * enemy.scale_y
	return enemy
end

function draw_enemy(enemy)-- vacciné
	if enemy.hp > 0 then
		local texture = enemy.sprite
		if enemy.flashtimer > 0 then
			texture = enemy.sprite_flash
--			love.graphics.setColor(1,0.1,0.1)
		end
		love.graphics.draw(texture, enemy.x,enemy.y,0,enemy.scale_x,enemy.scale_y)
	end
	love.graphics.setColor(1,1,1)
end

function move_toward_player(x,y,speed,dt) -- vacciné
	local dx = p.x - x
	local dy = p.y - y
	local angle = math.atan2(dy, dx)
	return math.cos(angle), math.sin(angle)

	-- Désolé guillaume!
	--[[local distance = math.sqrt(dx^2+dy^2)
	if p.x < x + y/200 or p.x > x + y/10 then
		x = x - dx/distance * y * dt
	end
	if p.y < y - y/200 or p.y > y + y/10 then
		y = y - dy/distance * y * dt 
	end
	return x,y]]
end

function enemy_update(dt) -- vacciné
	for i, enemy in ipairs(total_enemy) do 
		--enemy.hp = 3
		if enemy.hp > 0 then
			if enemy_wont_move == true then
				enemy.dx,enemy.dy = move_toward_player(enemy.x,enemy.y,enemy.speed,dt)
				enemy.dx = enemy.dx --* enemy.speed
				enemy.dy = enemy.dy --* enemy.speed
				enemy.x = enemy.x + enemy.dx
				enemy.y = enemy.y + enemy.dy
			end
		else 
			table.remove(total_enemy, i)
			enemy.x = 0
			enemy.y = 0
		end

		enemy.flashtimer = enemy.flashtimer - dt
	end
end

function spawn_enemy(x,y)-- vacciné
	table.insert(total_enemy, enemy_create(
		love.graphics.newImage("assets/enemy_potato_1.png"),
		{x=x,y=y},
		200,
		0.25
	))
end
