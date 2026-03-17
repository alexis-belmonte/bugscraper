require "scripts.util"
local Class = require "scripts.meta.class"
local TextMenuItem = require "scripts.ui.menu.items.text_menu_item"
local Ui = require "scripts.ui.ui"
local images = require "data.images"

local Menu = Class:inherit()

function Menu:init(game, title, items, bg_color, prompts, extra_draw, params)
	params = params or {}
	self.title = Text:parse(title)
	self.items = {}
	self.is_menu = true

	local th = params.item_separation or (get_text_height() + 2)
	self.height = (#items - 1) * th

	for i, parms in pairs(items) do
		local parm1 = parms[1]
		if type(parm1) == "string" then
			self.items[i] = TextMenuItem:new(i, CANVAS_WIDTH / 2, (i - 1) * th, unpack(parms))
		else
			local class = table.remove(parms, 1)
			self.items[i] = class:new(i, CANVAS_WIDTH / 2, (i - 1) * th, unpack(parms))
		end
	end

	self.bg_color = bg_color or { 1, 1, 1, 0 }
	self.blur_enabled = true
	self.padding_y = 64
	self.padding_y_top = self.padding_y
	self.padding_y_bottom = 32 + 24

	self.prompts = prompts or {}
	self.second_layer = love.graphics.newCanvas(CANVAS_WIDTH, CANVAS_HEIGHT)

	self.is_scrollable = self.height > (CANVAS_HEIGHT - self.padding_y)
	if self.is_scrollable then
		self.def_y = -self.padding_y
	else
		local center = self.padding_y_top + (CANVAS_HEIGHT - self.padding_y_top - self.padding_y_bottom) / 2
		self.def_y = -center + self.height / 2
	end

	self.scroll_position = self.def_y
	self.target_scroll_position = self.def_y
	
	self.draw_sawtooth_border = true
	self.sawtooth_scroll = 0
	self.sawtooth_color = COL_BLACK_BLUE
	self.border_scroll_speed = -14

	self.is_backable = param(params.is_backable, true)

	self.do_pause_music_mode = true

	self.extra_update = params.update or function(_, _) end
	self.extra_draw = extra_draw or function() end
end

function Menu:update(dt)
	if self.is_scrollable then
		self.scroll_position = lerp(self.scroll_position, self.target_scroll_position, 0.3)
	end
	
	for i, item in pairs(self.items) do
		item.y = item.def_y - self.scroll_position
		item:update(dt)
	end
end

function Menu:draw()
	for i, item in pairs(self.items) do
		if item.is_visible and not item.is_selected then
			item:draw()
		end
	end
	for i, item in pairs(self.items) do
		if item.is_visible and item.is_selected then
			item:draw()
		end
	end

	if self.draw_sawtooth_border then
		Ui:draw_sawtooth_border(36, 24, game.menu_manager.sawtooth_scroll, {color = self.sawtooth_color or COL_BLACK_BLUE, image_bottom = images.sawtooth_separator_small})
	end

	print_centered_outline(COL_LIGHTEST_GRAY, COL_BLACK_BLUE, self.title, CANVAS_WIDTH/2, 14)
	self:draw_prompts()
	if self.extra_draw then self.extra_draw() end
end

function Menu:on_set(is_back)
	for i, item in pairs(self.items) do
		item:on_set(is_back)
		if item.ox then
			item.ox = 20 * (is_back and -1 or 1)
		end
		item.is_selected = false
	end

	self:set_scroll_position(self.def_y)
end

function Menu:on_unset()
end

function Menu:textinput()
end

function Menu:set_target_scroll_position(value)
	self.target_scroll_position = clamp(value, -self.padding_y, self.height - CANVAS_HEIGHT + self.padding_y)
end

function Menu:set_scroll_position(value)
	self:set_target_scroll_position(value)
	self.scroll_position = self.target_scroll_position
end

function Menu:draw_prompts()
	local x = 4
	local rect_h = 18
	local def_y = CANVAS_HEIGHT - rect_h
	local y = def_y

	local old_canvas = love.graphics.getCanvas()
	love.graphics.setCanvas(self.second_layer)
	love.graphics.clear()

	local bottom_width = 0
	local top_width = 0
	for i, prompt in ipairs(self.prompts) do
		if #prompt >= 2 then
			local actions, text = prompt[1], prompt[2]
			local user_n = Input:get_last_ui_user_n() -- scotch
			if Input:get_user(user_n) == nil then
				local function find_first_valid_player()
					for i = 1, MAX_NUMBER_OF_PLAYERS do
						if Input:get_user(i) then
							return i
						end
					end
					return -1
				end
				user_n = find_first_valid_player()
			end
			local new_x = Input:draw_input_prompt(user_n, actions, text, COL_LIGHTEST_GRAY, x, y)
			x = new_x + 8
		end
	end

	love.graphics.setCanvas(old_canvas)
	-- rect_color({0,0,0,0.7}, "fill", 0, def_y, x, rect_h)
	love.graphics.draw(self.second_layer, 0, 0)
end

return Menu