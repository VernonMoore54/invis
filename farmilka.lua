-- Координаты для телепортации с направлением
local TELEPORT_CFRAME = CFrame.new(
    -97.5721741, 584.828491, 379.401611,
    -0.917395175, -3.28883658e-08, 0.397977561,
    -3.93950579e-08, 1, -8.17249646e-09,
    -0.397977561, -2.31757582e-08, -0.917395175
)
local TARGET_ANIMATION_ID = "10470389827"
local CHECK_RADIUS = 20
local COLLISION_DISABLE_INTERVAL = 1

-- Получение служб
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Функция для обработки нового персонажа
local function handleCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")

    -- Цикл телепортации и обнуления инерции
    RunService.Stepped:Connect(function()
        rootPart.CFrame = TELEPORT_CFRAME
        rootPart.Velocity = Vector3.zero
    end)

    -- Цикл проверки анимаций других игроков
    RunService.Stepped:Connect(function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer and player.Character then
                local otherHumanoid = player.Character:FindFirstChild("Humanoid")
                local animator = otherHumanoid and otherHumanoid:FindFirstChildOfClass("Animator")
                if animator then
                    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                        if track.Animation.AnimationId == "rbxassetid://" .. TARGET_ANIMATION_ID then
                            local distance = (player.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                            if distance <= CHECK_RADIUS then
                                humanoid.Health = 0
                                return
                            end
                        end
                    end
                end
            end
        end
    end)
end

-- Отключение коллизии у всех частей игроков
local function disableCollisions()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end

task.spawn(function()
    while true do
        disableCollisions()
        wait(COLLISION_DISABLE_INTERVAL)
    end
end)

-- Обработчик для Players.LocalPlayer
Players.LocalPlayer.CharacterAdded:Connect(handleCharacter)
if Players.LocalPlayer.Character then
    handleCharacter(Players.LocalPlayer.Character)
end
