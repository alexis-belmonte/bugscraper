local Cutscene = require "scripts.game.cutscene"
local CutsceneScene = require "scripts.game.cutscene_scene"
local Rect = require "scripts.math.rect"
local images = require "data.images"

return Cutscene:new("arum_titan_enter", {
    CutsceneScene:new({
        duration = 1.9,
    }),
    CutsceneScene:new({
        duration = 1.5,
        enter = function(cutscene, data)
            if not Options:get("skip_boss_intros") then
                game.menu_manager:set_menu("w4_boss_intro")
            end
        end,
    }),
})

