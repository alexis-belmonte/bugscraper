require "scripts.util"
local Menu = require "scripts.ui.menu.menu"
local TextMenuItem = require "scripts.ui.menu.items.text_menu_item"
local images       = require "data.images"
local debug_command_manager = require "scripts.debug.debug_command_manager"
local utf8 = require 'utf8'

local DebugCommandMenu = Menu:inherit()

function DebugCommandMenu:init(game)
	DebugCommandMenu.super.init(self, game, "", {{""}}, {0, 0, 0, 0.5}, nil, nil)

	self.debug_command_manager = debug_command_manager
	
	self:init_menu()
end

function DebugCommandMenu:on_set(is_back)
	DebugCommandMenu.super.on_set(self, is_back)

	Input:set_standby_mode(true)
	self:init_menu()
end

function DebugCommandMenu:on_unset()
end

function DebugCommandMenu:init_menu()
	self.blur_enabled = false
	
	self.show_autocompletion_on_empty = false
	self.input = ""
	self.cursor_pos = 0
	self.autocompletion_cursor = 1
	self.autocomplete = {}
	self.args = {}
end

function DebugCommandMenu:keypressed(key, scancode)
	if key == 'escape' then
		Input:set_standby_mode(false)
		
		game.menu_manager:set_can_pause(false)
		game.menu_manager:unpause()
		game.menu_manager:set_menu()
		game.debug.set_can_pause_to_true_timer = 2
	end

	-- Send messages
	if key == "return" then
		self:send_input()
	end
	if key == "tab" then
		self.show_autocompletion_on_empty = true
		if #self.args > 0 and #self.autocomplete > 0 then
			self:complete_autocomplete()
		end
	end
	
	-- Backspace deletes text
	if key == 'backspace' then
		self:backspace_input(1)
	end
	if key == 'delete' then
		self:del_input(1)
	end

	-- Move cursor
	if key == 'left' then
		self:move_cursor(-1)
	end
	if key == 'right' then
		self:move_cursor(1)
	end

	if key == 'up' then
		self:move_autocompletion_cursor(-1)
	end
	if key == 'down' then
		self:move_autocompletion_cursor(1)
	end

	if key == 'v' and (love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")) then
		local clipboard = love.system.getClipboardText() or ""
		self:textinput(clipboard)
	end
end

function DebugCommandMenu:keypressedrepeat(key, scancode)
	self:keypressed(key, scancode)
end

function DebugCommandMenu:send_input()
	self.debug_command_manager:run(unpack(self.args))
	self:clear_input()
end


function DebugCommandMenu:textinput(text)
	if self.block_next_input then
		self.block_next_input = false
		return
	end

	local a = utf8.sub(self.input, 1, self.cursor_pos)
	local b = utf8.sub(self.input, self.cursor_pos+1, utf8.len(self.input))
	self.input = a..text..b
	self.cursor_pos = self.cursor_pos + utf8.len(text)	
	
	self:reset_autocompletion_cursors()
end

function DebugCommandMenu:backspace_input(n)
	local curtext = self.input
	if #curtext == 0 or self.cursor_pos == 0 then
		return 
	end

	local b = math.max(0, self.cursor_pos-n)
	local first = utf8.sub(curtext, 1, b)
	local last  = utf8.sub(curtext, self.cursor_pos+1, -1) 
	self.input = first..last
	self.cursor_pos = clamp(math.max(0, self.cursor_pos-n), 0, utf8.len(self.input))

	self:reset_autocompletion_cursors()
end

function DebugCommandMenu:del_input(n)
	local len = utf8.len(self.input)

	-- When you press "del"
	local curtext = self.input
	if #curtext == 0 or self.cursor_pos == len then
		return 
	end

	local b = math.min(len+1, self.cursor_pos+1+n)
	local first = utf8.sub(curtext, 1, self.cursor_pos)
	local last  = utf8.sub(curtext, b, -1) 
	self.input = first..last
--	self.cursor_pos = clamp(math.min(len, self.cursor_pos, 0, utf8.len(self.input))

	self:reset_autocompletion_cursors()
end

function DebugCommandMenu:clear_input()
	self.input = ""
	self.cursor_pos = 0
end

function DebugCommandMenu:move_cursor(delta)
	self.cursor_pos = clamp(self.cursor_pos + delta, 0, #self.input)
end

function DebugCommandMenu:reset_autocompletion_cursors()
	self.show_autocompletion_on_empty = false
	self:update_autocomplete()
	self.autocompletion_cursor = #self.autocomplete
end

function DebugCommandMenu:update_autocomplete()
	if #self.args == 0 and not self.show_autocompletion_on_empty then
		self.autocomplete = {}
	else
		self.autocomplete = self.debug_command_manager:get_autocomplete(self.input)
	end
end

function DebugCommandMenu:complete_autocomplete()
	if #self.args > 0 and #self.autocomplete > 0 and is_between(self.autocompletion_cursor, 1, #self.autocomplete) then
		local completion = self.autocomplete[self.autocompletion_cursor]
		local last_arg = self.args[#self.args]
		
		self.input = self.input..utf8.sub(completion, #last_arg + 1, #completion).." "
		self.cursor_pos = #self.input
	end
end

function DebugCommandMenu:move_autocompletion_cursor(delta)
	self.autocompletion_cursor = mod_plus_1(self.autocompletion_cursor + delta, #self.autocomplete)
end

function DebugCommandMenu:update(dt)
	DebugCommandMenu.super.update(self, dt)

	self.args = split_str(self.input, " ", false)
	self:update_autocomplete()
end

function DebugCommandMenu:draw()
	DebugCommandMenu.super.draw(self)

	Text:push_font(FONT_MINI)
	local text_height = get_text_height()

	local x = 4
	local y = CANVAS_HEIGHT - text_height

	-- Draw input bar
	local final_text = "> "..self.input
	rect_color({0,0,0,0.6}, "fill", 0, y, CANVAS_WIDTH, 16)
	print_outline(COL_WHITE, COL_BLACK_BLUE, final_text, x, y)
	
	local t = 1
	if love.timer.getTime() % t < t/2 then
		local substr = utf8.sub(self.input, 1, self.cursor_pos)
		local cursor_x = get_text_width(substr) + get_text_width("> ") + x
		love.graphics.setColor(1,1,1)
		love.graphics.rectangle("fill", cursor_x,y, 2,32)
	end 

	-- Draw messages
	local msg_y = y
	for i = #self.debug_command_manager.messages, 1, -1 do
		local message = self.debug_command_manager.messages[i]
		local msg_w = get_text_width(message.content)
		local msg_h = get_text_height(message.content)

		msg_y = msg_y - msg_h

		rect_color({0, 0, 0, 0.6}, "fill", 0, msg_y, x + msg_w + 4, msg_h)
		print_outline(message.color or COL_WHITE, COL_BLACK_BLUE, message.content, x, msg_y)
	end

	-- Autocomplete
	local autocomplete_y = y
	for i = #self.autocomplete, 1, -1 do
		local message = self.autocomplete[i]
		local msg_w = get_text_width(message)
		local msg_h = get_text_height(message)

		autocomplete_y = autocomplete_y - msg_h

		local color = ternary(self.autocompletion_cursor == i, COL_WHITE, COL_MID_GRAY)

		rect_color({0, 0, 0, 1}, "fill", 0, autocomplete_y, x + msg_w + 4, msg_h)
		print_outline(color, COL_BLACK_BLUE, message, x, autocomplete_y)
	end

	Text:pop_font()
end

return DebugCommandMenu