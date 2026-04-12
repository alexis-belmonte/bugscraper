require "scripts.util"
local Upgrade = require "scripts.upgrade.upgrade"
local images= require "data.images"
local EffectSlowness = require "scripts.effect.effect_slowness"

local UpgradeGazpacho = Upgrade:inherit()

function UpgradeGazpacho:init()
    UpgradeGazpacho.super.init(self, "gazpacho")
    self.sprite = images.upgrade_gazpacho

    self.color = COL_DARK_BRICK
    self.palette = {COL_DARK_BRICK, COL_LIGHT_BRICK, COL_MID_DARK_GREEN}

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
    Particles:smoke_big(player.mid_x, player.mid_y, {COL_LIGHT_BRICK, COL_DARK_BRICK, COL_MID_DARK_GREEN})
end

function UpgradeGazpacho:on_finish(player)
end



return UpgradeGazpacho