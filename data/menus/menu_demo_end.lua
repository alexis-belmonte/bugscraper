require "scripts.util"
local menu_util             = require "scripts.ui.menu.menu_util"
local Menu                  = require "scripts.ui.menu.menu"
local Timer                 = require "scripts.timer"

local DEFAULT_MENU_BG_COLOR = menu_util.DEFAULT_MENU_BG_COLOR
local func_url              = menu_util.func_url
local PROMPTS_GAME_OVER     = menu_util.PROMPTS_GAME_OVER

local create_end_menu       = require "data.menus.create_end_menu"

---------------------------------------------------------

local items = create_end_menu(false)

local DemoEndMenu = Menu:inherit()

function DemoEndMenu:init(game)
    DemoEndMenu.super.init(self, game, "{menu.credits.thank_you_for_playing}", items, DEFAULT_MENU_BG_COLOR,
        PROMPTS_GAME_OVER, nil)

    self.is_backable = false
end

function DemoEndMenu:update(dt)
    DemoEndMenu.super.update(self, dt)
end

function DemoEndMenu:on_set(is_back)
    DemoEndMenu.super.on_set(self, is_back)
end

return DemoEndMenu:new()
