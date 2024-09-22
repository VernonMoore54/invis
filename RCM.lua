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
