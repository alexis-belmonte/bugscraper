require "scripts.util"
local Shop = require "scripts.actor.enemies.shop"
local images = require "data.images"

local ShopVendingMachine = Shop:inherit()

function ShopVendingMachine:init(x, y, w, h)
    ShopVendingMachine.super.init(self, x, y, w or 1, h or 1, {assign_random_upgrades = true, spr = images.vending_machine})
    self.name = "shop_vending_machine"

    self.ui_oy = 120
    self.loot = {}
end

function ShopVendingMachine:apply_current_product()
    ShopVendingMachine.super.apply_current_product(self)

    self:play_sound(self.selected_product.activate_sound)
    Particles:collected_upgrade(self.mid_x, self.mid_y, self.selected_product.sprite, self.selected_product.color)
    game:screenshake(6)

    self:kill()
end

function ShopVendingMachine:on_death()
    self:play_sound_var("sfx_actor_button_small_glass_break", 0.1, 1.1)

    Particles:image(self.mid_x, self.mid_y - 32, 150, { images.cabin_fragment_1, images.cabin_fragment_2, images.cabin_fragment_3 }, 32, 120, 0.6)
end

return ShopVendingMachine