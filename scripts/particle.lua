function make_particle(sprite, pos, speed, size, delta_size, rot, delta_rot)
	local pt = {
		x = pos.x,
		y = pos.y,
		dx = speed.x,
		dy = speed.y,
		s = size,
		ds = delta_size,
		r = rot,
		dr = delta_rot,

		sprite = sprite,
        
        mustdestroy = false,
	}
	pt.w = pt.sprite:getWidth()
	pt.h = pt.sprite:getHeight()

	return pt
end

function update_particle(pt, dt)
	pt.x = pt.x + pt.dx * dt
	pt.y = pt.y + pt.dy * dt

	pt.s = pt.s * pt.ds
	pt.r = (pt.r + pt.dr) % math.pi

    local epsilon = 0.001
    if pt.s <= epsilon then
        pt.mustdestroy = true
    end
end

function draw_particle(pt)
	love.graphics.draw(pt.sprite, pt.x, pt.y, pt.r, pt.s, pt.s, pt.w/2, pt.h/2)
end


function spawn_smoke(x, y)
	table.insert(particles, make_particle(
		love.graphics.newImage("assets/smoke.png"),
		{x=x, y=y},
		{x = (love.math.random()*2-1)*10, y = (love.math.random()*2-1)*10},
		love.math.random()*0.5, 0.95, --size, Δ size
		love.math.random() * 2*math.pi,
		(love.math.random()*2 - 1) / 3
	))
end
