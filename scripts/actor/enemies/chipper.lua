require "scripts.util"
local Enemy = require "scripts.actor.enemy"
local Timer = require "scripts.timer"
local StateMachine = require "scripts.state_machine"
local Rect = require "scripts.math.rect"
local sounds = require "data.sounds"
local images = require "data.images"

local Chipper = Enemy:inherit()
	
function Chipper:init(x, y, spr)
    Chipper.super.init(self, x,y, spr or images.chipper_1)
    self.name = "chipper"
    self.is_flying = true
    self.life = 10
    self.follow_player = false
    --self.speed_y = 0--self.speed * 0.5
    
    self.speed = random_range(7,13) --10
    -- self.speed_x = self.speed
    -- self.speed_y = self.speed

    self.direction = random_range_int(0, 3)
    self.target_rot = self.spr.rot

    self.gravity = 0
    self.friction_y = self.friction_x

    self.anim_frame_len = 0.2
    self.anim_frames = {images.chipper_1, images.chipper_2, images.chipper_3, images.chipper_2}
    self.normal_anim_frames = {images.chipper_1, images.chipper_2, images.chipper_3, images.chipper_2}
    self.attack_anim_frames = {images.chipper_attack_1, images.chipper_attack_2, images.chipper_attack_3, images.chipper_attack_2}
	self.flip_mode = ENEMY_FLIP_MODE_MANUAL

    self.spr:set_anchor(SPRITE_ANCHOR_CENTER_CENTER)
    self.min_walk_duration = 0.6
    self.max_walk_duration = 2.0
    self.turn_timer = Timer:new(self:get_random_walk_duration())
    self.turn_timer:start()
    
    self.wander_no_attack_timer = Timer:new(1.0)
    self.player_detection_range = 256
    self.player_detection_width = 16
    self.telegraph_timer = Timer:new(0.5)
    -- self.telegraph_source = Audio:get_sound("sfx_enemy_chipper_trigger"):clone()
    self:set_constant_sound("trigger", "sfx_enemy_chipper_trigger", false)
    self:set_constant_sound_volume("trigger", 0.7)

    self.attack_speed = 100
    self.post_attack_timer = Timer:new(0.5)
    self.score = 10

    self.sound_death = "sfx_enemy_kill_general_glitch_{01-10}"
    self.sound_stomp = "sfx_enemy_kill_general_glitch_{01-10}"

    self:set_constant_sound("crawl", "sfx_enemy_chipper_crawl_lp_{01-04}", true, 1.0)
    self:set_constant_sound_volume("crawl", 0.2)

    self.state_machine = StateMachine:new({
        idle = {
            enter = function(state)
            end,
            update = function(state, dt)
                self.vx = 0 
                self.vy = 0 
            end,
        },
        wander = {
            enter = function(state)
                self.anim_frames = self.normal_anim_frames
                self.wander_no_attack_timer:start()
            end,
            update = function(state, dt)
                if self.turn_timer:update(dt) then
                    self.turn_timer:set_duration(self:get_random_walk_duration())
                    self.turn_timer:start()
            
                    self.direction = (self.direction + random_sample({-1, 1})) % 4
                end
                
                self.vx = self.vx + math.cos(self.direction * pi/2) * self.speed
                self.vy = self.vy + math.sin(self.direction * pi/2) * self.speed
                
                self.target_rot = self.direction * pi/2
                
                self.wander_no_attack_timer:update(dt)
                if not self.wander_no_attack_timer.is_active then
                    local detected = self:detect_player_in_range()
                    if detected then
                        return "telegraph"
                    end
                end
                -- self.state_machine:set_state("exploding")
            end,
        },
        telegraph = {
            enter = function(state) 
                self.anim_frames = self.attack_anim_frames
                self.telegraph_timer:start()

                self:play_constant_sound("trigger")
            end,
            update = function(state, dt)
                if self.telegraph_timer:update(dt) then
                    self.state_machine:set_state("attack")
                end
            end
        },
        attack = {
            enter = function()
                self.anim_frames = self.attack_anim_frames
            end,
            update = function(state, dt)
                local a = self.direction * pi/2
                self.vx = self.vx + math.cos(a) * self.attack_speed
                self.vy = self.vy + math.sin(a) * self.attack_speed

                Particles:dust(self.mid_x, self.mid_y)
                Particles:static_image(random_sample{images.particle_bit_zero, images.particle_bit_one}, self.mid_x, self.mid_y, 0, 0.25)
            end,
        },
        post_attack = {
            enter = function(state)
                self.anim_frames = self.normal_anim_frames
                self.post_attack_timer:start()
                self:stop_constant_sound("trigger")
            
				self:play_sound_var("sfx_bullet_bounce_{01-02}", 0.2, 1.2)
                self:play_sound_var("metal_impact", 0, 1)
                -- local s = "metalfootstep_0"..tostring(love.sume=0.5})

            end,
            update = function(state, dt)
                local r = 3 * self.post_attack_timer:get_time() / self.post_attack_timer:get_duration()
                self.spr:update_offset(random_neighbor(r), random_neighbor(r))

                if self.post_attack_timer:update(dt) then
                    self.state_machine:set_state("wander")
                end
            end,
        },
    }, "wander")
end

function Chipper:update(dt)
    Chipper.super.update(self, dt)

    self.spr:set_rotation(lerp_angle(self.spr:get_rotation(), self.target_rot, 0.2))
    self.state_machine:update(dt)

    if random_range(0, 1) < 0.02 then
        -- Particles:word(self.mid_x, self.mid_y, random_sample{"0", "1"}, random_sample{COL_LIGHT_GREEN, COL_MID_GREEN})
    end
end

function Chipper:get_random_walk_duration()
    return random_range(self.min_walk_duration, self.max_walk_duration)
end

function Chipper:detect_player_in_range()
    -- for fuck's sake please use vectors i'm begging you
    local a = self.direction * pi/2
    local w = self.player_detection_width
    local r = self.player_detection_range
    local forward_x, forward_y = math.cos(a), math.sin(a)
    local side_x, side_y = math.cos(a + pi/2), math.sin(a + pi/2)

    local rect = Rect:new(
        self.mid_x + side_x*w, 
        self.mid_y + side_y*w, 
        self.mid_x - side_x*w + forward_x*r, 
        self.mid_y - side_y*w + forward_y*r
    )

    local intersects = false
    for _, player in pairs(game.players) do
        if rect:rectangle_intersection(Rect:new(player.x, player.y, player.x + player.w, player.y + player.h)) then
            intersects = true
            break
        end
    end
    self.vision_rect = rect

    return intersects
end

function Chipper:draw()
	self:draw_enemy()

    -- circle_color(COL_YELLOW, "fill", self.x, self.y, 10)
    if self.vision_rect and game.debug and game.debug.colview_mode then
        rect_color(COL_RED, "line", self.vision_rect.x, self.vision_rect.y, self.vision_rect.w, self.vision_rect.h)
    end
end

function Chipper:is_collision_normal_to_direction(normal)
    self.removeme_normal = normal
    local dir = self.direction % 4
    return (
        (dir == 0 and normal.x == -1 and normal.y == 0) or
        (dir == 1 and normal.x == 0  and normal.y == -1) or
        (dir == 2 and normal.x == 1  and normal.y == 0) or
        (dir == 3 and normal.x == 0  and normal.y == 1)
    )
end

function Chipper:after_collision(col, other)
    if col.type ~= "cross" then
        if self.state_machine:in_state("attack") and self:is_collision_normal_to_direction(col.normal) then
            self.state_machine:set_state("post_attack")
        end

        if self.state_machine:in_state("wander") then
            local new_vx, new_vy = bounce_vector_cardinal(-math.cos(self.direction * pi/2), -math.sin(self.direction * pi/2), col.normal.x, col.normal.y)
            self.direction = math.floor(math.atan2(new_vy, new_vx) / (pi/2))
        end
    end
end

return Chipper