-- Splash screen
local time_launched = love.timer.getTime()
local init = require "scripts.meta.init"
init()
----------

assert(love.graphics.newImage("images/bugscraper.png"))

require "scripts.util"
local Game = require "scripts.game.game"
local Measure = require "scripts.debug.measure"

game = nil

function love.load(args)
	LAUNCH_ARGUMENTS_RAW = args or {}
	print_table(LAUNCH_ARGUMENTS_RAW)

	LAUNCH_ARGUMENTS = {}
	for i=1, #LAUNCH_ARGUMENTS_RAW do
		LAUNCH_ARGUMENTS[LAUNCH_ARGUMENTS_RAW[i]] = true
	end
	DEBUG_MODE = DEBUG_MODE or (LAUNCH_ARGUMENTS["--debug"] or LAUNCH_ARGUMENTS["-d"])

	game = Game:new()

	local time = love.timer.getTime()
	print(              "--------------------------")
	print(string.format(" Game loaded in %d ms. ", round((time - time_launched) * 1000)))
	print(              "--------------------------")
end

local fixed_dt = 1/60 -- fixed frame delta time
_G_t = 0
_G_frame = 0
_G_fixed_frame = 0
_G_frame_by_frame_mode = false
_G_frame_repeat = 1
_G_speedup = false
_G_profiler_on = false
local max_frame_buffer_duration = fixed_dt * 2
local _frame_by_frame_mode_advance_flag = false

local measure_update = Measure:new(10000)
local function fixed_update()
	if _G_frame_by_frame_mode and not _frame_by_frame_mode_advance_flag then
		return
	else
		_frame_by_frame_mode_advance_flag = false
	end

	_G_fixed_frame = _G_fixed_frame + 1
	game:update(fixed_dt)
	
	if _G_speedup then
		_G_fixed_frame = _G_fixed_frame + 1
		for i = 1, _G_frame_repeat-1 do
			game:update(fixed_dt)
		end
	end
end

_G_do_fixed_framerate = true

function love.update(dt)
	_G_t = math.min(_G_t + dt, max_frame_buffer_duration)
	local cap = 1 
	local i = 0
	local update_fixed_dt = fixed_dt
	while (not _G_do_fixed_framerate or _G_t > update_fixed_dt) and cap > 0 do
		_G_t = _G_t - update_fixed_dt
		fixed_update()
		cap = cap - 1
		i=i+1
	end

	if game then   game.frame_repeat = i end
	_G_frame = _G_frame + 1
end

function love.draw()
	game:draw()
end

function love.keypressed(key, scancode, isrepeat)
	if isrepeat then
		love.keypressedrepeat(key, scancode)
		return
	end

	if key == "f5" then
		if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
			love.event.quit("restart")
		end

	elseif key == "f4" then
		if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
			love.event.quit()
		end

	elseif key == "return" and (love.keyboard.isDown("lalt") or love.keyboard.isDown("ralt")) then
		if Options then
			Options:toggle("is_fullscreen")
		end
	
	-- elseif scancode == "n" and (love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")) then
	elseif love.keyboard.isDown("f9") then
		if _G_frame_by_frame_mode then
			_frame_by_frame_mode_advance_flag = true
		end

	end

	if game.keypressed then  game:keypressed(key, scancode)  end
end

function love.keypressedrepeat(key, scancode)
	if game.keypressed then  game:keypressedrepeat(key, scancode)  end
end

function love.keyreleased(key, scancode)
	if game.keyreleased then  game:keyreleased(key, scancode)  end
end

function love.mousepressed(x, y, button, istouch, presses)
	if game.mousepressed then   game:mousepressed(x, y, button, istouch, presses)   end
end

function love.mousereleased(x, y, button, istouch, presses)
	if game.mousereleased then   game:mousereleased(x, y, button, istouch, presses)   end
end

function love.joystickadded(joystick)
	if game.joystickadded then   game:joystickadded(joystick)   end
end

function love.joystickremoved(joystick)
	if game.joystickremoved then   game:joystickremoved(joystick)   end
end

function love.gamepadpressed(joystick, buttoncode)
	if game.gamepadpressed then   game:gamepadpressed(joystick, buttoncode)   end
end

function love.gamepadreleased(joystick, buttoncode)
	if game.gamepadreleased then   game:gamepadreleased(joystick, buttoncode)   end
end

function love.gamepadaxis(joystick, axis, value)
	if game.gamepadaxis then   game:gamepadaxis(joystick, axis, value)   end
end

function love.quit()
	if game.quit then   game:quit()   end
end

function love.resize(w, h)
	if not game then   return   end
	if game.on_resize then   game:on_resize(w,h)   end
end

function love.textinput(text)
	if game.textinput then  game:textinput(text)  end
end

function love.focus(f)
	if game.focus then  game:focus(f)  end
end

--- Quits the game and saves settings.
---@param restart boolean Whether the game should restart
function quit_game(restart)
	print("Quitting game")
	if Options then   Options:on_quit()   end
	if Input then     Input:on_quit()   end
	if Files then     Input:on_quit()   end
	love.event.quit(ternary(restart, "restart", nil))
end

__time_log_calls = 1
__buf_times = {}
__times = {}
__times_i = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
local function __tick(label, col, layer)
	if not __times[label] then
		__times[label] = {}
		__times[label].total_t = 0
		__times[label].calls = 0
	end

	__times[label].layer = layer or 1
	__times[label].i = __times_i[layer]
	__times[label].t = 0
	__times[label].tic = love.timer.getTime()
	__times[label].label = label
	__times[label].col = col or COL_WHITE
	
	__times_i[layer] = __times_i[layer] + 1
end
local function __tock(label)
	__times[label].t = love.timer.getTime() - __times[label].tic

	__times[label].total_t = __times[label].total_t + __times[label].t
	__times[label].calls = __times[label].calls + 1
	__times[label].avg_t = __times[label].total_t / __times[label].calls
	
	if __time_log_calls % 60*5 then
		__times[label].total_t = __times[label].avg_t
		__times[label].calls = 1
	end
end

function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	local dt = 0

	-- Main loop time.
	return function()
		__times_i = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
		-- __times = {}
		__tick("run", {0.5, 0.5, 0.6, 1}, 1)
		
		__tick("event", COL_YELLOW, 2)
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end
		__tock("event")

		-- Update dt, as we'll be passing it to update
		if love.timer then dt = love.timer.step() end

		__tick("update", COL_BLUE, 2)
		-- Call update and draw
		if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled
		__tock("update")

		__tick("draw", COL_RED, 2)
		if love.graphics and love.graphics.isActive() then
			__tick("origin", COL_RED, 3)
			love.graphics.origin()
			__tock("origin")
			__tick("clear", COL_ORANGE, 3)
			love.graphics.clear(love.graphics.getBackgroundColor())
			__tock("clear")
			
			__tick("love.draw", COL_YELLOW, 3)
			if love.draw then love.draw() end
			__tock("love.draw")
			
			__tick("present", COL_GREEN, 3)
			love.graphics.present()
			__tock("present")

			-- love.graphics.clear()
			-- love.graphics.print(love.timer.getFPS(), 0, 0, 0, 5)
			-- game.debug:draw()
			-- love.graphics.present()
		end
		__tock("draw")
		
		if love.timer then love.timer.sleep(0.001) end		
		__tock("run")

		__buf_times = __times
		__time_log_calls = __time_log_calls + 1
	end
end
