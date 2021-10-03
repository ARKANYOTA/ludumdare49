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
end

function draw_enemy()
	love.graphics.draw(enemy.sprite,enemy.x,enemy.y,0,enemy.scale_x,enemy.scale_y)
end

function move_toward_player()
	local x = enemy.x - (p.x + p.w/2)
	local y = enemy.y - (p.x + p.h/2)
	enemy.angle = math.atan2(y, x)
	if  (p.x <= enemy.x and p.y <= enemy.y) or (p.x >= enemy.x and p.y >= enemy.y) then
	enemy.x = enemy.x - math.cos(enemy.angle) * enemy.speed
	enemy.y = enemy.y - math.cos(enemy.angle) * enemy.speed
	elseif  (p.x >= enemy.x and p.y <= enemy.y) or (p.x <= enemy.x and p.y >= enemy.y) then
		enemy.y = enemy.y + math.cos(enemy.angle) * enemy.speed
		enemy.x = enemy.x - math.cos(enemy.angle) * enemy.speed
	end
end

function enemy_update()
	move_toward_player()
end