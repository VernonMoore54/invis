repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer
repeat task.wait() until game.Players.LocalPlayer.Character
task.wait()
setfpscap(155)

-- Конфигуратор позиции UI (меняйте эти значения под ваше расположение)
local UI_START_POS = UDim2.new(0, 640, 0, 100)  -- по умолчанию 50px от левого края, 100px от верха

--[[============================================================================
    LocalScript: PlantingWithToggleAndFarm.lua
    Расположение: StarterGui → PlantingWithToggleAndFarm.lua
    (При каждом запуске удаляет старый UI "PlantingToggleGUI" и создаёт новый.)
================================================================================]]

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputMgr   = game:GetService("VirtualInputManager")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Удаляем старый UI
local oldGui = playerGui:FindFirstChild("PlantingToggleGUI")
if oldGui then oldGui:Destroy() end

-- Создаём новый ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name         = "PlantingToggleGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent       = playerGui

-- Единый Frame, draggable, позиция задаётся через UI_START_POS
local container = Instance.new("Frame")
container.Name               = "ControlContainer"
container.Size               = UDim2.new(0, 200, 0, 40)
container.Position           = UI_START_POS
container.BackgroundTransparency = 1
container.Active             = true
container.Draggable          = true
container.Parent             = screenGui

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Name             = "ToggleButton"
toggleButton.Text             = "OFF"
toggleButton.Font             = Enum.Font.SourceSansBold
toggleButton.TextSize         = 20
toggleButton.TextColor3       = Color3.new(1, 1, 1)
toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleButton.Size             = UDim2.new(0, 100, 0, 40)
toggleButton.Position         = UDim2.new(0, 0, 0, 0)
toggleButton.Parent           = container

-- Key Input Box
local keyBox = Instance.new("TextBox")
keyBox.Name             = "KeyBox"
keyBox.Text             = "E"
keyBox.Font             = Enum.Font.SourceSans
keyBox.TextSize         = 20
keyBox.TextColor3       = Color3.new(1,1,1)
keyBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
keyBox.Size             = UDim2.new(0, 80, 0, 40)
keyBox.Position         = UDim2.new(0, 110, 0, 0)
keyBox.ClearTextOnFocus = false
keyBox.Parent           = container

-- Состояние и выбранная клавиша
local enabled    = false
local currentKey = Enum.KeyCode.E

toggleButton.MouseButton1Click:Connect(function()
    enabled = not enabled
    if enabled then
        toggleButton.Text             = "ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    else
        toggleButton.Text             = "OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end
end)

keyBox.FocusLost:Connect(function()
    local txt = keyBox.Text:upper():gsub("%s+","")
    if Enum.KeyCode[txt] then
        currentKey = Enum.KeyCode[txt]
    else
        keyBox.Text = currentKey.Name
    end
end)

-- (Далее весь остальной код без изменений, использующий `currentKey` при VirtualInputMgr:SendKeyEvent)

local targetPosPlant = Vector3.new(20.912565231323242, 0.13552704453468323, -130.45901489257812)
local farmBase        = Vector3.new(20.912565231323242, 0.13552704453468323, -130.45901489257812)
local sellPos         = Vector3.new(89, 3, 0)

local fruitNames = {
    "Orange Tulip",
    "Apple","Bamboo","Coconut","Cactus","Dragon Fruit","Mango","Grape",
    "Mushroom","Pepper","Cacao","Beanstalk","Raspberry","Rose","Lilac",
    "Foxglove","Lily","Pink Lily","Purple Dahlia","Lavender","Nectarshade","Nectarine","Mushroom","Ember Lily",
    "Hive Fruit",
}

local function shuffle(t)
    local temp = {}
    for i = 1, #t do temp[i] = t[i] end
    for i = #temp, 2, -1 do
        local j = math.random(i)
        temp[i], temp[j] = temp[j], temp[i]
    end
    return temp
end

math.randomseed(tick())

local plantEvent = ReplicatedStorage.GameEvents:WaitForChild("Plant_RE")
local sellEvent  = ReplicatedStorage.GameEvents:WaitForChild("Sell_Inventory")

local backpack = player:WaitForChild("Backpack")
local function getCharacter() return player.Character or player.CharacterAdded:Wait() end

local function countTools()
    local c = 0
    for _, itm in ipairs(backpack:GetChildren()) do
        if itm:IsA("Tool") then c += 1 end
    end
    local ch = getCharacter()
    for _, itm in ipairs(ch:GetChildren()) do
        if itm:IsA("Tool") then c += 1 end
    end
    return c
end

task.spawn(function()
    while true do
        task.wait(0.01)
        if not enabled then continue end

        local character = getCharacter()

        -- 6.a) Перенос
        for _, item in ipairs(backpack:GetChildren()) do
            local nm = item.Name
            if nm ~= "Shovel [Destroy Plants]"
            and not nm:find("Uses")
            and not nm:find("Age") then
                item.Parent = character
            end
        end

        -- 6.b) Посадка
        for _, nm in ipairs(shuffle(fruitNames)) do
            if not enabled then break end
            plantEvent:FireServer(targetPosPlant, nm)
        end
        if not enabled then continue end

        -- 6.c) Телепорт
        do
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(
                    farmBase.X + math.random(-5,5),
                    farmBase.Y + math.random(0,3),
                    farmBase.Z + math.random(-5,5)
                )
            end
        end

        -- 6.d) Пауза
        do
            local e = 0
            while e < 0.1 do
                task.wait(0.01); e += 0.01
                if not enabled then break end
            end
            if not enabled then continue end
        end

        -- 6.e) Удержание
        do
            while enabled do
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = CFrame.new(
                        farmBase.X + math.random(-5,5),
                        farmBase.Y + math.random(0,3),
                        farmBase.Z + math.random(-5,5)
                    )
                    VirtualInputMgr:SendKeyEvent(true, currentKey, false, game)
                    task.wait(0.03)
                    VirtualInputMgr:SendKeyEvent(false, currentKey, false, game)
                end

                -- перенос + посадка внутри удержания
                for _, item in ipairs(backpack:GetChildren()) do
                    local nm = item.Name
                    if nm ~= "Shovel [Destroy Plants]"
                    and not nm:find("Uses")
                    and not nm:find("Age") then
                        item.Parent = character
                    end
                end
                for _, nm in ipairs(shuffle(fruitNames)) do
                    if not enabled then break end
                    plantEvent:FireServer(targetPosPlant, nm)
                end

                if countTools() > 130 then break end

                local w = 0
                while w < 0.05 do
                    task.wait(0.01); w += 0.01
                    if not enabled then break end
                end
                if not enabled then break end
            end
            VirtualInputMgr:SendKeyEvent(false, currentKey, false, game)
            if not enabled then continue end
        end

        -- 6.f) Продажа
        do
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = CFrame.new(sellPos) end
        end

        -- 6.g) Пауза
        do
            local e = 0
            while e < 0.1 do
                task.wait(0.01); e += 0.01
                if not enabled then break end
            end
            if not enabled then continue end
        end

        -- 6.h) Sell
        for i = 1, 3 do
            if not enabled then break end
            sellEvent:FireServer()
            task.wait(0.01)
        end
    end
end)
