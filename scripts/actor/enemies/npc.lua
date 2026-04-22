require "scripts.util"
local Enemy = require "scripts.actor.enemy"
local images = require "data.images"
local StaticProp = require "scripts.actor.enemies.static_prop"
local AnimatedSprite = require "scripts.graphics.animated_sprite"

local utf8 = require "utf8"

local NPC = StaticProp:inherit()

function NPC:init(x, y, params)
    params = params or {}
    NPC.super.init(self, x, y, images.empty)
    self.name = "npc"
    self.npc_name = params.npc_name or ""
    
    self.gravity = self.default_gravity

    self.spr = AnimatedSprite:new(params.animations or {
        normal = params.animation or {images.npc_brown, 0.2, 4},
    }, "normal")

    self.dialogue_key = params.dialogue_key or ""
    self.dialogue = (params.dialogue or Text:text(self.dialogue_key)) or ""

    self.is_interactible = false
    self.interact_actions = {"up"}
    self.interaction_margin = 32
    self.interaction_delay = 4.0

    self.extra_update = param(params.extra_update, nil)
    self.extra_draw = param(params.extra_draw, nil)
    
    self.flip_mode = ENEMY_FLIP_MODE_MANUAL
    self.spr:set_flip_x(param(params.flip_x, false))
end

function NPC:update(dt)
    NPC.super.update(self, dt)

    if self.extra_update then
        self.extra_update(self, dt)
    end
end

function NPC:on_interact(player)
	Particles:word(self.mid_x, self.y - 32, self.dialogue, COL_WHITE, self.interaction_delay-1.0, nil, nil, 0.02)
end

function NPC:draw()
	NPC.super.draw(self)

    if self.extra_draw then
        self.extra_draw(self)
    end
end

function NPC:on_collision(col, other)
end

return NPC