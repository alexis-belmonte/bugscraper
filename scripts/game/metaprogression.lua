require "scripts.util"
local Class = require "scripts.meta.class"
local upgrades = require "data.upgrades"
local skins = require "data.skins"

local MetaprogressionManager = Class:inherit()

function MetaprogressionManager:init()
    self.default_data = {
        ["$version"] = METAPROGRESSION_FILE_FORMAT_VERSION, 

        total_xp = 0,
        xp = 0,
        xp_level = 1,

        skins = { 1, 2, 3, 4 },
        upgrades = { 
            "UpgradeTea",
            "UpgradeEspresso",
            "UpgradeMilk",
            "UpgradeBoba",
            "UpgradeSoda",

            "UpgradeFizzyLemonade",
            "UpgradeHotSauce",
            "UpgradeHotChocolate",
            "UpgradeCoconutWater",
        },
        achievements = {},

		has_seen_intro_credits = false,
		has_played_tutorial = false,
		has_seen_stomp_tutorial = false,

        has_seen_w1_transition_cutscene = false,
        has_seen_w2_transition_cutscene = false,
        has_seen_w3_transition_cutscene = false,
        has_seen_w4_transition_cutscene = false,
        has_seen_w5_transition_cutscene = false,
    }

    self.levels = require "data.metaprogression_levels"

    self.data = {}
    self:read_progress()
    self:remove_duplicates({"skins", "upgrades", "achievements"})

    -- Count the number of skins / upgrades
    self.max_upgrades = #self.default_data["upgrades"]
    self.max_skins = #self.default_data["skins"]
    for _, level in pairs(self.levels) do
        for __, reward in pairs(level.rewards) do
            if reward.type == "skin" then
                self.max_skins = self.max_skins + 1
            elseif reward.type == "upgrade" then
                self.max_upgrades = self.max_upgrades + 1
            end
        end
    end

    self.old_xp = self:get_xp()
    self.old_total_xp = self:get_total_xp()
    self.old_xp_level = self:get_xp_level()
end

function MetaprogressionManager:add_xp(value)
    self.old_xp = self:get_xp()
    self.old_total_xp = self:get_total_xp()
    self.old_xp_level = self:get_xp_level()

    local new_xp = self:get_xp() + value 
    local new_level = self:get_xp_level()

    while new_xp >= self:get_xp_level_threshold(new_level) do
        new_xp = new_xp - self:get_xp_level_threshold(new_level)
        self:grant_level_rewards(new_level)
        new_level = new_level + 1
    end

    self:set_total_xp(self:get_total_xp() + value)
    self:set_xp(new_xp)
    self:set_xp_level(new_level)
end

function MetaprogressionManager:grant_level_rewards(xp_level)
    local level_info = self:get_xp_level_info(xp_level)

    if not level_info then
        return
    end

    for _, reward in pairs(level_info.rewards) do
        self:grant_reward(reward)
    end
end

function MetaprogressionManager:grant_reward(reward)
    if reward.type == "skin" then
        self:unlock_skin(reward.skin)
    elseif reward.type == "upgrade" then
        self:unlock_upgrade(reward.upgrade)
    end
end
    
function MetaprogressionManager:get_xp()
    return self:get("xp")
end

function MetaprogressionManager:set_xp(value)
    self:set("xp", value)
end
    
function MetaprogressionManager:get_total_xp()
    return self:get("total_xp")
end

function MetaprogressionManager:set_total_xp(value)
    self:set("total_xp", value)
end

function MetaprogressionManager:get_xp_level()
    return self:get("xp_level")
end

function MetaprogressionManager:set_xp_level(value)
    self:set("xp_level", value)
end

function MetaprogressionManager:get_xp_level_threshold(level)
    return (self:get_xp_level_info(level) or {}).threshold or math.huge
end

function MetaprogressionManager:get_xp_level_info(level)
    return self.levels[level or self:get_xp_level()]
end

function MetaprogressionManager:unlock_skin(skin_id)
    local s = self:get("skins")
    table.insert(s, skin_id)
    self:remove_duplicates({"skins"})
    self:save_progress()
    self:check_achievements()
end

function MetaprogressionManager:unlock_upgrade(upgrade_name)
    local tab = self:get("upgrades")
    local u = upgrades[upgrade_name]
    if u then
        table.insert(tab, upgrade_name)
        self:remove_duplicates({"upgrades"})
        self:save_progress()
        self:check_achievements()
    end
end

function MetaprogressionManager:check_achievements()
    if #self:get("upgrades") >= self.max_upgrades and BUILD_TYPE ~= "demo" then
        Achievements:grant("ach_all_upgrades")
    end
    if #self:get("skins") >= self.max_skins and BUILD_TYPE ~= "demo" then
        Achievements:grant("ach_all_skins")
    end
end

-----------------------------------------------------

function MetaprogressionManager:get(name)
    return self.data[name]
end

function MetaprogressionManager:set(name, value, do_not_save)
    self.data[name] = value
    if not do_not_save then
        self:save_progress()
    end
end

function MetaprogressionManager:reset()
    self.data = copy_table_shallow(self.default_data)
    self:save_progress()
end

function MetaprogressionManager:read_progress()
    self.data = Files:read_config_file("progress.txt", self.default_data)
end

function MetaprogressionManager:remove_duplicates(fields)
    for _, field_name in pairs(fields) do
        self.data[field_name] = remove_table_duplicates(self.data[field_name])
    end
end

function MetaprogressionManager:save_progress()
    Files:write_config_file("progress.txt", self.data)
end

return MetaprogressionManager
