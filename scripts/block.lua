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
	bl.y = 1*bl.h

end

function block_draw()--{{{2
	for i,v in ipairs(map) do
		for j,u in ipairs(v) do
			if u == 1 then
				love.graphics.draw(bl.sprite, (i-1)* bl.w, (j-1)*bl.h-CMwh, 0, bl.scale_y, bl.scale_y)
			end
		end
	end
 -- coll_table[y][x]
end