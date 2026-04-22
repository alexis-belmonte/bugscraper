require "scripts.util"
local images = require "data.images"
local ButtonSmall = require "scripts.actor.enemies.button_small"

local UpgradeTea = require "scripts.upgrade.upgrade_tea"

local utf8 = require "utf8"

local VendingMachine = ButtonSmall:inherit()

function VendingMachine:init(x, y, w, h)
    self:init_button_small(x, y, nil, w or 25, h or 61)
    self.name = "vending_machine"

    self:set_image(images.machine_coffee)
    self.sprite_pressed = images.machine_coffee_pressed

    self.products = {
        -- UpgradeCoffee:new(),
        -- UpgradeMoreLife:new(),
        UpgradeTea:new(),
    }
    self.product = nil
    self.is_focused = false
    self.disappear_after_press = true
    self.show_text = true
    self.show_preview = true
    self.do_collected_particle = true

    self.stomp_height = 12

    self.player_detection_radius = 50
    self.target_player = nil

    self.animation_t = 0
    self.letters = {}
end

function VendingMachine:ready()
    self:select_random_product()
end

function VendingMachine:update(dt)
    self:update_button_small(dt)

    local player, distance = self:get_nearest_player()
    self.is_focused = (distance <= self.player_detection_radius)

    self.target_player = ternary(self.is_focused, player, nil)
    if self.is_focused then
        self.animation_t = clamp(self.animation_t + dt * 2, 0, 1)
    else
        self.animation_t = clamp(self.animation_t - dt * 2, 0, 1)
    end
end

function VendingMachine:get_nearest_player()
    local shortest_dist_sqr = math.huge
    local nearest_player = nil
    for _, ply in pairs(game.players) do
        local dist = distsqr(self.mid_x, self.mid_y, ply.mid_x, ply.mid_y)
        if dist < shortest_dist_sqr then
            shortest_dist_sqr = dist
            nearest_player = ply
        end
    end
    return nearest_player, math.sqrt(shortest_dist_sqr)
end

function VendingMachine:select_random_product()
    self.product = self.products[random_range_int(1, #self.products)]
end

function VendingMachine:on_press()
    if self.product then
        game:apply_upgrade(self.product)

        if self.do_collected_particle then
            Particles:collected_upgrade(self.mid_x, self.mid_y, self.product.sprite, self.product.color)    
        end
    end
end

function VendingMachine:draw()
    self:draw_enemy()

    self:draw_product()
end

function VendingMachine:draw_product()
    local x = self.mid_x
    local y = self.mid_y - 64
    local s = ease_out_cubic(clamp(self.animation_t, 0, 1))

    if self.show_preview then
        love.graphics.setColor(self.product.color)
        draw_centered(images.rays, x, y, game.t, s * 0.4, s * 0.4)
        love.graphics.setColor(COL_WHITE)
        self.product:draw(x, y, s)
    end

    if self.show_text then
        self:draw_text(x, y - 52, self.product:get_title(), self.product.color, 2)
        self:draw_text(x, y - 30, self.product:get_description())
    end
end

function VendingMachine:draw_text(x, y, text, col, s)
    col = param(col, COL_WHITE)
    s = param(s, 1)

    local total_w = get_text_width(text) * s
    local text_x = x - total_w / 2
    for i = 1, #text do
        local t = (#text - i) / #text + self.animation_t * 2 - 1
        local c = utf8.sub(text, i, i)
        local w = get_text_width(c) * s
        if t > 0 then
            local oy = ease_out_cubic(clamp(t, 0, 1)) * (-4)
            print_outline(col, COL_BLACK_BLUE, c, text_x, y + oy, nil, nil, s)
        end
        text_x = text_x + w
    end
end

return VendingMachine
