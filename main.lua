#!/usr/bin/env -S love ./
-- Permet de l'executer avec ./main.lua
-- vim: fdm=marker

-- FUNCTIONS {{{1
-- is_odd, is_even {{{2
function is_odd(n) return n%2==1 end
function is_even(n) return n%2==0 end

-- EVENTS{{{1
function love.load() -- LOAD {{{2
	menu = 'ingame'
	timer = 0
	x, y, w, h = 20, 20, 60, 20
	player_create()
	debug = false
end


function love.update(dt) -- UPDATE {{{2
	player_movement()
	timer = timer + dt
	w = w + 1
	h = h + 1
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
end

function love.draw() -- DRAWING {{{2
	if menu == 'ingame' then
		love.graphics.print("Hello World!", 400, 300)
		love.graphics.rectangle("fill",600, 100,100,20,40,1)
		love.graphics.draw(p.sprite,p.x,p.y,0,0.5,0.5)
	end
	if debug then
		love.graphics.print(tostring(timer), 40, 0)
	end
end	


-----------------
--Player function 
-----------------

function player_create()
	p = {
		x=0,
		y=0,
		sprite = love.graphics.newImage("assets/player.sprite/player01.png"),
		speed = 8
		}
end

function player_movement()
	if love.keyboard.isDown("left") then 
		p.x = p.x - p.speed
	end

	if love.keyboard.isDown("right") then 
		p.x = p.x + p.speed
	end

	if love.keyboard.isDown("up") then 
		p.y = p.y - p.speed
	end

	if love.keyboard.isDown("down") then
		 p.y = p.y + p.speed
	end
end
