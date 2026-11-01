-- EGG-HUB ELITE // remote loader
local url = "https://raw.githubusercontent.com/Tmax1012/EGG-HUB/main/main.lua"
local ok, source = pcall(function()
    return game:HttpGet(url)
end)
if not ok or type(source) ~= "string" or #source == 0 then
    warn("[EGG-HUB] Téléchargement impossible.")
    return
end
local compileOk, chunk = pcall(loadstring, source)
if not compileOk or type(chunk) ~= "function" then
    warn("[EGG-HUB] Compilation impossible : " .. tostring(chunk))
    return
end
local runOk, runError = pcall(chunk)
if not runOk then
    warn("[EGG-HUB] Erreur d'exécution : " .. tostring(runError))
end
