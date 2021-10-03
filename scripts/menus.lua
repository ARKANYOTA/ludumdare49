-- vim: fdm=marker

-- Crédits {{{2
--[[
|-----------------------------------------------------------|
|            ███ ███  ███  ██  █ ███                        |
|            █   ███  ██   █ █ █  █                         |
|            ███ █ ██ ███  ██  █  █                         |
|  Developers:                                              |
|    - ARKANYOTA    @ARKANYOTA                              |
|    - Yolwoocle    @Yolwoocle                              |
|    -                                                      |
|                                                           |
|                                                           |
|                                                           |
|                                                           |
|                                                           |
|-----------------------------------------------------------|
|-----------------------------------------------------------|
|               ███ █ █ ███ ███                             |
|                █  █ █  █  █ █                             |
|                █  ███  █  ███                             |
| - wasd and arrow       move player                        |
| - escape               pause or exit pause                |
|                                                           |
|                                                           |
|                                                           |
|                                                           |
|                                                           |
|                                                           |
|                                                           |
|-----------------------------------------------------------|
--]]

function load_credits()
	game_over_font_70 = love.graphics.newFont("fonts/game_over.ttf", 70)
	game_over_font_90 = love.graphics.newFont("fonts/game_over.ttf", 90)
	game_over_font_120 = love.graphics.newFont("fonts/game_over.ttf", 200)
	nb_categories = 4
	nb_contributors = 7
	contributors = {
		{"Code and Design", "Art", "Sound", "Special thanks"},
		{
			{
				{"Arkanyota", "Maxim-Costa", "Yolwoocle", "Notgoyome"},
				{"#Arkanyota","#Maxim-Costa","#Yolwoocle","#Yauyau123"}
			},
			{
				{"Poulpito_GDL", "Yolwoocle"},
				{"#Poulpito_GD", "#Yolwoocle"}
			},
			{
				{"Pierre"},
				{"#..."}
			},
			{
				{"Antoine"},
				{"#..."}
			}
		}
	}
	controls = {
		move_player = "wasd_en and zqsd_fr or arrow",
		pause = "escape",
		shoot = "mouse left click",
		aim = "mouse",
	}
end

function credit_print(hx, ps, txt, txt2)
	-- hx for h1-6 and is a int
	-- local nb_lignes = nb_categories + nb_contributors -- pour center
	love.graphics.print({{244, 0, 0, 1}, txt}, game_over_font_90,hx*50+10, ps*40+100)
	love.graphics.print({{244, 0, 0, 0.5}, txt2}, game_over_font_70,400, ps*40+110)
end

function draw_credits()
	love.graphics.print({{244, 0, 0, 1}, "Credits"}, game_over_font_120,250, 0)
	local ligne = 0
	for i, u in pairs(contributors[1]) do
		credit_print(1, ligne, u, "")
		ligne = ligne + 1
		user = contributors[2][i][1]
		soci = contributors[2][i][2]
		for k, w in pairs(user) do
			credit_print(2, ligne, w, soci[k])
			ligne = ligne + 1
		end
	end
end
function draw_tuto()
	love.graphics.print({{244, 0, 0, 1}, "Tuto"}, game_over_font_120,250, 0)
	local ligne = 0
	for i, u in pairs(controls) do
		love.graphics.print({{244, 0, 0, 1}, i}, game_over_font_90,100, 30*ligne+100)
		love.graphics.print({{244, 0, 0, 0.5}, u}, game_over_font_70,350, 30*ligne+120)
		ligne = ligne + 1
	end
end


function start_menu(m)
	love.mouse.setVisible(true)
	for i, _ in ipairs(buttons) do buttons[i] = nil end
	menu = m
	if menu =='menu'then
		table.insert(buttons, newButton("Start Game", start_game))
		table.insert(buttons, newButton("Help", function() start_menu("tuto") end))
		table.insert(buttons, newButton("Crédits", function() start_menu("credits") end))
		table.insert(buttons, newButton("Ragequit", function() love.event.quit(0) end))
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
		table.insert(buttons, newButton("Ragequit", function() love.event.quit(0) end))
	end
end

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
	if menu == "game_over" then
		love.graphics.print({{244, 0, 0, 1}, "Game Over!"}, game_over_font_120,200, 0)
		love.graphics.print({{244, 0, 0, 0.7}, "score : "..p.score}, game_over_font_90,200, 100)
		love.graphics.print({{244, 0, 0, 0.7}, "highscore : "..p.max_score}, game_over_font_90,200, 130)
	end
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