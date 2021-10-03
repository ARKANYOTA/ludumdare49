require "scripts/constants"
require "scripts/textures"

function block_create() --{{{2
	bl = {
		x = 500,
		y = 0,
        w = blockw,
        h = blockw,
        
		sprite = love.graphics.newImage("assets/stone.png"), --200 × 200
		bg = sand1,
		scale_x = 1/3,
		scale_y = 1/3,
	}
	bl.scale_x = blockw / bl.sprite:getWidth()
    bl.scale_y = blockw / bl.sprite:getHeight()
end

function block_draw()--{{{2
	for y, line in ipairs(map) do
		for x, block in ipairs(line) do
			if block == 1 then
				love.graphics.draw(bl.sprite, (x-1)* bl.w, (y-1)*bl.h-CameraY+DeletedMapBlock*blockh, 0, bl.scale_y, bl.scale_y)
			elseif block == 0 then
				local texture = sandmap[(x+y*#map[1]) % #sandmap]
				love.graphics.draw(texture, (x-1)* bl.w, (y-1)*bl.h-CameraY+DeletedMapBlock*blockh, 0, bl.scale_y, bl.scale_y)
			end
		end
	end
 -- coll_table[y][x]
end
