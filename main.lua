#!/usr/bin/env -S love ./
-- Permet de l'executer avec ./main.lua
-- vim: fdm=marker
require "scripts/entities"
-- EVENTS{{{1
function love.load() -- LOAD {{{2
	player_create()
	bomb_create()
	menu = 'ingame'
	ingame_timer = 0
	global_timer = 0
	debug = true 
end

function love.update(dt) -- UPDATE {{{2
	global_timer = global_timer + dt
	if menu == 'ingame' then
		global_timer = global_timer + 1

		player_movement(dt)
		--coll = collision(p.x,p.y,p.w,p.h,b.x,b.y,b.w,b.h)
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
		--love.graphics.rectangle("fill",600, 100,100,20,40,1)
		love.graphics.draw(p.sprite,p.x,p.y,0,p.scale_x,scale_y) --joueur
		love.graphics.draw(b.sprite,b.x,b.y,0,0.2,0.2)
	end
	if debug then
		love.graphics.print(string.format("%.3f",p.x).."/"..string.format("%.3f",p.y), p.x, p.y-50, 0,2,2) -- coordonnées player
		love.graphics.print(string.format("%.3f",b.x).."/"..string.format("%.3f",b.y), b.x+50, b.y, 0,2,2) -- coordonnées bomb
		--love.graphics.print(coll,16,16)
		love.graphics.print(string.format("%.3f",global_timer), 0, 50, 0,2,2) -- arrondi a 3 décimale apres ,
	end
end	
