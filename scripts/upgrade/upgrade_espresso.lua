require "scripts.util"
local Upgrade = require "scripts.upgrade.upgrade"
local images= require "data.images"

local UpgradeShootFasterLimitedTime = Upgrade:inherit()

function UpgradeShootFasterLimitedTime:init()
    UpgradeShootFasterLimitedTime.super.init(self, "espresso")
    self.sprite = images.upgrade_espresso
    self.strength = 2.0
    self.duration = 20 -- Lasts for X floors 
    self:set_description(self.strength, self.duration)

    self.color = COL_MID_BROWN
    self.palette = {COL_MID_BROWN, COL_LIGHT_BROWN, COL_DARK_BROWN}

    self.activate_sound = "sfx_upgrades_espresso_pickedup"
end

function UpgradeShootFasterLimitedTime:update(player, dt)
    UpgradeShootFasterLimitedTime.super:update(self, player, dt)

    if game.level.fury_active then
        player.spr:update_offset(random_neighbor(1), random_neighbor(1))
        Particles:push_layer(PARTICLE_LAYER_BACK)
        Particles:smoke(player.mid_x, player.mid_y, 1, random_sample{COL_MID_BROWN, COL_DARK_BROWN})
        Particles:pop_layer()
    end
end

function UpgradeShootFasterLimitedTime:apply_permanent(player)
    table.insert(player.fury_gun_cooldown_multiplier_extra, 1/self.strength)
end

function UpgradeShootFasterLimitedTime:on_finish(player)
end

return UpgradeShootFasterLimitedTime