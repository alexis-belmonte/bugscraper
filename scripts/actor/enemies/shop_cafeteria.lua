require "scripts.util"
local Shop = require "scripts.actor.enemies.shop"

local ShopCafeteria = Shop:inherit()

function ShopCafeteria:init(x, y, w, h)
    ShopCafeteria.super.init(self, x, y, w or 1, h or 1, {assign_random_upgrades = true})
    self.name = "shop_cafeteria"
end

function ShopCafeteria:apply_current_product()
    ShopCafeteria.super.apply_current_product(self)

    game.level:on_shop_killed(self)

    self:play_sound(self.selected_product.activate_sound)
    Particles:collected_upgrade(self.mid_x, self.mid_y, self.selected_product.sprite, self.selected_product.color)
    game:screenshake(6)

    self:kill()
    
    game.level:on_shop_killed(self)
end

function ShopCafeteria:on_death()
    self:play_sound_var("sfx_actor_button_small_glass_break", 0.1, 1.1)
end

return ShopCafeteria