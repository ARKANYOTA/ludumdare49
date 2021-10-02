#!/usr/bin/env -S love ./
-- Permet de l'executer avec ./main.lua
-- vim: fdm=marker
require "scripts/entities"

BUTTON_HEIGHT = 64
local buttons = {}
local font = nil
function newButton(text, fn)
    return {
        text=text,
        fn=fn,
		now= false,
		last = false
    }
end

-- EVENTS{{{1
function love.load() -- LOAD {{{2
	player_create()
	bomb_create()
	menu = 'menu'
	ingame_timer = 0
	global_timer = 0
	debug = true 

	font = love.graphics.newFont(32)
	table.insert( buttons, newButton("Start Game", function() print("Starting Game") end))
	table.insert( buttons, newButton("Tuto", function() print("Tuto") end))
	table.insert( buttons, newButton("Info", function() print("Info") end))
	table.insert( buttons, newButton("Exit Game", function() love.event.quit(0) end))
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
		love.graphics.rectangle("fill",600, 100,100,20,40,1)
		love.graphics.draw(p.sprite,p.x,p.y,0,p.scale_x,scale_y) --joueur
		love.graphics.draw(b.sprite,b.x,b.y,0,0.2,0.2)
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
		love.graphics.print(p.x.."/"..p.y, p.x, p.y-50, 0,2,2) -- coordonnées player
		love.graphics.print(b.x.."/"..b.y, b.x+50, b.y, 0,2,2) -- coordonnées bomb
		--love.graphics.print(coll,16,16)
		love.graphics.print(string.format("%.3f",global_timer), 0, 50, 0,2,2) -- arrondi a 3 décimale apres ,
		love.graphics.print(p.x.."/"..p.y, 0, 0, 0,2,2)
	end
end	
