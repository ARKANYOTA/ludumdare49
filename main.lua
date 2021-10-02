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
		last = false,
		color = {0.4, 0.4, 0.5, 1.0}
    }
end

function see_collision(x,y,w,h) -- {{{2
	love.graphics.rectangle("line",x,y,w,h) -- vertical left
end

-- EVENTS{{{1
function love.load() -- LOAD {{{2
	-- UI
	buttons = {}
	ww = love.graphics.getWidth()
	wh = love.graphics.getHeight()
	button_width = ww * (1/3)
	margin = 16

	-- Proper font scaling 
    font = love.graphics.newFont(15, "none", 3)
    love.graphics.setFont(font)
	font = love.graphics.newFont(32)

	-- Menu {{{3
	start_menu('menu') -- valeurs posibles menu,ingame, ingame_menu, gameover
	ingame_timer = 0
	global_timer = 0
	debug = false 
	BUTTON_HEIGHT = 64

	-- Particles
	particles = {}

	coll_check = false
end

function love.update(dt) -- UPDATE {{{2
	global_timer = global_timer + dt
	
	if menu == 'menu' then
		update_buttons()
	end
	
	if menu == 'ingame' then
		global_timer = global_timer + 1
		player_update()
	end

	for i,pt in ipairs(particles) do
		update_particle(pt, dt)
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
		if key=="g" then start_game() end
		if key=="m" then start_menu("menu") end
	end
end

function love.draw() -- DRAWING {{{2
	love.graphics.setColor(255, 255, 255, 1.0)
	if menu == 'ingame' then -- {{{3
		--love.graphics.rectangle("fill",600, 100,100,20,40,1)
		draw_player()
		draw_bomb()

		block_draw()
		player_cursor()

		for i,pt in ipairs(particles) do
			draw_particle(pt)
		end

		-- Keep at last
		draw_cursor()
	end
	if menu == "menu" then -- menu {{{3
		draw_menu()
	end
	if debug then -- {{{3
		draw_debug()			
	end
end	

-- USELESS FUCNTIONS {{{2
function update_buttons()
	local total_height = (BUTTON_HEIGHT + margin) * #buttons
	local cursor_y = 0

	for i, button in ipairs(buttons) do
		local bx = (ww / 2) - (button_width / 2)
		local by = (wh / 2) - (total_height / 2) + cursor_y
		local mx, my = love.mouse.getPosition()
		local hot = mx > bx and mx < bx + button_width and my > by and my < by + BUTTON_HEIGHT
		button.color = {0.4, 0.4, 0.5, 1.0}
		if hot then
			button.color = {0.8, 0.8, 0.9, 1.0}
		end
		button.now = love.mouse.isDown(1)
		if button.now and not button.last and hot then
			button.fn()
		end
		cursor_y = cursor_y + (BUTTON_HEIGHT + margin)
	end
end

function draw_buttons()
	local total_height = (BUTTON_HEIGHT + margin) * #buttons
	local cursor_y = 0

	for i, button in ipairs(buttons) do
		button.last = button.now
		local bx = (ww / 2) - (button_width / 2)
		local by = (wh / 2) - (total_height / 2) + cursor_y
		
		love.graphics.setColor(unpack(button.color))
		love.graphics.rectangle("fill", bx, by, button_width, BUTTON_HEIGHT)
		love.graphics.setColor(0, 0, 0, 1)
		local textW = font:getWidth(button.text)
		local textH = font:getHeight(button.text)
		love.graphics.print(button.text, font, (ww * 0.5) - textW * 0.5, by + textH * 0.5)
		cursor_y = cursor_y + (BUTTON_HEIGHT + margin)
	end
end

function draw_menu()
	draw_buttons()
end

function draw_debug()
	love.graphics.setColor(255, 255, 255, 1.0)
	if menu == 'ingame' then
		draw_collision(b.x,b.y,b.w,b.h)
		draw_collision(p.x,p.y,p.w,p.h)

		love.graphics.print(math.floor(b.x).."/"..math.floor(b.y), b.x+50, b.y) -- coordonnées bomb
		love.graphics.print(b.catchcooldown, b.x+50, b.y-20) -- coordonnées bomb
		--love.graphics.print(coll,16,16)
		-- coordonnées player
		love.graphics.print("player x:"..math.floor(p.x).." y:"..math.floor(p.y), 0, 20)
		-- coordonnées bomb
		love.graphics.print("bomb x:"..math.floor(b.x).." y:"..math.floor(b.y), 0, 40)
		love.graphics.print("bomb timer:"..math.floor(b.timer * 1000)/1000, 0, 60)
		love.graphics.print("bomb cooldown:"..math.floor(b.max_catchcooldown * 1000)/1000, 0, 80)
		love.graphics.print("bomb active:"..tostring(b.active), 0, 100)
		love.graphics.print("collision bomb/player: "..tostring(coll_check),0, 120)
	end
	love.graphics.print("debug: is_on",0,0)
end

function start_game()
	love.mouse.setVisible(false)
	player_create()
	bomb_create()
	block_create()
	ingame_timer = 0
	menu = 'ingame'
end

function start_menu(m)
	love.mouse.setVisible(true)
	for i, v in ipairs(buttons) do buttons[i] = nil end
	menu = m
	if menu =='menu'then
		table.insert(buttons, newButton("Start Game", start_game))
		table.insert(buttons, newButton("Tuto", function() print("Tuto") end))
		table.insert(buttons, newButton("Info", function() print("Info") end))
		table.insert(buttons, newButton("Exit Game", function() love.event.quit(0) end))
	end
end
