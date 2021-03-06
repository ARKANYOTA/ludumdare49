-- vim: fdm=marker

function collision(x1,y1,w1,h1,x2,y2,w2,h2) -- si collision entre deux objets, return true --{{{2
	return (x1+w1 > x2 and x1 < x2 + w2 and
	   y1 < y2 + h2 and y1 + h1 > y2)
	   
end

function draw_collision(x,y,w,h)--{{{2
	love.graphics.rectangle("line",x,y,w,h)
end

function make_blank_map(w, h)
	local t = {}
	for y = 1, w do
		table.insert(t, {})
		for _ = 1, h do
			rd = love.math.random(9)
			if rd == 2 or rd == 3 or rd == 4 then
				table.insert(t[y], 2)
			elseif rd == 5 or rd == 6 or rd == 7 then
				table.insert(t[y], 3)
			else
				table.insert(t[y], 0)
			end
		end
	end
	return t
end

function get_map(map, x, y)
	x = (math.floor(x) + 1)
	y = (math.floor(y) + 1)
	if x <= 0 or #map[1] < x or y <= 0 or #map < y then
		return 0
	end
	return map[y][x]
end

function set_map(map, x, y, val)
	x = (math.floor(x) + 1)
	y = (math.floor(y) + 1)
	if x <= 0 or #map[1] < x or y <= 0 or #map < y then
		return false
	end
	map[y][x] = val
	return true
end
--[[
function make_collision_table()
	coll_table = {}
	for y = 0, 2700, bl.w do
		local coll_table_x = {}
		for x = 0, 700, bl.h do
			table.insert(coll_table_x,0)
		end
		table.insert(coll_table,coll_table_x)
	end
end--]]

function is_solid(map, x, y)
	y = y - DeletedMapBlock
    if (x < 0) or (nb_block_x < x) or (y < 0) or (nb_block_y < y) then
        return true
    end
	return get_map(map, x, y) == 1
end

function is_solid_rect(map, x, y, w, h)
    --[[
        A - x - B
        |       |
        y       z
        |       |
        C - w - D
    ]]
    return 
        is_solid(map, x,     y) or   --A
        is_solid(map, x+w,   y) or   --B
        is_solid(map, x,     y+h) or --C
        is_solid(map, x+w,   y+h) or --D

        is_solid(map, x+w/2, y) or     --x
        is_solid(map, x,     y+h/2) or --y
        is_solid(map, x+w,   y+h/2) or --z
        is_solid(map, x+w/2, y+h/2)    --w
end
