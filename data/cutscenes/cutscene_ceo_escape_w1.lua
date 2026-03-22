local Cutscene = require "scripts.game.cutscene"
local CutsceneScene = require "scripts.game.cutscene_scene"
local images = require "data.images"

return Cutscene:new("ceo_escape_w1", {
    CutsceneScene:new({
        description = "",
        
        duration = 0.1,
        enter = function(cutscene, data)
            if not Metaprogression:get("has_seen_w1_transition_cutscene") then
                game.menu_manager:set_can_pause(false)
                game.game_ui.cinematic_bars_enabled = true
                game.game_ui.cinematic_bar_color = COL_VERY_DARK_GRAY
                game.camera:set_target_offset(10000, 0)
                
                for _, actor in pairs(game.actors) do
                    if actor.is_shop then
                        actor:end_interaction(true)
                    end
                end

                for _, player in pairs(game.players) do
                    player:set_input_mode(PLAYER_INPUT_MODE_CODE)
                    player:reset_virtual_controller()
                end
            end 

            for _, actor in pairs(game.actors) do
                if actor.name == "npc" and actor.npc_name == "ceo" then
                    data.ceo = actor
                    return
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
            data.shake = math.max(0, data.shake - dt*6)
        end,
        exit = function(cutscene, data)
            data.ceo.spr:update_offset(0, 0)
        end
    }),
    CutsceneScene:new({
        description = "Shocked",
        
        duration = 1.0,
        enter = function(cutscene, data)
        end,
        update = function(cutscene, data, dt)
            if Metaprogression:get("has_seen_w1_transition_cutscene") then
                return true
            end
        end,
    }), 
    CutsceneScene:new({
        description = "Jump out of window",
        
        duration = 0.93,
        enter = function(cutscene, data)
            data.ceo.gravity = data.ceo.default_gravity
            data.ceo.friction_x = 1.0
            data.ceo.vx = -133
            data.ceo.vy = -500
            
            data.ceo.is_affected_by_bounds = false
            data.ceo.is_affected_by_walls = false
            data.old_vy = data.ceo.vy

            data.ceo.spr:set_animation("airborne")
        end,
        update = function(cutscene, data, dt)
            if data.ceo.vy >= 0 and data.old_vy < 0 then
                data.ceo.is_visible = false
                data.ceo.draw_behind_windows_in_cafeterias = true
                game:screenshake(10)
                game:frameskip(5)
                Particles:image(data.ceo.mid_x, data.ceo.mid_y, 150, images.glass_shard, 32, 400, 0.3)

                data.ceo:play_sound("sfx_w1_cutscene_glass_break")

                if game.level.backroom then
                    game.level.backroom.cafeteria_glass_hole = true
                    game.level.backroom.cafeteria_glass_hole_x = math.floor(data.ceo.mid_x - images.cafeteria_glass_hole:getWidth()/2)
                    game.level.backroom.cafeteria_glass_hole_y = math.floor(data.ceo.mid_y - images.cafeteria_glass_hole:getHeight()/2)
                end
            end

            data.old_vy = data.ceo.vy
        end
    }),
    
    CutsceneScene:new({
        description = "",
        
        duration = 1.0,
        enter = function(cutscene, data)
            data.ceo.vx = 0
            data.ceo.vy = 0
            data.ceo.gravity = 0
        end,
    }),

    CutsceneScene:new({
        description = "CEO brrrrr",
        
        duration = 3.0,
        enter = function(cutscene, data)
            data.ceo.vx = 0
            data.ceo.vy = -50
            data.ceo.gravity = 0

            data.ceo.spr:set_animation("jetpack")
            Audio:play("sfx_w1_cutscene_jetpack")

            data.update_jetpack = function(dt)
                Particles:push_layer(PARTICLE_LAYER_CAFETERIA_BACKGROUND)

                Particles:smoke_big(data.ceo.mid_x, data.ceo.y+data.ceo.h, {
                        type = "gradient",
                        COL_WHITE, COL_YELLOW, COL_ORANGE, COL_DARK_RED, COL_DARK_GRAY, COL_BLACK_BLUE
                    }, 
                    12, -- rad
                    10 -- quantity
                    -- {
                    --     vx = 0, 
                    --     vx_variation = 20, 
                    --     vy = 50, 
                    --     vy_variation = 10,
                    --     min_spawn_delay = 0,
                    --     max_spawn_delay = 0.2,
                    -- }
                )

                Particles:pop_layer()
                
                data.ceo.spr:update_offset(random_neighbor(3), random_neighbor(3))
            end
        end,
        update = function(cutscene, data, dt)
            data.update_jetpack(dt)
        end,
    }),
    
    CutsceneScene:new({
        description = "Give back control to players",
        duration = 0.0,
        enter = function(cutscene, data)
            if not Metaprogression:get("has_seen_w1_transition_cutscene") then
                game.menu_manager:set_can_pause(true)
                game.game_ui.cinematic_bars_enabled = false
                game.camera:set_target_offset(0, 0)
    
                for _, player in pairs(game.players) do
                    player:set_input_mode(PLAYER_INPUT_MODE_USER)
                    player:reset_virtual_controller()
                end

                Metaprogression:set("has_seen_w1_transition_cutscene", true)
            end
        end
    }),

    CutsceneScene:new({
        description = "CEO brrrrrr",
        
        duration = 3.0,
        update = function(cutscene, data, dt)
            data.update_jetpack(dt)
        end,
        exit = function(cutscene, data)
            if not data.ceo then
                return
            end
            data.ceo.vx = 0
            data.ceo.vy = 0
            data.ceo.gravity = 0
            data.ceo.spr:update_offset(0, 0)
        end,
    }),
    
    CutsceneScene:new({
        description = "Give back control to players",
        duration = 0.0,
        enter = function(cutscene, data)            
            if not Metaprogression:get("has_seen_w1_transition_cutscene") then
                game.game_ui.cinematic_bar_color = nil
                Metaprogression:set("has_seen_w1_transition_cutscene", true)
            end
        end
    }),
    
})