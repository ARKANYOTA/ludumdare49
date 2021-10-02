#!/usr/bin/env -S love ./
-- Permet de l'executer avec ./main.lua
-- vim: fdm=marker

--METTEZ OU IL FAUT LE METTRE SVP
require "scripts/entities"
CM = require "lib.CameraMgr".newManager()

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
	love.graphics.rectangle("line",x,y,w,h) -- vertical left
end

-- EVENTS{{{1
function love.load() -- LOAD {{{2
	-- Proper font scaling 
    font = love.graphics.newFont(15, "none", 3)
    love.graphics.setFont(font)

	-- Create entities
	player_create()
	bomb_create()
	block_create()
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
	if menu == 'ingame' then -- {{{3
		--love.graphics.rectangle("fill",600, 100,100,20,40,1)
		player_draw()
		player_cursor()
		love.graphics.draw(b.sprite, b.x, b.y, 0, b.scale_x, b.scale_y)
		block_draw()
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
	if debug then -- {{{3
		love.graphics.setColor(255, 255, 255, 1.0)
		if menu == 'ingame' then
			draw_collision(b.x,b.y,b.w,b.h)
			draw_collision(p.x,p.y,p.w,p.h)
			draw_collision(bl.x,bl.y,bl.w,bl.h)
			love.graphics.print(math.floor(p.x).."/"..math.floor(p.y), p.x, p.y-50, 0,2,2) -- coordonnées player
			love.graphics.print(math.floor(b.x).."/"..math.floor(b.y), b.x+50, b.y, 0,2,2) -- coordonnées bomb
			--love.graphics.print(coll,16,16)
			love.graphics.print("collision bomb/player: "..tostring(coll_check),600,100)
		end
		
	end
end	

