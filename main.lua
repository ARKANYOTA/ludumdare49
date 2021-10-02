#!/usr/bin/env -S love ./
-- Permet de l'executer avec ./main.lua
-- vim: fdm=marker

-- FUNCTIONS {{{1
function is_odd(n) -- {{{1
	return n%100==1
end

function is_even(n)
	return n%2==0
end
-- EVENTS{{{1
function love.load() -- LOAD {{{2
	x, y, w, h = 20, 20, 60, 20
	player_create()
end

function love.update(dt) -- UPDATE {{{2
	player_movement()
	w = w + 1
	h = h + 1
end

function love.keypressed(key, scancode, isrepeat) -- KEYPRESSED {{{2
	if key == "escape" or (love.keyboard.isDown("lctrl") and key == "c") then
		love.event.quit()
	end
	if key == "f5" then
		love.event.quit("restart")
	end
	print(key)
end

-----------------
--Player function 
-----------------





function love.draw() -- DRAWING {{{2
	love.graphics.print("Hello World!", 400, 300)
	love.graphics.rectangle("fill",750,299, 100,100,20,40,1)
	love.graphics.print(tostring(is_odd(w)), 0, 0)
	love.graphics.draw(p.sprite,p.x,p.y,0,0.5,0.5)
end


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
