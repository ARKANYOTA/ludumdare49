#!/usr/bin/env -S love ./
-- Permet de l'executer avec ./main.lua
-- vim: fdm=marker

--METTEZ OU IL FAUT LE METTRE SVP
require "scripts/entities"

-- Function {{{1
function newButton(text, fn) -- {{{2
    return {
        text=text,
        fn=fn,
		now= false,
		last = false
    }
end

function see_collision(x,y,w,h) -- {{{2
	love.graphics.rectangle("fill",x,y,4,h) -- vertical left
	love.graphics.rectangle("fill",x+w,y,4,h) -- vert right
	love.graphics.rectangle("fill",x,y,w,4)
	love.graphics.rectangle("fill",x,y+w,w,4)
end

-- EVENTS{{{1
function love.load() -- LOAD {{{2
	player_create()
	bomb_create()
	menu = 'menu'
	ingame_timer = 0
	global_timer = 0
	debug = true 

	-- Menu {{{3
	BUTTON_HEIGHT = 64
	buttons = {}
	font = love.graphics.newFont(32)

	table.insert( buttons, newButton("Start Game", function() menu = "ingame" end))
	table.insert( buttons, newButton("Tuto", function() print("Tuto") end))
	table.insert( buttons, newButton("Info", function() print("Info") end))
	table.insert( buttons, newButton("Exit Game", function() love.event.quit(0) end))

	coll_check = false

end

function love.update(dt) -- UPDATE {{{2
	global_timer = global_timer + dt
	if menu == 'ingame' then
		global_timer = global_timer + 1

		player_movement(dt)
		coll_check = collision(p.x,p.y,p.w,p.h,b.x,b.y,b.w,b.h)
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
	if menu == "menu" then -- menu {{{3
		local ww = love.graphics.getWidth()
		local wh = love.graphics.getHeight()

		local button_with = ww * (1/3)
		local margin = 16

		local total_height = (BUTTON_HEIGHT + margin) * #buttons
		local cursor_y = 0

		for i, button in ipairs(buttons) do
			button.last = button.now
			local bx = (ww * 0.5) - (button_with * 0.5)
			local by = (wh * 0.5) - (total_height *0.5) + cursor_y
			local color = {0.4, 0.4, 0.5, 1.0}
			local mx, my = love.mouse.getPosition()
			local hot = mx > bx and mx < bx + button_with and my > by and my < by + BUTTON_HEIGHT
			if hot then
				color = {0.8, 0.8, 0.9, 1.0}
			end
			button.now = love.mouse.isDown(1)
			if button.now and not button.last and hot then
				button.fn()
			end
			love.graphics.setColor(unpack(color))
			love.graphics.rectangle("fill", bx, by, button_with, BUTTON_HEIGHT)
			love.graphics.setColor(0, 0, 0, 1)
			local textW = font:getWidth(button.text)
			local textH = font:getHeight(button.text)
			love.graphics.print(button.text, font, (ww * 0.5) - textW * 0.5, by + textH * 0.5)
			cursor_y = cursor_y + (BUTTON_HEIGHT + margin)
		end
	end
	if debug then
		love.graphics.setColor(255, 255, 255, 1.0)
		if menu == 'ingame' then
			see_collision(b.x,b.y,b.w,b.h)
			see_collision(p.x,p.y,p.w,p.h)
			love.graphics.print(string.format("%.3f",p.x).."/"..string.format("%.3f",p.y), p.x, p.y-50, 0,2,2) -- coordonnées player
			love.graphics.print(string.format("%.3f",b.x).."/"..string.format("%.3f",b.y), b.x+50, b.y, 0,2,2) -- coordonnées bomb
			love.graphics.print("collision bomb/player: "..tostring(coll_check),600,100)
		end
		
	end
end	
