-- EGG-HUB V3 // one-line remote loader
local u="https://raw.githubusercontent.com/Tmax1012/EGG-HUB/main/main.lua"
local ok,s=pcall(function() return game:HttpGet(u) end)
if not ok or type(s)~="string" or #s==0 then warn("[EGG-HUB] Download failed"); return end
local f,e=loadstring(s); if not f then warn("[EGG-HUB] Compile error: "..tostring(e)); return end
local r,x=pcall(f); if not r then warn("[EGG-HUB] Runtime error: "..tostring(x)) end
