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

require "scripts/font"

function hexcol(hex)
    local r = bit.rshift(hex, 16)
    local g = bit.rshift(hex, 8) % 256
    local b =            hex     % 256 
    return {r/255, g/255, b/255}
end

col_beige = hexcol(0xeec39a)
col_dbeige = hexcol(0xd9a066)
col_lbrown = hexcol(0x8f563b)
col_brown = hexcol(0x663931)
col_dark_purple = hexcol(0x45283c)
col_dblue = hexcol(0x222034)

function load_credits()
	--[[
	game_over_font_small = love.graphics.newFont("fonts/game_over.ttf", 70)
	game_over_font_medium = love.graphics.newFont("fonts/game_over.ttf", 90)
	game_over_font_big = love.graphics.newFont("fonts/game_over.ttf", 200)
]]

	nb_categories = 4
	nb_contributors = 7
	contributors = {
		{"Code and Design", "Art", "Sound", "Special thanks"},
		{
			{
				{"Arkanyota", "Maxim-Costa", "Yolwoocle", "Notgoyome"},
				{"@Arkanyota","@Maxim-Costa","@Yolwoocle","@Yauyau123"}
			},
			{
				{"Poulpito_GDL", "Yolwoocle"},
				{"@PoulpitoGDL", "@Yolwoocle"}
			},
			{
				{"Pierre"},
				{"@PIerreAndries"}
			},
			{
				{"Antoine"},
				{"@Antoine-Roucau"}
			}
		}
	}
	controls = {
		Move = "WASD or arrow keys",
		Pause = "escape",
		Shoot = "mouse left click",
		Aim = "mouse",
	}
end

function credit_print(hx, ps, txt, txt2)
	-- hx for h1-6 and is a int
	-- local nb_lignes = nb_categories + nb_contributors -- pour center
	love.graphics.print({hexcol(0x663931), txt}, game_font_medium,hx*50+10, ps*40+100) --brown
	love.graphics.print({hexcol(0x8f563b), txt2}, game_font_medium_light,400, ps*40+100) --lbrown
end

function draw_credits()
	love.graphics.setBackgroundColor(hexcol(0xeec39a)) -- beige
	love.graphics.print({hexcol(0x45283c), "Credits"}, game_font_big,250, 0) -- dark purple
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
	love.graphics.setBackgroundColor(hexcol(0xeec39a)) -- beige
	love.graphics.print({col_dark_purple, "How to play"}, game_font_big,230, 20)
	local ligne = 0
	for i, u in pairs(controls) do
		love.graphics.print({col_brown, i}, game_font_medium,100, 40*ligne+350)
		love.graphics.print({col_lbrown, u}, game_font_small,350, 40*ligne+365)
		ligne = ligne + 1
	end
	local text = {
		"An accident has occured in the mine and gas is escaping! Flee!",
		"Your bomb is your weapon. Throw it on enemies, and catch it ",
		"before it explodes. The longer you let it fly, the more damage",
		"it'll cause, but this is at your own risk.",
	}
	for i,v in ipairs(text) do
		love.graphics.print({col_brown, v}, 50, 40*i+85)
	end
end


function start_menu(m)
	love.graphics.setBackgroundColor(hexcol(0xeec39a)) --beige
	love.mouse.setVisible(true) 
	for i, _ in ipairs(buttons) do buttons[i] = nil end
	menu = m
	if menu =='menu'then
		love.graphics.setBackgroundColor(hexcol(0xeec39a)) --beige
		table.insert(buttons, newButton("Start Game", start_game))
		table.insert(buttons, newButton("Help", function() start_menu("tuto") end))
		table.insert(buttons, newButton("Credits", function() start_menu("credits") end))
		table.insert(buttons, newButton("Ragequit", function() love.event.quit(0) end))
	end
	if menu =='game_over' then
		love.graphics.setBackgroundColor(col_dbeige) --lbrown
		table.insert(buttons, newButton("Restart", start_game))
		table.insert(buttons, newButton("Home", function() start_menu("menu") end))
		--table.insert(buttons, newButton("principal", start_game))
		table.insert(buttons, newButton("Ragequit", function() love.event.quit(0) end))
	end
	if menu =='pause' then
		love.graphics.setBackgroundColor(col_dbeige) --lbrown
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
		love.graphics.print({col_dark_purple, "Game Over!"}, game_font_big, 230, 0)
		love.graphics.print({col_brown, "Score : "..p.score}, game_font_medium,200, 90)
		love.graphics.print({col_brown, "Highscore : "..p.max_score}, game_font_medium,200, 130)
	end
	local total_height = (BUTTON_HEIGHT + margin) * #buttons
	local cursor_y = 0

	for _, button in ipairs(buttons) do
		button.last = button.now
		local bx = (ww / 2) - (button_width / 2)
		local by = (wh / 2) - (total_height / 2) + cursor_y
		
		love.graphics.setFont(game_font_small)
		love.graphics.setColor(unpack(button.color))
		--love.graphics.rectangle("fill", bx, by, button_width, BUTTON_HEIGHT)
		love.graphics.draw(sprite_btn, bx, by+5)
		love.graphics.setColor(1, 1, 1, 1)
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

		if menu == "game_over" then --TODO
			love.graphics.print(dead_way, 200, 70)
		elseif menu == "menu" then
			love.graphics.draw(logo, 0, 0)
		end
		draw_buttons()
	end
end
