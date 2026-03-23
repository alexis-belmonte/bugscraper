require "scripts.util"
local Class = require "scripts.meta.class"
local discordRPC, discordAppId
local import_success
if pcall(function()
	discordRPC = require("lib.discordRPC.discordRPC")
	discordAppId = require("lib.discordRPC.applicationId")
end) then
	print("DiscordRPC: successfully loaded")
	import_success = true
else
	print("DiscordRPC: error during import")
	import_success = false
end

-- Thanks to https://github.com/pfirsich/lua-discordRPC/tree/master?tab=readme-ov-file
-- And also https://github.com/discord/discord-rpc/ 
-- WARNING: Discord-RPC has been deprecated for a few years now, eventually migrate to Discord GameSDK:
-- https://discord.com/developers/docs/developer-tools/game-sdk
-- Lua binding: https://github.com/yutotakano/mpvcord 

local DiscordPresence = Class:inherit()

--[[
	`state`          string (max length: 127)
	`details`        string (max length: 127)
	`startTimestamp` integer (52 bit, signed)
	`endTimestamp`   integer (52 bit, signed)
	`largeImageKey`  string (max length: 31)
	`largeImageText` string (max length: 127)
	`smallImageKey`  string (max length: 31)
	`smallImageText` string (max length: 127)
	`partyId`        string (max length: 127)
	`partySize`      integer (32 bit, signed)
	`partyMax`       integer (32 bit, signed)
	`matchSecret`    string (max length: 127)
	`joinSecret`     string (max length: 127)
	`spectateSecret` string (max length: 127)
	`instance`       integer (8 bit, signed)
]]

function DiscordPresence:init()
	self.is_enabled = false
	self.import_success = import_success

	if not self.import_success then
		self.is_enabled = false
		print("DiscordRPC: error during import")
		return
	end

	self:enable()
end

function DiscordPresence:enable()
	local now = os.time(os.date("*t"))
	self.presence = {
		startTimestamp = now,
		largeImageKey = "icon_1024x1024",
		largeImageText = "Bugscraper",
		
        partySize = 0,
        partyMax = MAX_NUMBER_OF_PLAYERS,
    }
	self.next_presence_update = 0
	
	discordRPC.initialize(discordAppId, true) --TODO remake
end

function DiscordPresence:disable()
	discordRPC.shutdown() --TODO remake
end

function DiscordPresence:update(dt)
	if not self.is_enabled then
		return
	end

	local number_players = Input:get_number_of_users()
	self.presence.partySize = number_players
	self.presence.state = ternary(
		number_players <= 1,
		Text:text("discord.state.solo"),
		Text:text("discord.state.local_multiplayer")
	)
	if game.game_state == GAME_STATE_WAITING then
		self.presence.details = Text:text("discord.details.waiting")
	elseif game.game_state == GAME_STATE_PLAYING then
		self.presence.details = Text:text("discord.details.playing", game:get_floor(), game.level.max_floor)
	elseif game.game_state == GAME_STATE_DYING then
		self.presence.details = Text:text("discord.details.dying", game.stats.floor, game.level.max_floor)
	elseif game.game_state == GAME_STATE_WIN or game.game_state == GAME_STATE_ELEVATOR_BURNING then
		self.presence.details = Text:text("discord.details.win")
	else
		self.presence.details = ""
	end

	if self.next_presence_update < love.timer.getTime() then
        discordRPC.updatePresence(self.presence) --TODO remake
        self.next_presence_update = love.timer.getTime() + 3.0
    end
    discordRPC.runCallbacks() --TODO remake
end

function DiscordPresence:quit()
	if not self.is_enabled then
		return
	end

	self:disable()
end

function DiscordPresence:ready(user_id, username, discriminator, avatar)
	self.is_enabled = true
	print(string.format("Discord RPC: ready (user_id %s, username %s, discriminator %s, avatar %s)", user_id, username, discriminator, avatar))
end

function DiscordPresence:disconnected(error_code, message)
	self.is_enabled = false
    print(string.format("Discord: disconnected (error_code %d: %s)", error_code, message))
end

function DiscordPresence:errored(error_code, message)
    print(string.format("Discord: error (error_code %d: %s)", error_code, message))
end

local discord_instance = DiscordPresence:new()

if not import_success then

	return discord_instance
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- DiscordRPC Callbacks
-------------------------------------------------------------------------------------------------------------------------------------------------------------

--TODO remake
function discordRPC.ready(userId, username, discriminator, avatar)
    discord_instance:ready(userId, username, discriminator, avatar)
end

function discordRPC.disconnected(errorCode, message)
	discord_instance:disconnected(errorCode, message)
end

function discordRPC.errored(errorCode, message)
	discord_instance:errored(errorCode, message)
end

return discord_instance

