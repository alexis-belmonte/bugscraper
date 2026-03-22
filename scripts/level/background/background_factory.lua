require "scripts.util"
local images = require "data.images"
local BackgroundLayered = require "scripts.level.background.background_layered"
local BackgroundLayerParticles = require "scripts.level.background.layer.background_layer_particles"
local BackgroundLayerPattern = require "scripts.level.background.layer.background_layer_pattern"

local BackgroundFactory = BackgroundLayered:inherit()

function BackgroundFactory:init(level)
	BackgroundFactory.super.init(self, level)
	self.name = "background_factory"

	self.clear_color = COL_BLACK_BLUE

	-- self:add_layer(BackgroundLayerParticles:new(self, 1, {
	-- 	images = {images.cabin_grid}
	-- }))
	self:add_layer(BackgroundLayerPattern:new(self, 0.2, {
		pattern_images = {images._test_hexagon_small},
		pattern_x_offsets = {0, 7},
		pattern_y_offsets = {-2, -2},
		determinant_function = function(_self, x, y)
			return love.math.noise(x/100, y/100 + 10000) > 0.5
		end
	}))
	
	self:add_layer(BackgroundLayerPattern:new(self, 0.4, {
		pattern_images = {images._test_hexagon},
		pattern_x_offsets = {0, 15},
		pattern_y_offsets = {-7, -7},
		determinant_function = function(_self, x, y)
			return love.math.noise(x/100, y/100) > 0.5
		end
	}))
end

function BackgroundFactory:update(dt)
	BackgroundFactory.super.update(self, dt)
end

function BackgroundFactory:draw()
	BackgroundFactory.super.draw(self)
end

return BackgroundFactory