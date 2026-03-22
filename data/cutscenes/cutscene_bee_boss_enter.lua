local Cutscene = require "scripts.game.cutscene"
local CutsceneScene = require "scripts.game.cutscene_scene"
local LightSpotlight = require "scripts.graphics.light.light_spotlight"
local Rect = require "scripts.math.rect"
local images = require "data.images"

return Cutscene:new("bee_boss_enter", {
    CutsceneScene:new({
        duration = 1.5,
        enter = function(cutscene, data)
            game.level.slowdown_timer_override = 3.0
            game.level.opened_door_timer_override = 1.0
            game.is_light_on = false
            
            game.light_world.darkness_intensity = 0.0
            data.t = 0.0

            game.level.elevator.audience_oy_target = 0
        end,
        update = function(cutscene, data, dt)
            data.t = clamp(0.0, 1.0, data.t + dt)
            game.light_world.darkness_intensity = lerp(0, 0.85, data.t)
        end,
    }),
    CutsceneScene:new({
        duration = 0.3,
        enter = function(cutscene, data)
            game.light_world:new_light("center", LightSpotlight:new(CANVAS_WIDTH/2, -32, {
                angle = pi*0.5,
                spread = pi*0.1,
                range = 800,
                is_active = true,
            }))
            Audio:play_var("sfx_boss_intro_spotlights_01", nil, 1.05)
        end,
    }),
    CutsceneScene:new({
        duration = 0.3,
        enter = function(cutscene, data)
            game.light_world:new_light("left", LightSpotlight:new(500, -32, {
                angle = pi*0.7, 
                spread = pi*0.05, 
                range = 800, 
                is_active = true,
            }))
            Audio:play_var("sfx_boss_intro_spotlights_02", nil, 1.05)
        end,
    }),
    CutsceneScene:new({
        duration = 0.3,
        enter = function(cutscene, data)
            game.light_world:new_light("right", LightSpotlight:new(CANVAS_WIDTH - 500, -32, {
                angle = pi*0.3, 
                spread = pi*0.05, 
                range = 800, 
                is_active = true,
            }))
            Audio:play_var("sfx_boss_intro_spotlights_03", nil, 1.05)
        end,
    }),
    CutsceneScene:new({
        duration = 1.1,
        enter = function(cutscene, data)
        end,
    }),
    CutsceneScene:new({
        duration = 0,
        enter = function(cutscene, data)
            if not Options:get("skip_boss_intros") then
                game.menu_manager:set_menu("w2_boss_intro")
            end
        end,
    }),
    CutsceneScene:new({
        enter = function(cutscene, data)
            game.level.slowdown_timer_override = nil
            game.level.opening_door_timer_override = nil
            game.level.opened_door_timer_override = nil
            
            local light_settings = {
                ["left"] = {1, pi/12},
                ["right"] = {0.7, pi/12},
                ["center"] = {1.23, pi/12},
            }

            for name, light in pairs(game.light_world.lights) do
                light.oscillation_enabled = true
                light.oscillation_speed = light_settings[name][1]
                light.oscillation_amplitude = light_settings[name][2]
            end

            local boss
            for _, actor in pairs(game.actors) do
                if actor.name == "bee_boss" then
                    boss = actor
                    break
                end
            end
            if boss then
                game.light_world.lights.center.target = boss
            end
        end,
    }),
    CutsceneScene:new({
        update = function(cutscene, data, dt)
            game.light_world.darkness_intensity = move_toward(game.light_world.darkness_intensity, 0.4, 0.3*dt)
        end
    }),
})