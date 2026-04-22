require "scripts.util"
local images = require "data.images"
local enemies = require "data.enemies"
local BackroomWithDoor = require "scripts.level.backroom.backroom_with_door"
local BackgroundCity = require "scripts.level.background.background_city"
local Rect = require "scripts.math.rect"
local Loot = require "scripts.actor.loot"

local guns = require "data.guns"

local BackroomCityOutside = BackroomWithDoor:inherit()

function BackroomCityOutside:init(params)
	params = params or {}
    BackroomCityOutside.super.init(self, params)
	self.name = "city_outside"

	self.city_background = BackgroundCity:new(self)
end

function BackroomCityOutside:generate(world_generator)
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

	game.level.show_cabin = false
end

function BackroomCityOutside:get_default_player_position(player_n)
	return 3*16, 12*16
end

function BackroomCityOutside:get_default_camera_position()
	return 0, 48
end

function BackroomCityOutside:can_exit()
	return false
end

function BackroomCityOutside:update(dt)
	BackroomCityOutside.super.update(self, dt)
end

function BackroomCityOutside:draw_background()
	self.city_background:draw()
end

function BackroomCityOutside:draw_items()
	love.graphics.draw(images.tutorial_level_back, 0, 0)
	love.graphics.draw(images.building, 16*83, 16*14 - images.building:getHeight())
end

function BackroomCityOutside:draw_front_walls()
	love.graphics.draw(images.tutorial_level, 0, 0)
	love.graphics.draw(images.tutorial_house, 0, -16*5)
end

return BackroomCityOutside