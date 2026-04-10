require "scripts.util"
local Enemy = require "scripts.actor.enemy"
local Timer = require "scripts.timer"
local FlyingDung = require "scripts.actor.enemies.flying_dung"
local AnimatedSprite = require "scripts.graphics.animated_sprite"
local Sprite = require "scripts.graphics.sprite"
local StateMachine  = require "scripts.state_machine"

local sounds = require "data.sounds"
local images = require "data.images"

local DungBeetle = Enemy:inherit()

function DungBeetle:init(x, y)
    self:init_enemy(x,y, images.dung_beetle_1, 24, 16)
    self.name = "dung_beetle"
    self.follow_player = false

    self.score = 500

    self.damage = 1
    self.life = math.huge

    self.knockback = 0
    
    self.is_pushable = false
    self.is_knockbackable = false
    self.is_stompable = false
    self.destroy_bullet_on_impact = false
	self.is_immune_to_bullets = true
    self.is_bouncy_to_bullets = true

    self.spawn_dung_timer = Timer:new(2.0)
    self.spawn_dung_timer:start()
    self.dung_limit = 6
    self.dungs = {}

    self.spr = AnimatedSprite:new({
        idle = {
            {images.dung_beetle_idle},
            0.1
        },
        dead = {
            {images.dung_beetle_dead},
            0.1
        },
        run = {
            {
                images.dung_beetle_4, 
                images.dung_beetle_5, 
                images.dung_beetle_6,
                images.dung_beetle_1, 
                images.dung_beetle_2,
                images.dung_beetle_3, 
            }, 
            0.06
        },
    }, "idle") 

    self.state_machine = StateMachine:new({
        chase = {
            update = function(state, dt)
                if self.vehicle and math.abs(self.vehicle.vx) > 20 then
                    self.spr:set_animation("run")
                    self.spr:set_flip_x(self.vehicle.vx > 0)
                    
                else
                    if self.spr.frame_i == 1 then
                        self.spr:set_animation("idle")
                    end
                end
                self.anim_frame_len = 0.08
            end
        },
        flying = {
            enter = function(state)
                self.vy = -300
                self.vx = 0
                self.gravity = self.default_gravity * 0.3

                self.self_knockback_mult = 0
                
                self.is_pushable = false
                self.is_stompable = true
                self.destroy_bullet_on_impact = true
                self.is_immune_to_bullets = false
                self.is_bouncy_to_bullets = false

                self.dung_pile_sprite = Sprite:new(images.dung_pile)
                self.dung_pile_sprite_x = self.mid_x
                self.dung_pile_sprite_y = game.level.cabin_inner_rect.by

                self.spr:set_animation("dead")
                self.spr:set_anchor(SPRITE_ANCHOR_CENTER_CENTER)
                self.vr = 9        

                game:frameskip(25)
                game:screenshake(8)

                Particles:push_layer(PARTICLE_LAYER_BACK)
                Particles:static_image(images.star_big, self.mid_x, self.mid_y, 0, 0.05, 1.3, {
                    color = COL_WHITE
                })
                Particles:static_image(images.star_big, self.mid_x, self.mid_y, 0, 0.05, 1, {
                    color = COL_LIGHT_RED
                })
                Particles:pop_layer()

                Particles:image(self.mid_x, self.mid_y, 40, images.glass_shard, self.h)
                self:play_sound("sfx_boss_mrdung_dying")
                self:play_sound_var("sfx_actor_upgrade_display_break_{01-04}", 0.1, 1.1)

                game.music_player:set_disk("off")
            end,
            update = function(state, dt)
                self.spr.rot = self.spr.rot + self.vr * dt 

                if self.y + self.h > game.level.cabin_inner_rect.by - 26 then
                    return "stuck"
                end
            end,
            draw = function(state)
                self.dung_pile_sprite:draw(self.dung_pile_sprite_x, self.dung_pile_sprite_y)
            end
        },
        stuck = {
            enter = function(state)
                self.vx = 0
                self.vy = 0
                self.vr = 0
                self.gravity = 0

                self.is_pushable = false
                self.is_stompable = true
                self.destroy_bullet_on_impact = true
                self.is_immune_to_bullets = false
                self.is_bouncy_to_bullets = false
                
                self.y = game.level.cabin_inner_rect.by - 26
                self.can_be_stomped_if_on_head = false
                self.spr.rot = pi

                game:screenshake(6)
                Particles:image(self.mid_x, self.mid_y, 40, {images.dung_particle_1, images.dung_particle_2, images.dung_particle_3}, self.h)
                self:play_sound_var("sfx_boss_mrdung_land_in_dung", 0.1, 1.1)

                state.shake_timer = Timer:new(1.0, {loopback = true}):start()
                state.shake = 0
            end,

            update = function(state, dt)
                state.shake = math.max(state.shake - dt*6, 0)

                if state.shake_timer:update(dt) then
                    state.shake = 3
                    Particles:sweat(self.mid_x + self.w/2, self.y)
                end

                self.spr:update_offset(random_neighbor(state.shake), 0)
            end,

            draw = function(state)
                self.dung_pile_sprite:draw(self.dung_pile_sprite_x, self.dung_pile_sprite_y)
                draw_faint_halo(self.mid_x, self.y - 16, self.t, images.star_small_2)                
            end
        },
    },"chase")

    self.hits = self.dung_limit
    self.life = math.huge
    self.unridden_life = 10

    self.has_unridden = false
    self.vr = 0
end

function DungBeetle:update(dt)
    self.state_machine:update(dt)

    self:update_enemy(dt)

    if (self.spawn_dung_timer:update(dt) or #self.dungs == 0) and self.vehicle then
        local flying_dung = FlyingDung:new(self.mid_x, self.mid_y, self)
        flying_dung:center_actor()
        game:new_actor(flying_dung)
        table.insert(self.dungs, flying_dung)

        if #self.dungs < self.dung_limit then
            self.spawn_dung_timer:start()
        end
    end
    
    for i = #self.dungs, 1, -1 do
        local dung = self.dungs[i]
        if dung.is_removed then
            table.remove(self.dungs, i)
            self.spawn_dung_timer:start()
        end
    end

    if self.vehicle == nil and not self.has_unridden then
        self.has_unridden = true
        self:unride()
    end
end

function DungBeetle:on_damage(amount)
    if self.life > 0 and self.vehicle then
        game:screenshake(6)
        game:frameskip(8)
    end
end


function DungBeetle:on_death()
    for i = 1, #self.dungs do
        local dung = self.dungs[i]
        dung:kill()
    end

    game:screenshake(8)
    game:frameskip(30)
    Input:vibrate_all(0.3, 0.3)
    
    Particles:ejected_player(images.dung_beetle_dead, self.mid_x, self.mid_y, nil, nil, {
        x_sign = ternary(self.mid_x < CANVAS_WIDTH/2, 1, -1)
    })
    Particles:image(self.mid_x, self.mid_y, 100, {images.dung_particle_1, images.dung_particle_2, images.dung_particle_3}, self.h, 2)
    self:play_sound("sfx_boss_mrdung_death_{01-03}")
end

function DungBeetle:draw()
    self:draw_enemy()
    self.state_machine:draw()

    if self.vehicle then
        draw_centered(images.dung_beetle_shield, self.mid_x, self.mid_y, -self.vehicle.spr.rot)
        draw_centered(images.dung_beetle_shield_shine, self.mid_x, self.mid_y)
        -- print_outline(nil, nil, tostring(self.anim_frame_len), self.mid_x + 20, self.mid_y)
    end
end

function DungBeetle:on_hit_flying_dung(flying_dung)
    self.hits = math.max(0, self.hits - 1)
    
    self:do_damage(5, flying_dung)
    self:play_sound("sfx_boss_mrdung_ball_hit_{01-06}", 1.0)

    if self.vehicle then
        if sign(self.vehicle.vx) == -sign(flying_dung.vx) then
            self.vehicle:do_knockback(self.vehicle.self_knockback_mult, sign(flying_dung.vx) * 20, 0)
        end
        self.vehicle:do_damage(5, flying_dung)
    end
end

function DungBeetle:unride()
    self.follow_player = false
    self.is_pushable = true
    self.is_knockbackable = true

    self.destroy_bullet_on_impact = true
	self.is_immune_to_bullets = false
    self.is_bouncy_to_bullets = false

    self.life = self.unridden_life
    self.damage = 0

    for i = 1, #self.dungs do
        local dung = self.dungs[i]
        dung:kill()
    end

    self.pass_to_flying_flag = true
    
    self.state_machine:set_state("flying")
end

return DungBeetle