#!/usr/bin/env -S love ./
-- Permet de l'exécuter avec ./main.lua
-- vim: fdm=marker

--METTEZ OU IL FAUT LE METTRE SVP
require "scripts/menus"
require "scripts/player"
require "scripts/enemy"
require "scripts/block"
require "scripts/constants"
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

function print_table(elt)
	for i,_ in ipairs(elt) do
		print(unpack(elt[i]))
	end
end

function draw_collision(x,y,w,h) -- {{{2
	love.graphics.rectangle("line",x,y,w,h) -- vertical left
end

function has_value(tab, val)
	for _, value in ipairs(tab) do
		if value == val then
			return true
		end
	end
	return false
end

-- EVENTS{{{1
function love.load() -- LOAD {{{2
	-- UI
	menus = {'menu', 'game_over', 'pause', 'credits', 'tuto'}
	buttons = {}
	ww = love.graphics.getWidth()
	wh = love.graphics.getHeight()
	CameraY = 0
	CM.setCoords(ww/2, wh/2)
	button_width = ww * (1/3)
	margin = 16

	-- Proper font scaling
	font = love.graphics.newFont(15, "none", 3)
	love.graphics.setFont(font)
	font = love.graphics.newFont(32)

	-- Menu {{{3
	sprite_btn = love.graphics.newImage("assets/button.png"),
	start_menu('menu') -- valeurs possibles menu,in_game, pause, game_over
	in_game_timer = 0
	global_timer = 0
	load_credits()

	-- Particles
	particles = {}
	coll_check = false
	
	-- Map
	map = make_blank_map(30, 30)
	set_map(map, 1, 0, 1)
	set_map(map, 1, 1, 1)
	set_map(map, 1, 4, 1)
	blockw = 30

	-- Debug
end

function love.update(dt) -- UPDATE {{{2
	CM.update(dt)
	global_timer = global_timer + dt
	
	
	if menu == 'in_game' then
		player_update()
		enemy_update(dt)
		if love.keyboard.isScancodeDown("k") then
			CameraY = CameraY +1
			p.y = p.y -1
			b.y = b.y -1
			enemy.y = enemy.y -1
		end
	end

	for _,pt in ipairs(particles) do
		update_particle(pt, dt)
	end

end

function love.mousepressed( x, y, button, istouch, presses ) 
	if has_value(menus,menu) then
		update_buttons(button, x, y)
	end
end


function love.mousemoved( x, y, dx, dy, istouch )
	if has_value(menus,menu) then
		update_buttons(0, x, y)
	end
end

function love.keypressed(key, scancode, isrepeat) -- KEYPRESSED {{{2
	-- always {{{3
	if (love.keyboard.isDown("lctrl") and key == "c") then
		love.event.quit()
	end
	if key == "f5" then love.event.quit("restart") end
	if key == "f3" then debug = not debug end
	if menu == "in_game" then -- in_game {{{3
		if key == "escape" then
			start_menu("pause")
		end
	elseif menu == "pause" then -- in_game {{{3
		if key == "escape" then
			continue_game("pause")
		end
	elseif menu == "credits" or menu == "tuto" then
		if key == "escape" then
			start_menu("menu")
		end
	end
	if has_value(menus,menu) then -- menu {{{3

	end
	if debug then
		if key=="g" then start_game() end
		if key=="m" then start_menu("menu") end
		if key=="o" then start_menu("game_over") end
		if key=="c" then start_menu("credits") end
		if key=="t" then start_menu("tuto") end

		if key=="b" then b.x = p.x; b.y = p.y; end
	end
end

function love.draw() -- DRAWING {{{2
	CM.attach() -- CE QUI EST RELATIF A LA CAMERA
	love.graphics.setColor(255, 255, 255, 1.0)
	if menu == 'in_game' then -- {{{3
		--love.graphics.rectangle("fill",600, 100,100,20,40,1)
		block_draw()
		draw_player()
		draw_bomb()
		draw_enemy()
		player_cursor()

		for _,pt in ipairs(particles) do
			draw_particle(pt)
		end

		-- vv KEEP AS THE LAST vv
		draw_cursor()
	end
	if debug then -- {{{3
		draw_debug_unfix()
	end
	CM.detach() -- CE QUI EST FIX DANS L ÉCRAN
	if debug then -- {{{3
		--CM.debug()
		draw_debug()			
	end
	if has_value(menus,menu) then -- menu {{{3
		draw_menu()
	end
end	

-- USELESS FUNCTIONS {{{2
function update_buttons(pressed_btn, mx, my)
	local total_height = (BUTTON_HEIGHT + margin) * #buttons
	local cursor_y = 0

	for _, button in ipairs(buttons) do
		local bx = (ww / 2) - (button_width / 2)
		local by = (wh / 2) - (total_height / 2) + cursor_y
		local hot = mx > bx and mx < bx + button_width and my > by and my < by + BUTTON_HEIGHT
		button.color = {0.4, 0.4, 0.5, 1.0}
		if hot then
			button.color = {0.8, 0.8, 0.9, 1.0}
		end
		button.now = pressed_btn==1
		if button.now and not button.last and hot then
			button.fn()
		end
		cursor_y = cursor_y + (BUTTON_HEIGHT + margin)
	end
end

function draw_buttons()
	local total_height = (BUTTON_HEIGHT + margin) * #buttons
	local cursor_y = 0

	for _, button in ipairs(buttons) do
		button.last = button.now
		local bx = (ww / 2) - (button_width / 2)
		local by = (wh / 2) - (total_height / 2) + cursor_y
		
		love.graphics.setColor(unpack(button.color))
		--love.graphics.rectangle("fill", bx, by, button_width, BUTTON_HEIGHT)
		love.graphics.draw(sprite_btn, bx, by+5)
		love.graphics.setColor(0, 0, 0, 1)
		local textW = font:getWidth(button.text)
		local textH = font:getHeight(button.text)
		love.graphics.print(button.text, font, (ww * 0.5) - textW * 0.5, by + textH * 0.5)
		cursor_y = cursor_y + (BUTTON_HEIGHT + margin)
	end
end

function draw_menu()
	if menu == "credits" then
		draw_credits()
	elseif menu == "tuto" then
		draw_tuto()
	else
		draw_buttons()
	end
end

function debug_print(ps, txt)
	love.graphics.print(txt, 0, ps*20)
end

function draw_debug()
	love.graphics.setColor(255, 255, 255, 1.0)
	if menu == 'in_game' then
		--love.graphics.print(math.floor(b.x).."/"..math.floor(b.y), b.x+50, b.y) -- coordonnées bomb
		--love.graphics.print(b.catch_cooldown, b.x+50, b.y-20) -- coordonnées bomb
		--love.graphics.print(coll,16,16)
		debug_print(1, "player x:"..math.floor(p.x).." y:"..math.floor(p.y))
		debug_print(2, "player dx:"..math.floor(p.dx).." dy:"..math.floor(p.dy))
		debug_print(3, "screenw, h: "..screenw..";"..screenh)
		debug_print(4, "FPS: "..love.timer.getFPS())
		debug_print(5, "bomb x:"..math.floor(b.x).." y:"..math.floor(b.y))
		debug_print(6, "bomb timer:"..math.floor(b.timer * 1000)/1000)
		debug_print(7, "bomb cooldown:"..math.floor(b.max_catch_cooldown * 1000)/1000)
		debug_print(8, "bomb active:"..tostring(b.active))
		debug_print(9, "collision bomb/player: "..tostring(coll_check))
		debug_print(10, "dif_x : "..math.floor(p.angle))
		debug_print(13, "CameraY: "..tostring(CameraY))
		
		for i,v in ipairs(map) do
			for j,u in ipairs(v) do
				love.graphics.print(tostring(u), (j-1)* bl.w, (i-1)*bl.h-CameraY)
			end
		end
	end
	-- debug_print(0, "debug: is_on ; menu: "..menu)
end

function draw_debug_unfix()
	love.graphics.setColor(255, 255, 255, 1.0)
	if menu == 'in_game' then
		draw_collision(b.x,b.y,b.w,b.h)
		draw_collision(p.x,p.y,p.w,p.h)
		draw_collision(enemy.x,enemy.y,enemy.w,enemy.h)
	end
end

function start_game()
	CameraY = 0
	love.mouse.setVisible(false)
	player_create()
	bomb_create()
	block_create()
	enemy_create()
	in_game_timer = 0
	menu = 'in_game'
	CM.update(0)
end

function continue_game()
	love.mouse.setVisible(false)
	menu = 'in_game'
	CM.update(0)
end

function start_menu(m)
	love.mouse.setVisible(true)
	for i, _ in ipairs(buttons) do buttons[i] = nil end
	menu = m
	if menu =='menu'then
		table.insert(buttons, newButton("Start Game", start_game))
		table.insert(buttons, newButton("Help", function() start_menu("tuto") end))
		table.insert(buttons, newButton("Crédits", function() start_menu("credits") end))
		table.insert(buttons, newButton("Exit Game", function() love.event.quit(0) end))
	end
	if menu =='game_over' then
		table.insert(buttons, newButton("Restart", start_game))
		table.insert(buttons, newButton("Home", function() start_menu("menu") end))
		--table.insert(buttons, newButton("principal", start_game))
		table.insert(buttons, newButton("Rage quit", function() love.event.quit(0) end))
	end
	if menu =='pause' then
		table.insert(buttons, newButton("Continuer", continue_game))
		table.insert(buttons, newButton("Home", function() start_menu("menu") end))
		table.insert(buttons, newButton("Rage quit", function() love.event.quit(0) end))
	end
end
