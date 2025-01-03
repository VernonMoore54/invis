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
   local Char = GetCharacter()
   if Char then
       Char:MoveTo(pos)
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
local mouse = player:GetMouse()
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

mouse.Button2Down:Connect(function()

    heartbeatConnection = runService.Heartbeat:Connect(function()
        teleportToNearestPlayer()
    end)
end)

mouse.Button2Up:Connect(function()

    if heartbeatConnection then
        heartbeatConnection:Disconnect()
    end
end)

player.CharacterAdded:Connect(function(character)
    
    character = character
    end)
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
Part.CFrame = CFrame.new(965811918581, 9918751121951, 958188191939)
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
    Vector3.new(99818151121951, 99918151121951, 99818151121951),
    Vector3.new(99818151121951, 99918251121921, 99818151121951),
    Vector3.new(99818151121951, 99918351121931, 99818151121951),
    Vector3.new(99818151121951, 99918451121841, 99818151121951),
    Vector3.new(99818151121951, 99918551121961, 99818151121951),
    Vector3.new(99818151121951, 99918651121971, 99818151121951),
    Vector3.new(99818151121951, 99918751124981, 99818151121951),
    Vector3.new(99818151121951, 99918851131991, 99818151121951),
    Vector3.new(99818151121951, 99918951122751, 99818151121951),
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
    local duration = 0.05 -- Длительность обнуления
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
Sound.SoundId = "rbxassetid://9050683445"
Sound:Play()
game:GetService("StarterGui"):SetCore("SendNotification", {["Title"] = "FE Invisible ON", ["Text"] = "Press " .. Keybind .. ". Made by Vernon.", ["Duration"] = 5, ["Button1"] = "Ok..."})
]==])

table.insert(scripts, [==[
loadstring(game:HttpGet("https://raw.githubusercontent.com/FFJ1/Roblox-Exploits/main/scripts/TSBUtils.lua"))()
]==])

table.insert(scripts, [==[
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer

function GetCharacter()
    return Player.Character or Player.CharacterAdded:Wait()
end

function KickUp()
    local Char = GetCharacter()
    if Char and Char:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = Char.HumanoidRootPart
        
        -- Проверяем координату Y
        if humanoidRootPart.Position.Y < 0 then
            -- Создаем BodyVelocity для пинка
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, 500, 0) -- Устанавливаем скорость вверх
            bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0) -- Ограничиваем силу только по оси Y
            bodyVelocity.Parent = humanoidRootPart
            
            -- Удаляем BodyVelocity через короткое время, чтобы не мешать движению
            wait(0.1)
            bodyVelocity:Destroy()
        end
    end
end

-- Подключаем функцию к событию Heartbeat для постоянной проверки высоты персонажа
RunService.Heartbeat:Connect(KickUp)
]==])

table.insert(scripts, [==[
-- Переменные для управления скриптом
local SCRIPT_ENABLED = false
local FLYING = false
local TARGET_ANIMATION_IDS = { -- Таблица ID целевых анимаций
    "16515448089",
    "17889471098",
    "15240176873",
    "14001963401",
    "13378751717",
    "13295919399",
    "13532604085",
    "10469639222"
}
local WAIT_TIME_AFTER_DISABLE = 0.5 -- Время ожидания перед повторным запуском

-- Индикатор состояния
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local Indicator = Instance.new("TextLabel")
Indicator.Size = UDim2.new(0, 200, 0, 50)
Indicator.Position = UDim2.new(0, 10, 1, -60)
Indicator.BackgroundColor3 = Color3.new(1, 0, 0) -- Красный по умолчанию
Indicator.Text = "Script Disabled"
Indicator.TextColor3 = Color3.new(1, 1, 1)
Indicator.TextScaled = true
Indicator.Parent = ScreenGui

-- Функция для полёта
function sFLY()
    repeat wait() until game.Players.LocalPlayer and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local Character = game.Players.LocalPlayer.Character
    local hrp = Character:FindFirstChild("HumanoidRootPart")

    local BG = Instance.new('AlignOrientation')
    BG.Mode = Enum.OrientationAlignmentMode.OneAttachment
    BG.RigidityEnabled = true
    BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    BG.CFrame = hrp.CFrame * CFrame.Angles(math.rad(-90), 0, 0)
    BG.Attachment0 = Instance.new('Attachment', hrp)
    BG.Parent = hrp

    task.spawn(function()
        FLYING = true
        while FLYING do
            wait()
            BG.CFrame = hrp.CFrame * CFrame.Angles(math.rad(-2), 0, 0)
        end
    end)

    task.delay(1.5, function()
        FLYING = false
        BG:Destroy()
    end)
end

-- Функция ожидания целевых анимаций
function waitForAnimations()
    repeat
        if not SCRIPT_ENABLED then return false end
        local Character = game.Players.LocalPlayer.Character
        if Character and Character:FindFirstChild("Humanoid") then
            local animator = Character.Humanoid:FindFirstChildOfClass("Animator")
            if animator then
                for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                    for _, animId in ipairs(TARGET_ANIMATION_IDS) do
                        if track.Animation.AnimationId == "rbxassetid://" .. animId then
                            return true
                        end
                    end
                end
            end
        end
        wait()
    until false
end

-- Функция для переключения состояния скрипта
function toggleScript()
    SCRIPT_ENABLED = not SCRIPT_ENABLED
    if SCRIPT_ENABLED then
        Indicator.BackgroundColor3 = Color3.new(0, 1, 0) -- Зелёный
        Indicator.Text = "Script Enabled"
    else
        Indicator.BackgroundColor3 = Color3.new(1, 0, 0) -- Красный
        Indicator.Text = "Script Disabled"
    end
end

-- Привязываем переключатель к клавише R
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.R then
        toggleScript()
    end
end)

-- Основной цикл
task.spawn(function()
    while true do
        if SCRIPT_ENABLED and waitForAnimations() then
            sFLY()
            wait(1.7 + WAIT_TIME_AFTER_DISABLE)
        else
            wait(0.1)
        end
    end
end)
]==])

table.insert(scripts, [==[
--- Drawing Player Radar
--- Made by topit

_G.RadarSettings = {
    --- Radar settings
    RADAR_LINES = true; -- Displays distance rings + cardinal lines 
    RADAR_LINE_DISTANCE = 50; -- The distance between each distance ring
    RADAR_SCALE = 1; -- Controls how "zoomed in" the radar display is 
    RADAR_RADIUS = 125; -- The size of the radar itself
    RADAR_ROTATION = true; -- Toggles radar rotation. Looks kinda trippy when disabled
    SMOOTH_ROT = true; -- Toggles smooth radar rotation
    SMOOTH_ROT_AMNT = 30; -- Lower number is smoother, higher number is snappier 
    CARDINAL_DISPLAY = true; -- Displays the four cardinal directions (north east south west) around the radar
    
    --- Marker settings
    DISPLAY_OFFSCREEN = true; -- Displays offscreen / off-radar markers
    DISPLAY_TEAMMATES = true; -- Displays markers that belong to your teammates
    DISPLAY_TEAM_COLORS = true; -- Displays your teammates markers with either a custom color (change Team_Marker) or with that teams TeamColor (enable USE_TEAM_COLORS) 
    DISPLAY_FRIEND_COLORS = true; -- Displays your friends markers with a custom color (Friend_Marker). This takes priority over DISPLAY_TEAM_COLORS and DISPLAY_RGB
    DISPLAY_RGB_COLORS = false; -- Displays each marker with an RGB cycle. Takes priority over DISPLAY_TEAM_COLORS, but not DISPLAY_FRIEND_COLORS
    MARKER_SCALE_BASE = 1.25; -- Base scale that gets applied to markers
    MARKER_SCALE_MAX = 1.25; -- The largest scale that a marker can be
    MARKER_SCALE_MIN = 0.75; -- The smallest scale that a marker can be
    MARKER_FALLOFF = true; -- Affects the markers' scale depending on how far away the player is - bypasses SCALE_MIN and SCALE_MAX
    MARKER_FALLOFF_AMNT = 125; -- How close someone has to be for falloff to start affecting them 
    OFFSCREEN_TRANSPARENCY = 0.3; -- Transparency of offscreen markers
    USE_FALLBACK = false; -- Enables an emergency "fallback mode" for StreamingEnabled games
    USE_QUADS = true; -- Displays radar markers as arrows instead of dots 
    USE_TEAM_COLORS = false; -- Uses a team's TeamColor for marker colors
    VISIBLITY_CHECK = false; -- Makes markers that are not visible slightly transparent 
    
    --- Theme
    RADAR_THEME = {
        Outline = Color3.fromRGB(35, 35, 45); -- Radar outline
        Background = Color3.fromRGB(25, 25, 35); -- Radar background
        DragHandle = Color3.fromRGB(50, 50, 255); -- Drag handle 
        
        Cardinal_Lines = Color3.fromRGB(110, 110, 120); -- Color of the horizontal and vertical lines
        Distance_Lines = Color3.fromRGB(65, 65, 75); -- Color of the distance rings
        
        Generic_Marker = Color3.fromRGB(255, 25, 115); -- Color of a player marker without a team
        Local_Marker = Color3.fromRGB(115, 25, 255); -- Color of your marker, regardless of team
        Team_Marker = Color3.fromRGB(25, 115, 255); -- Color of your teammates markers. Used when DISPLAY_TEAM_COLORS is disabled
        Friend_Marker = Color3.fromRGB(25, 255, 115); -- Color of your friends markers. Used when DISPLAY_FRIEND_COLORS is enabled 
    };
}

loadstring(game:HttpGet('https://raw.githubusercontent.com/VernonMoore54/invis/refs/heads/main/Radar.lua'))()
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

