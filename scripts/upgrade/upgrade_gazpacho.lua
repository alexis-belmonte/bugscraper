require "scripts.util"
local Upgrade = require "scripts.upgrade.upgrade"
local images= require "data.images"
local EffectSlowness = require "scripts.effect.effect_slowness"

local UpgradeGazpacho = Upgrade:inherit()

function UpgradeGazpacho:init()
    UpgradeGazpacho.super.init(self, "gazpacho")
    self.sprite = images.upgrade_tea
    self.number_of_hearts = 2
    self:set_description(self.number_of_hearts)

    self.color = COL_MID_GREEN
    self.palette = {COL_MID_GREEN, COL_MID_DARK_GREEN, COL_DARK_GREEN}

    self.activate_sound = "sfx_upgrades_tea_pickedup"
end

function UpgradeGazpacho:update(player, dt)
    UpgradeGazpacho.super:update(self, player, dt)
end

function UpgradeGazpacho:apply_instant(player)
    player.bloodthirst_enabled = true
end

function UpgradeGazpacho:play_effects(player)
    -- Particles:smoke(player.mid_x, player.mid_y, 8, COL_LIGHT_GREEN)
    Particles:smoke_big(player.mid_x, player.mid_y, COL_LIGHT_GREEN)
    Particles:image(player.mid_x, player.mid_y, self.number_of_hearts, images.particle_leaf, 5, 1.5, 0.6, 0.5)
end

function UpgradeGazpacho:on_finish(player)
end



return UpgradeGazpacho