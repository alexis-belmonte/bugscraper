require "scripts.util"
local menu_util             = require "scripts.ui.menu.menu_util"
local Menu                  = require "scripts.ui.menu.menu"
local Timer                 = require "scripts.timer"

local DEFAULT_MENU_BG_COLOR = menu_util.DEFAULT_MENU_BG_COLOR
local func_url              = menu_util.func_url
local PROMPTS_GAME_OVER     = menu_util.PROMPTS_GAME_OVER

local create_end_menu       = require "data.menus.create_end_menu"

---------------------------------------------------------

local game_over_items = create_end_menu()

local GameOverMenu = Menu:inherit()

function GameOverMenu:init(game)
    GameOverMenu.super.init(self, game, "{menu.game_over.title}", game_over_items, DEFAULT_MENU_BG_COLOR,
        PROMPTS_GAME_OVER, nil)

    self.is_backable = false

    self.auto_restart_timer = Timer:new(10.0)
end

function GameOverMenu:update(dt)
    GameOverMenu.super.update(self, dt)

    if self.auto_restart_timer:update(dt) then
        game:new_game()
    end
end

function GameOverMenu:on_set(is_back)
    GameOverMenu.super.on_set(self, is_back)

    if Options:get("convention_mode") then
        self.auto_restart_timer:start()
    end
end

local game_over_menu = GameOverMenu:new()

return game_over_menu
