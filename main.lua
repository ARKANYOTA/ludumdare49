#!/usr/bin/env -S love ./
-- Permet de l'exécuter avec ./main.lua
-- vim: fdm=marker

--METTEZ OU IL FAUT LE METTRE SVP
require "scripts/menus"
require "scripts/player"
require "scripts/enemy"
require "scripts/block"
require "scripts/constants"
--CM = require "lib.CameraMgr".newManager()

-- EVENTS{{{1
function love.load() -- LOAD {{{2
	-- UI
	menus = {'menu', 'game_over', 'pause', 'credits', 'tuto'}
	buttons = {}
	ww = love.graphics.getWidth()
	wh = love.graphics.getHeight()
	CameraY = 0
	--CM.setCoords(ww/2, wh/2)
	button_width = ww * (1/3)
	margin = 16
	flashalpha = 0
	flashalpha_speed = 2
	
	-- Window
	love.window.setTitle("Ludum Dare 49") --TODO: PLEASE CHANGE

	-- Proper font scaling
	font = love.graphics.newFont(15, "none", 3)
	love.graphics.setFont(font)
	font = love.graphics.newFont(32)
	font = game_font_small_light

	-- Menu {{{3
	sprite_btn = love.graphics.newImage("assets/button.png"),
	start_menu('menu') -- valeurs possibles menu,in_game, pause, game_over

	in_game_timer = 0
	global_timer = 0
	load_credits()

	-- Particles
	particles = {}
	coll_check = false

	gas_puffs = {}
	for i=0, screenw ,30 do
		table.insert(gas_puffs, {
			x = i, 
			y = 0, 
			s = (love.math.random() + 1) * 0.2, 
			r = love.math.random() * 2*math.pi, 
			dr= (love.math.random() - 0.5) * 0.2
	})
	end
	
	-- Debug
	enemy_wont_move = true

	-- Smoke
	smoke_dt = 1
end

function love.update(dt) -- UPDATE {{{2
	--CM.update(dt)
	global_timer = global_timer + dt
	
	if menu == 'in_game' then
		smoke_dt = smoke_dt - dt
		down_screen_dt = down_screen_dt + 0.3
		in_game_timer = in_game_timer + dt
		player_update()
		enemy_update(dt)

		-- Evit bomb quit map
		if b.y < 0-blockh-1 or b.x < 0-blockw-1 or b.x > 800+blockw+1 then
			p.hasBomb = true
		end
		while down_screen_dt >= 0 do
			down_screen_dt = down_screen_dt - 0.3
			CameraY = CameraY + 1
			CameraYAdd = CameraYAdd + 1
			p.y = p.y - 1
			b.y = b.y - 1
			for i,enemy in ipairs(total_enemy) do --vacciné
				enemy.y = enemy.y - 1
			end
		end
		while CameraYAdd > blockh+10 do
			CameraYAdd = CameraYAdd - blockh
			-- Creer un element dans map
			-- Supprimer le premier element de la map
			table.remove(map, 1)
			table.insert(map, {})
			for _ = 1, nb_block_x do
				rd = love.math.random(9)
				if rd == 1 then
					table.insert(map[#map], 1)
				elseif rd == 2 or rd == 3 or rd == 4 then
					table.insert(map[#map], 2)
				elseif rd == 5 or rd == 6 or rd == 7 then
					table.insert(map[#map], 3)
				else
					table.insert(map[#map], 0)
				end
			end
			DeletedMapBlock = DeletedMapBlock + 1
			-- Spawn enemies
			if love.math.random(10)==1 then
				spawn_enemy(love.math.random(800),1000)
			end
		end

		-- Music
		if b.active then
			music_calm:setVolume(0)
			music_tense:setVolume(0.2)
		else
			music_calm:setVolume(0.2)
			music_tense:setVolume(0)
		end

		-- Gas puffs
		for i,v in ipairs(gas_puffs) do
			v.r = v.r + v.dr
		end
	else
		music_calm:setVolume(0)
		music_tense:setVolume(0)
	end

	for i, pt in ipairs(particles) do
		update_particle(pt, dt)
		if pt.mustdestroy then
			table.remove(particles, i)
		end
	end
end

function love.mousepressed( x, y, button, istouch, presses ) 
	if has_value(menus,menu) then
		update_buttons(button, x, y)
	end
end

function love.mousemoved(x, y, dx, dy, istouch)
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
end

function love.draw() -- DRAWING {{{2
	--CM.attach() -- CE QUI EST RELATIF A LA CAMERA
	love.graphics.setColor(255, 255, 255, 1.0)
	if menu == 'in_game' then -- {{{3
		--love.graphics.rectangle("fill",600, 100,100,20,40,1)
		block_draw()
		draw_player()
		draw_bomb()
		for _,enemy in ipairs(total_enemy) do  --vacciné
			draw_enemy(enemy)
		end
		player_cursor()

		for _,pt in ipairs(particles) do
			draw_particle(pt)
		end
		
		

		-- Draw toxic gas
		if smoke_dt < 0 or true then
			smoke_dt = 1
			for i,v in ipairs(gas_puffs) do
				love.graphics.draw(toxic_gas, v.x, v.y, v.r, v.s, v.s, 
				toxic_gas:getWidth()*v.s, toxic_gas:getHeight()*v.s)
				--spawn_smoke(i, 10, "green")
			end
		end
		--all_hit
		for i,hit in ipairs(all_hit) do
			love.graphics.print(hit.txt, hit.x, hit.y)
			hit.dt = hit.dt - 0.16
			if hit.dt < 0 then
				table.remove(all_hit, i)
			end
		end
		--zombie life bar
		for i,enemy in ipairs(total_enemy) do --vacciné
			love.graphics.setColor(0,0,0,1)
			love.graphics.setLineWidth(5)
			love.graphics.line(enemy.x,enemy.y-10, enemy.x+80, enemy.y-10)
			love.graphics.setColor(1,0,0,1)
			love.graphics.setLineWidth(2)
			love.graphics.line(enemy.x+2,enemy.y-10, enemy.x+(26*enemy.hp), enemy.y-10)
			love.graphics.setColor(1,1,1,1)
		end
		-- life bar
		draw_gui()

		-- vv KEEP AS THE LAST vv
		draw_cursor()
	end
	if debug then -- {{{3
		draw_debug_unfix()
	end
	--CM.detach() -- CE QUI EST FIX DANS L ÉCRAN
	if debug then -- {{{3
		draw_debug()			
	end
	if has_value(menus,menu) then -- menu {{{3
		draw_menu()
	end
end	

function draw_gui()
	for i=1, p.max_life do
		local w = img_heart:getWidth()*0.2 + 10
		if i <= p.life then
			love.graphics.draw(img_heart,       screenw-i*w, 20, 0, 0.2)
		else
			love.graphics.draw(img_heart_empty, screenw-i*w, 20, 0, 0.2)
		end
	end

	love.graphics.setFont(game_font_medium)
	love.graphics.print(p.score, screenw + 50, 20)
	love.graphics.setFont(game_font_medium)
	-- afficher lescore
	love.graphics.print("Score : "..p.score, 10,0)
end

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

function start_game()
	color = 1
	total_enemy = {}

	-- flou a la fin
	alcohol_level = 0

	--hit
	all_hit = {
		--x: b.x + random
		--y: b.y + random
		--dt: 3
	}

	--map
	down_screen_dt = 0.3

	spawn_enemy(100,100)
	spawn_enemy(200,100)
	--spawn_enemy(100,1000)
	CameraY = 0
	DeletedMapBlock = 0
	CameraYAdd = 0
	love.mouse.setVisible(false)
	player_create()
	bomb_create()
	block_create()
	in_game_timer = 0
	map = make_blank_map(nb_block_y, nb_block_x)
	set_map(map, 1, 0, 1)
	set_map(map, 1, 1, 1)
	set_map(map, 1, 4, 1)
	menu = 'in_game'
	--CM.update(0)
	dead_way = nil
	
	-- Music
	music_calm:play()
	music_tense:play()
end

function continue_game()
	love.mouse.setVisible(false)
	menu = 'in_game'
	--CM.update(0)
end

-- USELESS FUNCTIONS {{{2
function debug_print(ps, txt)
	love.graphics.print(txt, default_font,10, ps*20+100)
end

function draw_debug()
	love.graphics.setColor(255, 255, 255, 1.0)
	if menu == 'in_game' then
		--love.graphics.print(math.floor(b.x).."/"..math.floor(b.y), b.x+50, b.y) -- coordonnées bomb
		--love.graphics.print(b.catch_cooldown, b.x+50, b.y-20) -- coordonnées bomb
		--love.graphics.print(coll,16,16)
		love.graphics.setColor(0, 0, 0, 1.0)
		debug_print(1, "player x:"..math.floor(p.x).." y:"..math.floor(p.y))
		debug_print(2, "player dx:"..math.floor(p.dx).." dy:"..math.floor(p.dy))
		debug_print(3, "player lx:"..(math.floor((p.x+p.w)/bl.w)+1).." ly:"..math.floor((p.y+p.h+CameraY)/bl.h)+1)
		debug_print(4, "FPS: "..love.timer.getFPS())
		debug_print(5, "bomb x:"..math.floor(b.x).." y:"..math.floor(b.y))
		debug_print(6, "bomb timer:"..math.floor(b.timer * 1000)/1000)
		debug_print(7, "bomb active:"..tostring(b.active))
		debug_print(8, "has bomb: "..tostring(p.hasBomb))
		debug_print(9, "CameraY: "..tostring(CameraY))
		debug_print(10, "CameraYAdd: "..tostring(CameraYAdd))
		debug_print(11, "DeletedMapBlock: "..tostring(DeletedMapBlock))
		debug_print(12, "Vie: "..tostring(p.life))
		debug_print(13, "p.iframe: "..tostring(p.iframes))


		love.graphics.setColor(255, 255, 255, 1.0)
		for i,v in ipairs(map) do
			--lllig= ""
		  	for j,u in ipairs(v) do
				love.graphics.print(tostring(u),default_font,(j-1)* blockw, (i-1)*blockw-CameraYAdd)
				--lllig = lllig..tostring(u)
			end
			--print(lllig)
		end
		--print("-----")

		love.graphics.setColor(1,0,0)
		love.graphics.line(screenw2, screenh2, screenw2 + 64, screenh2)
		love.graphics.setColor(0,1,0)
		love.graphics.line(screenw2, screenh2, screenw2, screenh2 + 64)
		love.graphics.setColor(0,0,0)
	end
	-- debug_print(0, "debug: is_on ; menu: "..menu)
end

function draw_debug_unfix()
	love.graphics.setColor(255, 255, 255, 1.0)
	if menu == 'in_game' then
		draw_collision(b.x,b.y,b.w,b.h)
		draw_collision(p.x,p.y,p.w,p.h)
		for i,enemy in ipairs(total_enemy) do --vacciné
			if enemy.hp > 0 then
				draw_collision(enemy.x,enemy.y,enemy.w,enemy.h)
			end
		end
	end
end

