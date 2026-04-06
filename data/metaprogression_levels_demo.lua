local skin_name_to_id = require "data.skin_name_to_id"

local t = skin_name_to_id

return {
    { threshold = 5000, rewards = { { type = "upgrade", upgrade = "UpgradePomegranateJuice" } } },
    { threshold = 5000, rewards = { { type = "skin", skin = t.nel } } },
    { threshold = 5000, rewards = { { type = "skin", skin = t.rico } } },
    { threshold = 5000, rewards = { { type = "upgrade", upgrade = "UpgradeEnergyDrink" } } },
    { threshold = 5000, rewards = { { type = "skin", skin = t.amb } } },
    { threshold = 5000, rewards = { { type = "skin", skin = t.dodu } } },
}