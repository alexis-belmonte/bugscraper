require "scripts.util"
local menu_util = require "scripts.ui.menu.menu_util"
local Menu = require "scripts.ui.menu.menu"

local DEFAULT_MENU_BG_COLOR = menu_util.DEFAULT_MENU_BG_COLOR
local PROMPTS_NORMAL    = menu_util.PROMPTS_NORMAL

local function func_language_menu(lang)
    return function()
        game.buffered_language = lang
        game.menu_manager:set_menu("options_confirm_language")
    end
end

return Menu:new(game, "{menu.options.language.title}", {
    -- { "{language.default}", func_language_menu("default") },
    { "{language.en}", func_language_menu("en") },
    { "{language.fr}", func_language_menu("fr") },
    { "{language.es}", func_language_menu("es") },
    -- { "{language.zh_Hans}", func_language_menu("zh_Hans") },
    { "{language.ja}", func_language_menu("ja") },
    { "{language.pl}", func_language_menu("pl") },
    { "{language.pt_BR}", func_language_menu("pt_BR") },
}, DEFAULT_MENU_BG_COLOR, PROMPTS_NORMAL)