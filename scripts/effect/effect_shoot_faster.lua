-- !! DEPRECATED !!

require "scripts.util"
local Effect = require "scripts.effect.effect"
local images = require "data.images"

local EffectShootFaster = Effect:inherit()

function EffectShootFaster:init(strength)
    self:init_effect()
    self.name = "effect_coffee"
    self.strength = strength or 2.0
end

function EffectShootFaster:on_apply(player, duration)
    player:multiply_gun_cooldown_multiplier(1/self.strength)
end

function EffectShootFaster:update(dt, player)
    self:update_effect(dt)
    
    -- number, col, spw_rad, size, sizevar, layer
    player.spr:update_offset(random_neighbor(1), random_neighbor(1))
    Particles:push_layer(PARTICLE_LAYER_BACK)
    Particles:smoke(player.mid_x, player.mid_y, 1, random_sample{COL_MID_BROWN, COL_DARK_BROWN})
    Particles:pop_layer()
end

function EffectShootFaster:on_finish(player)
    player.spr:update_offset(0, 0)
    player:multiply_gun_cooldown_multiplier(self.strength)
end

return EffectShootFaster