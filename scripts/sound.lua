function play_random_pitch(snd)
    snd:setPitch(love.math.random() + 1)
    snd:play()
end

snd_throw = love.audio.newSource("assets/sound/throw.mp3", "static") -- https://freesound.org/people/lesaucisson/sounds/585257/
snd_bombbounce = love.audio.newSource("assets/sound/bomb_bounce.mp3", "static") --https://freesound.org/people/taylorevanmcalister/sounds/223530/
-- metal_bar : https://freesound.org/people/jorickhoofd/sounds/160045/
snd_bombbeep = love.audio.newSource("assets/sound/bomb_beep.mp3", "static") --https://freesound.org/people/SpliceSound/sounds/369880/
