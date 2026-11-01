-- EGG-HUB // V3 INTELLIGENCE
-- Evidence-based utilities. No hidden inventory reads, item stealing, remote abuse or anti-cheat bypass.
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local LP = Players.LocalPlayer
local PLACE_ID = game.PlaceId
local started = os.clock()

local C = {
 bg=Color3.fromRGB(9,12,21), panel=Color3.fromRGB(18,24,38),
 panel2=Color3.fromRGB(26,35,53), line=Color3.fromRGB(49,65,91),
 text=Color3.fromRGB(240,245,255), muted=Color3.fromRGB(143,159,184),
 cyan=Color3.fromRGB(57,220,235), purple=Color3.fromRGB(157,115,255),
 green=Color3.fromRGB(86,225,160), gold=Color3.fromRGB(255,198,82),
 red=Color3.fromRGB(255,94,115)
}
local function toast(t,m)
 pcall(function() StarterGui:SetCore("SendNotification",{Title=t,Text=m,Duration=4}) end)
end
local gui=Instance.new("ScreenGui")
gui.Name="EGG_HUB_V3"; gui.ResetOnSpawn=false; gui.IgnoreGuiInset=true
local parent
pcall(function() if gethui then parent=gethui() end end)
gui.Parent=parent or LP:WaitForChild("PlayerGui")
local function round(o,r) local x=Instance.new("UICorner"); x.CornerRadius=UDim.new(0,r or 10); x.Parent=o end
local function outline(o,col)
 local x=Instance.new("UIStroke"); x.Color=col or C.line; x.Thickness=1; x.Transparency=.15; x.Parent=o
end
local function txt(p,s,z,col,font)
 local x=Instance.new("TextLabel"); x.BackgroundTransparency=1; x.Text=s; x.TextColor3=col or C.text
 x.TextSize=z or 13; x.Font=font or Enum.Font.Gotham; x.TextXAlignment=Enum.TextXAlignment.Left
 x.TextYAlignment=Enum.TextYAlignment.Center; x.Parent=p; return x
end
local function btn(p,s,w,fn)
 local x=Instance.new("TextButton"); x.Size=UDim2.new(0,w or 100,0,36); x.BackgroundColor3=C.panel2
 x.Text=s; x.TextColor3=C.text; x.TextSize=12; x.Font=Enum.Font.GothamBold; x.Parent=p
 round(x,8); outline(x); x.Activated:Connect(fn); return x
end
local function panel(p,h)
 local x=Instance.new("Frame"); x.Size=UDim2.new(1,-3,0,h or 65); x.BackgroundColor3=C.panel; x.Parent=p
 round(x,10); outline(x); return x
end
local function input(p,placeholder,default)
 local x=Instance.new("TextBox"); x.Size=UDim2.new(1,-18,0,35); x.BackgroundColor3=C.panel2
 x.TextColor3=C.text; x.PlaceholderColor3=C.muted; x.PlaceholderText=placeholder
 x.Text=default or ""; x.TextSize=12; x.Font=Enum.Font.Gotham; x.ClearTextOnFocus=false; x.Parent=p
 round(x,8); outline(x); return x
end

local root=Instance.new("Frame"); root.Size=UDim2.new(0,590,0,420)
root.Position=UDim2.new(.5,-295,.5,-210); root.BackgroundColor3=C.bg; root.Parent=gui
round(root,15); outline(root,C.cyan)
local scale=Instance.new("UIScale"); scale.Scale=UserInputService.TouchEnabled and .82 or 1; scale.Parent=root
local top=Instance.new("Frame"); top.Size=UDim2.new(1,0,0,57); top.BackgroundColor3=C.panel; top.Parent=root; round(top,15)
local title=txt(top,"EGG-HUB",22,C.text,Enum.Font.GothamBlack); title.Position=UDim2.new(0,16,0,4); title.Size=UDim2.new(0,180,0,28)
local sub=txt(top,"INTELLIGENCE SUITE  •  V3",9,C.cyan,Enum.Font.GothamBold); sub.Position=UDim2.new(0,18,0,31); sub.Size=UDim2.new(0,240,0,15)
local close=btn(top,"×",32,function() gui:Destroy() end); close.Position=UDim2.new(1,-43,0,11)
local nav=Instance.new("Frame"); nav.Position=UDim2.new(0,10,0,67); nav.Size=UDim2.new(0,125,1,-77); nav.BackgroundColor3=C.panel; nav.Parent=root; round(nav,10)
local body=Instance.new("Frame"); body.Position=UDim2.new(0,145,0,67); body.Size=UDim2.new(1,-155,1,-77); body.BackgroundTransparency=1; body.Parent=root
local pages={}
local function page(name)
 local f=Instance.new("ScrollingFrame"); f.Name=name; f.Size=UDim2.fromScale(1,1); f.BackgroundTransparency=1
 f.BorderSizePixel=0; f.ScrollBarThickness=3; f.ScrollBarImageColor3=C.cyan; f.AutomaticCanvasSize=Enum.AutomaticSize.Y
 f.CanvasSize=UDim2.new(); f.Visible=false; f.Parent=body
 local l=Instance.new("UIListLayout"); l.Padding=UDim.new(0,8); l.Parent=f; pages[name]=f; return f
end
local function show(n) for k,v in pairs(pages) do v.Visible=(k==n) end end
local function head(p,s) local x=txt(p,s,17,C.text,Enum.Font.GothamBold); x.Size=UDim2.new(1,0,0,26); return x end
local function stat(p,k,v,col)
 local f=panel(p,62); local a=txt(f,k,10,C.muted,Enum.Font.GothamBold); a.Position=UDim2.new(0,11,0,5); a.Size=UDim2.new(1,-20,0,18)
 local b=txt(f,v,20,col or C.cyan,Enum.Font.GothamBlack); b.Position=UDim2.new(0,11,0,25); b.Size=UDim2.new(1,-20,0,28); return b
end

-- Dashboard
local dash=page("Dashboard"); head(dash,"Command Center")
local welcome=panel(dash,64); local w=txt(welcome,"Bienvenue, "..LP.Name,16,C.text,Enum.Font.GothamBold); w.Position=UDim2.new(0,12,0,7); w.Size=UDim2.new(1,-24,0,23)
local pid=txt(welcome,"Place ID : "..tostring(PLACE_ID),10,C.muted); pid.Position=UDim2.new(0,13,0,33); pid.Size=UDim2.new(1,-25,0,18)
local session=stat(dash,"SESSION","00:00",C.green)
local playerCount=stat(dash,"JOUEURS DANS CE SERVEUR",tostring(#Players:GetPlayers()),C.cyan)
local dashNote=panel(dash,57); local dn=txt(dashNote,"Données vérifiées séparément des estimations. Aucun inventaire privé n'est lu.",11,C.gold); dn.Position=UDim2.new(0,11,0,5); dn.Size=UDim2.new(1,-22,0,46)

-- Spawn predictor: sample is a community event-context series, not a universal timer.
local spawn=page("Spawn Predictor"); head(spawn,"Spawn Predictor")
local evidence=panel(spawn,91)
local ev1=txt(evidence,"RESET OBSERVÉ : médiane 5 min (échantillon communautaire)",11,C.cyan,Enum.Font.GothamBold)
ev1.Position=UDim2.new(0,11,0,8); ev1.Size=UDim2.new(1,-22,0,22)
local ev2=txt(evidence,"Intervalles observés : 293 / 300 / 300 / 300 / 307 s. Non universel.",10,C.muted)
ev2.Position=UDim2.new(0,11,0,34); ev2.Size=UDim2.new(1,-22,0,22)
local anchor=panel(spawn,142)
local anchorLabel=txt(anchor,"Entre le nombre de secondes écoulées depuis le dernier « All Egg Reset » visible :",10,C.text)
anchorLabel.Position=UDim2.new(0,10,0,6); anchorLabel.Size=UDim2.new(1,-20,0,28)
local elapsedBox=input(anchor,"Secondes écoulées","0"); elapsedBox.Position=UDim2.new(0,9,0,38)
local startBtn=btn(anchor,"LANCER LE COMPTE À REBOURS",210,function() end); startBtn.Position=UDim2.new(0,9,1,-45)
local countdown=txt(anchor,"En attente de ton observation.",13,C.gold,Enum.Font.GothamBold)
countdown.Position=UDim2.new(0,228,1,-45); countdown.Size=UDim2.new(1,-238,0,36)
local remaining=nil
startBtn.Activated:Connect(function()
 local n=tonumber(elapsedBox.Text)
 if not n or n<0 then countdown.Text="Valeur invalide."; remaining=nil; return end
 remaining=math.max(0,300-n)
 countdown.Text=string.format("%02d:%02d",math.floor(remaining/60),math.floor(remaining%60))
end)
local sourceCard=panel(spawn,72)
local sl=txt(sourceCard,"Source : série vidéo communautaire continue, contexte Admin Abuse / update.",10,C.muted)
sl.Position=UDim2.new(0,10,0,6); sl.Size=UDim2.new(1,-20,0,27)
local link=btn(sourceCard,"OUVRIR LE REGISTRE",150,function()
 pcall(function() if setclipboard then setclipboard("https://stealaneggwiki.com/research/spawn-observations") end end)
 toast("EGG-HUB","Lien copié si le presse-papiers est disponible.")
end); link.Position=UDim2.new(0,10,0,35)

-- Radar
local radar=page("Radar"); head(radar,"Public Server Radar")
local radarStatusCard=panel(radar,48); local radarStatus=txt(radarStatusCard,"Prêt à scanner les serveurs publics.",11,C.muted)
radarStatus.Position=UDim2.new(0,10,0,5); radarStatus.Size=UDim2.new(1,-20,0,35)
local radarControls=Instance.new("Frame"); radarControls.Size=UDim2.new(1,0,0,38); radarControls.BackgroundTransparency=1; radarControls.Parent=radar
local scanned={}
local results=Instance.new("Frame"); results.Size=UDim2.new(1,0,0,0); results.AutomaticSize=Enum.AutomaticSize.Y; results.BackgroundTransparency=1; results.Parent=radar
local rl=Instance.new("UIListLayout"); rl.Padding=UDim.new(0,6); rl.Parent=results
local function clearRows() for _,c in ipairs(results:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end end
local function scan()
 radarStatus.Text="Récupération des serveurs publics..."; clearRows(); scanned={}
 local cursor=""; local loops=0
 repeat
  local url="https://games.roblox.com/v1/games/"..PLACE_ID.."/servers/Public?sortOrder=Asc&limit=100"
  if cursor~="" then url=url.."&cursor="..HttpService:UrlEncode(cursor) end
  local ok,bodyText=pcall(function() return game:HttpGet(url) end)
  if not ok then radarStatus.Text="API non accessible dans cet environnement."; return end
  local ok2,data=pcall(function() return HttpService:JSONDecode(bodyText) end)
  if not ok2 or type(data)~="table" or type(data.data)~="table" then radarStatus.Text="Réponse API invalide."; return end
  for _,s in ipairs(data.data) do
   if s.id and s.playing and s.maxPlayers then table.insert(scanned,{id=s.id,playing=s.playing,max=s.maxPlayers,ping=s.ping or 999}) end
  end
  cursor=data.nextPageCursor or ""; loops=loops+1
 until cursor=="" or loops>=3
 table.sort(scanned,function(a,b) local fa=a.max-a.playing; local fb=b.max-b.playing; if fa==fb then return a.ping<b.ping end return fa>fb end)
 radarStatus.Text=#scanned.." serveurs publics trouvés • triés par places libres."
 for i,s in ipairs(scanned) do
  if i>20 then break end
  local row=panel(results,52)
  local t=txt(row,string.format("#%02d  %d/%d joueurs • %d places libres",i,s.playing,s.max,s.max-s.playing),11,C.text,Enum.Font.GothamBold)
  t.Position=UDim2.new(0,9,0,3); t.Size=UDim2.new(1,-112,0,22)
  local p=txt(row,"Ping : "..tostring(s.ping).." ms",9,C.muted); p.Position=UDim2.new(0,10,0,27); p.Size=UDim2.new(1,-112,0,16)
  local j=btn(row,"REJOINDRE",84,function() radarStatus.Text="Connexion au serveur..."; pcall(function() TeleportService:TeleportToPlaceInstance(PLACE_ID,s.id,LP) end) end)
  j.Position=UDim2.new(1,-94,0,8)
 end
end
local scanBtn=btn(radarControls,"SCANNER",100,scan); scanBtn.Position=UDim2.new(0,0,0,0)
local refBtn=btn(radarControls,"ACTUALISER",100,scan); refBtn.Position=UDim2.new(0,108,0,0)

-- Fusion Lab
local fusion=page("Fusion Lab"); head(fusion,"Fusion Intelligence")
local fc=panel(fusion,215)
local fhead=txt(fc,"Estimation manuelle — pas une prédiction officielle du jeu.",10,C.gold); fhead.Position=UDim2.new(0,10,0,5); fhead.Size=UDim2.new(1,-20,0,22)
local va=input(fc,"Créature A : gain / seconde",""); va.Position=UDim2.new(0,9,0,32)
local vb=input(fc,"Créature B : gain / seconde",""); vb.Position=UDim2.new(0,9,0,73)
local mult=input(fc,"Multiplicateur estimé (1 = aucun bonus)","1"); mult.Position=UDim2.new(0,9,0,114)
local out=txt(fc,"Résultat : saisis les valeurs.",11,C.cyan,Enum.Font.GothamBold); out.Position=UDim2.new(0,10,0,155); out.Size=UDim2.new(1,-20,0,22)
local calc=btn(fc,"CALCULER",105,function()
 local a,b,m=tonumber(va.Text),tonumber(vb.Text),tonumber(mult.Text)
 if not a or not b or not m then out.Text="Valeurs numériques requises."; return end
 local r=(a+b)*m
 out.Text=string.format("Total estimé : %.3f /s",r)
end); calc.Position=UDim2.new(1,-115,1,-43)

-- Database snapshot / index limits
local db=page("Database"); head(db,"Research Database")
local intro=panel(db,75)
local it=txt(intro,"Pet Index observé : 13 groupes • 106 emplacements visibles au total.",12,C.cyan,Enum.Font.GothamBold)
it.Position=UDim2.new(0,10,0,6); it.Size=UDim2.new(1,-20,0,25)
local it2=txt(intro,"Les silhouettes verrouillées ne révèlent pas les noms, raretés ou revenus.",10,C.muted)
it2.Position=UDim2.new(0,10,0,34); it2.Size=UDim2.new(1,-20,0,30)
local groups={
 {"Forest",8},{"Lake",8},{"Desert",8},{"Jungle",8},{"Snow",8},{"Volcano",8},
 {"Abyss Ocean",8},{"Prehistoric",8},{"Cosmic",8},{"Cherry Blossom",8},
 {"Titan Temple",8},{"Monster Egg",12},{"Brainrot Egg",6}
}
for _,g in ipairs(groups) do
 local r=panel(db,34); local t=txt(r,g[1].."  •  "..g[2].." slots observés",10,C.text,Enum.Font.GothamBold)
 t.Position=UDim2.new(0,10,0,2); t.Size=UDim2.new(1,-20,0,28)
end
local source=panel(db,48)
local src=txt(source,"Snapshot communautaire daté du 04/09/2026. Structure seulement.",9,C.muted)
src.Position=UDim2.new(0,10,0,5); src.Size=UDim2.new(1,-20,0,36)

-- Notebook
local notebook=page("Notebook"); head(notebook,"Personal Value Notebook")
local nc=panel(notebook,130)
local nName=input(nc,"Nom de la créature / œuf",""); nName.Position=UDim2.new(0,9,0,8)
local nValue=input(nc,"Valeur / seconde",""); nValue.Position=UDim2.new(0,9,0,49)
local add=btn(nc,"AJOUTER",95,function() end); add.Position=UDim2.new(1,-105,1,-42)
local list=Instance.new("Frame"); list.Size=UDim2.new(1,0,0,0); list.AutomaticSize=Enum.AutomaticSize.Y; list.BackgroundTransparency=1; list.Parent=notebook
local ll=Instance.new("UIListLayout"); ll.Padding=UDim.new(0,6); ll.Parent=list
add.Activated:Connect(function()
 local n,v=nName.Text,tonumber(nValue.Text)
 if n=="" or not v then toast("EGG-HUB","Nom et valeur valides requis."); return end
 local r=panel(list,38); local t=txt(r,n.."  •  "..tostring(v).."/s",11,C.text,Enum.Font.GothamBold)
 t.Position=UDim2.new(0,10,0,4); t.Size=UDim2.new(1,-20,0,30); nName.Text=""; nValue.Text=""
end)

-- Settings / transparency
local settings=page("Settings"); head(settings,"Settings & Sources")
local sc=panel(settings,105)
local st=txt(sc,"EGG-HUB V3\nDonnées : Roblox public servers + recherche communautaire.\nLe compte à rebours est une estimation, pas une garantie.",10,C.muted)
st.Position=UDim2.new(0,10,0,8); st.Size=UDim2.new(1,-20,0,85)
local closeBtn=btn(settings,"FERMER LE HUB",130,function() gui:Destroy() end)

local navItems={{"⌂","Dashboard"},{"◷","Spawn Predictor"},{"◎","Radar"},{"✦","Fusion Lab"},{"▦","Database"},{"▤","Notebook"},{"⚙","Settings"}}
for i,item in ipairs(navItems) do
 local b=btn(nav,item[1].."  "..item[2],112,function() show(item[2]) end)
 b.Position=UDim2.new(0,6,0,7+(i-1)*43); b.TextXAlignment=Enum.TextXAlignment.Left; b.TextSize=10
end
show("Dashboard")

-- Drag window with touch/mouse
local dragging,dragStart,startPos=false,nil,nil
top.InputBegan:Connect(function(i)
 if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
  dragging=true; dragStart=i.Position; startPos=root.Position
  i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dragging=false end end)
 end
end)
UserInputService.InputChanged:Connect(function(i)
 if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
  local d=i.Position-dragStart
  root.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
 end
end)
RunService.RenderStepped:Connect(function(dt)
 if not gui.Parent then return end
 local sec=math.floor(os.clock()-started)
 session.Text=string.format("%02d:%02d",math.floor(sec/60),sec%60)
 playerCount.Text=tostring(#Players:GetPlayers())
 if remaining then
  remaining=math.max(0,remaining-dt)
  countdown.Text=string.format("%02d:%02d",math.floor(remaining/60),math.floor(remaining%60))
  if remaining<=0 then countdown.Text="Vérifie le reset en jeu."; remaining=nil; toast("EGG-HUB","Fenêtre estimée atteinte : vérifie le reset.") end
 end
end)
toast("EGG-HUB V3","Intelligence Suite chargée.")
print("[EGG-HUB] V3 loaded")
