require "scripts.util"
local TextMenuItem = require "scripts.ui.menu.items.text_menu_item"
local InputButton = require "scripts.input.input_button"
local images = require "data.images"

local ControlsMenuItem = TextMenuItem:inherit()

function ControlsMenuItem:init(i, x, y, player_n, profile_id, input_type, action_name, label_text, params)
	params = params or {}
	ControlsMenuItem.super.init(self, i, x, y, action_name)

	self.player_n = player_n
	self:set_label_text(label_text or action_name)
	self.profile_id = profile_id
	self.input_type = input_type
	self.action_name = action_name
	self.is_ui_action = is_in_table(UI_ACTIONS, self.action_name)

	self.avoid_collisions = param(params.avoid_collisions, {})
	
	self.scancode = nil
	
	self.is_waiting_for_input = false
	self.waiting_timer = 0.0
	self.waiting_duration = 8.0
	self.is_selectable = true

	self.t = 0.0
end

function ControlsMenuItem:update(dt)
	ControlsMenuItem.super.update(self, dt)
	
	self:set_value_text("[ERROR]")

	self.value = self:get_buttons()
	self:set_value_text("")

	if self.is_waiting_for_input then
		self:set_annotation("{menu.options.input_submenu.press_again_to_remove}")
	else
		self:set_annotation(nil)
	end
	
	self.waiting_timer = max(0.0, self.waiting_timer - dt)
	if self.is_waiting_for_input and self.waiting_timer <= 0 then
		self:stop_waiting()
	end

	self.t = self.t + dt
end

function ControlsMenuItem:draw_value_text()
	local right_bound = CANVAS_WIDTH - game.menu_manager:get_menu_padding() + self.ox - 16
	local y = math.floor(self.y + self.oy + 2)

	if not self.is_waiting_for_input and (type(self.value) == "table" and #self.value == 0) then
		local text = Text:text("menu.options.input_submenu.no_buttons")
		local w = get_text_width(text)
		print_ycentered(text, right_bound - w, y)

	else
		local x = right_bound
		local i = 1
		for _, button in pairs(self.value) do
			if button.type == self.input_type then
				x = self:draw_button_icon(i, button, x, y)
				i = i + 1
			end
		end

		if self.is_waiting_for_input and self.t % 0.5 < 0.3 then
			local text = Text:text("menu.options.input_submenu.press_button")
			local w = get_text_width(text)
			print_ycentered(text, x - w, y)
		end
	end
end

local BUTTON_ICON_MARGIN = 4

function ControlsMenuItem:draw_button_icon(i, button, x, y)
	local img = Input:get_button_icon(self.player_n, button)

	if img ~= nil then
		local icon_draw_func = ternary(self.is_selected,
			function(_img, _x, _y) 
				local col = Input:get_last_ui_player_colors()
				draw_with_outline(col, "round", _img, _x, _y) 
			end,
			function(_img, _x, _y) love.graphics.draw(_img, _x, _y) end
		)
		if i == 1 then
			icon_draw_func = function(_img, _x, _y) 
				draw_with_outline(COL_WHITE, "round", _img, _x, _y) 
			end
		end

		local width = img:getWidth()
		local height = img:getHeight()
		icon_draw_func(img, x - width, y - height/2)
		return x - width - BUTTON_ICON_MARGIN
	end
	return x
end

function ControlsMenuItem:get_profile()
	return Input:get_input_profile(self.profile_id)
end

function ControlsMenuItem:get_buttons()
	return self:get_profile():get_buttons(self.action_name, self.input_type)
end

function ControlsMenuItem:on_click()
	if self.is_waiting_for_input then return end
	if not self.is_selectable then return end

	-- Go in standby mode
	Options:update_options_file()
	Audio:play("ui_menu_select_{01-04}")
	self.oy = -self.selected_anim_offset
	
	Input:set_standby_mode(true)
	self.is_waiting_for_input = true
	self.waiting_timer = self.waiting_duration
end

function ControlsMenuItem:keypressed(key, scancode)
	-- if scancode == "escape" then
	-- 	self.is_waiting_for_input = false
	-- 	Input:set_standby_mode(false)
	-- end
	
	-- Apply new key control
	self:on_button_pressed(InputButton:new(INPUT_TYPE_KEYBOARD, scancode))
end

function ControlsMenuItem:gamepadpressed(joystick, buttoncode)
	-- if Input:get_user(self.player_n) and self.player_n ~= Input:get_joystick_user_n(joystick) then
	-- 	return
	-- end
	
	self:on_button_pressed(InputButton:new(INPUT_TYPE_CONTROLLER, buttoncode))
end

function ControlsMenuItem:gamepadaxis(joystick, axis, value)
	-- if Input:get_user(self.player_n) and self.player_n ~= Input:get_joystick_user_n(joystick) then
	-- 	return
	-- end

	local user_n = ternary(Input:get_user(self.player_n) == nil, Input:get_joystick_user_n(joystick), self.player_n)

	local key_name = Input:axis_to_key_name(axis, value)
	if Input:is_axis_down(user_n, key_name) then
		self:on_button_pressed(InputButton:new(INPUT_TYPE_CONTROLLER, key_name))
	end
end

function ControlsMenuItem:mousepressed(x, y, button, istouch, presses)
	self:on_button_pressed(InputButton:new(INPUT_TYPE_KEYBOARD, "mouse"..tostring(button)))
end

function ControlsMenuItem:stop_waiting()
	self.is_waiting_for_input = false
	Input:set_standby_mode(false)
end

function ControlsMenuItem:on_button_pressed(button)
	if self.is_waiting_for_input then
		if not Input:is_allowed_button(button) then
			return
		end
		if self.input_type ~= button.type then
			return
		end

		self.oy = -self.selected_anim_offset
		self:stop_waiting()
		
		if Input:is_button_in_use(self.profile_id, self.action_name, button) then
			self:remove_action_button(button)
			return
		end
		if #self:get_buttons() >= MAX_ASSIGNABLE_BUTTONS then
			return
		end
		
		for _, potential_collision in pairs(self.avoid_collisions) do
			if Input:is_button_in_use(self.profile_id, potential_collision, button) then
				return 
			end
		end
		
		self.scancode = button.key_name
		Input:add_action_button(self.profile_id, self.action_name, button)
		Input:update_controls_file(self.profile_id)
		
		self.value = self:get_buttons()
	end
end


function ControlsMenuItem:remove_action_button(button_to_remove)
	local old_buttons = self:get_buttons()

	-- Don't allow removal of the last button for UI actions
	if self.is_ui_action and #old_buttons <= 1 then
		return
	end
	-- TODO: do not allow multiple ui actions to have the same button (especially confirm & back, which can cause softlocks)

	local new_bindings = {}
	
	for _, button in pairs(old_buttons) do
		if button.key_name ~= button_to_remove.key_name then
			table.insert(new_bindings, button)
		end
	end

	Input:set_action_buttons(self.profile_id, self.action_name, new_bindings)
end


function ControlsMenuItem:clear_buttons()
	-- NOTE: this will remove any buttons whose input type aren't the menu item's input type (I think?) 
	local old_buttons = self:get_buttons() 
	local new_bindings = {}
	for _, button in pairs(old_buttons) do
		if button.type ~= self.input_type then
			table.insert(new_bindings, button)
		end
	end

	-- keep at least one button if clearing an UI action
	if is_in_table(UI_ACTIONS, self.action_name) then
		local button = nil
		local default_buttons = self:get_profile():get_default_mappings()[self.action_name] or {}
		-- Find the last button used and add it to the new bindings
		-- for _, default_button in pairs(default_buttons) do
		for i = #old_buttons, 1, -1 do
			local old_button = old_buttons[i]
			if old_button.type == self.input_type then
				button = old_button
				break
			end
		end
		if button then
			table.insert(new_bindings, button)
		end
	end
	Input:set_action_buttons(self.profile_id, self.action_name, new_bindings)
end

return ControlsMenuItem