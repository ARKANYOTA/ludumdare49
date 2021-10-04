function enemy_create(sprite,pos,speed,size)-- vacciné
	local enemy = {
		hp = 3,
		x = pos.x,
		y= pos.y,
		dx = 0,
		dy = 0,
		sprite = love.graphics.newImage("assets/enemy_potato_1.png"),
		speed = speed,
		scale_x = 0.25,
		scale_y = 0.25,
		angle = 0,
		knockback = 4,
	}
	enemy.w, enemy.h  = enemy.sprite:getWidth()*enemy.scale_x, enemy.sprite:getHeight() * enemy.scale_y
	return enemy
end

function draw_enemy(enemy)-- vacciné
	if enemy.hp > 0 then
		love.graphics.draw(enemy.sprite,enemy.x,enemy.y,0,enemy.scale_x,enemy.scale_y)
	end
end

function move_toward_player(x,y,speed,dt) -- vacciné
	local dx, dy = x - p.x, y - p.y
	
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
			end
		else 
			enemy.x = 0
			enemy.y = 0
		end
		enemy.x = enemy.x + enemy.dx
		enemy.y = enemy.y + enemy.dy
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