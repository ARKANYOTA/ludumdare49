#!/usr/bin/env -S love ./
-- Permet de l'executer avec ./main.lua
-- vim: fdm=marker

-- FUNCTIONS {{{1
-- is_odd, is_even {{{2
function is_odd(n) return n % 2 == 1 end
function is_even(n) return n % 2 == 0 end

-- EVENTS{{{1
function love.load() -- LOAD {{{2
	menu = 'ingame'
	timer = 0
	x, y, w, h = 20, 20, 60, 20
	debug = false
end

function love.update(dt) -- UPDATE {{{2
	timer = timer + dt
	w = w + 1
	h = h + 1
end

function love.keypressed(key, scancode, isrepeat) -- KEYPRESSED {{{2
	-- always {{{3
	if key == "escape" or (love.keyboard.isDown("lctrl") and key == "c") then
		love.event.quit()
	end
	if key == "f5" then 
		love.event.quit("restart") 
	end
	if key == "f3" then 
		debug = not debug 
	end
	if menu == "ingame" then -- ingame {{{3
		
	end
	if menu == "menu" then -- menu {{{3

	end
end

function love.draw() -- DRAWING {{{2
	if menu == 'ingame' then
		love.graphics.print("Hello World! (THEOBOSSE IS THE BEST BTW)", 400, 300)
		love.graphics.rectangle("fill",600, 100,100,20,40,1)
	end
	if debug then
		love.graphics.print(tostring(timer), 40, 0)
	end
end

