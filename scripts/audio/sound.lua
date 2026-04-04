require "scripts.util"
local Class = require "scripts.meta.class"

local Sound = Class:inherit()

function Sound:init(source, pitch, volume, params)
    params = params or {}
    pitch = param(pitch, 1.0)
    volume = param(volume, 1.0)
    
    self.source = source:clone()
    self.pitch = pitch
    self.volume = volume
    self.is_looping = param(params.looping, false)

    self.is_paused = false
    self.layer = param(params.layer, "sfx")

    self.x = 0
    self.y = 0
    self.z = 0

    self:update_source()
end

function Sound:clone(volume, pitch, params)
    return Sound:new(
        self.source:clone(), 
        volume or self.pitch, 
        pitch or self.volume, 
        params or {
            looping = self.is_looping,
        }
    )
end

function Sound:update_source()
    local layer_volume = Options:get(self.layer .. "_volume") or 1.0

    self.source:setVolume(self.volume * layer_volume)
	self.source:setPitch(self.pitch)
    if self.source:getChannelCount() == 1 then
        self.source:setPosition(self.x, self.y, self.z)
    end
end

function Sound:set_volume(volume)
    self.volume = volume
    self:update_source()
end

function Sound:set_pitch(pitch)
    self.pitch = pitch
    self:update_source()
end

function Sound:set_position(x, y, z)
    local cx, cy = game.camera:get_real_position()
    local corrected_x = ((x or (cx + CANVAS_WIDTH/2) ) - cx) / CANVAS_WIDTH
    local corrected_y = ((y or (cy + CANVAS_HEIGHT/2)) - cy) / CANVAS_WIDTH
    local corrected_z = z or 1

    -- Convert from [0, 1] range to [-1, 1] range 
    corrected_x = (corrected_x*2 - 1) * AUDIO_3D_RANGE
    corrected_y = (corrected_y*2 - 1) * AUDIO_3D_RANGE
    corrected_z = 1

    self.x = corrected_x
    self.y = corrected_y
    self.z = corrected_z
    self:update_source()
end

function Sound:set_layer(layer)
    self.layer = layer
    assert(Options:get(layer.."_volume"), "no audio layer "..tostring(layer).." defined")
end

function Sound:play()
    self:update_source()
    self.is_paused = false
	self.source:play()
end

function Sound:pause()
    self.is_paused = true
	self.source:pause()
end

function Sound:resume()
    if self.is_paused then
        self.is_paused = false
        self.source:play()
    end
end

function Sound:stop()
    self.is_paused = false
	self.source:stop()
end

function Sound:seek(time)
    self.is_paused = false
	self.source:seek(time)
end

function Sound:get_duration()
	return self.source:getDuration()
end

function Sound:set_effect(effect_name)
    if not effect_name then
        return
    end
	return self.source:setEffect(effect_name)
end

-- ---@param offset number
-- ---@param unit "seconds"|"samples"
-- function Sound:seek(offset, unit)
--     self.source:seek(offset, unit)
-- end

return Sound