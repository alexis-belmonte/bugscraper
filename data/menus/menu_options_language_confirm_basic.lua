require "scripts.util"
local menu_util = require "scripts.ui.menu.menu_util"
local Menu = require "scripts.ui.menu.menu"

local DEFAULT_MENU_BG_COLOR = menu_util.DEFAULT_MENU_BG_COLOR
local PROMPTS_NORMAL    = menu_util.PROMPTS_NORMAL

return Menu:new(game, "", {
    { "", false, function(item)
        item:set_label_text(Text:parse("{language."..game.buffered_language.."}?"))
    end },
    { "❌ NO", function()
        game.menu_manager:back()
    end },
    { "✓ YES", function()
        if game and game.buffered_language then
            Options:set("has_chosen_language", true)
            Options:set("language", game.buffered_language)
        end
        quit_game(true)
    end },

}, DEFAULT_MENU_BG_COLOR, {
    { { "ui_select" }, "✓ OK" },
    { { "ui_back" }, "🔙 BACK" },
})