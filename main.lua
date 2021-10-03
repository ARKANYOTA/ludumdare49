#!/usr/bin/env -S love ./
-- Permet de l'executer avec ./main.lua
-- vim: fdm=marker

--METTEZ OU IL FAUT LE METTRE SVP
require "scripts/entities"
require "scripts/menus"
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
    for i,v in ipairs(elt) do
		print(unpack(elt[i]))
    end
end

function draw_collision(x,y,w,h) -- {{{2
	love.graphics.rectangle("line",x,y,w,h) -- vertical left
end

function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

-- EVENTS{{{1
function love.load() -- LOAD {{{2
	-- UI
	menus = {'menu', 'gameover', 'pause', 'credits', 'tuto'}
	buttons = {}
	ww = love.graphics.getWidth()
	wh = love.graphics.getHeight()
	CMwh = 0
	CM.setCoords(ww/2, wh/2)
	button_width = ww * (1/3)
	margin = 16

	-- Proper font scaling 
    font = love.graphics.newFont(15, "none", 3)
    love.graphics.setFont(font)
	font = love.graphics.newFont(32)

	-- Menu {{{3
    sprite_btn = love.graphics.newImage("assets/button.png"),
	start_menu('menu') -- valeurs posibles menu,ingame, pause, gameover
	ingame_timer = 0
	global_timer = 0
	debug = true 
	BUTTON_HEIGHT = 64
	-- Credits
	load_credits()

	-- Particles
	particles = {}
	coll_check = false
	-- Map
	map = make_blank_map(30, 30)
	--set_map(map, 3, 3, 1)
	--map[2][2] = 1
	set_map(map, 2, 2, 1)
	-- Debug
end

function love.update(dt) -- UPDATE {{{2
	CM.update(dt)
	global_timer = global_timer + dt
	
	if has_value(menus,menu) then
		update_buttons()
	end
	
	if menu == 'ingame' then
		player_update()
		enemy_update()
		if love.keyboard.isScancodeDown("k") then
			CMwh = CMwh +1
		end 
	end

	for i,pt in ipairs(particles) do
		update_particle(pt, dt)
	end

end

function love.keypressed(key, scancode, isrepeat) -- KEYPRESSED {{{2
	-- always {{{3
	if (love.keyboard.isDown("lctrl") and key == "c") then
		love.event.quit()
	end
	if key == "f5" then love.event.quit("restart") end
	if key == "f3" then debug = not debug end
	if menu == "ingame" then -- ingame {{{3
		if key == "escape" then
			start_menu("pause")
		end
	elseif menu == "pause" then -- ingame {{{3
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
		if key=="o" then start_menu("gameover") end
		if key=="c" then start_menu("credits") end
		if key=="p" then draw_credits() end
	end
end

function love.draw() -- DRAWING {{{2
	CM.attach() -- CE QUI EST RELATIF A LA CAMERA
	love.graphics.setColor(255, 255, 255, 1.0)
	if menu == 'ingame' then -- {{{3
		--love.graphics.rectangle("fill",600, 100,100,20,40,1)
		draw_player()
		draw_bomb()
		draw_enemy()
		block_draw()
		player_cursor()

		for i,pt in ipairs(particles) do
			draw_particle(pt)
		end
		block_draw()
		
		-- vv KEEP AS THE LAST vv
		draw_cursor()
	end
	if debug then -- {{{3
		draw_debug_unfix()
	end
	CM.detach() -- CE QUI FIX DANS L4ECRAN
	if debug then -- {{{3
		--CM.debug()
		draw_debug()			
	end
	if has_value(menus,menu) then -- menu {{{3
		draw_menu()
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
	else
		draw_buttons()
	end
end

function debug_print(ps, txt)
	love.graphics.print(txt, 0, ps*20)
end

function draw_debug()
	love.graphics.setColor(255, 255, 255, 1.0)
	if menu == 'ingame' then
		--love.graphics.print(math.floor(b.x).."/"..math.floor(b.y), b.x+50, b.y) -- coordonnées bomb
		--love.graphics.print(b.catchcooldown, b.x+50, b.y-20) -- coordonnées bomb
		--love.graphics.print(coll,16,16)
		debug_print(1, "player x:"..math.floor(p.x).." y:"..math.floor(p.y))
		debug_print(2, "player dx:"..math.floor(p.dx).." dy:"..math.floor(p.dy))
		debug_print(3, "solidx: "..tostring(p.solidx).." solidy:"..tostring(p.solidy).." block: "..tostring(p.block))
		debug_print(4, "FPS: "..love.timer.getFPS())
		debug_print(5, "bomb x:"..math.floor(b.x).." y:"..math.floor(b.y))
		debug_print(6, "bomb timer:"..math.floor(b.timer * 1000)/1000)
		debug_print(7, "bomb cooldown:"..math.floor(b.max_catchcooldown * 1000)/1000)
		debug_print(8, "bomb active:"..tostring(b.active))
		debug_print(9, "collision bomb/player: "..tostring(coll_check))
		debug_print(10, "dif_x : "..math.floor(p.angle))
		debug_print(13, "CMwh: "..tostring(CMwh))
		
		for i,v in ipairs(map) do
			for j,u in ipairs(v) do
				love.graphics.print(tostring(u), (j-1)* bl.w, (i-1)*bl.h-CMwh) -- 
			end
		end
	end
	-- debug_print(0, "debug: is_on ; menu: "..menu)
end

function draw_debug_unfix()
	love.graphics.setColor(255, 255, 255, 1.0)
	if menu == 'ingame' then
		draw_collision(b.x,b.y,b.w,b.h)
		draw_collision(p.x,p.y,p.w,p.h)
	end
end

function start_game()
	CMwh = 0
	love.mouse.setVisible(false)
	player_create()
	bomb_create()
	block_create()
	enemy_create()
	ingame_timer = 0
	menu = 'ingame'
	CM.update(0)
end

function continue_game()
	love.mouse.setVisible(false)
	menu = 'ingame'
	CM.update(0)
end

function start_menu(m)
	love.mouse.setVisible(true)
	for i, v in ipairs(buttons) do buttons[i] = nil end
	menu = m
	if menu =='menu'then
		table.insert(buttons, newButton("Start Game", start_game))
		table.insert(buttons, newButton("Tuto", function() start_menu("tuto") end))
		table.insert(buttons, newButton("Crédits", function() start_menu("credits") end))
		table.insert(buttons, newButton("Exit Game", function() love.event.quit(0) end))
	end
	if menu =='gameover' then
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
