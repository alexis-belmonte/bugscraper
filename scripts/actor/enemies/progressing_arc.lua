require "scripts.util"
local Enemy = require "scripts.actor.enemy"
local Fly = require "scripts.actor.enemies.fly"
local Prop = require "scripts.actor.enemies.prop"
local ElectricArc = require "scripts.actor.enemies.electric_arc"
local Timer = require "scripts.timer"
local sounds = require "data.sounds"
local images = require "data.images"

local ProgressingArc = Prop:inherit()

function ProgressingArc:init(x, y, params)
    params = params or {}

    ProgressingArc.super.init(self, x,y, images.empty, 1, 1)
    self.name = "progressing_arc"
    
    self.max_life = 100
    self.life = self.max_life

    self.score = 0
    
    self.counts_as_enemy = false
    self.is_immune_to_electricity = true

    self.length = 0.0
    if type(params.points) == "function" then
        self.points = params.points()
    elseif type(params.points) == "table" then
        self.points = params.points
    end
    self.points = self.points or {}
    self.rays = {}
    self.ray_info = {}

    self.progress_speed = params.progress_speed or 40.0
    self.interval_size = params.interval_size or 40.0

    self.cur_length = 0
    self.cur_max_length = 0.0
    self.cur_ray_index = 1
    self.cur_ray = nil
    self.cur_ray_direction = nil
    
    self.is_front = param(params.is_front, false)
    
    self.arc_params = params.arc_params
    self.arc_params.is_front = param(params.arc_params, self.is_front)
    
    self.rays_spawned = false

    self.outline_color = nil

    self.arc_enabled = false
    self.arc_enabled_timer = 3.0

    self.z = 10
end

function ProgressingArc:ready()
    self:spawn_rays()
end

function ProgressingArc:spawn_rays()
    self.length = 0.0

    for i = 1, #self.points-1 do 
        local ax, ay = self.points[i][1], self.points[i][2]
        local bx, by = self.points[i+1][1], self.points[i+1][2]
        
        local arc = ElectricArc:new(ax, ay, self.arc_params)
        arc:set_segment(ax, ay, bx, by)
        arc:set_active(false)

        self.length = self.length + arc:get_length()

        local dx, dy = arc:get_direction()
        self.ray_info[i] = {
            x = ax,
            y = ay,
            max_length = arc:get_length(),
            direction_x = dx, 
            direction_y = dy,
        }

        arc:set_segment(ax, ay, ax, ay)
        table.insert(self.rays, arc)
        game:new_actor(arc)
    end
    
    self.cur_ray_index = 1
    self:load_ray()
end

function ProgressingArc:set_bounds(a, b)
    local lower = 0.0
    for i=1, #self.points - 1 do
        local ray = self.rays[i]
        local info = self.ray_info[i]
        local upper = lower + info.max_length
        
        if upper < a or b < lower then
            ray:set_active(false)
        else
            local clamped_a = clamp(a, lower, upper)
            local clamped_b = clamp(b, lower, upper)
            self:set_ray_bounds(i, clamped_a - lower, clamped_b - lower)
            ray:set_active(true)
            -- ray.debug_values[1] = ""
            -- ray.debug_values[2] = ""
            -- ray.debug_values[3] = ""
            -- ray.debug_values[5] = concat("[", i, "]: ", clamped_a - lower, ", ", clamped_b - lower)
        end

        lower = upper
    end
    -- print _debug("--------")
end

function ProgressingArc:set_ray_bounds(ray_index, a, b)
    local ray = self.rays[ray_index]
    if not ray then
        return
    end
    
    local info = self.ray_info[ray_index]
    assert(info ~= nil, "Ray info for ray "..tostring(ray_index).." doesn't exist")

    -- print _debug(
    --     "[", ray_index, "]: ", round(a, 1), " -> ", round(b, 1), " || ",
    --     tostring(round(info.x + info.direction_x * a))..","..
    --     tostring(round(info.y + info.direction_y * a))..","..
    --     tostring(round(info.x + info.direction_x * b))..","..
    --     tostring(round(info.y + info.direction_y * b))
    -- )
    ray:set_segment(
        info.x + info.direction_x * a,
        info.y + info.direction_y * a,
        info.x + info.direction_x * b,
        info.y + info.direction_y * b
    )
end

function ProgressingArc:load_ray()
    self.cur_ray = self.rays[self.cur_ray_index]

    if not self.cur_ray then
        return 
    end
    self.cur_ray_segment = self.cur_ray:get_segment()
    
    self.cur_length = 0.0
    self.cur_max_length = self.ray_info[self.cur_ray_index].max_length
    self.cur_ray_direction_x = self.ray_info[self.cur_ray_index].direction_x
    self.cur_ray_direction_y = self.ray_info[self.cur_ray_index].direction_y

    self.cur_ray:set_active(true)
end

function ProgressingArc:update(dt)
    ProgressingArc.super.update(self, dt)    
    -- self.debug_values[1] = self.length

    self:update_ray(dt)
end

function ProgressingArc:update_ray(dt)
    if not self.cur_ray then
        return
    end
    
    if self.arc_enabled_timer <= 0 then       
        self.cur_length = self.cur_length + self.progress_speed*dt
    end
    self.cur_length = ((self.cur_length + self.interval_size) % (self.length + 2*self.interval_size)) - self.interval_size

    self:set_bounds(self.cur_length, self.cur_length + self.interval_size)

    if self.arc_enabled_timer > 0 then
        self.arc_enabled_timer = math.max(0, self.arc_enabled_timer - dt)

        for i=1, #self.points - 1 do
            local ray = self.rays[i]
            ray:set_arc_active(false)
 
            ray:set_visible(self.arc_enabled_timer % 0.2 < 0.1)
        end
    else
        for i=1, #self.points - 1 do
            local ray = self.rays[i]
            ray:set_arc_active(true)
        end
    end

    -- self.cur_ray:set_segment(
    --     self.cur_ray_segment.ax, self.cur_ray_segment.ay, 
    --     self.cur_ray_segment.ax + self.cur_ray_direction_x * l, 
    --     self.cur_ray_segment.ay + self.cur_ray_direction_y * l
    -- )

    -- local overflow = math.max(0.0, l - self.cur_max_length)
    -- if overflow > 0.0 then
    --     self.cur_ray_index = self.cur_ray_index + 1
    --     self:load_ray()
    -- end
end

function ProgressingArc:draw()
	ProgressingArc.super.draw(self)

    if game.debug.colview_mode then
        for i = 1, #self.points-1 do
            line_color(COL_GREEN, self.points[i][1], self.points[i][2], self.points[i+1][1], self.points[i+1][2])
        end
    end

    -- Dotted points
    for i = 1, #self.points-1 do
        line_dotted(transparent_color(COL_LIGHT_GREEN, 0.8), 
            self.points[i][1], self.points[i][2], self.points[i+1][1], self.points[i+1][2], { 
            spacing = 3,
            segment_length = 3, 
            offset = self.t * 10,
        })
    end
end

function ProgressingArc:on_death()
    for _, ray in pairs(self.rays) do
        ray:kill()
    end
end

return ProgressingArc