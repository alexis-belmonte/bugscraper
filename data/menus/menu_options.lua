require "scripts.util"
local menu_util = require "scripts.ui.menu.menu_util"
local Menu = require "scripts.ui.menu.menu"

local RangeOptionMenuItem = require "scripts.ui.menu.items.range_option_menu_item"
local BoolOptionMenuItem  = require "scripts.ui.menu.items.bool_option_menu_item"
local EnumOptionMenuItem  = require "scripts.ui.menu.items.enum_option_menu_item"

local DEFAULT_MENU_BG_COLOR = menu_util.DEFAULT_MENU_BG_COLOR
local func_set_menu     = menu_util.func_set_menu
local PROMPTS_NORMAL    = menu_util.PROMPTS_NORMAL

return Menu:new(game, "{menu.options.title}", {
    { "<<< {menu.options.input.title} >>>" },
    { "🔘 {menu.options.input.input}", func_set_menu("options_input") },
    { "" },
    { "<<< {menu.options.audio.title} >>>" },
    { BoolOptionMenuItem, "🔊 {menu.options.audio.sound}", "sound_on" },
    { RangeOptionMenuItem, "🔉 {menu.options.audio.volume}", "volume", { 0.0, 1.0 }, 0.05, "%",
        function(self)
            self.is_selectable = Options:get("sound_on")
        end
    },
    { RangeOptionMenuItem, "  🔈 {menu.options.audio.sfx_volume}", "sfx_volume", { 0.0, 1.0 }, 0.05, "%",
        function(self)
            self.is_selectable = Options:get("sound_on")
        end
    },
    { RangeOptionMenuItem, "  🎵 {menu.options.audio.music_volume}", "music_volume", { 0.0, 1.0 }, 0.05, "%",
        function(self)
            self.is_selectable = Options:get("sound_on")
        end
    },
    { BoolOptionMenuItem, "🔊 {menu.options.audio.ambience}", "ambience_on", 
        function(self)
            self.is_selectable = Options:get("sound_on")
        end 
    },
    { BoolOptionMenuItem, "🎼 {menu.options.audio.music_pause_menu}", "play_music_on_pause_menu",
        function(self)
            self.is_selectable = Options:get("sound_on")
        end
    },
    { "" },
    { "<<< {menu.options.visuals.title} >>>" },
    { BoolOptionMenuItem, "🔳 {menu.options.visuals.fullscreen}", "is_fullscreen" },
    { EnumOptionMenuItem, "🔲 {menu.options.visuals.pixel_scale}", "pixel_scale", { "auto", "max_whole", "1", "2", "3", "4", "5", "6" },
        function(value)
            if tonumber(value) then
                return tostring(value)
            else
                return tostring(Text:text("menu.options.visuals.pixel_scale_value." .. value))
            end
        end,
        function(self)
            if OPERATING_SYSTEM == "Web" then
                self.is_selectable = false
            end
        end
    },
    { BoolOptionMenuItem, "📺 {menu.options.visuals.vsync}", "is_vsync" },
    { BoolOptionMenuItem, "💧 {menu.options.visuals.menu_blur}", "menu_blur" },
    { RangeOptionMenuItem, "🌄 {menu.options.visuals.background_speed}", "background_speed", { 0.0, 1.0 }, 0.05, "%" },
    { RangeOptionMenuItem, "🥚 {menu.options.visuals.bullet_lightness}", "bullet_lightness", { 0.1, 1.0 }, 0.1, "%" },
    { "" },
    { "<<< {menu.options.game.title} >>>" },
    { "🌐 {menu.options.game.language}", func_set_menu("options_language") },
    { "🎓 {menu.options.game.tutorial}", func_set_menu("confirm_tutorial") }, 
    { RangeOptionMenuItem, "🛜 {menu.options.game.screenshake}", "screenshake", { 0.0, 2.0 }, 0.05, function(value)
        if value == 2.0 then
            return "Vlambeer"
        end
		return string.format("%d%%", round(value * 100)) 
	end },
    { BoolOptionMenuItem, "🕐 {menu.options.game.timer}", "timer_on" },
    { BoolOptionMenuItem, "↖ {menu.options.game.mouse_visible}", "mouse_visible" },
    { BoolOptionMenuItem, "🛅 {menu.options.game.pause_on_unfocus}", "pause_on_unfocus" },
    { BoolOptionMenuItem, "⏭ {menu.options.game.skip_boss_intros}", "skip_boss_intros" },
    { BoolOptionMenuItem, "⚠ {menu.options.game.show_fps_warning}", "show_fps_warning" },
    -- { BoolOptionMenuItem, "⚠ convention_mode", "convention_mode" },
}, DEFAULT_MENU_BG_COLOR, PROMPTS_NORMAL)