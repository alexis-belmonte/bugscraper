local Cutscene = require "scripts.game.cutscene"
local CutsceneScene = require "scripts.game.cutscene_scene"
local backgrounds = require "data.backgrounds"
local BackgroundFinalBossIntro = require "scripts.level.background.background_final_boss_intro"
local BackgroundAboveCity = require "scripts.level.background.background_above_city"
local BackgroundCity = require "scripts.level.background.background_city"
local BackgroundFinalBossDeath = require "scripts.level.background.background_final_boss_death"
local BackroomEnding  = require "scripts.level.backroom.backroom_ending"
local guns            = require "data.guns"
local InvisibleDummy = require "scripts.actor.enemies.invisible_dummy"

local Rect = require "scripts.math.rect"
local images = require "data.images"

return Cutscene:new("final_boss_death", {
    CutsceneScene:new({
        duration = 2.0,

        enter = function(cutscene, data)
            game.menu_manager:set_can_pause(false)
        end
    }),

    CutsceneScene:new({
        description = "setup",

        duration = 0.0,
        enter = function(cutscene, data)
            for _, actor in pairs(game.actors) do
                if not actor.is_player then
                    actor:remove()
                end
            end
            game:new_actor(InvisibleDummy:new(0, 0))
            
            -- Init players
            for _, player in pairs(game.players) do
                player:set_input_mode(PLAYER_INPUT_MODE_CODE)
                player:reset_virtual_controller()

                player.do_fury_trail = false
                player.is_visible = false
            end

            game.game_ui:set_gameplay_hud_visible(false)
            game.game_ui.cinematic_bars_enabled = true
            game.game_ui.cinematic_bar_color = COL_BLACK_BLUE
            game.level.show_cabin = false

            game.camera.do_camera_position_clamping = false
            game.camera:set_position(CANVAS_WIDTH, 0)

            data.bg = BackgroundFinalBossDeath:new()
            data.bg.offset_y = 100
            game.level:set_background(data.bg)
            game.level.background_speed_lines = false
        end,
    }),

    CutsceneScene:new({ 
        duration = 5,
        enter = function(cutscene, data)
            data.rocket_shake = 3
            data.t = 0

            data.cutscene_update = function(dt)
                data.t = data.t + dt
                Particles:push_layer(PARTICLE_LAYER_CAFETERIA_BACKGROUND)

                game:screenshake(2)
                
                Particles:speed_line(random_range(CANVAS_WIDTH, CANVAS_WIDTH*2), -64, {
                    vy = random_range(2000, 3000),
                    particle_layer = PARTICLE_LAYER_CAFETERIA_BACKGROUND, 
                })

                data.bg.rocket_y = CANVAS_CENTER[2] - 60
                data.bg.rocket_ox = random_neighbor(data.rocket_shake)
                data.bg.rocket_oy = random_neighbor(data.rocket_shake)

                if data.t > 2.0 then
                    data.rocket_shake = data.rocket_shake + dt*3
                end

                data.bg.camera_oy = data.bg.camera_oy + 100*dt

                Particles:smoke_big(CANVAS_WIDTH*1.5, data.bg.rocket_y+120, {
                        type = "gradient",
                        COL_WHITE, COL_YELLOW, COL_ORANGE, COL_DARK_RED, COL_DARK_GRAY, COL_BLACK_BLUE
                    }, 
                    12, -- rad
                    10, -- quantity
                    {
                        vx = 0, 
                        vx_variation = 20, 
                        vy = 300, 
                        vy_variation = 30,
                        min_spawn_delay = 0,
                        max_spawn_delay = 0.2,
                    }
                )

                Particles:pop_layer()
            end
        end,
        update = function(cutscene, data, dt)
            data.cutscene_update(dt)
        end,
    }),

    CutsceneScene:new({ 
        duration = 0.02,
        enter = function(cutscene, data)
            game:frameskip(30)
            game:reset_screenshake()
            data.bg.draw_star = true

            data.bg.rocket_ox = 0
            data.bg.rocket_oy = 0

            for _, player in pairs(game.players) do
                player:set_position(game.level.cabin_inner_rect.ax + player.n * 24, player.y)
            end
            data.frame = 0
        end,
        update = function(cutscene, data, dt)
            data.frame = data.frame + 1
            if data.frame > 1 then
                data.bg.draw_star = false
            end
        end,
    }),

    CutsceneScene:new({ 
        duration = 3.0,
        enter = function(cutscene, data)
            game:screenshake(40)

            data.bg.rocket_y = 4000 

            game:frameskip(4)
            Particles:push_layer(PARTICLE_LAYER_CAFETERIA_BACKGROUND)
            Particles:explosion(CANVAS_WIDTH*1.5, CANVAS_HEIGHT*0.5, 80)
            Particles:image(
                CANVAS_WIDTH*1.5, CANVAS_HEIGHT*0.5, 
                200, --numner
                {
                    images.cabin_fragment_1,
                    images.cabin_fragment_2,
                    images.cabin_fragment_3,
                    images.button_fragment_1,
                    images.button_fragment_2,
                    images.button_fragment_3,
                    images.button_fragment_4,
                    images.button_fragment_5,
                }, 
                40, 3.0, 1.0, nil, -- spw_rad, life, vs, g,
                {
                    clamp_to_cabin_rect = false,
                    is_solid = false,
                    vx1 = -150 * 1.5,
                    vx2 = 150 * 1.5,
                    vy1 = 80 * 1.5,
                    vy2 = -200 * 1.5,

                    scale = 1.5,
                }
            )
            Particles:pop_layer()
        end,
        update = function(cutscene, data, dt)
        end,
    }),

    CutsceneScene:new({ 
        duration = 3.0,
        enter = function(cutscene, data)
            game.camera:set_position(0, 0)
            
            local bg = BackgroundAboveCity:new(100000)
            game.level:set_background(bg)
            game.draw_shadows = false

            local num_players = game:get_number_of_alive_players()
            local n = 0
            for _, player in pairs(game.players) do
                player.is_affected_by_bounds = false
                player.is_affected_by_walls = false
                player.is_vulnerable_to_kill_zone = false

                local sp = 32
                player:set_position(CANVAS_WIDTH/2 - sp*(num_players-1)*0.5 + n*sp, CANVAS_HEIGHT/2)
				player.gravity_mult = 0
                player.is_visible = true
                player.friction_x = 0.0
                
				player.vx = 0
				player.vy = 0

                player.spr:set_rotation(0)--random_range_int(0, 3) * pi/2)

                player:reset_virtual_controller()
                player.spr:set_animation("airborne")
                player.spr:set_shake(2)
                player:equip_gun(guns.unlootable.EmptyGun:new(player))

                n = n + 1
            end
        end,
        update = function(cutscene, data, dt)
            data.upd = function(dt)
                Particles:speed_line(random_range(0, CANVAS_WIDTH), CANVAS_HEIGHT + 64, {
                    vy = -random_range(800, 1200), 
                })
    
                for _, player in pairs(game.players) do
                    player.spr:set_animation("dead")
                end
            end
            game.level.level_speed = -1000
            data.upd(dt)
        end,
    }),

    CutsceneScene:new({ 
        duration = 2.0,
        enter = function(cutscene, data)
            data.cam_vy = 0
        end,
        update = function(cutscene, data, dt)
            data.upd(dt)
            
            data.cam_vy = data.cam_vy + 200*dt
            for _, player in pairs(game.players) do
                player:set_position(player.x, player.y + data.cam_vy * dt)
            end
        end,
    }),

    CutsceneScene:new({ 
        duration = 2.0,
        enter = function(cutscene, data)
            Particles:clear()

            for _, actor in pairs(game.actors) do
                if not actor.is_player then
                    actor:remove()
                end
            end

            for _, player in pairs(game.players) do
                player:reset()
                player:set_position(4*16 + player.n*24, 0*16)
                player.show_hud = false

                player.gravity_mult = 3.0
                player.gravity_cap = math.huge
                
                player:set_input_mode(PLAYER_INPUT_MODE_CODE)
                player:reset_virtual_controller()
            end

            game.level:begin_backroom(BackroomEnding:new())
            game.level:set_backroom_on()
        end,
        update = function(cutscene, data)
            for _, player in pairs(game.players) do
                if player.is_grounded then
                    return true
                end
            end
        end,
    }),

    CutsceneScene:new({ 
        duration = 1.0,
        enter = function(cutscene, data)
            for _, player in pairs(game.players) do
                player:reset()
                player:set_input_mode(PLAYER_INPUT_MODE_CODE)
                player:reset_virtual_controller()
            end
            
            game:screenshake(14)
            
            for _, player in pairs(game.players) do
                Particles:image(
                    player.mid_x, player.y + player.h, 
                    200, --numner
                    {
                        images.cabin_fragment_1,
                        images.cabin_fragment_2,
                        images.cabin_fragment_3,
                    }, 
                    4, 3.0, 1.0, nil, -- spw_rad, life, vs, g,
                    {
                        clamp_to_cabin_rect = false,
                        is_solid = false,
                        vx1 = -150 * 0.7,
                        vx2 = 150 * 0.7,
                        vy1 = 80 * 0.7,
                        vy2 = -200 * 0.7,
                    }
                )
            end
        end,
        update = function(cutscene, data)
            for _, player in pairs(game.players) do
                if player.is_grounded then
                    return
                end
            end
        end,
    }),

    CutsceneScene:new({ 
        duration = 1.0,
    }),

    CutsceneScene:new({ 
        duration = 0.0,
        enter = function(cutscene, data)
            for _, player in pairs(game.players) do
                player:set_input_mode(PLAYER_INPUT_MODE_USER)
                player:reset_virtual_controller()
            end

            game.game_ui.cinematic_bars_enabled = false
            game.game_ui.cinematic_bar_color = COL_BLACK_BLUE

            game.menu_manager:set_can_pause(true)
        end
    })
})