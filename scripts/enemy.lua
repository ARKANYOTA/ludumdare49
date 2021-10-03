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
ends

function draw_enemy()
	love.graphics.draw(enemy.sprite,enemy.x,enemy.y,0,enemy.scale_x,enemy.scale_y)
end

function move_toward_player()
	if p.x > enemy.x  then
		enemy.x = enemy.x + enemy.speed
	elseif p.x < enemy.x then
		enemy.x = enemy.x - enemy.speed
	end
	if p.y > enemy.y  then
		enemy.y = enemy.y + enemy.speed
	elseif p.y < enemy.y then
		enemy.y = enemy.y- enemy.speed
	end
end

function enemy_update()
	move_toward_player()
end