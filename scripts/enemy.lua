function enemy_create()
	enemy = {
		x = 200,
		y=200,
		sprite = love.graphics.newImage("assets/enemy_potato_1.png"),
		speed = 200,
		scale_x = 0.25,
		scale_y = 0.25,
		angle = 0
	}
	enemy.w, enemy.h  = enemy.sprite:getWidth()*enemy.scale_x, enemy.sprite:getHeight() * enemy.scale_y
end

function draw_enemy()
	love.graphics.draw(enemy.sprite,enemy.x,enemy.y,0,enemy.scale_x,enemy.scale_y)
end

function move_toward_player(dt)
	local dx,dy = enemy.x - p.x, enemy.y-p.y
	local distance = math.sqrt(dx^2+dy^2)
if p.x < enemy.x + enemy.w or p.x > enemy.x + enemy.speed/10 then
	enemy.x = enemy.x - dx/distance * enemy.speed * dt
end
if p.y < enemy.y - enemy.speed/200 or p.y > enemy.y + enemy.speed/10 then
	enemy.y = enemy.y - dy/distance * enemy.speed * dt 
end
end

function enemy_update(dt)
	move_toward_player(dt)
end