require "scripts.util"
local menu_util             = require "scripts.ui.menu.menu_util"
local Menu                  = require "scripts.ui.menu.menu"
local images                = require "data.images"
local skins                 = require "data.skins"
local skin_name_to_id       = require "data.skin_name_to_id"
local upgrades              = require "data.upgrades"

local StatsMenuItem         = require "scripts.ui.menu.items.menu_item_stats"
local ProgressBarMenuItem   = require "scripts.ui.menu.items.progress_bar_menu_item"

local DEFAULT_MENU_BG_COLOR = menu_util.DEFAULT_MENU_BG_COLOR
local func_url              = menu_util.func_url
local PROMPTS_GAME_OVER     = menu_util.PROMPTS_GAME_OVER


local NewXpRewardMenu = Menu:inherit()

function NewXpRewardMenu:init(game)
    NewXpRewardMenu.super.init(self, game, "", { { "" } }, DEFAULT_MENU_BG_COLOR, PROMPTS_GAME_OVER, nil)

    self.is_backable = false

    self.rewards = {}

    self.starburst_scale = 0
    self.color_palette = {COL_WHITE, COL_LIGHT_GRAY, COL_MID_GRAY}
    self.rot = 0
    self.t = 0

    self.center_image = images.empty
    self.overtext = ""
    self.undertext = ""
    self.credits_text = ""
    self.text = ""
end

function NewXpRewardMenu:update(dt)
    NewXpRewardMenu.super.update(self, dt)

    self.rot = (self.rot + dt) % pi2
    self.starburst_scale = lerp(self.starburst_scale, 0.5, 0.2)

    self.t = self.t + dt

    if Input:action_pressed_any_player("ui_select") then
        game.menu_manager:back({})
    end
end

function NewXpRewardMenu:draw()
    NewXpRewardMenu.super.draw(self)

    local s = math.max(0, self.starburst_scale)
    exec_color(self.color_palette[3], function()
        draw_centered(images.rays_big, CANVAS_CENTER[1], CANVAS_CENTER[2], self.rot*0.3, s*1.9)
    end)
    exec_color(self.color_palette[2], function()
        draw_centered(images.rays_big, CANVAS_CENTER[1], CANVAS_CENTER[2], -self.rot, s*1.4)
    end)
    exec_color(self.color_palette[1], function()
        draw_centered(images.rays_big, CANVAS_CENTER[1], CANVAS_CENTER[2], self.rot, s)
    end)
    draw_centered(self.center_image, CANVAS_CENTER[1], CANVAS_CENTER[2], 0, s*4)

    print_wavy_centered_outline_text(COL_WHITE, nil, self.overtext, CANVAS_WIDTH/2, CANVAS_HEIGHT/2 - 50, 1, self.t, 2, 5, 0.4, 0, 1)
    print_wavy_centered_outline_text(COL_WHITE, nil, self.undertext, CANVAS_WIDTH/2, CANVAS_HEIGHT/2 + 70, 1, self.t, 2, 5, 0.4, 0, 1)

	print_wavy_centered_outline_text(self.color_palette[2], COL_WHITE, self.text, CANVAS_WIDTH/2, CANVAS_HEIGHT/2 + 42 + 3, 1, self.t, 3, 5, 0.4, 0, 2)
	print_wavy_centered_outline_text(self.color_palette[1], COL_WHITE, self.text, CANVAS_WIDTH/2, CANVAS_HEIGHT/2 + 42,     1, self.t, 3, 5, 0.4, 0, 2)
	print_wavy_centered_outline_text(self.color_palette[2], COL_BLACK, self.text, CANVAS_WIDTH/2, CANVAS_HEIGHT/2 + 42 + 3, 1, self.t, 3, 5, 0.4, 0, 2)
	print_wavy_centered_outline_text(self.color_palette[1], COL_BLACK, self.text, CANVAS_WIDTH/2, CANVAS_HEIGHT/2 + 42,     1, self.t, 3, 5, 0.4, 0, 2)

end

function NewXpRewardMenu:on_set(is_back)
    NewXpRewardMenu.super.on_set(self, is_back)

    self.starburst_scale = 0
end

function NewXpRewardMenu:set_rewards(rewards)
    self.rewards = rewards

    if #rewards > 0 then
        self:set_reward_graphics(rewards[1])
    end
end

function NewXpRewardMenu:set_reward_graphics(reward)
    if reward.type == "skin" then
        local skin = skins[reward.skin]
        if not skin then
            return
        end

        Audio:play("sfx_ui_unlock")

        self.overtext = Text:text("menu.new_reward.new_skin")
        self.text = Text:text("player.name." .. skin.text_key)
        self.center_image = skin.img_walk_down
        self.color_palette = skin.color_palette
        self.undertext = skin.guest_source or ""

    elseif reward.type == "upgrade" then
        local upgrade = upgrades[reward.upgrade]
        if not upgrade then
            return
        end

        local upgrade_inst = upgrade:new()
        
        Audio:play(upgrade_inst.activate_sound)

        self.overtext = Text:text("menu.new_reward.new_upgrade")
        self.text = upgrade_inst.title
        self.center_image = upgrade_inst.sprite
        self.undertext = upgrade_inst.description

        self.color_palette = upgrade_inst.palette
    end
end

return NewXpRewardMenu
