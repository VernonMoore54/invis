repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer
repeat task.wait() until game.Players.LocalPlayer.Character

task.wait()

setfpscap(155)


--[[============================================================================
    LocalScript: PlantingWithToggleAndFarm.lua
    Расположение: StarterGui → PlantingWithToggleAndFarm.lua
    (Каждый раз, когда вы вставляете/выполняете этот скрипт, он удалит старый UI,
     если он есть, и создаст новый.)

    Содержание:
      1) Удаляем старый UI "PlantingToggleGUI", если он существует.
      2) Создаём новый ScreenGui с кнопкой-переключателем (Draggable).
      3) По клику включаем/выключаем режим “тасовать-сажать + фармить + продавать”.
      4) Основной цикл: пока включен переключатель, выполняем по порядку:
           a) Переносим все предметы из Backpack → Character, кроме Shovel [Destroy Plants].
           b) Тасуем список фруктов и для каждого шлём Plant_RE:FireServer(targetPosPlant, name).
           c) Телепортируем персонажа на (24 ±5, 3, -126 ±5).
           d) Ждём 0.3 сек.
           e) Зажимаем "E" через VirtualInputManager и **пока удерживаем E**:
                – с небольшой задержкой (0.5 сек) повторяем:
                    1) Телепортируем персонажа снова на (24 ±5, 3, -126 ±5).
                    2) Переносим все предметы из Backpack → Character (кроме того же Shovel).
                    3) Тасуем список фруктов и для каждого шлём Plant_RE:FireServer.
                    4) Проверяем общее количество Tool-ов (рюкзак + персонаж).
                – Как только количество Tool-ов > 130 **или** переключатель выключили, выходим из цикла.
           f) После выхода из цикла — отпускаем "E".
           g) Телепортируем персонажа на (89, 3, 0).
           h) Ждём 0.3 сек.
           i) Три раза вызываем RemoteEvent Sell_Inventory:FireServer().
      5) После продачи цикл повторяется, пока переключатель включен. При выключении – 
         скрипт досрочно прерывает все действия.
================================================================================]]

local Players            = game:GetService("Players")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local VirtualInputMgr    = game:GetService("VirtualInputManager")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-------------------------------------------------------------------------------
-- 1) Если есть старый UI "PlantingToggleGUI" – удаляем его
-------------------------------------------------------------------------------
local oldGui = playerGui:FindFirstChild("PlantingToggleGUI")
if oldGui then
    oldGui:Destroy()
end

-------------------------------------------------------------------------------
-- 2) Создаём новый ScreenGui + кнопку-переключатель
-------------------------------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name         = "PlantingToggleGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent       = playerGui

local toggleButton = Instance.new("TextButton")
toggleButton.Name             = "ToggleButton"
toggleButton.Text             = "OFF"
toggleButton.Font             = Enum.Font.SourceSansBold
toggleButton.TextSize         = 20
toggleButton.TextColor3       = Color3.new(1, 1, 1)
toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleButton.Size             = UDim2.new(0, 100, 0, 40)
toggleButton.Position         = UDim2.new(0.35, 0, 0.1, 0)
toggleButton.AnchorPoint      = Vector2.new(0, 0)
toggleButton.Active           = true
toggleButton.Draggable        = true
toggleButton.Parent           = screenGui

-------------------------------------------------------------------------------
-- 3) Переменная-состояние: включен ли режим фарма/посадки/продажи
-------------------------------------------------------------------------------
local enabled = false

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

-------------------------------------------------------------------------------
-- 4) Настройка данных для посадки и продажи
-------------------------------------------------------------------------------

-- 4.1) Координаты для посадки фруктов
local targetPosPlant = Vector3.new(26.787460327148438, 0.13552704453468323, -130.29730224609375)

-- 4.2) Базовая точка для фермы (центральная координата без рандома)
local farmBase = Vector3.new(24, 3, -126)

-- 4.2.a) Функция, возвращающая рандомизированную точку фермы ±5 метров по X и Z
local function getRandomFarmPos()
    local offsetX = (math.random() * 10) - 5
    local offsetZ = (math.random() * 10) - 5
    return Vector3.new(
        farmBase.X + offsetX,
        farmBase.Y,
        farmBase.Z + offsetZ
    )
end

-- 4.3) Координаты для продажи (после фарма)
local sellPos = Vector3.new(89, 3, 0)

-- 4.4) Список фруктов/растений
local fruitNames = {
    "Tomato",
    "Carrot",
    "Strawberry",
    "Orange Tulip",
    "Corn",
    "Blueberry",
    "Daffodil",
    "Watermelon",
    "Pumpkin",
    "Apple",
    "Bamboo",
    "Coconut",
    "Cactus",
    "Dragon Fruit",
    "Mango",
    "Grape",
    "Mushroom",
    "Pepper",
    "Cacao",
    "Beanstalk",
    "Raspberry",
    -- добавьте остальные названия по необходимости...
}

-- 4.5) Fisher–Yates shuffle (каждый проход – новый порядок)
local function shuffle(t)
    local temp = {}
    for i = 1, #t do
        temp[i] = t[i]
    end
    for i = #temp, 2, -1 do
        local j = math.random(i)
        temp[i], temp[j] = temp[j], temp[i]
    end
    return temp
end

-- 4.6) Инициализируем math.random
math.randomseed(tick())

-- 4.7) RemoteEvent для посадки
local plantEvent = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("Plant_RE")

-- 4.8) RemoteEvent для продажи
local sellEvent = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("Sell_Inventory")

-- 4.9) Ссылки на Backpack и Character
local backpack = player:WaitForChild("Backpack")
local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

-------------------------------------------------------------------------------
-- 5) Функция для подсчёта Tool-ов в Backpack + Character
-------------------------------------------------------------------------------
local function countTools()
    local count = 0
    -- считаем в рюкзаке
    for _, item in ipairs(backpack:GetChildren()) do
        if item:IsA("Tool") then
            count = count + 1
        end
    end
    -- считаем на персонаже (возможно предметы уже туда перенесены)
    local character = getCharacter()
    for _, item in ipairs(character:GetChildren()) do
        if item:IsA("Tool") then
            count = count + 1
        end
    end
    return count
end

-------------------------------------------------------------------------------
-- 6) Основной цикл
-------------------------------------------------------------------------------
task.spawn(function()
    while true do
        -- Ждём немного перед каждой итерацией, чтобы не перегружать CPU:
        task.wait(0.05)

        if not enabled then
            continue
        end

        ----------------------------------------------------------------------------
        -- 6.a) Переносим всё из Backpack → Character, кроме "Shovel [Destroy Plants]"
        ----------------------------------------------------------------------------
        local character = getCharacter()
        for _, item in ipairs(backpack:GetChildren()) do
            if item.Name ~= "Shovel [Destroy Plants]" then
                item.Parent = character
            end
        end

        ----------------------------------------------------------------------------
        -- 6.b) Посадка фруктов: тасуем список и шлём Plant_RE для каждого
        ----------------------------------------------------------------------------
        do
            local shuffledNames = shuffle(fruitNames)
            for _, name in ipairs(shuffledNames) do
                if not enabled then break end
                plantEvent:FireServer(targetPosPlant, name)
                -- при необходимости можно вставить небольшой task.wait(0.01)
            end
            if not enabled then
                continue
            end
        end

        ----------------------------------------------------------------------------
        -- 6.c) Телепортируем персонажа на рандомизированную позицию фермы
        ----------------------------------------------------------------------------
        do
            character = getCharacter()
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(getRandomFarmPos())
            end
        end

        ----------------------------------------------------------------------------
        -- 6.d) Ждём 0.3 секунды
        ----------------------------------------------------------------------------
        do
            local elapsed = 0
            while elapsed < 0.2 do
                task.wait(0.02)
                elapsed = elapsed + 0.02
                if not enabled then break end
            end
            if not enabled then continue end
        end

        ----------------------------------------------------------------------------
        -- 6.e) Зажимаем "E" и — пока удерживаем E
        --       1) Каждые 0.5 сек телепортируем на новую рандомизированную ферму
        --       2) Переносим все предметы из Backpack → Character (кроме лопаты)
        --       3) Тасуем список фруктов и сажаем
        --       4) Проверяем общее количество Tool-ов
        ----------------------------------------------------------------------------
        do
            -- Зажимаем E
            

            -- Пока включён режим:
            while enabled do
                -- 6.e.1) Телепорт на новую рандомизированную позицию фермы
                character = getCharacter()
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = CFrame.new(getRandomFarmPos())
                    VirtualInputMgr:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                    task.wait(0.03)
                    VirtualInputMgr:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                end

                -- 6.e.2) Переносим всё из Backpack → Character (кроме "Shovel [Destroy Plants]")
                character = getCharacter()
                for _, item in ipairs(backpack:GetChildren()) do
                    if item.Name ~= "Shovel [Destroy Plants]" then
                        item.Parent = character
                    end
                end

                -- 6.e.3) Посадка фруктов во время удержания E
                local shuffledNames2 = shuffle(fruitNames)
                for _, name in ipairs(shuffledNames2) do
                    if not enabled then break end
                    plantEvent:FireServer(targetPosPlant, name)
                end
                if not enabled then
                    break
                end

                -- 6.e.4) Проверяем количество Tool-ов
                local toolCount = countTools()
                if toolCount > 130 then
                    break
                end

                -- Ждём 0.5 секунды перед следующим заходом
                local waited = 0
                while waited < 0.1 do
                    task.wait(0.01)
                    waited = waited + 0.01
                    if not enabled then break end
                end
                if not enabled then
                    break
                end
            end

            -- Отпускаем E

            -- Если переключатель выключили во время удержания E
            if not enabled then
                continue
            end
        end

        ----------------------------------------------------------------------------
        -- 6.f) Телепортируем персонажа на позицию продажи
        ----------------------------------------------------------------------------
        do
            character = getCharacter()
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(sellPos)
            end
        end

        ----------------------------------------------------------------------------
        -- 6.g) Ждём 0.3 секунды
        ----------------------------------------------------------------------------
        do
            local elapsed = 0
            while elapsed < 0.1 do
                task.wait(0.01)
                elapsed = elapsed + 0.01
                if not enabled then break end
            end
            if not enabled then continue end
        end

        ----------------------------------------------------------------------------
        -- 6.h) Вызываем Sell_Inventory:FireServer() три раза
        ----------------------------------------------------------------------------
        do
            for i = 1, 3 do
                if not enabled then break end
                sellEvent:FireServer()
                task.wait(0.01)
            end
        end

        -- После этого внешний while вернётся к началу и проверит enabled снова.
    end
end)
