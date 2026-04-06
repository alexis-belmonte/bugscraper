require "scripts.util"
local creq = require "lib.creq.creq"
local Class = require "scripts.meta.class"
local LuaSteam
local import_success

local pcall_res, err = pcall(function()
	LuaSteam = require "luasteam"
	import_success = true
end)

if pcall_res then
	print("Steamworks: successfully loaded")
else
	print("Steamworks: error during import (require failed)")
	print("Steamworks: error - ", err)
	import_success = false
end

-- Thanks to https://github.com/uspgamedev/luasteam

local Steamworks = Class:inherit()

function Steamworks:init()
	self.is_enabled = false
	self.import_success = import_success

	if not self.import_success then
		self.is_enabled = false
		return
	end
	
	self:enable()
end

function Steamworks:enable()
	if not self.is_enabled then
		return
	end
	self.is_enabled = LuaSteam.Init()
end

function Steamworks:disable()
	if not self.is_enabled then
		return
	end

	LuaSteam.Shutdown()
end

function Steamworks:update(dt)
	if not self.is_enabled then
		return
	end

	LuaSteam.RunCallbacks()
end

function Steamworks:quit()
	if not self.is_enabled then
		return
	end

	self:disable()
end

function Steamworks:set_achievement(achievement_id)
	if not self.is_enabled then
		return
	end

	LuaSteam.UserStats.SetAchievement(achievement_id)
    LuaSteam.UserStats.StoreStats()
end

function Steamworks:clear_achievement(achievement_id)
	if not self.is_enabled then
		return
	end

	LuaSteam.UserStats.ClearAchievement(achievement_id)
	LuaSteam.UserStats.StoreStats()
end

function Steamworks:reset_all_stats(achievements_too)
	if not self.is_enabled then
		return
	end

	LuaSteam.UserStats.ResetAllStats(achievements_too)
end

return Steamworks:new()