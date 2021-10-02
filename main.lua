#!/usr/bin/env -S love ./
-- Permet de l'executer avec ./main.lua
-- vim: fdm=marker

-- FUNCTIONS {{{1
--Player {{{2
function player_create() -- {{{3
	p = {
		x=200,
		y=200,
		sprite = love.graphics.newImage("assets/player01.png"),
		speed = 8,
		scale_x = 1,
		scale_y = 1
		}
end

function bombe_create()
    b = {
	x=0,
	y=0,
	sprite = love.graphics.newImage("assets/bomb.png")

    }
end



function player_movement() --{{{3
	if love.keyboard.isDown("q") or love.keyboard.isDown("left") then 
		p.x = p.x - p.speed
	end

	if love.keyboard.isDown("d") or love.keyboard.isDown("right") then 
		p.x = p.x + p.speed
	end

	if love.keyboard.isDown("z") or love.keyboard.isDown("up") then 
		p.y = p.y - p.speed
	end

	if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
		 p.y = p.y + p.speed
	end
end




-- EVENTS{{{1
function love.load() -- LOAD {{{2
	player_create()
	bombe_create()
	menu = 'ingame'
	ingame_timer = 0
	global_timer = 0
	debug = true 
end

function love.update(dt) -- UPDATE {{{2
	global_timer = global_timer + dt
	if menu == 'ingame' then
		global_timer = global_timer + 1
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
		player_movement()
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
		love.graphics.draw(b.sprite,b.x,b.y,0,0.2,0.2)
	end
	if debug then
		love.graphics.print(p.x.."/"..p.y, 0, 0, 0,2,2)
		love.graphics.print(string.format("%.3f",global_timer), 0, 50, 0,2,2) -- arrondi a 3 décimale apres ,
	end
end	
