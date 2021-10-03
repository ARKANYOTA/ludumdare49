-- vim: fdm=marker

-- Crédits {{{2
--[[
|-----------------------------------------------------------|
|            --- ---  ---  --  - ---                        |
|            -   ---  --   - - -  -                         |
|            --- - -- ---  --  -  -                         |
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
--]]

function load_credits()
	game_over_font_70 = love.graphics.newFont("fonts/game_over.ttf", 70)
	game_over_font_90 = love.graphics.newFont("fonts/game_over.ttf", 90)
	game_over_font_120 = love.graphics.newFont("fonts/game_over.ttf", 200)
	nb_categories = 4
	nb_contributors = 7
	contributors = {
		{"Developers and Thinkers", "Images", "Sound", "Thinkers"},
		{
			{
				{"ARKANYOTA", "Maxim-Costa", "Yolwoocle", "Notgoyome"},
				{"#ARKANYOTA","#Maxim-Costa","#Yolwoocle","#cringecrimson"}
			},
			{
				{"Poulpito_GDL"},
				{"#Poulpito_GD"}
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
end

function credit_print(hx, ps, txt, txt2)
	-- hx for h1-6 and is a int
	-- local nb_lignes = nb_categories + nb_contributors -- pour center
	love.graphics.print({{244, 0, 0, 1}, txt}, game_over_font_90,hx*50+10, ps*40+100)
	love.graphics.print({{244, 0, 0, 0.5}, txt2}, game_over_font_70,400, ps*40+110)

end

function draw_credits()
	love.graphics.print({{244, 0, 0, 1}, "Crédits"}, game_over_font_120,250, 0)
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
