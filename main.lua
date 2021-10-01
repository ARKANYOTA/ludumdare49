#!/usr/bin/env -S love ./
-- Permet de l'executer avec ./main.lua
-- vim: fdm=marker

-- FUNCTIONS {{{1
function is_odd(n)
	return n%2==1
end

-- EVENTS{{{1
function love.load() -- LOAD {{{2
    x, y, w, h = 20, 20, 60, 20
end -- END LOAD }}}

function love.update(dt) -- UPDATE {{{2
    w = w + 1
    h = h + 1
end -- END UPDATE }}}

function love.keypressed(key, scancode, isrepeat) -- KEYPRESSED {{{2
   if key == "escape" then
      love.event.quit()
   end
   if key == "f5" then
		love.event.quit("restart")
	end
end -- END KEYPRESSED }}}

function love.draw() -- DRAWING {{{2
	love.graphics.print("Hello World!", 400, 300)
	love.graphics.print(tostring(is_odd(w)), 0, 0)
end -- END DRAWING

