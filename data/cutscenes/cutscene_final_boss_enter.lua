local Cutscene = require "scripts.game.cutscene"
local CutsceneScene = require "scripts.game.cutscene_scene"
local backgrounds = require "data.backgrounds"
local BackgroundFinalBossIntro = require "scripts.level.background.background_final_boss_intro"
local BackgroundAboveCity = require "scripts.level.background.background_above_city"
local BackgroundCity = require "scripts.level.background.background_city"

local Rect = require "scripts.math.rect"
local images = require "data.images"

return Cutscene:new("final_boss_enter", {
    CutsceneScene:new({
        duration = 1.0,

        enter = function(cutscene, data)
            game.level.slowdown_timer_override = 9.5
            game.level.opened_door_timer_override = 1.0

            game.menu_manager:set_can_pause(false)
        end
    }),

    CutsceneScene:new({
        duration = 1.9,
        enter = function(cutscene, data)
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

            data.bg = BackgroundFinalBossIntro:new()
            data.bg.offset_y = 100
            game.level:set_background(data.bg)

            Audio:play("sfx_cutscene_rocket")
        end,
    }),

    CutsceneScene:new({ 
        duration = 0.0,
    }),

    CutsceneScene:new({ 
        duration = 2.5,
        enter = function(cutscene, data)
            data.shake_q = 1.0
        end,
        update = function(cutscene, data, dt)
            data.shake_q = data.shake_q + dt*0.5
            game:screenshake(data.shake_q)
        end,
    }),

    CutsceneScene:new({ 
        duration = 0.1,
        enter = function(cutscene, data)
            data.bg.rocket_y = CANVAS_CENTER[2] + 5
        end,
        update = function(cutscene, data, dt)
            data.bg.rocket_y = data.bg.rocket_y - dt*900
            data.shake_q = data.shake_q + dt*0.5
            game:screenshake(data.shake_q)
        end,
    }),

    CutsceneScene:new({ 
        duration = 0,
        enter = function(cutscene, data)
            game:frameskip(20)
            data.bg.draw_star = true
            data.frame = 0

            Particles:push_layer(PARTICLE_LAYER_CAFETERIA_BACKGROUND)
            Particles:image(
                CANVAS_WIDTH*1.5, 
                CANVAS_HEIGHT*0.5, 
                100,
                { 
                    images.cabin_fragment_1, 
                    images.cabin_fragment_2, 
                    images.cabin_fragment_3,
                }, 
                32, 3.0, 1.0, nil, -- spw_rad, life, vs, g,
                {
                    clamp_to_cabin_rect = false,
                    is_solid = false,
                    vx1 = -100,
                    vx2 = 100,
                    vy1 = -200,
                    vy2 = -150,
                }
            )
            for ix=CANVAS_WIDTH*1.5 - 32, CANVAS_WIDTH*1.5 + 32 do
                -- col, size, rnd_pos, sizevar, params
                Particles:dust(ix, CANVAS_HEIGHT*0.5, {COL_WHITE, COL_LIGHT_GRAY, COL_LIGHTEST_GRAY}, 
                    8, nil, 2, {
                    vx1 = 0, vx2 = 0, vy1 = -150, vy2 = -50
                })
            end

            Particles:pop_layer()
        end
    }),

    CutsceneScene:new({ 
        duration = 2.5,
        enter = function(cutscene, data)
            game:screenshake(40)

            for _, player in pairs(game.players) do
                player:set_position(game.level.cabin_inner_rect.ax + player.n * 24, player.y)
            end
        end,
        update = function(cutscene, data, dt)
            data.frame = data.frame + 1
            if data.frame > 3 then
                data.bg.draw_star = false
            end

            data.bg.rocket_y = data.bg.rocket_y - dt*900
        end,
    }),

    CutsceneScene:new({
        description = "Back in rocket",

        duration = 1.0,
        enter = function(cutscene, data)
            game.menu_manager:set_can_pause(true)

            -- Init players
            for _, player in pairs(game.players) do
                player:set_input_mode(PLAYER_INPUT_MODE_USER)
                player:reset_virtual_controller()

                player.do_fury_trail = true
                player.is_visible = true
            end

            game.game_ui:set_gameplay_hud_visible(true)
            game.game_ui.cinematic_bars_enabled = false
            game.game_ui.cinematic_bar_color = nil
            game.level.show_cabin = true

            game.camera.do_camera_position_clamping = false
            game.camera:set_position(DEFAULT_CAMERA_X, DEFAULT_CAMERA_Y)

            local bg = BackgroundAboveCity:new()
            game.level:set_background(bg)

            game.level.level_speed = game.level.level_speed_advancing
        end,
    }),

    CutsceneScene:new({ 
        duration = 1.0,
        enter = function(cutscene, data)
            game.music_player:set_disk("boss_w5")
            
        end,
    }),

    CutsceneScene:new({ 
        duration = 1.5,
        enter = function(cutscene, data)
            if not Options:get("skip_boss_intros") then
                game.menu_manager:set_menu("w5_boss_intro")
            end
        end,
    }),
})