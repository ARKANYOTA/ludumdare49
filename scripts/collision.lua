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
			table.insert(t[y], 0)
		end
	end
	return t
end

function get_map(map, x, y, blockw)
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
    if (x < 0) or (screenw/blockw < x) or (y < 0) or (screenh/blockw < y) then
        return true
    end 
	return get_map(map, x, y) == 1
end

function is_solid_rect(map, x, y, w, h)
    return is_solid(map, x, y) or is_solid(map, x+w, y) or is_solid(map, x,   y+h) or is_solid(map, x+w, y+h) 
end