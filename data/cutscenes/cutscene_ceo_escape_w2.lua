local Cutscene = require "scripts.game.cutscene"
local CutsceneScene = require "scripts.game.cutscene_scene"
local images = require "data.images"

return Cutscene:new("ceo_escape_w2", {
    CutsceneScene:new({
        description = "",

        duration = 0.01,
        enter = function(cutscene, data)            
            for _, actor in pairs(game.actors) do
                if actor.is_shop then
                    actor:end_interaction(true)
                end 
            end

            if not Metaprogression:get("has_seen_w2_transition_cutscene") then
                game.menu_manager:set_can_pause(false)
                game.game_ui.cinematic_bars_enabled = true
                game.game_ui.cinematic_bar_color = COL_VERY_DARK_GRAY
                game.camera:set_target_offset(10000, 0)

                for _, player in pairs(game.players) do
                    player:set_input_mode(PLAYER_INPUT_MODE_CODE)
                    player:reset_virtual_controller()
                end
            end

            for _, actor in pairs(game.actors) do
                if actor.name == "npc" and actor.npc_name == "ceo" then
                    data.ceo = actor
                end
                if actor.name == "npc" and actor.npc_name == "bee1" then
                    data.bee1 = actor
                end
                if actor.name == "npc" and actor.npc_name == "bee2" then
                    data.bee2 = actor
                end
                if actor.name == "npc" and actor.npc_name == "bee3" then
                    data.bee3 = actor
                end
            end
        end,
    }),
    CutsceneScene:new({
        description = "",

        duration = 0,
        enter = function(cutscene, data)
            data.ceo.gravity = 0
        end,
    }),
    CutsceneScene:new({
        description = "Wait for a bit",

        duration = 1.5,
        enter = function(cutscene, data)
        end,
        update = function(cutscene, data, dt)
        end,
    }),
    CutsceneScene:new({
        description = "Shocked",

        duration = 0.5,
        enter = function(cutscene, data)
            data.ceo.spr:set_animation("shocked")
            data.shake = 3.0

            Particles:static_image(images.surprise_effect, data.ceo.x - 16, data.ceo.y - 30, 0, 0.3)
            data.ceo:play_sound("sfx_w1_cutscene_surprise")
        end,
        update = function(cutscene, data, dt)
            data.ceo.spr:update_offset(random_neighbor(data.shake), random_neighbor(data.shake))
            data.shake = math.max(0, data.shake - dt * 6)
        end,
        exit = function(cutscene, data)
            data.ceo.spr:update_offset(0, 0)
        end
    }),
    CutsceneScene:new({
        description = "Shocked (wait)",

        duration = 1.0,
        enter = function(cutscene, data)
        end,
        update = function(cutscene, data, dt)
            if Metaprogression:get("has_seen_w2_transition_cutscene") then
                return true
            end
        end,
    }),
    CutsceneScene:new({
        description = "",

        duration = (0.02 * 3),
        enter = function(cutscene, data)
            data.ceo.spr:set_animation("clap")
        end,
    }),
    CutsceneScene:new({
        description = "",

        duration = 1.0,
        enter = function(cutscene, data)
            Particles:static_image(images.clap_effect, math.floor(data.ceo.x), math.floor(data.ceo.y - 32), 0, 0.3)
            data.ceo:play_sound("sfx_w2_cutscene_clap")

            data.shake = 3.0
        end,
        update = function(cutscene, data, dt)
            data.ceo.spr:update_offset(random_neighbor(data.shake), random_neighbor(data.shake))
            data.shake = math.max(0, data.shake - dt * 6)
        end,
        exit = function(cutscene, data)
            data.ceo.spr:update_offset(0, 0)
        end
    }),
    CutsceneScene:new({
        description = "",

        duration = 1.0,
        enter = function(cutscene, data)
        end,
        update = function(cutscene, data, dt)
            game:screenshake(3)
            Audio:play("sfx_w2_cutscene_rumble")
        end,
    }),
    CutsceneScene:new({
        description = "",

        duration = 1.7,
        enter = function(cutscene, data)
            data.bee1.vy = -340
            data.bee2.vy = -340
            data.bee3.vy = -340

            data.sweat_timer = 0

            data.bee1:play_sound("sfx_w2_cutscene_bees_beeingbees")
        end,
        update = function(cutscene, data, dt)
            data.bee1.vy = math.min(data.bee1.vy + 1000 * dt, 20)
            data.bee2.vy = math.min(data.bee2.vy + 1000 * dt, 20)
            data.bee3.vy = math.min(data.bee3.vy + 1000 * dt, 20)

            if data.bee1.y - 16 < data.ceo.y then
                data.follow_bees = true
            end

            if data.follow_bees then
                data.ceo:set_position(data.ceo.x, data.bee1.y - 16)
                data.ceo.spr:set_animation("airborne")
            end

            if data.bee1.vy > 0 then
                data.sweat_timer = data.sweat_timer + dt
                if data.sweat_timer > 0.15 then
                    Particles:sweat(data.bee1.x - 12, data.bee1.y - 20, true)
                    Particles:sweat(data.bee3.x + 12, data.bee3.y - 20, false)
                    data.sweat_timer = 0
                end

                data.bee1.spr:update_offset(random_neighbor(1), random_neighbor(1))
                data.bee2.spr:update_offset(random_neighbor(1), random_neighbor(1))
                data.bee3.spr:update_offset(random_neighbor(1), random_neighbor(1))
            end
        end,
        exit = function(cutscene, data)
            data.bee1.spr:update_offset(0, 0)
            data.bee2.spr:update_offset(0, 0)
            data.bee3.spr:update_offset(0, 0)
        end
    }),
    CutsceneScene:new({
        description = "",

        duration = 1.2,
        enter = function(cutscene, data)
            data.has_shaken = false
        end,
        update = function(cutscene, data, dt)
            data.bee1.vy = data.bee1.vy - 2500 * dt
            data.bee2.vy = data.bee2.vy - 2500 * dt
            data.bee3.vy = data.bee3.vy - 2500 * dt

            data.ceo:set_position(data.ceo.x, data.bee1.y - 20)

            if data.bee1.y < game.level.cabin_inner_rect.ay and not data.has_shaken then
                data.has_shaken = true
                game:screenshake(12)
                Particles:image(data.bee2.x, game.level.cabin_inner_rect.ay + 16, 40,
                    { images.cabin_fragment_1, images.cabin_fragment_2, images.cabin_fragment_3 }, 16, 400, 0.5, nil,
                    {
                        vx1 = -50,
                        vx2 = 50,

                        vy1 = 80,
                        vy2 = 200,
                    }
                )

                data.ceo:play_sound("sfx_w2_cutscene_roof_breaking")
            end
        end,
    }),


    CutsceneScene:new({
        description = "Give back control to players",
        duration = 0,
        enter = function(cutscene, data)
            if not Metaprogression:get("has_seen_w2_transition_cutscene") then
                game.menu_manager:set_can_pause(true)
                game.game_ui.cinematic_bars_enabled = false
                game.camera:set_target_offset(0, 0)

                for _, player in pairs(game.players) do
                    player:set_input_mode(PLAYER_INPUT_MODE_USER)
                    player:reset_virtual_controller()
                end

                Metaprogression:set("has_seen_w2_transition_cutscene", true)
            end
        end
    }),
})
