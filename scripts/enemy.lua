function enemy_create()
	enemy = {
		x = 200,
		y=200,
		sprite = love.graphics.newImage("assets/enemy_potato_1.png"),
		speed = 2,
		scale_x = 0.25,
		scale_y = 0.25,
		angle = 0
	}
	enemy.w, enemy.h  = enemy.sprite:getWidth()*enemy.scale_x, enemy.sprite:getHeight() * enemy.scale_y
end

function draw_enemy()
	love.graphics.draw(enemy.sprite,enemy.x,enemy.y,0,enemy.scale_x,enemy.scale_y)
end

function move_toward_player()
	local center_enemy_x = enemy.x + enemy.w/3.25
	local center_enemy_y = enemy.y + enemy.h/3.25
	
	if p.x < center_enemy_x - enemy.speed/2 or p.x > center_enemy_x + enemy.speed/2 then
		if p.x > center_enemy_x  then
			enemy.x = enemy.x + enemy.speed
		elseif p.x < center_enemy_x then
			enemy.x = enemy.x - enemy.speed
		end
	end
	if p.y < center_enemy_y - enemy.speed/2 or p.y > center_enemy_y + enemy.speed/2 then
		if p.y > center_enemy_y  then
			enemy.y = enemy.y + enemy.speed
		elseif p.y < center_enemy_y then
			enemy.y = enemy.y - enemy.speed
		end
	end
end

function enemy_update()
	move_toward_player()
end