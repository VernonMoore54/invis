local delay = 0.075

-- Создаем таблицу для хранения скриптов
local scripts = {}

-- Добавляем скрипты в таблицу
table.insert(scripts, [==[
loadstring(game:HttpGet("https://raw.githubusercontent.com/uksfx/infiniteyield-reborn-reborn/master/source"))()
]==])


table.insert(scripts, [==[
local UIS = game:GetService("UserInputService")

local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()

function GetCharacter()
   return game.Players.LocalPlayer.Character
end

function Teleport(pos)
   if game.Players.LocalPlayer.Character:GetAttribute("Invis") == false then
       -- Режим невидимости не активен, перемещаем оригинального персонажа
       local Char = GetCharacter()
       Char:MoveTo(pos)
   else
       -- Режим невидимости активен, перемещаем FakePart
       local FakePart = workspace.FakePart
       if game.Players.LocalPlayer.Character:GetAttribute("Invis") == true then
           FakePart.CFrame = CFrame.new(pos)
       end
   end
end

UIS.InputBegan:Connect(function(input)
   if input.UserInputType == Enum.UserInputType.MouseButton1 and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
       local targetPosition = Mouse.Hit.p
       -- Проверяем координату Y
       if targetPosition.Y < 400 then
           -- Если Y меньше 400, заменяем его на 1000
           targetPosition = Vector3.new(targetPosition.X, 1000, targetPosition.Z)
       end
       Teleport(targetPosition)
   end
end)
]==])

table.insert(scripts, [==[
local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")
local teleportDistance = 0.01 

local function findNearestPlayer()
    local nearestPlayer = nil
    local nearestDistance = math.huge
    local character = player.Character
    if character then
        local playerPosition = character.HumanoidRootPart.Position
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                local character = workspace.Live:FindFirstChild(player.Name)
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local targetPosition = character.HumanoidRootPart.Position
                    local distance = (targetPosition - playerPosition).magnitude
                    if distance < nearestDistance then
                        nearestPlayer = player
                        nearestDistance = distance
                    end
                end
            end
        end
    end
    return nearestPlayer
end

local function teleportToNearestPlayer()
    local nearestPlayer = findNearestPlayer()
    if nearestPlayer then
        local character = player.Character
        if character then
            local targetCharacter = nearestPlayer.Character
            local targetPosition = targetCharacter.HumanoidRootPart.Position - targetCharacter.HumanoidRootPart.CFrame.lookVector * teleportDistance
            character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
        end
    end
end

local runService = game:GetService("RunService")
local heartbeatConnection = nil

userInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.Five and not gameProcessedEvent then
        heartbeatConnection = runService.Heartbeat:Connect(function()
            teleportToNearestPlayer()
        end)
    end
end)

userInputService.InputEnded:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.Five and not gameProcessedEvent then
        if heartbeatConnection then
            heartbeatConnection:Disconnect()
            heartbeatConnection = nil
        end
    end
end)

player.CharacterAdded:Connect(function(character)
    -- Эта строка не нужна, так как character уже передается в функцию
    -- character = character
end)
]==])


table.insert(scripts, [==[
loadstring(game:HttpGet("https://raw.githubusercontent.com/VernonMoore54/myprice/refs/heads/main/TSBUtils.lua"))()
]==])

table.insert(scripts, [==[
-- Получаем игрока
local player = game:GetService("Players").LocalPlayer

-- Обходим все объекты ScreenGui в PlayerGui
for _, screenGui in pairs(player.PlayerGui:GetChildren()) do
    if screenGui:IsA("ScreenGui") then
        -- Устанавливаем ResetOnSpawn в false
        screenGui.ResetOnSpawn = false
    end
end

local ScriptStarted = false
local Keybind = "H" -- Установите на нужную вам клавишу
local Transparency = true -- Сделает вас немного прозрачным, когда вы невидимы
local NoClip = true -- Сделает вашего фейкового персонажа без коллизий

local Player = game:GetService("Players").LocalPlayer
local RealCharacter = Player.Character or Player.CharacterAdded:Wait()

local IsInvisible = false

RealCharacter.Archivable = true
local FakeCharacter = RealCharacter:Clone()
local Part
Part = Instance.new("Part", workspace)
Part.Anchored = true
Part.Size = Vector3.new(444, 4, 444)
Part.CFrame = CFrame.new(965811918581, 918751121951, 958188191939)
Part.CanCollide = true
FakeCharacter.Parent = workspace
FakeCharacter.HumanoidRootPart.CFrame = Part.CFrame * CFrame.new(0, 5, 0)

for i, v in pairs(RealCharacter:GetChildren()) do
    if v:IsA("LocalScript") then
        local clone = v:Clone()
        clone.Disabled = true
        clone.Parent = FakeCharacter
    end
end

if Transparency then
    for i, v in pairs(FakeCharacter:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Transparency = 0.7
        end
    end
end

local CanInvis = true

-- Динамические точки для обновления позиции
local SafeAreaPoints = {
    Vector3.new(955811918481, 918751121951, 958188191939),
    Vector3.new(945811918681, 918751121951, 958188191939),
    Vector3.new(965811918381, 918751121951, 958188191939),
    Vector3.new(935811918581, 918751121851, 958188191939),
    Vector3.new(925811918581, 918751121951, 958188191949),
    Vector3.new(915811914581, 918751121951, 958188191939),
    Vector3.new(975811918581, 918751124951, 958188191939),
    Vector3.new(985811918581, 918751131951, 958188191939),
    Vector3.new(995811918581, 918751122951, 958188191939),
}

local function UpdateSafeArea()
    local RandomPoint = SafeAreaPoints[math.random(1, #SafeAreaPoints)]
    Part.CFrame = CFrame.new(RandomPoint) * CFrame.new(0, 5, 0)
end

-- Удаление дублирующегося обработчика события Died
RealCharacter.Humanoid.Died:Connect(function()
    RealCharacter:Destroy()
    FakeCharacter:Destroy()
end)

function RealCharacterDied()
    CanInvis = false
    RealCharacter:Destroy()
    RealCharacter = Player.Character
    CanInvis = true
    IsInvisible = false

    -- Оптимизация создания/удаления FakeCharacter
    if not FakeCharacter or FakeCharacter.Parent ~= workspace then
        FakeCharacter = RealCharacter:Clone()
        FakeCharacter.Parent = workspace
        FakeCharacter.HumanoidRootPart.CFrame = Part.CFrame * CFrame.new(0, 5, 0)

        for i, v in pairs(RealCharacter:GetChildren()) do
            if v:IsA("LocalScript") then
                local clone = v:Clone()
                clone.Disabled = true
                clone.Parent = FakeCharacter
            end
        end

        if Transparency then
            for i, v in pairs(FakeCharacter:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Transparency = 0.5
                end
            end
        end
    end
end

game:GetService("RunService").RenderStepped:Connect(
    function()
        if PseudoAnchor ~= nil then
            PseudoAnchor.CFrame = Part.CFrame * CFrame.new(0, 5, 0)
        end

        -- Использование FakeCharacter.Humanoid.PlatformStand вместо FakeCharacter.Humanoid:ChangeState(11)
        FakeCharacter.Humanoid.PlatformStand = false
        UpdateSafeArea() -- Обновляем позицию на каждом кадре
    end
)

PseudoAnchor = FakeCharacter.HumanoidRootPart

local function resetVelocity()
    local character = Player.Character or Player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Обнуляем скорость
    humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
end

local function startResettingVelocity()
    local duration = 0.02 -- Длительность обнуления
    local endTime = tick() + duration

    while tick() < endTime do
        resetVelocity()
        game:GetService("RunService").RenderStepped:Wait() -- Ждем следующий кадр
    end
end

local function Invisible()
    if IsInvisible == false then
        local StoredCF = RealCharacter.HumanoidRootPart.CFrame
        RealCharacter.HumanoidRootPart.CFrame = FakeCharacter.HumanoidRootPart.CFrame
        FakeCharacter.HumanoidRootPart.CFrame = StoredCF
        Player.Character = FakeCharacter
        workspace.CurrentCamera.CameraSubject = FakeCharacter.Humanoid
        PseudoAnchor = RealCharacter.HumanoidRootPart
        for i, v in pairs(FakeCharacter:GetChildren()) do
            if v:IsA("LocalScript") then
                v.Disabled = false
            end
        end

        -- Обнуляем инерцию при входе в невидимость
        startResettingVelocity()

        IsInvisible = true
    else
        local StoredCF = FakeCharacter.HumanoidRootPart.CFrame
        FakeCharacter.HumanoidRootPart.CFrame = RealCharacter.HumanoidRootPart.CFrame
        RealCharacter.HumanoidRootPart.CFrame = StoredCF

        Player.Character = RealCharacter
        workspace.CurrentCamera.CameraSubject = RealCharacter.Humanoid
        PseudoAnchor = FakeCharacter.HumanoidRootPart
        for i, v in pairs(FakeCharacter:GetChildren()) do
            if v:IsA("LocalScript") then
                v.Disabled = true
            end
        end

        -- Обнуляем инерцию при выходе из невидимости
        startResettingVelocity()

        IsInvisible = false
    end
end

game:GetService("UserInputService").InputBegan:Connect(
    function(key, gamep)
        if gamep then
            return
        end
        if key.KeyCode.Name:lower() == Keybind:lower() and CanInvis and RealCharacter and FakeCharacter then
            if RealCharacter:FindFirstChild("HumanoidRootPart") and FakeCharacter:FindFirstChild("HumanoidRootPart") then
                Invisible()
            end
        end
    end
)

local Sound = Instance.new("Sound", game:GetService("SoundService"))
Sound.SoundId = "rbxassetid://2661731024"
Sound:Play()
game:GetService("StarterGui"):SetCore("SendNotification", {["Title"] = "FE Invisible ON", ["Text"] = "Press " .. Keybind .. ". Made by Vernon.", ["Duration"] = 5, ["Button1"] = "Ok..."})
]==])


-- Функция для ввода скриптов с задержкой
local function runScripts()
    for i, script in ipairs(scripts) do
        wait(delay)
        loadstring(script)()
    end
end

-- Вводим скрипты
runScripts()
