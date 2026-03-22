require "scripts.util"
local Class = require "scripts.meta.class"
local StateMachine = require "scripts.state_machine"
local images = require "data.images"
local skins = require "data.skins"
local utf8 = require "utf8"
local Timer= require "scripts.timer"

local Toast = Class:inherit()

function Toast:init(i, image, title, description, params)
    params = params or {}
    
    self.i = i

    self.image = image
    self.title = title
    self.description = description

    self.stay_duration = params.stay_duration or 8.0

	self.padding = 2
	self.text_x_padding = 10
	self.text_y_padding = 6

	self.min_w = 130
    self.w = 0
    self:compute_w()
    self.off_ox = -self.w - 8
	self.h = 38
    
    self.ui_margin = 2
    self.sep = 2

    self.x = 0
    self.y = 0
    local y = (self.i - 1) * (self.h + self.sep)
    self.y = y

    self.state = "off"
    self.stay_timer = Timer:new(self.stay_duration)

    self.enabled = false
    self.to_delete = false

    self:enable()
end

function Toast:update(dt)
    local y = (self.i - 1) * (self.h + self.sep)
    self.y = lerp(self.y, y, 0.1)

    if self.state == "entering" then
        self.x = lerp(self.x, 0, 0.1) 
        if math.abs(self.x) < 1 then
            self.x = 0
            self.state = "on"
        end
        
    elseif self.state == "on" then


    elseif self.state == "exiting" then
        self.x = lerp(self.x, self.off_ox, 0.1)
        if math.abs(self.x - self.off_ox) < 1 then
            self.x = self.off_ox
            self.state = "off"

            self.enabled = false
            self.to_delete = true
        end
        
    elseif self.state == "off" then

    end

    if self.stay_timer:update(dt) then
        self.state = "exiting"
    end
end

function Toast:enable()
    self.x = self.off_ox
    self.stay_timer:start()
    self.state = "entering" 

    self.enabled = true
end

function Toast:compute_w()
    self.w = max(
        self.min_w, 
        max(
            get_text_width(self.title, FONT_REGULAR), 
            get_text_width(self.description, FONT_MINI)
        ) + 
        (self.image and self.image:getWidth() or 0) + 
        self.padding*2 + 
        self.text_x_padding*2
    )
end

function Toast:draw()
    local x = self.ui_margin + self.x
    local y = self.ui_margin + self.y

    draw_3_slice(images.toast_left, images.toast_mid, images.toast_right, {1, 1, 1, 0.8}, x, y, self.w, self.h)

    if self.image then
        rect_color(COL_WHITE, "fill", x+self.padding, y+self.padding, self.image:getWidth()+2, self.image:getHeight()+2)
        love.graphics.draw(self.image, x+self.padding+1, y+self.padding+1)
    end

    local text_x = x+self.image:getWidth()+self.padding+self.text_x_padding

    if self.title then
        Text:push_font(FONT_REGULAR)
        print_color(COL_WHITE, self.title, text_x, y+self.text_y_padding)
        Text:pop_font()
    end

    if self.description then
        if not Text:get_meta().large_mini_font then
            Text:push_font(FONT_MINI)
        end
        print_color(COL_LIGHTEST_GRAY, self.description, text_x, y+self.h-self.text_y_padding-get_text_height())
        if not Text:get_meta().large_mini_font then
            Text:pop_font()
        end
    end
end

return Toast