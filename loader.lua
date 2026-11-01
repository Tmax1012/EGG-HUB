-- EGG-HUB loader
-- Charge le fichier main.lua depuis le dépôt public.
local URL = "https://raw.githubusercontent.com/Tmax1012/EGG-HUB/main/main.lua"

local ok, source = pcall(function()
    return game:HttpGet(URL)
end)

if not ok or type(source) ~= "string" or #source == 0 then
    warn("[EGG-HUB] Impossible de télécharger main.lua.")
    return
end

local fn, err = loadstring(source)
if not fn then
    warn("[EGG-HUB] Erreur de compilation : " .. tostring(err))
    return
end

fn()
