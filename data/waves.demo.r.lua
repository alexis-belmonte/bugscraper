require "scripts.util"
local backgrounds       = require "data.backgrounds"
local enemies           = require "data.enemies"
local cutscenes         = require "data.cutscenes"
local images            = require "data.images"
local bit               = require "bit"

local Rect              = require "scripts.math.rect"
local LevelGeometry     = require "scripts.level.level_geometry"
local Wave              = require "scripts.level.wave"
local BackroomCafeteria = require "scripts.level.backroom.backroom_cafeteria"
local BackroomCEOOffice = require "scripts.level.backroom.backroom_ceo_office"
local E                 = require "data.enemies"

local ElevatorW1        = require "scripts.level.elevator.elevator_w1"
local ElevatorW2        = require "scripts.level.elevator.elevator_w2"
local ElevatorW3        = require "scripts.level.elevator.elevator_w3"
local ElevatorW4        = require "scripts.level.elevator.elevator_w4"
local ElevatorW0        = require "scripts.level.elevator.elevator_w0"
local ElevatorRocket    = require "scripts.level.elevator.elevator_rocket"

local utf8              = require "utf8"

RECT_ELEVATOR           = Rect:new(unpack(RECT_ELEVATOR_PARAMS))
RECT_CAFETERIA          = Rect:new(unpack(RECT_CAFETERIA_PARAMS))
RECT_CEO_OFFICE         = Rect:new(unpack(RECT_CEO_OFFICE_PARAMS))

local function new_cafeteria(params)
    params = params or {}

    local run_func = params.run_func or function(...) end
    local wave_enemies = {
        { E.ShopCafeteria, 1, position = { 35*16, 13*16 }, ignore_position_clamp = true },
    }
    if params.empty_cafeteria then
        wave_enemies = {}
    end

    return Wave:new({
        floor_type = FLOOR_TYPE_CAFETERIA,
        roll_type = WAVE_ROLL_TYPE_FIXED,
        music = "cafeteria",
        ambience = "cafeteria",
        push_music_buffer = true, 

        run = function(self, level)
            for _, actor in pairs(game.actors) do
                if actor.name == "poison_cloud" then
                    actor.lifespan = 1
                end
                if actor.name == "floor_hole_spawner" or actor.name == "pendulum" then
                    actor:remove()
                end
            end

            for i=1, MAX_NUMBER_OF_PLAYERS do
                if game.waves_until_respawn[i][2] then
                    game.waves_until_respawn[i][1] = -1
                end
            end

            run_func(self, level)
        end,

        min = 1,
        max = 1,
        enemies = wave_enemies,

        backroom = BackroomCafeteria,
        backroom_params = {
            ceo_info = params.ceo_info,
            empty_cafeteria = param(params.empty_cafeteria, false)
        },

        achievements = params.achievements,
    })
end

local function new_wave(params)
    params.bounds = params.bounds or RECT_ELEVATOR
    return Wave:new(params)
end

local function get_world_prefix(n)
    return Text:text("level.world_prefix", tostring(n))
end

local function get_world_name(n)
    return Text:text("level.world_" .. tostring(n))
end

local function spawn_timed_spikes()
    local j = 0
    local x2 = CANVAS_WIDTH / 16 - 4
    for ix = 3, x2 do
        local spikes = enemies.TimedSpikes:new(ix * BW, CANVAS_HEIGHT * 0.85, 4, 1, 0.5, j * 0.2, {
            do_standby_warning = x2 - 4 <= ix
        })
        spikes.z = 3 - j / 100
        game:new_actor(spikes)
        j = j + 1
    end
end

local function spawn_timed_spikes_w5()
    local j = 0
    local x2 = CANVAS_WIDTH / 16 - 4
    for ix = 3, x2 do
        local spikes = enemies.TimedSpikes:new(ix * BW, CANVAS_HEIGHT * 0.85, 4, 0.5, 0.2, j * 0.1 + 2.0, {
            do_standby_warning = x2 - 4 <= ix
        })
        spikes.z = 3 - j / 100
        game:new_actor(spikes)
        j = j + 1
    end
end

local function get_w4_vines_points_func_2()
    return function()
        local pts = {}
        local center = (game.level.cabin_inner_rect.ax + game.level.cabin_inner_rect.bx) / 2

        local ix = 0
        for ix = 0, CANVAS_WIDTH, 16 do
            table.insert(pts, { ix, game.level.cabin_inner_rect.by - math.cos((ix-CANVAS_WIDTH/2)/32) * 24 })
        end

        return pts
    end
end

local function get_w4_vines_points_func_3()
    return function()
        local pts = {}
        local cx = (game.level.cabin_inner_rect.ax + game.level.cabin_inner_rect.bx) / 2
        local cy = (game.level.cabin_inner_rect.ay + game.level.cabin_inner_rect.by) / 2

        local theta_step = 0.4
        local a = 8
        local max_theta = 8 * math.pi
        local theta = max_theta

        while theta >= 0 do
            local r = a * theta
            local x = cx + math.cos(theta) * r
            local y = cy + math.sin(theta) * r
            table.insert(pts, {x, y})
            theta = theta - theta_step
        end

        return pts
    end
end

local function parse_waves_table(waves)
    local parsed_waves = {}

    local current_world = nil
    local current_background = nil
    local current_elevator = nil
    local current_music = nil
    for i = 1, #waves do
        local wave_params = waves[i]

        current_world = wave_params.world or current_world
        -- current_background = wave_params.background or current_background
        current_elevator = wave_params.elevator or current_elevator
        current_music = wave_params.music or current_music

        wave_params.world = current_world
        -- wave_params.background = current_background
        wave_params.elevator = current_elevator
        wave_params.music = current_music

        -- current_background = wave_params.backgroud_transition or current_background

        parsed_waves[i] = new_wave(wave_params)

    end
    return parsed_waves
end

local thorns_arc_params = {
    lightning_params = {
        style = LIGHTNING_STYLE_THORNS, 
        min_step_size = 10,
        max_step_size = 10,
        min_line_width = 0,
        max_line_width = 0,
        jitter_width = 0,
    }
}

local waves_defs = {

    {
        min = 5,
        max = 5,
        enemies = {
            { E.Larva, 3, entrances = { "main" } },
        },
        music = "w1",
        fade_out_music = false,
        ambience = "w1",

        over_title = get_world_prefix(1),
        title = get_world_name(1),
        over_title_color = COL_LIGHT_GRAY,
        title_color = {COL_LIGHTEST_GRAY, COL_WHITE, COL_MID_GRAY, COL_MID_GRAY, stacked=true},
        title_outline_color = COL_BLACK_BLUE,

        elevator = ElevatorW1,
    },


    {
        -- Woodlouse intro
        min = 4,
        max = 6,
        enemies = {
            { E.Woodlouse, 2, entrances = { "main" } },
        },
    },

    {
        min = 4,
        max = 6,
        enemies = {
            { E.Larva,     2, entrances = { "main" } },
            { E.Fly,       3, entrances = { "main" } },
            { E.Woodlouse, 2, entrances = { "main" } },
        },
    },

    {
        -- Slug intro
        min = 4,
        max = 6,
        enemies = {
            { E.Larva, 2 },
            { E.Fly,   2 },
            { E.Slug,  4 },
        },
    },


    {
        min = 3,
        max = 5,
        enemies = {
            -- Shelled Snail intro
            { E.SnailShelled, 3 },
        },
    },

    {
        min = 6,
        max = 8,
        enemies = {
            --
            { E.Larva,        4 },
            { E.Fly,          4 },
            { E.Woodlouse,    2 },
            { E.SnailShelled, 3 },
            { E.Slug,         2 },
        },
    },

    {
        min = 7,
        max = 9,
        enemies = {
            { E.SnailShelled, 4 },
            { E.SpikedFly,    3 },
            { E.Fly,          3 },
        },
    },

    {
        -- Mushroom ant intro
        roll_type = WAVE_ROLL_TYPE_FIXED,
        enemies = {
            { E.Fly,        2 },
            { E.Boomshroom, 4 },
        },
    },

    {
        min = 8,
        max = 10,
        enemies = {
            { E.Fly,          5 },
            { E.Slug,         2 },
            { E.SpikedFly,    4 },
            { E.Woodlouse,    4 },
            { E.SnailShelled, 4 },
        },
    },

    new_cafeteria(),

    {
        -- Spiked Fly intro
        min = 6,
        max = 8,
        music = "w1",
        pull_music_buffer = true, 

        enemies = {
            { E.Larva,     1 },
            { E.Fly,       2 },
            { E.SpikedFly, 4 },
        },
    },

    {
        min = 6,
        max = 8,
        enemies = {
            { E.Larva,        1 },
            { E.Fly,          2 },
            { E.SpikedFly,    2 },
            { E.Boomshroom,   4 },
            { E.Slug,         2 },
            { E.SnailShelled, 2 },
        },
    },

    {
        -- Spider intro
        min = 6,
        max = 8,
        enemies = {
            { E.Larva,  1 },
            { E.Slug,   2 },
            { E.Spider, 4 },
        },
    },

    {
        min = 6,
        max = 8,
        enemies = {
            { E.Fly,          2 },
            { E.SnailShelled, 2 },
            { E.Spider,       4 },
        },
    },

    {
        min = 8,
        max = 9,
        enemies = {
            { E.Fly,          2 },
            { E.SpikedFly,    2 },
            { E.SnailShelled, 2 },
            { E.Slug,         2 },
            { E.Spider,       4 },
        },
    },

    {
        -- Stink bug intro
        min = 5,
        max = 6,
        enemies = {
            { E.StinkBug, 3 },
        },
    },

    {
        min = 7,
        max = 9,
        enemies = {
            { E.Larva,        1 },
            { E.SpikedFly,    2 },
            { E.Boomshroom,   2 },
            { E.SnailShelled, 2 },
            { E.Spider,       2 },
            { E.StinkBug,     4 },
        },
    },

    {
        min = 8,
        max = 10,
        enemies = {
            { E.Fly,          2 },
            { E.Slug,         2 },
            { E.Woodlouse,    2 },
            { E.SpikedFly,    2 },
            { E.Boomshroom,   2 },
            { E.SnailShelled, 2 },
            { E.Spider,       2 },
            { E.StinkBug,     2 },
        },
    },

    {
        -- roll_type = WAVE_ROLL_TYPE_FIXED,
        min = 1,
        max = 1,
        enemies = {
            { E.Dung, 1, position = { CANVAS_WIDTH / 2 - 24 / 2, 200 } },
        },
        music = "boss_w1",
        cutscene = "dung_boss_enter",
    },

    new_cafeteria({ ceo_info = 1, achievements = {"ach_complete_w1"} }),
}

local waves = parse_waves_table(waves_defs)

local function sanity_check_waves()
    for i, wave in ipairs(waves) do
        assert((wave.min <= wave.max), "max > min for wave " .. tostring(i))

        for j, enemy_pair in ipairs(wave.enemies) do
            local enemy_class = enemy_pair[1]
            local weight = enemy_pair[2]

            assert(enemy_class ~= nil, "enemy " .. tostring(j) .. " for wave " .. tostring(i) .. " doesn't exist")
            assert(type(weight) == "number",
                "weight for enemy " .. tostring(j) .. " for wave " .. tostring(i) .. " isn't a number")
            assert(weight >= 0, "weight for enemy " .. tostring(j) .. " for wave " .. tostring(i) .. " is negative")
        end
    end
end

sanity_check_waves()

for i, wave in pairs(waves) do
    table.sort(wave.enemies, function(a, b) return a[2] > b[2] end)
end

return waves