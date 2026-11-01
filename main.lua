-- EGG-HUB | prototype de navigateur de serveurs publics
-- Note : ce script ne peut pas lire les œufs présents dans les autres serveurs.

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
    warn("[EGG-HUB] LocalPlayer introuvable.")
    return
end

local PLACE_ID = game.PlaceId
local GUI_NAME = "EGG_HUB"

pcall(function()
    local old = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild(GUI_NAME)
    if old then old:Destroy() end
end)

local gui = Instance.new("ScreenGui")
gui.Name = GUI_NAME
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(310, 370)
frame.Position = UDim2.new(0.5, -155, 0.5, -185)
frame.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
frame.BorderSizePixel = 0
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -48, 0, 38)
title.Position = UDim2.fromOffset(12, 6)
title.BackgroundTransparency = 1
title.Text = "EGG-HUB | SERVER FINDER"
title.TextColor3 = Color3.fromRGB(245, 245, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(28, 28)
close.Position = UDim2.new(1, -36, 0, 10)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextSize = 13
close.TextColor3 = Color3.new(1, 1, 1)
close.BackgroundColor3 = Color3.fromRGB(150, 55, 65)
close.Parent = frame
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 7)
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -24, 0, 42)
status.Position = UDim2.fromOffset(12, 44)
status.BackgroundColor3 = Color3.fromRGB(29, 33, 45)
status.Text = "Finder œufs : source de données non connectée"
status.TextColor3 = Color3.fromRGB(255, 205, 120)
status.Font = Enum.Font.Gotham
status.TextSize = 10
status.TextWrapped = true
status.Parent = frame
Instance.new("UICorner", status).CornerRadius = UDim.new(0, 6)

local refresh = Instance.new("TextButton")
refresh.Size = UDim2.new(1, -24, 0, 34)
refresh.Position = UDim2.fromOffset(12, 94)
refresh.Text = "ACTUALISER LES SERVEURS"
refresh.TextColor3 = Color3.new(1, 1, 1)
refresh.BackgroundColor3 = Color3.fromRGB(67, 91, 170)
refresh.Font = Enum.Font.GothamBold
refresh.TextSize = 11
refresh.Parent = frame
Instance.new("UICorner", refresh).CornerRadius = UDim.new(0, 7)

local list = Instance.new("ScrollingFrame")
list.Size = UDim2.new(1, -24, 1, -184)
list.Position = UDim2.fromOffset(12, 136)
list.BackgroundColor3 = Color3.fromRGB(25, 28, 38)
list.BorderSizePixel = 0
list.ScrollBarThickness = 4
list.CanvasSize = UDim2.new()
list.Parent = frame
Instance.new("UICorner", list).CornerRadius = UDim.new(0, 7)

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = list

local selectedServer

local function clearRows()
    for _, child in ipairs(list:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    list.CanvasPosition = Vector2.new(0, 0)
end

local function showMessage(text)
    clearRows()
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 58)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 225, 240)
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextWrapped = true
    label.Parent = list
end

local function loadServers()
    refresh.Text = "CHARGEMENT..."
    refresh.Active = false
    selectedServer = nil
    showMessage("Récupération des serveurs publics Roblox...")

    task.spawn(function()
        local url = "https://games.roblox.com/v1/games/" .. tostring(PLACE_ID)
            .. "/servers/Public?sortOrder=Asc&limit=100"

        local ok, result = pcall(function()
            local raw = game:HttpGet(url)
            return HttpService:JSONDecode(raw)
        end)

        if not ok or type(result) ~= "table" or type(result.data) ~= "table" then
            showMessage("Impossible de récupérer les serveurs. Vérifie l'accès HTTP de ton environnement, puis réessaie.")
            refresh.Text = "RÉESSAYER"
            refresh.Active = true
            return
        end

        clearRows()
        local count = 0

        for _, server in ipairs(result.data) do
            if server.id and server.playing and server.maxPlayers
                and server.playing < server.maxPlayers then
                count += 1

                local row = Instance.new("TextButton")
                row.Size = UDim2.new(1, -10, 0, 48)
                row.BackgroundColor3 = Color3.fromRGB(39, 44, 59)
                row.Text = string.format(
                    "Serveur %02d  |  %d/%d joueurs",
                    count, server.playing, server.maxPlayers
                )
                row.TextColor3 = Color3.fromRGB(240, 242, 250)
                row.Font = Enum.Font.Gotham
                row.TextSize = 11
                row.Parent = list
                Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

                row.MouseButton1Click:Connect(function()
                    selectedServer = server.id
                    for _, other in ipairs(list:GetChildren()) do
                        if other:IsA("TextButton") then
                            other.BackgroundColor3 = Color3.fromRGB(39, 44, 59)
                        end
                    end
                    row.BackgroundColor3 = Color3.fromRGB(55, 105, 85)
                    status.Text = "Serveur sélectionné. Appuie sur Rejoindre."
                    status.TextColor3 = Color3.fromRGB(140, 235, 175)
                end)
            end
        end

        if count == 0 then
            showMessage("Aucun serveur public disponible sur cette page.")
        else
            list.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 8)
        end

        refresh.Text = "ACTUALISER LES SERVEURS"
        refresh.Active = true
        status.Text = tostring(count) ..
            " serveur(s) listé(s) • inventaire des œufs non fourni par l'API"
        status.TextColor3 = Color3.fromRGB(255, 205, 120)
    end)
end

local join = Instance.new("TextButton")
join.Size = UDim2.new(1, -24, 0, 34)
join.Position = UDim2.new(0, 12, 1, -40)
join.Text = "REJOINDRE LE SERVEUR SÉLECTIONNÉ"
join.TextColor3 = Color3.new(1, 1, 1)
join.BackgroundColor3 = Color3.fromRGB(42, 135, 90)
join.Font = Enum.Font.GothamBold
join.TextSize = 10
join.Parent = frame
Instance.new("UICorner", join).CornerRadius = UDim.new(0, 7)

refresh.MouseButton1Click:Connect(loadServers)

join.MouseButton1Click:Connect(function()
    if not selectedServer then
        status.Text = "Sélectionne d'abord un serveur dans la liste."
        return
    end
    status.Text = "Tentative de connexion..."
    local ok, err = pcall(function()
        TeleportService:TeleportToPlaceInstance(PLACE_ID, selectedServer, LocalPlayer)
    end)
    if not ok then
        status.Text = "Téléportation impossible : " .. tostring(err)
    end
end)

loadServers()
