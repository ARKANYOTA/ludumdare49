#!/usr/bin/env -S love ./
-- Permet de l'executer avec ./main.lua
-- vim: fdm=marker

-- FUNCTIONS {{{1
function is_odd(n) -- {{{1
	return n%100==1
end

-- EVENTS{{{1
function love.load() -- LOAD {{{2
	x, y, w, h = 20, 20, 60, 20
end

function love.update(dt) -- UPDATE {{{2
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

function love.draw() -- DRAWING {{{2
	love.graphics.print("Hello World!", 400, 300)
	love.graphics.print(tostring(is_odd(w)), 0, 0)
end

