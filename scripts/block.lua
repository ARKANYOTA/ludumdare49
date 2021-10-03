require "scripts/constants"

function block_create() --{{{2
	bl = {
		x = 500,
		y = 0,
		sprite = love.graphics.newImage("assets/stone.jpg"), --200 × 200
		scale_x = 1/3,
		scale_y = 1/3,
        w = blockw,
        h = blockw,
	}
	bl.scale_x = blockw / bl.sprite:getWidth()
    bl.scale_y = blockw / bl.sprite:getHeight()
end

function block_draw()--{{{2
	for y, line in ipairs(map) do
		for x, block in ipairs(line) do
			if block == 1 then
				love.graphics.draw(bl.sprite, (x-1)* bl.w, (y-1)*bl.h-CameraY, 0, bl.scale_y, bl.scale_y)
			end
		end
	end
 -- coll_table[y][x]
end