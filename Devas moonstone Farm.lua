-- Установка VirtualInputManager
local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character

-- Список координат для телепортации
local positions = {
    Vector3.new(2417, -243, 540),
    Vector3.new(1693, -213, -195),
    Vector3.new(2294, -232, 106),
    Vector3.new(1631, -224, 188),
}

-- Глобальный флаг для контроля работы скрипта
_G.farmEnabled = true

-- Функция для телепортации
local function teleportToPosition(position)
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        -- Телепортируем персонажа к заданной позиции
        player.Character.HumanoidRootPart.CFrame = CFrame.new(position)
    end
end

-- Функция для нажатия клавиши G через VirtualInputManager
local function pressKeyG()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.G, false, game)
    wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.G, false, game)
end

-- Функция для телепортации на 30 единиц вниз
local function teleportDownBy30()
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        -- Получаем текущее местоположение персонажа
        local currentPosition = player.Character.HumanoidRootPart.Position
        -- Вычитаем 30 единиц по оси Y (вниз)
        local newPosition = currentPosition - Vector3.new(0, 30, 0)
        -- Телепортируем персонажа на новую позицию
        player.Character.HumanoidRootPart.CFrame = CFrame.new(newPosition)
    end
end

-- Основной цикл
while _G.farmEnabled do
    -- Проходим по всем координатам по очереди
    for _, position in ipairs(positions) do
        -- Проверяем, активен ли флаг перед каждым шагом
        if not _G.farmEnabled then return end

        -- Телепортация к текущей позиции
        teleportToPosition(position)
        
        -- Подождать 0.75 секунд перед нажатием G
        wait(0.75)
        
        -- Нажать клавишу G
        pressKeyG()
		wait(0.1)

        -- Телепортация на 30 единиц вниз после нажатия G
        teleportDownBy30()
		wait(0.1)
		character.HumanoidRootPart.Anchored = true
        
        -- Подождать 6.5 секунд перед переходом к следующей позиции
        wait(6.5)
		character.HumanoidRootPart.Anchored = false
    end
end
