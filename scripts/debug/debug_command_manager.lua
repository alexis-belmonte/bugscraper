require "scripts.util"
local Class           = require "scripts.meta.class"
local DebugCommand    = require "scripts.debug.debug_command"
local enemies         = require "data.enemies"
local utf8            = require 'utf8'
local cutscenes       = require 'data.cutscenes'
local upgrades        = require 'data.upgrades'
local skins           = require "data.skins"
local skin_name_to_id = require "data.skin_name_to_id"
local BackroomBasement = require "scripts.level.backroom.backroom_basement"
local BackroomCredits = require "scripts.level.backroom.backroom_credits"
local achievements    = require "data.achievements"

local DebugCommandManager = Class:inherit()

function DebugCommandManager:init()
    self.commands = {}
    self.commands["help"] = DebugCommand:new {
        name = "help",
        description = "Prints help",
        args = {},
        run = function()
            for i, command_name in pairs(self.all_commands) do
                local command = self.commands[command_name]
                self:add_message(string.format("- %s: %s", command.signature, command.description))
            end
        end
    }

    local enemies_keys = table_keys(enemies)
    local cutscenes_keys = table_keys(cutscenes)
    local achievements_keys = {}
    for _, ach in pairs(achievements) do
        table.insert(achievements_keys, ach.name)
    end
    table.insert(achievements_keys, "*")

    local upgrades_keys = table_keys(upgrades)
    for i, u in pairs(upgrades_keys) do
        upgrades_keys[i] = utf8.sub(u, 8, #u)
    end

    table.sort(enemies_keys)

    self.commands["listupgrades"] = DebugCommand:new {
        name = "listupgrades",
        description = "Lists all upgrades",
        args = {},
        run = function(name, x, y)
            local upgrade_keys = {}
            for _, upgrade_name in pairs(Metaprogression:get("upgrades")) do
                table.insert(upgrade_keys, upgrades[upgrade_name]:new().name)
            end
            table.sort(upgrade_keys)

            for _, k in pairs(upgrade_keys) do
                self:add_message(concat(" - ", k))
            end
            return true
        end,
    }
    self.commands["upgrade"] = DebugCommand:new {
        name = "upgrade",
        description = "Applies an upgrade",
        args = {
            { "name:string", values = upgrades_keys },
        },
        run = function(name, x, y)
            local upgrade_class = upgrades["Upgrade" .. tostring(name)]
            if not upgrade_class then
                return false, "Upgrade '" .. name .. "' not found"
            end

            local upgrade = upgrade_class:new()
            game:apply_upgrade(upgrade)
            self:add_message("Applied upgrade '" .. name .. "'")

            return true
        end,
    }
    self.commands["randomupgrades"] = DebugCommand:new {
        name = "randomupgrades",
        description = "Applies a number of random upgrades",
        args = {
            { "number:number", default = 1 },
        },
        run = function(number)
            local unlocked_upgrades = Metaprogression:get("upgrades")
            if #unlocked_upgrades < number then
                return false, concat("Number too large: must be smaller or equal to ", #unlocked_upgrades)
            end
            local bag = copy_table_shallow(unlocked_upgrades)
            shuffle_table(bag)

            local applied = ""
            for i = 1, number do
                local upgrade = upgrades[bag[i]]:new()
                game:apply_upgrade(upgrade)

                applied = applied .. upgrade.name .. ", "
            end

            self:add_message("Applied upgrades: " .. applied)

            return true
        end,
    }
    self.commands["spawn"] = DebugCommand:new {
        name = "spawn",
        description = "Spawns an enemy",
        args = {
            { "name:string",   values = enemies_keys },
            { "amount:number", default = 1 },
            { "x:number",      default = CANVAS_WIDTH / 2 },
            { "y:number",      default = CANVAS_HEIGHT / 2 },
        },
        run = function(name, amount, x, y)
            local enemy_class = enemies[name]
            if not enemy_class then
                return false, "Enemy '" .. name .. "' not found"
            end

            for i = 1, amount do
                local enemy = enemy_class:new(x, y)
                game:new_actor(enemy)
                self:add_message("Spawned '" .. name .. "'")
            end

            return true
        end,
    }
    self.commands["cutscene"] = DebugCommand:new {
        name = "cutscene",
        description = "Plays a cutscene",
        args = {
            { "name:string", values = cutscenes_keys },
        },
        run = function(name, x, y)
            local cutscene = cutscenes[name]
            if not cutscene then
                return false, "Cutscene '" .. name .. "' not found"
            end

            game:play_cutscene(name)
            self:add_message("Played cutscene '" .. name .. "'")

            return true
        end,
    }
    self.commands["achievement"] = DebugCommand:new {
        name = "achievement",
        description = "Grants an achievement",
        args = {
            { "action:string", values = {"grant", "revoke", "g", "r"} },
            { "name:string", values = achievements_keys },
        },
        run = function(action, name)
            if not is_in_table({"grant", "revoke", "g", "r"}, action) then
                return false, "Invalid action '" .. tostring(action) .. "'"
            end
            if not is_in_table(achievements_keys, name) then
                return false, "Achievement '" .. name .. "' not found "
            end

            if action == "grant" or action == "g" then
                if name == "*" then
                    Achievements:grant_all()
                    self:add_message("Granted all achievements")
                else
                    Achievements:grant(name)
                    self:add_message("Granted achievement '" .. name .. "'")
                end
                
            elseif action == "revoke" or action == "r" then
                if name == "*" then
                    Achievements:revoke_all()
                    self:add_message("Revoked all achievements")
                else
                    Achievements:revoke(name)
                    self:add_message("Revoked achievement '" .. name .. "'")
                end
            end

            return true
        end,
    }
    self.commands["kill"] = DebugCommand:new {
        name = "kill",
        description = "Kills a player",
        args = {
            { "player_n:number", default = 1 },
        },
        run = function(player_n)
            local player = game.players[player_n]
            if not player then
                return false, "Player " .. tostring(player_n) .. " doesn't exist"
            end

            player:kill()
            self:add_message("Killed player " .. tostring(player_n) .. "")

            return true
        end,
    }
    
    self.commands["kick"] = DebugCommand:new {
        name = "kick",
        description = "Kicks a player",
        args = {
            { "player_n:number", default = 0 },
        },
        run = function(player_n)
            if player_n == 0  then
                for i=1, MAX_NUMBER_OF_PLAYERS do
                    game:leave_game(i)
                    self:add_message("Kicked player " .. tostring(player_n) .. "")
                end
                return true

            end
            local player = game.players[player_n]
            if not player then
                return false, "Player " .. tostring(player_n) .. " doesn't exist"
            end

            self:add_message("Kicked player " .. tostring(player_n) .. "")

            game:leave_game(player_n)

            return true
        end,
    }
    self.commands["revive"] = DebugCommand:new {
        name = "revive",
        description = "Revives a player",
        args = {
            { "player_n:number", default = 1 },
            { "x:number", default = CANVAS_CENTER[1] },
            { "y:number", default = CANVAS_CENTER[2] },
        },
        run = function(player_n, x, y)
            if not Input:get_user(player_n) then
                return false, "User " .. tostring(player_n) .. " doesn't exist"
            end

            game:revive_player(player_n, x, y)
            self:add_message("Revived player " .. tostring(player_n) .. "")

            return true
        end,
    }
    self.commands["say"] = DebugCommand:new {
        name = "say",
        description = "Send a message in the chat",
        args = {
            { "message:string" },
        },
        run = function(message)
            self:add_message(message)
            return true
        end,
    }
    self.commands["print"] = DebugCommand:new {
        name = "print",
        description = "Prints text to the console",
        args = {
            { "text:string" },
        },
        run = function(text)
            print(text)
            return true
        end,
    }

    self.commands["score"] = DebugCommand:new {
        name = "score",
        description = "Grants some amount of score",
        args = {
            { "number:number" },
        },
        run = function(number)
            if not number then
                return false, "Invalid number"
            end
            game.score = game.score + number
            self:add_message(concat("Added ", number, " to the score"))
            return true
        end,
    }

    self.commands["xp"] = DebugCommand:new {
        name = "xp",
        description = "Grants some amount of xp",
        args = {
            { "number:number" },
        },
        run = function(number)
            if not number then
                return false, "Invalid number"
            end
            Metaprogression:add_xp(number)
            self:add_message(concat("Added ", number, " to the xp"))
            return true
        end,
    }

    self.commands["menu"] = DebugCommand:new {
        name = "menu",
        description = "Sets the menu",
        args = {
            { "name:string" }, -- Menu keys can't be set since the menus are loaded at the same time as the debug menu... to fix later
        },
        run = function(name)
            local success, err = game.menu_manager:set_menu(name)
            if not success then
                return false, err
            end

            game.menu_manager:set_menu(name)
            self:add_message(concat("Set menu to '", name, "'"))
            return true
        end,
    }

    local skin_names = table_keys(skin_name_to_id)
    self.commands["unlock_skin"] = DebugCommand:new {
        name = "unlock_skin",
        description = "Unlocks a skin",
        args = {
            { "skin_name:string", values = skin_names },
        },
        run = function(skin_name)
            if not skin_name then
                return false, "No skin given"
            end
            local skin_id = skin_name_to_id[skin_name]
            if not skin_id then
                return false, concat("Skin '", skin_name, "' doesn't exit")
            end

            Metaprogression:unlock_skin(skin_id)
            self:add_message(concat("Unlocked skin '", skin_name, "'"))
            return true
        end,
    }

    self.commands["fury"] = DebugCommand:new {
        name = "fury",
        description = "Enables fury",
        args = {
        },
        run = function()
            game.level.fury_bar = game.level.fury_max
            self:add_message(concat("Enabled fury"))
            return true
        end,
    }

    self.commands["resetstats"] = DebugCommand:new {
        name = "resetstats",
        description = "Resets stats",
        args = {
        },
        run = function()
            Stats:reset()
            self:add_message(concat("Reset stats"))
            return true
        end,
    }

    self.commands["_credits"] = DebugCommand:new {
        name = "_credits",
        description = "Starts credits",
        args = {
        },
        run = function()
            game:new_game({ 
                backroom = BackroomCredits:new(),
                iris_params = {0, 0, 0, 0, 0}
            })

            self:add_message(concat("Enabled rocket backroom"))
            return true
        end,
    }

    self.commands["_rocket_backroom"] = DebugCommand:new {
        name = "_rocket_backroom",
        description = "Enables rocket backroom",
        args = {
        },
        run = function()
            game.level:begin_backroom(BackroomBasement:new())
            game.level:set_backroom_on()

            self:add_message(concat("Enabled rocket backroom"))
            return true
        end,
    }

    self.commands["_spawn_upgrades"] = DebugCommand:new {
        name = "_spawn_upgrades",
        description = "Spawns a bunch of upgrades",
        args = {
        },
        run = function(text)
            local upgrades_keys = copy_table_shallow(table_keys(upgrades))
            table.sort(upgrades_keys)
            local i = 0
            for _, name in pairs(upgrades_keys) do
                local upgrade = upgrades[name]
                local a = enemies.UpgradeDisplay:new(128 + i * 42, 220)
                game:new_actor(a)
                a:assign_upgrade(upgrade:new())
                i = i + 1
            end
            return true
        end,
    }
    self.commands["_weaken_all"] = DebugCommand:new {
        name = "_weaken_all",
        description = "Sets life of all enemies to 1 HP",
        args = {
            { "hp:number", default = 1 },
        },
        run = function(hp)
            hp = hp or 1
            for _, actor in pairs(game.actors) do
                if actor.is_enemy and actor.life then
                    actor.life = hp
                end
            end
            return true
        end,
    }
    self.commands["_set_smashbros_probability"] = DebugCommand:new {
        name = "_weaken_all",
        description = "Sets the probability of occurence of the Smash Bros easter egg",
        args = {
            { "prob:number" },
        },
        run = function(prob)
            SMASH_EASTER_EGG_PROBABILITY = prob
            return true
        end,
    }
    self.commands["_set_camera_offset_x"] = DebugCommand:new {
        name = "_set_camera_offset_x",
        description = "Pans camera to the extreme left edge of the play space",
        args = {
        },
        run = function(prob)
    		game.camera:set_target_offset(-100000, 0)
            return true
        end,
    }
    self.commands["_test_sub"] = DebugCommand:new {
        name = "_test_sub",
        description = "",
        args = {
            { "pattern:string" }
        },
        run = function(pattern)
            local success = nil

            local npattern = pattern:gsub("{(.-)%-(.-)}", function(a_str, b_str)
                if not (type(a_str) == "string") then
                    success = "argument 1 is not a string"
                    return ""
                end
                if not (type(b_str) == "string") then
                    success = "argument 2 is not a string"
                    return ""
                end
                local len = math.max(#a_str, #b_str)


                local a = tonumber(a_str)
                local b = tonumber(b_str)
                if not (type(a) == "number") then
                    success = "argument 1 is not a number ('" .. tostring(pattern) .. "')"
                    return ""
                end
                if not (type(b) == "number") then
                    success = "argument 2 is not a number ('" .. tostring(pattern) .. "')"
                    return ""
                end
                local n = random_range_int(a, b)
                return string.format("%0" .. len .. "d", n)
            end)

            if success ~= nil then
                return false, success
            end

            self:add_message(npattern)
            return true
        end,
    }
    self.commands["_chaotic_inputs"] = DebugCommand:new {
        name = "_chaotic_inputs",
        description = "Enables chaotic inputs for player n",
        args = {
            { "action:string", default="enable", values={"e", "enable", "d", "disable"} },
            { "player_n:number", default=1 },
        },
        run = function(action, player_n)
            if not is_in_table({"e", "enable", "d", "disable"}, action) then
                return false, "Invalid action " .. tostring(action)
            end

            local player = game.players[player_n]
            if not player then
                return false, "Player " .. tostring(player_n) .. " doesn't exist"
            end

            player.do_chaotic_inputs = (action == "e" or action == "enable")
            self:add_message("Set " .. tostring(player_n) .. " chaotic input to "..tostring( (action == "e" or action == "enable")))

            return true
        end,
    }

    self.messages = {}
    self.max_messages = 28

    self.all_commands = table_keys(self.commands)
    table.sort(self.all_commands)

    self:add_message("Please do NOT report to me any bugs related to the debug menu. I will NOT fix them!")
    self:add_message("Type 'help' for help")
end

function DebugCommandManager:filter_argument_completion(argument, possible_values)
    if argument == nil then
        return possible_values
    end

    local output = {}
    for i = 1, #possible_values do
        local command = possible_values[i]
        if utf8.sub(argument, 1, #argument) == utf8.sub(command, 1, #argument) then
            table.insert(output, command)
        end
    end
    return output
end

function DebugCommandManager:get_autocomplete(input)
    local function get_autocomplete_unsorted()
        local args = split_str(input, " ", true)
        -- local last_arg_index = #args - 1

        if #args == 0 then
            return self.all_commands
        end

        local last_arg = args[#args]
        local len_args = #args

        if len_args == 1 then
            return self:filter_argument_completion(last_arg, self.all_commands)
        elseif len_args >= 2 then
            local command = self.commands[args[1]]
            if not command then return {} end
            local arg = command.args[len_args - 1] --TODO this won't work with subcommands

            if not arg then return {} end
            if not arg.values then return {} end
            return self:filter_argument_completion(last_arg, arg.values)
        end

        return {}
    end

    local compl = copy_table_shallow(get_autocomplete_unsorted())
    table.sort(compl)
    return compl
end

function DebugCommandManager:add_message(message)
    local message_tab = {}
    if type(message) == "string" then
        message_tab = {
            color = COL_WHITE,
            content = message,
        }
    elseif type(message) == "table" then
        message_tab.color = message.color or COL_WHITE
        message_tab.content = message.content or ""
    end

    table.insert(self.messages, message_tab)

    if #self.messages > self.max_messages then
        table.remove(self.messages, 1)
    end
end

function DebugCommandManager:run(command_name, ...)
    local function run_command(...)
        if not command_name then
            return false, "No command name was given."
        end

        local command = self.commands[command_name]
        if not command then
            return false, "Command " .. command_name .. " doesn't exist"
        end

        local success, err_message = command:run(...)
        return success, err_message
    end

    local success, err_message = run_command(...)
    if not success then
        self:add_message({ color = COL_LIGHT_RED, content = err_message })
    end
end

return DebugCommandManager:new()
