require "scripts.util"
local Class = require "scripts.meta.class"
local images= require "data.images"

local Upgrade = Class:inherit()

function Upgrade:init(name)
    self.name = name or "upgrade"
    self.type = UPGRADE_TYPE_INSTANT

    self.sprite = images.upgrade_coffee

    self.title       = Text:text("upgrade."..tostring(self.name)..".title")
    self.description = Text:text("upgrade."..tostring(self.name)..".description")
    self.color = COL_WHITE
    self.palette = {COL_LIGHTEST_GRAY, COL_LIGHT_GRAY}

    self.activate_sound = "empty"
end

function Upgrade:update(player, dt)
end

function Upgrade:apply(player, is_revive)
    self:apply_permanent(player, is_revive)
    if not is_revive then
        self:apply_instant(player)
        self:play_effects(player)
    end
end

------------------------------------------

--- [ABSTRACT] Effects that are supposed to be permanent, like more max health or more max ammo
function Upgrade:apply_permanent(player, is_revive)
end

--- [ABSTRACT] Effects that are supposed to be momentary, like giving a time-limited effect or extra hearts
function Upgrade:apply_instant(player)
end

--- [ABSTRACT]
function Upgrade:play_effects(player)
end

--- [ABSTRACT]
function Upgrade:on_finish(player)
end

------------------------------------------

function Upgrade:finish(player)
    self:on_finish(player)
end

function Upgrade:draw(x, y, s)
    self:draw_upgrade(x, y, s)
end
function Upgrade:draw_upgrade(x, y, s)
    draw_centered(self.sprite, x, y, 0, s, s)
end

function Upgrade:get_title()
    return self.title
end

function Upgrade:get_description()
    return self.description
end

function Upgrade:set_description(...)
    self.description = Text:text("upgrade."..tostring(self.name)..".description", ...)
end

return Upgrade