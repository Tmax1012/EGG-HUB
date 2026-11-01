--[[
EGG-HUB ELITE // v4.0
Reliable utility dashboard for Steal An Egg.
Only uses public Roblox server metadata and user-entered observations.
No automated stealing, undocumented remotes, exploit bypasses, or hidden inventory access.
]]

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local PLACE_ID = game.PlaceId
local startedAt = os.clock()
local alive = true

local COLORS = {
    bg = Color3.fromRGB(9, 12, 22),
    panel = Color3.fromRGB(18, 24, 38),
    panel2 = Color3.fromRGB(27, 36, 55),
    line = Color3.fromRGB(49, 65, 91),
    text = Color3.fromRGB(241, 245, 255),
    muted = Color3.fromRGB(145, 160, 184),
    cyan = Color3.fromRGB(55, 220, 235),
    purple = Color3.fromRGB(160, 120, 255),
    green = Color3.fromRGB(85, 225, 160),
    gold = Color3.fromRGB(255, 199, 83),
    red = Color3.fromRGB(255, 100, 120)
}

local function notify(title, message)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title, Text = message, Duration = 4
        })
    end)
end

local function safeCall(fn)
    local ok, result = pcall(fn)
    if not ok then
        warn("[EGG-HUB] " .. tostring(result))
        return false, result
    end
    return true, result
end

local gui = Instance.new("ScreenGui")
gui.Name = "EGG_HUB_ELITE"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local guiParent
safeCall(function()
    if typeof(gethui) == "function" then guiParent = gethui() end
end)
gui.Parent = guiParent or LocalPlayer:WaitForChild("PlayerGui")

local function addCorner(object, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 10)
    corner.Parent = object
end

local function addStroke(object, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or COLORS.line
    stroke.Thickness = thickness or 1
    stroke.Transparency = 0.12
    stroke.Parent = object
end

local function makeLabel(parent, text, size, color, font)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or COLORS.text
    label.TextSize = size or 13
    label.Font = font or Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = parent
    return label
end

local function makeButton(parent, text, width, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, width or 100, 0, 36)
    button.BackgroundColor3 = COLORS.panel2
    button.Text = text
    button.TextColor3 = COLORS.text
    button.TextSize = 12
    button.Font = Enum.Font.GothamBold
    button.AutoButtonColor = true
    button.Parent = parent
    addCorner(button, 8)
    addStroke(button)
    button.Activated:Connect(function()
        safeCall(callback)
    end)
    return button
end

local function makePanel(parent, height)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, height or 64)
    frame.BackgroundColor3 = COLORS.panel
    frame.Parent = parent
    addCorner(frame, 11)
    addStroke(frame)
    return frame
end

local function makeInput(parent, placeholder, defaultValue)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -18, 0, 36)
    box.BackgroundColor3 = COLORS.panel2
    box.TextColor3 = COLORS.text
    box.PlaceholderColor3 = COLORS.muted
    box.PlaceholderText = placeholder
    box.Text = defaultValue or ""
    box.TextSize = 12
    box.Font = Enum.Font.Gotham
    box.ClearTextOnFocus = false
    box.Parent = parent
    addCorner(box, 8)
    addStroke(box)
    return box
end

local root = Instance.new("Frame")
root.Name = "Window"
root.Size = UDim2.new(0, 610, 0, 440)
root.Position = UDim2.new(0.5, -305, 0.5, -220)
root.BackgroundColor3 = COLORS.bg
root.Parent = gui
addCorner(root, 16)
addStroke(root, COLORS.cyan, 1.2)

local uiScale = Instance.new("UIScale")
uiScale.Scale = UserInputService.TouchEnabled and 0.78 or 1
uiScale.Parent = root

local top = Instance.new("Frame")
top.Size = UDim2.new(1, 0, 0, 60)
top.BackgroundColor3 = COLORS.panel
top.Parent = root
addCorner(top, 16)

local title = makeLabel(top, "EGG-HUB", 23, COLORS.text, Enum.Font.GothamBlack)
title.Position = UDim2.new(0, 17, 0, 4)
title.Size = UDim2.new(0, 190, 0, 29)

local subtitle = makeLabel(top, "ELITE INTELLIGENCE  •  V4.0", 9, COLORS.cyan, Enum.Font.GothamBold)
subtitle.Position = UDim2.new(0, 19, 0, 34)
subtitle.Size = UDim2.new(0, 250, 0, 15)

local hideButton = makeButton(top, "—", 32, function()
    root.Visible = not root.Visible
end)
hideButton.Position = UDim2.new(1, -82, 0, 12)

local closeButton = makeButton(top, "×", 32, function()
    alive = false
    gui:Destroy()
end)
closeButton.Position = UDim2.new(1, -43, 0, 12)
closeButton.BackgroundColor3 = Color3.fromRGB(68, 36, 53)

local nav = Instance.new("Frame")
nav.Position = UDim2.new(0, 10, 0, 70)
nav.Size = UDim2.new(0, 132, 1, -80)
nav.BackgroundColor3 = COLORS.panel
nav.Parent = root
addCorner(nav, 11)

local content = Instance.new("Frame")
content.Position = UDim2.new(0, 152, 0, 70)
content.Size = UDim2.new(1, -162, 1, -80)
content.BackgroundTransparency = 1
content.Parent = root

local pages = {}
local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Size = UDim2.fromScale(1, 1)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = COLORS.cyan
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Visible = false
    page.Parent = content
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page
    pages[name] = page
    return page
end

local function showPage(name)
    for pageName, page in pairs(pages) do
        page.Visible = (pageName == name)
    end
end

local function heading(parent, text)
    local label = makeLabel(parent, text, 17, COLORS.text, Enum.Font.GothamBold)
    label.Size = UDim2.new(1, -4, 0, 27)
    return label
end

local function statCard(parent, caption, initial, color)
    local frame = makePanel(parent, 65)
    local captionLabel = makeLabel(frame, caption, 10, COLORS.muted, Enum.Font.GothamBold)
    captionLabel.Position = UDim2.new(0, 11, 0, 5)
    captionLabel.Size = UDim2.new(1, -22, 0, 18)
    local valueLabel = makeLabel(frame, initial, 20, color or COLORS.cyan, Enum.Font.GothamBlack)
    valueLabel.Position = UDim2.new(0, 11, 0, 26)
    valueLabel.Size = UDim2.new(1, -22, 0, 30)
    return valueLabel
end

-- Dashboard
local dashboard = createPage("Dashboard")
heading(dashboard, "Command Center")
local welcome = makePanel(dashboard, 70)
local welcomeText = makeLabel(welcome, "Bienvenue, " .. LocalPlayer.Name, 16, COLORS.text, Enum.Font.GothamBold)
welcomeText.Position = UDim2.new(0, 12, 0, 8)
welcomeText.Size = UDim2.new(1, -24, 0, 25)
local placeText = makeLabel(welcome, "Place ID : " .. tostring(PLACE_ID), 10, COLORS.muted)
placeText.Position = UDim2.new(0, 13, 0, 37)
placeText.Size = UDim2.new(1, -26, 0, 19)
local sessionValue = statCard(dashboard, "SESSION", "00:00", COLORS.green)
local playerValue = statCard(dashboard, "JOUEURS DANS CE SERVEUR", tostring(#Players:GetPlayers()), COLORS.cyan)
local dashInfo = makePanel(dashboard, 60)
local dashInfoText = makeLabel(dashInfo, "Outils d'observation et d'aide. Les fonctions non vérifiables ne sont pas simulées.", 11, COLORS.gold)
dashInfoText.Position = UDim2.new(0, 11, 0, 7)
dashInfoText.Size = UDim2.new(1, -22, 0, 45)

-- Public server radar
local radar = createPage("Server Radar")
heading(radar, "Server Intelligence")
local radarInfo = makePanel(radar, 52)
local radarStatus = makeLabel(radarInfo, "Prêt. Le radar affiche uniquement les métadonnées publiques Roblox.", 10, COLORS.muted)
radarStatus.Position = UDim2.new(0, 11, 0, 5)
radarStatus.Size = UDim2.new(1, -22, 0, 40)
local radarActions = Instance.new("Frame")
radarActions.Size = UDim2.new(1, 0, 0, 38)
radarActions.BackgroundTransparency = 1
radarActions.Parent = radar
local serverResults = Instance.new("Frame")
serverResults.Size = UDim2.new(1, 0, 0, 0)
serverResults.AutomaticSize = Enum.AutomaticSize.Y
serverResults.BackgroundTransparency = 1
serverResults.Parent = radar
local serverLayout = Instance.new("UIListLayout")
serverLayout.Padding = UDim.new(0, 6)
serverLayout.Parent = serverResults

local function clearServerResults()
    for _, child in ipairs(serverResults:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
end

local function scanPublicServers()
    clearServerResults()
    radarStatus.Text = "Scan des serveurs publics..."
    local found = {}
    local cursor = ""
    local pagesRead = 0
    repeat
        local url = "https://games.roblox.com/v1/games/" .. tostring(PLACE_ID) ..
            "/servers/Public?sortOrder=Asc&limit=100"
        if cursor ~= "" then
            url = url .. "&cursor=" .. HttpService:UrlEncode(cursor)
        end
        local ok, body = pcall(function() return game:HttpGet(url) end)
        if not ok then
            radarStatus.Text = "API inaccessible. Vérifie la compatibilité HTTP de ton environnement."
            return
        end
        local decodeOk, data = pcall(function() return HttpService:JSONDecode(body) end)
        if not decodeOk or type(data) ~= "table" or type(data.data) ~= "table" then
            radarStatus.Text = "Réponse Roblox invalide."
            return
        end
        for _, server in ipairs(data.data) do
            if server.id and server.playing and server.maxPlayers then
                table.insert(found, {
                    id = server.id,
                    playing = server.playing,
                    maximum = server.maxPlayers,
                    ping = server.ping or 999
                })
            end
        end
        cursor = data.nextPageCursor or ""
        pagesRead = pagesRead + 1
    until cursor == "" or pagesRead >= 4

    table.sort(found, function(a, b)
        local freeA, freeB = a.maximum - a.playing, b.maximum - b.playing
        if freeA == freeB then return a.ping < b.ping end
        return freeA > freeB
    end)

    radarStatus.Text = tostring(#found) .. " serveurs publics trouvés. Triés par places libres."
    for index, server in ipairs(found) do
        if index > 24 then break end
        local row = makePanel(serverResults, 54)
        local info = makeLabel(row, string.format("#%02d  %d/%d joueurs  •  %d places libres",
            index, server.playing, server.maximum, server.maximum - server.playing),
            11, COLORS.text, Enum.Font.GothamBold)
        info.Position = UDim2.new(0, 10, 0, 5)
        info.Size = UDim2.new(1, -116, 0, 22)
        local ping = makeLabel(row, "Ping : " .. tostring(server.ping) .. " ms", 9, COLORS.muted)
        ping.Position = UDim2.new(0, 11, 0, 29)
        ping.Size = UDim2.new(1, -116, 0, 16)
        local join = makeButton(row, "REJOINDRE", 88, function()
            radarStatus.Text = "Tentative de connexion..."
            TeleportService:TeleportToPlaceInstance(PLACE_ID, server.id, LocalPlayer)
        end)
        join.Position = UDim2.new(1, -98, 0, 9)
    end
end
local scanButton = makeButton(radarActions, "SCANNER", 100, scanPublicServers)
scanButton.Position = UDim2.new(0, 0, 0, 0)
local refreshButton = makeButton(radarActions, "ACTUALISER", 105, scanPublicServers)
refreshButton.Position = UDim2.new(0, 108, 0, 0)

-- Spawn predictor: manually anchored to a user-observed reset.
local predictor = createPage("Spawn Predictor")
heading(predictor, "Spawn Predictor")
local evidence = makePanel(predictor, 90)
local evidenceTitle = makeLabel(evidence, "ÉCHANTILLON COMMUNAUTAIRE : 5 INTERVALLES", 11, COLORS.cyan, Enum.Font.GothamBold)
evidenceTitle.Position = UDim2.new(0, 11, 0, 7)
evidenceTitle.Size = UDim2.new(1, -22, 0, 20)
local evidenceText = makeLabel(evidence, "293 / 300 / 300 / 300 / 307 secondes • médiane 300 s.", 10, COLORS.text)
evidenceText.Position = UDim2.new(0, 11, 0, 31)
evidenceText.Size = UDim2.new(1, -22, 0, 20)
local evidenceLimit = makeLabel(evidence, "Contexte Admin Abuse / update : ce n'est pas un cycle universel garanti.", 9, COLORS.muted)
evidenceLimit.Position = UDim2.new(0, 11, 0, 55)
evidenceLimit.Size = UDim2.new(1, -22, 0, 22)
local timerPanel = makePanel(predictor, 140)
local timerHint = makeLabel(timerPanel, "Secondes écoulées depuis le dernier reset visible :", 10, COLORS.text)
timerHint.Position = UDim2.new(0, 10, 0, 6)
timerHint.Size = UDim2.new(1, -20, 0, 22)
local elapsedInput = makeInput(timerPanel, "Exemple : 75", "0")
elapsedInput.Position = UDim2.new(0, 9, 0, 34)
local timerOutput = makeLabel(timerPanel, "En attente de ton observation.", 13, COLORS.gold, Enum.Font.GothamBold)
timerOutput.Position = UDim2.new(0, 10, 0, 78)
timerOutput.Size = UDim2.new(1, -20, 0, 24)
local remainingSeconds = nil
local startTimer = makeButton(timerPanel, "DÉMARRER", 110, function()
    local elapsed = tonumber(elapsedInput.Text)
    if not elapsed or elapsed < 0 then
        timerOutput.Text = "Entre un nombre valide."
        remainingSeconds = nil
        return
    end
    remainingSeconds = math.max(0, 300 - elapsed)
    timerOutput.Text = string.format("Prochaine fenêtre estimée : %02d:%02d",
        math.floor(remainingSeconds / 60), math.floor(remainingSeconds % 60))
end)
startTimer.Position = UDim2.new(1, -121, 1, -43)

-- Fusion calculator
local fusion = createPage("Fusion Lab")
heading(fusion, "Fusion Intelligence")
local fusionPanel = makePanel(fusion, 220)
local fusionNote = makeLabel(fusion, "Calcul basé sur tes entrées, pas sur une formule officielle confirmée.", 9, COLORS.gold)
fusionNote.Position = UDim2.new(0, 10, 0, 5)
fusionNote.Size = UDim2.new(1, -20, 0, 20)
local valueA = makeInput(fusionPanel, "Créature A : gain / seconde", "")
valueA.Position = UDim2.new(0, 9, 0, 31)
local valueB = makeInput(fusionPanel, "Créature B : gain / seconde", "")
valueB.Position = UDim2.new(0, 9, 0, 72)
local multiplier = makeInput(fusionPanel, "Multiplicateur estimé (1 = aucun bonus)", "1")
multiplier.Position = UDim2.new(0, 9, 0, 113)
local fusionResult = makeLabel(fusionPanel, "Résultat : saisis les valeurs.", 11, COLORS.cyan, Enum.Font.GothamBold)
fusionResult.Position = UDim2.new(0, 10, 0, 154)
fusionResult.Size = UDim2.new(1, -20, 0, 22)
local calculate = makeButton(fusionPanel, "CALCULER", 105, function()
    local a, b, m = tonumber(valueA.Text), tonumber(valueB.Text), tonumber(multiplier.Text)
    if not a or not b or not m then
        fusionResult.Text = "Valeurs numériques requises."
        return
    end
    local total = (a + b) * m
    fusionResult.Text = string.format("Gain estimé : %.3f /s", total)
end)
calculate.Position = UDim2.new(1, -115, 1, -43)

-- Local notebook
local notebook = createPage("Value Notebook")
heading(notebook, "Value Notebook")
local notePanel = makePanel(notebook, 135)
local nameInput = makeInput(notePanel, "Nom de l'œuf / créature", "")
nameInput.Position = UDim2.new(0, 9, 0, 8)
local amountInput = makeInput(notePanel, "Gain / seconde ou valeur observée", "")
amountInput.Position = UDim2.new(0, 9, 0, 49)
local notesList = Instance.new("Frame")
notesList.Size = UDim2.new(1, 0, 0, 0)
notesList.AutomaticSize = Enum.AutomaticSize.Y
notesList.BackgroundTransparency = 1
notesList.Parent = notebook
local notesLayout = Instance.new("UIListLayout")
notesLayout.Padding = UDim.new(0, 6)
notesLayout.Parent = notesList
local addNote = makeButton(notePanel, "AJOUTER", 95, function()
    local name, amount = nameInput.Text, tonumber(amountInput.Text)
    if name == "" or not amount then
        notify("EGG-HUB", "Nom et valeur numérique requis.")
        return
    end
    local row = makePanel(notesList, 40)
    local rowText = makeLabel(row, name .. "  •  " .. tostring(amount), 11, COLORS.text, Enum.Font.GothamBold)
    rowText.Position = UDim2.new(0, 10, 0, 4)
    rowText.Size = UDim2.new(1, -20, 0, 32)
    nameInput.Text = ""
    amountInput.Text = ""
end)
addNote.Position = UDim2.new(1, -105, 1, -43)

-- Database snapshot
local database = createPage("Egg Database")
heading(database, "Research Database")
local dbIntro = makePanel(database, 78)
local dbTitle = makeLabel(dbIntro, "13 groupes • 106 emplacements observés dans l'index.", 12, COLORS.cyan, Enum.Font.GothamBold)
dbTitle.Position = UDim2.new(0, 10, 0, 7)
dbTitle.Size = UDim2.new(1, -20, 0, 22)
local dbLimit = makeLabel(dbIntro, "Les silhouettes verrouillées ne révèlent pas leurs noms, raretés ou revenus.", 9, COLORS.muted)
dbLimit.Position = UDim2.new(0, 10, 0, 34)
dbLimit.Size = UDim2.new(1, -20, 0, 32)
local groups = {
    {"Forest",8},{"Lake",8},{"Desert",8},{"Jungle",8},{"Snow",8},{"Volcano",8},
    {"Abyss Ocean",8},{"Prehistoric",8},{"Cosmic",8},{"Cherry Blossom",8},
    {"Titan Temple",8},{"Monster Egg",12},{"Brainrot Egg",6}
}
for _, group in ipairs(groups) do
    local row = makePanel(database, 34)
    local text = makeLabel(row, group[1] .. "  •  " .. group[2] .. " slots", 10, COLORS.text, Enum.Font.GothamBold)
    text.Position = UDim2.new(0, 10, 0, 2)
    text.Size = UDim2.new(1, -20, 0, 28)
end

-- Features directory: clear status, no pretend switches.
local features = createPage("Feature Status")
heading(features, "Feature Compatibility")
local supported = {
    {"Public Server Radar", "Disponible", COLORS.green},
    {"Spawn Predictor manuel", "Disponible • estimation", COLORS.green},
    {"Fusion Calculator", "Disponible • manuel", COLORS.green},
    {"Value Notebook", "Disponible • session", COLORS.green},
    {"Auto Steal / Auto Sell / Auto Fuse", "Non inclus • actions automatisées non prises en charge", COLORS.red},
    {"Inventaires cachés / ESP global", "Non accessibles via API publique", COLORS.gold},
    {"Auto Farm / Auto Hatch / Remote automation", "Non inclus • nécessite une interface officielle vérifiable", COLORS.gold}
}
for _, item in ipairs(supported) do
    local row = makePanel(features, 55)
    local t = makeLabel(row, item[1], 11, COLORS.text, Enum.Font.GothamBold)
    t.Position = UDim2.new(0, 10, 0, 5)
    t.Size = UDim2.new(1, -20, 0, 20)
    local s = makeLabel(row, item[2], 9, item[3])
    s.Position = UDim2.new(0, 10, 0, 28)
    s.Size = UDim2.new(1, -20, 0, 18)
end

-- Settings
local settings = createPage("Settings")
heading(settings, "Settings")
local settingsPanel = makePanel(settings, 100)
local settingsText = makeLabel(settingsPanel,
    "EGG-HUB ELITE v4.0\nRoblox public metadata + community research.\nAucune lecture d'inventaire privé ou manipulation de remotes.",
    10, COLORS.muted)
settingsText.Position = UDim2.new(0, 10, 0, 8)
settingsText.Size = UDim2.new(1, -20, 0, 82)
local closeHub = makeButton(settings, "FERMER EGG-HUB", 145, function()
    alive = false
    gui:Destroy()
end)

local navItems = {
    {"⌂","Dashboard"},{"◎","Server Radar"},{"◷","Spawn Predictor"},
    {"✦","Fusion Lab"},{"▤","Value Notebook"},{"▦","Egg Database"},
    {"≡","Feature Status"},{"⚙","Settings"}
}
for index, item in ipairs(navItems) do
    local button = makeButton(nav, item[1] .. "  " .. item[2], 118, function()
        showPage(item[2])
    end)
    button.Position = UDim2.new(0, 6, 0, 6 + (index - 1) * 42)
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.TextSize = 10
end
showPage("Dashboard")

-- Drag window on touch/mouse
local dragging, dragStart, startPosition = false, nil, nil
top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = root.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        root.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X,
            startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
    end
end)

RunService.RenderStepped:Connect(function(deltaTime)
    if not alive or not gui.Parent then return end
    local elapsed = math.floor(os.clock() - startedAt)
    sessionValue.Text = string.format("%02d:%02d", math.floor(elapsed / 60), elapsed % 60)
    playerValue.Text = tostring(#Players:GetPlayers())
    if remainingSeconds then
        remainingSeconds = math.max(0, remainingSeconds - deltaTime)
        timerOutput.Text = string.format("Prochaine fenêtre estimée : %02d:%02d",
            math.floor(remainingSeconds / 60), math.floor(remainingSeconds % 60))
        if remainingSeconds <= 0 then
            remainingSeconds = nil
            timerOutput.Text = "Fenêtre atteinte : vérifie le jeu."
            notify("EGG-HUB", "Fenêtre estimée atteinte. Vérifie le reset en jeu.")
        end
    end
end)

notify("EGG-HUB ELITE", "V4.0 chargée.")
print("[EGG-HUB ELITE] V4.0 loaded")
