require "scripts.util"
local Enemy = require "scripts.actor.enemy"
local images = require "data.images"
local images = require "data.images"
local Prop = require "scripts.actor.enemies.prop"
local Rect = require "scripts.math.rect"
local Segment = require "scripts.math.segment"
local Lightning = require "scripts.graphics.lightning"
local Timer = require "scripts.timer"

local utf8 = require "utf8"

local ElectricArc = Prop:inherit()

function ElectricArc:init(x, y, params)
    params = params or {} 
    ElectricArc.super.init(self, x, y, images.empty, 1, 1)
    self.name = "electric_arc"

    self.counts_as_enemy = false
    self.arc_damage = 1
    self.cooldown = 0.3
    
    self.score = 0

    self.is_pushable = false
    self.is_knockbackable = false
    self.is_affected_by_walls = false
    self.affected_by_bounds = false

    self.segment = Segment:new(x, y, x + 50, y - 70)
    self.collides = false
    self.arc_target = nil
    self.arc_target_player_n = nil
    self.hitbox_expand = 2

    self.lightning = Lightning:new(params.lightning_params)

    self.is_immune_to_electricity = true
    self.is_arc_active = param(params.is_active, true)
    -- self.particle_probability = 0.005
    self.particle_probability = 0.001

    self.is_front = param(params.is_front, false)

    self.active_arc_min_line_width = 1
    self.active_arc_max_line_width = 3
    self.inactive_arc_min_line_width = 0.1
    self.inactive_arc_max_line_width = 0.5

    self.activation_timer = Timer:new(params.activation_delay or 0)
    if params.activation_delay then
        self.activation_timer:start()
    end
    self.disable_timer = Timer:new()

    self.t = 0
end

function ElectricArc:set_arc_target(target)
    self.arc_target = target
    if target.is_player then
        self.arc_target_player_n = target.n
    end
end

function ElectricArc:set_arc_active(active)
    self.is_arc_active = active
end

function ElectricArc:get_segment()
    return self.segment
end

function ElectricArc:get_length()
    return self.segment:get_length()
end

function ElectricArc:get_direction()
    return self.segment:get_direction()
end

function ElectricArc:set_segment(ax_or_seg, ay, bx, by)
    if self.is_removed then
        return
    end

    local ax = ax_or_seg
    if type(ax_or_seg) ~= "number" then
        ax = ax_or_seg.ax
        ay = ax_or_seg.ay
        bx = ax_or_seg.bx
        by = ax_or_seg.by
    end

    self:set_position(ax, ay)
    self.segment:set_bounds(ax, ay, bx, by)
    self:update_lightning(0)
end

function ElectricArc:update(dt)
    ElectricArc.super.update(self, dt)

    -- Timers
    if self.activation_timer:update(dt) then
        self.is_arc_active = true
    end
    if self.disable_timer:update(dt) then
        self:kill()
    end

    self:update_target(dt)
    self:update_segment(dt)
    self:update_lightning(dt)

    for _, seg in pairs(self.lightning.segments) do
        if self.is_arc_active and random_range(0, 1) < self.particle_probability then
            Particles:spark(seg.segment.bx, seg.segment.by)
        end
    end

    if self.is_arc_active then
        self:check_for_collisions()
    end
end

function ElectricArc:update_segment(dt)
    self.segment.ax = self.x
    self.segment.ay = self.y
    if self.arc_target then
        self.segment.bx = self.arc_target.mid_x
        self.segment.by = self.arc_target.mid_y
    end
end

function ElectricArc:update_lightning(dt)
    self.lightning.min_line_width = ternary(self.is_arc_active, self.active_arc_min_line_width, self.inactive_arc_min_line_width)
    self.lightning.max_line_width = ternary(self.is_arc_active, self.active_arc_max_line_width, self.inactive_arc_max_line_width)

    self.lightning:generate(self.segment)
end

function ElectricArc:update_target(dt)
    if self.arc_target then
        if (self.arc_target.is_dead or self.arc_target.is_removed) then
            self.is_arc_active = false
            self.arc_target = nil
        end
    else
        if self.arc_target_player_n ~= nil then
            for _, player in pairs(game.players) do
                if (not player.is_dead and not player.is_removed) and player.n == self.arc_target_player_n then
                    self.is_arc_active = true
                    self.arc_target = player
                    break
                end
            end
        end
    end
end

--- Returns whether an actor is considered an enemy or not.
function ElectricArc:is_my_enemy(actor)
    if not actor.is_actor then
        return false
    end
    if self.arc_target then
        return self.arc_target.is_enemy ~= actor.is_enemy
    end
    return actor.is_player
end

function ElectricArc:check_for_collisions()
    self.collides = false
    for _, a in pairs(game.actors) do
        if a ~= self and a.is_active then
            local collision = a:get_rect(self.hitbox_expand):segment_intersection(self.segment)
            if collision and a.collision_filter and a.collision_filter(nil, self) then
                self:collide_with_actor(a)
            end
        end
    end
end

function ElectricArc:collide_with_actor(a)
    if a.on_hit_electrictiy then
        a:on_hit_electrictiy()
    end

    -- Sanity checks
    if a.is_immune_to_electricity then return end
    if not self:is_my_enemy(a) then return end
    if not a.do_damage then return end

    local success = a:do_damage(self.arc_damage, self)
    if success then
        self.collides = true
        a:set_invincibility(self.cooldown)
    end
end

function ElectricArc:start_disable_timer(duration, arc_activation)
    arc_activation = param(arc_activation, false)

    self.disable_timer:start(duration)
    self.is_arc_active = arc_activation
end

function ElectricArc:start_activation_timer(duration)
    self.activation_timer:start(duration)
end

function ElectricArc:draw_back()
    ElectricArc.super.draw_back(self)
end

function ElectricArc:draw()
    ElectricArc.super.draw(self)

    if self.lightning.style == LIGHTNING_STYLE_THORNS then
        self.lightning:draw(0, 0, {thorns_outline = COL_BLACK_BLUE})
    end

    self.lightning:draw()

    if game.debug.colview_mode then
        rect_color(COL_GREEN, "line", self.segment.ax - self.hitbox_expand, self.segment.ay - self.hitbox_expand, self.hitbox_expand*2, self.hitbox_expand*2)
        rect_color(COL_GREEN, "line", self.segment.bx - self.hitbox_expand, self.segment.by - self.hitbox_expand, self.hitbox_expand*2, self.hitbox_expand*2)
        
    end
end

return ElectricArc
