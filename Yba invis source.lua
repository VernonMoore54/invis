--//Config\\--
local InvisibilityKey = Enum.KeyCode.Z

--//Services\\--
local UserInputService = game:GetService("UserInputService")
local PlayerService = game:GetService("Players")

--//Variables\\--
local LocalPlayer = PlayerService.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")

local UndergroundAnimation, Highlight
function PlayAnimation(HumanoidCharacter, AnimationID, AnimationSpeed, Time)
	local CreatedAnimation = Instance.new("Animation")
	CreatedAnimation.AnimationId = AnimationID
    local animationTrack = HumanoidCharacter:FindFirstChildOfClass("Humanoid"):FindFirstChildOfClass("Animator"):LoadAnimation(CreatedAnimation)

	animationTrack:Play()
	animationTrack:AdjustSpeed(AnimationSpeed)
	animationTrack.Priority= Enum.AnimationPriority.Action4
	animationTrack.TimePosition = Time
	return animationTrack
end

local function Invisibile()
    local HUD = PlayerGui:FindFirstChild("HUD")
    HUD.Parent = nil

    --//As Simple As That Gang\\--
    UndergroundAnimation = PlayAnimation(Character, "rbxassetid://7189062263", 0, 5)
    LocalPlayer.Character = nil

    UndergroundAnimation:Stop()
    LocalPlayer.Character = Character

    HUD.Parent = PlayerGui

    Highlight = Instance.new("Highlight")
    Highlight.Parent = Character
    Highlight.Enabled = true
end

local function Uninvisible()
    --//As Simple As That Gang\\--
    PlayAnimation(Character, "rbxassetid://7189062263", 0, 5):Stop()
    Highlight:Destroy()
end

local IsInvisibile
UserInputService.InputBegan:Connect(function(Input, GameProccessed)
    if GameProccessed then return end
    if Input.KeyCode ~= InvisibilityKey then return end

    if IsInvisibile then
        Uninvisible()
    else
        Invisibile()
    end

    IsInvisibile = not IsInvisibile
end)

--//Bypasses\\--
local TPBypass
TPBypass = hookfunction(getrawmetatable(game).__namecall, newcclosure(function(self, ...)
  local args = {...}
  if self.Name == "Returner" and args[1] == "idklolbrah2de"  then
          return "  ___XP DE KEY"
      end
  return TPBypass(self, ...)
end))
