function play_random_pitch(snd, delta)
    delta = delta or 0.5
    snd:setPitch(1 + (love.math.random()-0.5)*delta)
    snd:play()
end

snd_throw = love.audio.newSource("assets/sound/throw.mp3", "static") -- https://freesound.org/people/lesaucisson/sounds/585257/
snd_bombbounce = love.audio.newSource("assets/sound/bomb_bounce.mp3", "static") --https://freesound.org/people/taylorevanmcalister/sounds/223530/
-- metal_bar : https://freesound.org/people/jorickhoofd/sounds/160045/
snd_bombbeep = love.audio.newSource("assets/sound/bomb_beep.mp3", "static") --https://freesound.org/people/SpliceSound/sounds/369880/
snd_bombboom = love.audio.newSource("assets/sound/explosion_LOUD.mp3", "static") --https://freesound.org/people/Iwiploppenisse/sounds/156031/
snd_bombboom:setVolume(0.15)
snd_enemydamage = love.audio.newSource("assets/sound/enemy_damage.wav", "static") --https://freesound.org/people/Deathscyp/sounds/404109/
snd_enemydamage:setVolume(0.5)
snd_playerdamage = love.audio.newSource("assets/sound/player_hurt.mp3", "static") --https://freesound.org/people/nettoi/sounds/553285/

music_calm = love.audio.newSource("assets/sound/music_calm.wav", "stream")
music_tense = love.audio.newSource("assets/sound/music_tense.wav", "stream")
music_calm:setVolume(0.2)
music_calm:setLooping(true)
music_tense:setVolume(0.2)
music_tense:setLooping(true)
