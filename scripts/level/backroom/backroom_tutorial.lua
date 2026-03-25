require "scripts.util"
local images = require "data.images"
local enemies = require "data.enemies"
local BackroomWithDoor = require "scripts.level.backroom.backroom_with_door"
local BackgroundCity = require "scripts.level.background.background_city"
local Rect = require "scripts.math.rect"
local Loot = require "scripts.actor.loot"

local cutscenes = require "data.cutscenes"
local guns = require "data.guns"

local BackroomTutorial = BackroomWithDoor:inherit()

function BackroomTutorial:init(params)
	params = params or {}
    BackroomTutorial.super.init(self, params)
	self.name = "tutorial"

	self.cafeteria_background = BackgroundCity:new(self)
	self.freeze_fury = false
end

function BackroomTutorial:generate(world_generator)
	game.level:set_bounds(Rect:new(unpack(RECT_TUTORIAL_PARAMS)))
	game.draw_shadows = false

	-- Collision 
	world_generator:reset()

	world_generator:write_rect_fill(Rect:new(0,  2,  2,  20),  TILE_STONE) -- A / brick house
	world_generator:write_rect_fill(Rect:new(3,  13, 7,  20),  TILE_STONE) -- B / cobblestone house front
	world_generator:write_rect_fill(Rect:new(8,  14, 8,  20),  TILE_STONE) -- C / cobblestone stairs
	world_generator:write_rect_fill(Rect:new(6,  15, 96, 20),  TILE_STONE) -- D / cobblestone plaza
	world_generator:write_rect_fill(Rect:new(25, 13, 32, 14),  TILE_STONE) -- E / concrete raised part
	world_generator:write_rect_fill(Rect:new(32, 6,  32, 12),  TILE_STONE) -- F / brick wall
	world_generator:write_rect_fill(Rect:new(47, 0,  47, 5),   TILE_STONE) -- G / brick wall top
	world_generator:write_rect_fill(Rect:new(54, 6,  56, 6),   TILE_METAL_SEMISOLID) -- H / metal platform overhang
	world_generator:write_rect_fill(Rect:new(60, 9,  61, 12),  TILE_STONE) -- I / concrete block stairs
	world_generator:write_rect_fill(Rect:new(62, 10, 62, 12),  TILE_STONE) -- J / concrete block stairs
	world_generator:write_rect_fill(Rect:new(63, 11, 63, 12),  TILE_STONE) -- K / concrete block stairs
	world_generator:write_rect_fill(Rect:new(64, 12, 64, 12),  TILE_STONE) -- L / concrete block stairs
	world_generator:write_rect_fill(Rect:new(66, 14, 100, 14), TILE_STONE) -- M / cobble stone plaza
	world_generator:write_rect_fill(Rect:new(95, 0,  96, 13),  TILE_BORDER) -- N / invisible wall for building
	world_generator:write_rect_fill(Rect:new(57, 6,  60, 6),   TILE_METAL) -- O / metal overhang solid part
	world_generator:write_rect_fill(Rect:new(60, 7,  60, 8),   TILE_STONE) -- P / concrete brick holding up metal overhang 
	world_generator:write_rect_fill(Rect:new(85, 8,  94, 8),   TILE_STONE) -- Q / Entrance overhang
	world_generator:write_rect_fill(Rect:new(33, 13, 59, 14),  TILE_SAND) -- R / sand pit
	world_generator:write_rect_fill(Rect:new(60, 13, 65, 14),  TILE_STONE) -- S / concrete block stairs


	world_generator:write_rect_fill(Rect:new(3, 8, 3, 8),  TILE_WOOD_SEMISOLID) -- d1 / house balcony 
	
	-- Walls, dummies
	game:new_actor(enemies.BreakableWall:new(47*16, 6*16))
	game:new_actor(enemies.Dummy:new(72*16, 13*16))
	game:new_actor(enemies.Dummy:new(75*16, 13*16))
	game:new_actor(enemies.Dummy:new(78*16, 13*16))
	self.gun = game:new_actor(Loot.Gun:new(40*16, 12*16, nil, 0, 0, guns.unlootable.Machinegun:new(), {
		life = math.huge,
		min_attract_dist = -1,
		player_filter = function(player)
			return player.gun and player.gun.name == "empty_gun"
		end,
		remove_on_collect = true,
	}), 440, 105)

	-- TODO add wrning sign at 418 181
	
	-- Exit sign
	local sign = game:new_actor(enemies.ExitSign:new(50, 160))
	sign.smash_easter_egg_probability = 0

	-- Exit trigger
	game:new_actor(enemies.PlayerTrigger:new(87*16, 9*16, 8*16, 5*16, function()
		if Metaprogression:get("has_played_tutorial") then
			game:play_cutscene("tutorial_end_short")
		else
			game:play_cutscene("tutorial_end")
		end
		game.game_ui.offscreen_indicators_enabled = false

		local ax, ay, bx, by = unpack(RECT_TUTORIAL_PARAMS)
		game.level:set_bounds(Rect:new(ax, ay, bx + 4, by))
	end, {min_player_trigger = 0}))
	
	-- Camera, music, stuff
	game.camera.max_x = 67*16
	game.music_player:set_disk("off")
	game.ambience_player:set_disk("tutorial")
	game.level.show_cabin = false

	-- Start cutscene
	if not Metaprogression:get("has_seen_intro_credits") then
		game:play_cutscene("tutorial_start")
	end
end

function BackroomTutorial:get_default_player_position(player_n)
	return 3*16, 12*16
end

function BackroomTutorial:get_default_player_gun()
	return guns.unlootable.EmptyGun:new()
end

function BackroomTutorial:get_default_camera_position()
	return 0, 48
end

function BackroomTutorial:get_x_target_after_join_game()
	return 95
end

function BackroomTutorial:on_player_joined(player)
	Particles:opened_door(3*16-1, 10*16)
end

function BackroomTutorial:can_exit()
	return false
end

function BackroomTutorial:update(dt)
	BackroomTutorial.super.update(self, dt)

	if self.gun and self.gun.is_removed then
		self.gun = game:new_actor(Loot.Gun:new(40*16, 12*16, nil, 0, 0, guns.unlootable.Machinegun:new(), {
			life = math.huge,
			min_attract_dist = -1,
			player_filter = function(player)
				return player.gun and player.gun.name == "empty_gun"
			end,
			remove_on_collect = true,
		}), 440, 105)
	end
end

function BackroomTutorial:on_fully_entered()
end

function BackroomTutorial:draw_background()
	self.cafeteria_background:draw()
end

function BackroomTutorial:draw_items()
	love.graphics.draw(images.tutorial_level_back, 0, 0)
	love.graphics.draw(images.building, 16*83, 16*14 - images.building:getHeight())
	
	if not Input:get_user(1) then
		return 
	end
	-- Input:draw_input_prompt(1, {"jump"}, Text:text("input.prompts.jump"), COL_WHITE, 24*16, 8*16, {
	-- 	alignment = "center",
	-- 	background_color = transparent_color(COL_BLACK_BLUE, 0.5),
	-- })
	-- Input:draw_input_prompt(1, {"jump", "right"}, Text:text("input.prompts.wall_jump"), COL_WHITE, 32.5*16, 4*16, {
	-- 	alignment = "center",
	-- 	background_color = transparent_color(COL_BLACK_BLUE, 0.5),
	-- })
	-- Input:draw_input_prompt(1, {"shoot"}, Text:text("input.prompts.shoot"), COL_WHITE, 40*16, 9*16, {
	-- 	alignment = "center",
	-- 	background_color = transparent_color(COL_BLACK_BLUE, 0.5),
	-- })
	Input:draw_input_prompt(1, {}, "🈶 {input.prompts.jetpack}", COL_WHITE, 54*16, 4*16, {
		alignment = "center",
		background_color = transparent_color(COL_BLACK_BLUE, 0.5),
	})
end

function BackroomTutorial:draw_front_walls()
	love.graphics.draw(images.tutorial_level, 0, 0)
	love.graphics.draw(images.tutorial_house, 0, -16*5)
end

return BackroomTutorial