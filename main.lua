#!/usr/bin/env -S love ./
-- Permet de l'executer avec ./main.lua
-- vim: fdm=marker

--METTEZ OU IL FAUT LE METTRE SVP
require "scripts/entities"
--require "lib/CameraMgr/main"


function see_collision(x,y,w,h)
	love.graphics.rectangle("fill",x,y,4,h) -- vertical left
	love.graphics.rectangle("fill",x+w,y,4,h) -- vert right
	love.graphics.rectangle("fill",x,y,w,4)
	love.graphics.rectangle("fill",x,y+w,w,4)
end



-- EVENTS{{{1
function love.load() -- LOAD {{{2
	player_create()
	bomb_create()
	menu = 'ingame'
	ingame_timer = 0
	global_timer = 0
	debug = true 
	coll_check = false
end

function love.update(dt) -- UPDATE {{{2
	global_timer = global_timer + dt
	if menu == 'ingame' then
		global_timer = global_timer + 1

		player_movement(dt)
		if collision(p.x,p.y,p.w,p.h,b.x,b.y,b.w,b.h) then
		coll_check = true
		else
		coll_check = false
		end
		player_get_bomb()

	end
end

function love.keypressed(key, scancode, isrepeat) -- KEYPRESSED {{{2
	-- always {{{3
	if key == "escape" or (love.keyboard.isDown("lctrl") and key == "c") then
		love.event.quit()
	end
	if key == "f5" then love.event.quit("restart") end
	if key == "f3" then debug = not debug end
	if menu == "ingame" then -- ingame {{{3
	end
	if menu == "menu" then -- menu {{{3

	end
	if debug then
		if key=="m" then
			menu = "menu"
		end
		if key=="g" then
			menu = "ingame"
		end
	end
end

function love.draw() -- DRAWING {{{2
	if menu == 'ingame' then
		love.graphics.draw(p.sprite,p.x,p.y,0,p.scale_x,scale_y) --joueur
		love.graphics.draw(b.sprite,b.x,b.y,0,b.scale_x,b.scale_y)

	end
	if debug then
		see_collision(b.x,b.y,b.w,b.h)
		see_collision(p.x,p.y,p.w,p.h)
		love.graphics.print(string.format("%.3f",p.x).."/"..string.format("%.3f",p.y), p.x, p.y-50, 0,2,2) -- coordonnées player
		love.graphics.print(string.format("%.3f",b.x).."/"..string.format("%.3f",b.y), b.x+50, b.y, 0,2,2) -- coordonnées bomb
		--love.graphics.print(string.format("%.3f",global_timer), 0, 50, 0,2,2) -- timer ,

		love.graphics.print("collision bomb/player: "..tostring(coll_check),600,100)
	end
end	
