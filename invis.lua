-- FE Invisible by NewScriptAuthor
-- Inspired from BitingTheDust version ; https://v3rmillion.net/member.php?action=profile&uid=1628149
local Env = getgenv and getgenv() or _G
local Initial = true
local Loop = true
local SoundManager = game:GetService("SoundService")
local CachedPosition
local SafeArea
if Env.SafeArea ~= nil then
	if type(Env.SafeArea) ~= "userdata" then return error("CFrame must be a userdata (CFrame.new(X, X, X)") end
	SafeArea = Env.SafeArea
else
	SafeArea = CFrame.new(0,-300,0)       
end

local ScriptActive = true
local ResetFlag = false
local RemoveOnDeath = {}
local TriggerKey
local BypassCollision
if Env.Key == nil then
	TriggerKey = "H" 
else
	TriggerKey = tostring(Env.Key)     
end

if Env.BypassCollision == nil then
	BypassCollision = false
else
	BypassCollision = Env.BypassCollision        
end

if type(BypassCollision) ~= "boolean" then return error("Noclip value isn't a boolean") end

function notifyUser(Message)
	game:GetService("StarterGui"):SetCore("SendNotification", { 
		Title = "FE Invisible";
		Text = Message;
		Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150"})
	local soundInstance = Instance.new("Sound")
	soundInstance.SoundId = "rbxassetid://7046168694"
	SoundManager:PlayLocalSound(soundInstance)
end

if Env.Active then
	return notifyUser("Script is already running")
else
	Env.Active = true
end

local CurrentlyInvisible = false
local PreviouslyInvisible = false
local IsDead = false
local Player = game:GetService("Players").LocalPlayer
local InputService = game:GetService("UserInputService")
repeat wait() until Player.Character
repeat wait() until Player.Character:FindFirstChild("Humanoid")
local OriginalCharacter = Player.Character or Player.CharacterAdded:Wait()
OriginalCharacter.Archivable = true
local CloneCharacter = OriginalCharacter:Clone()
CloneCharacter:WaitForChild("Humanoid").DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
CloneCharacter.Parent = game:GetService("Workspace")

for _, part in pairs(CloneCharacter:GetDescendants()) do
	if part:IsA("BasePart") and part.CanCollide == true then
		part.CanCollide = false
	end
end

CloneCharacter:SetPrimaryPartCFrame(SafeArea * CFrame.new(0, 5, 0))

local GroundPart
GroundPart = Instance.new("Part", workspace)
GroundPart.Anchored = true
GroundPart.Size = Vector3.new(200, 1, 200)
GroundPart.CFrame = SafeArea
GroundPart.CanCollide = true


for i, v in pairs(CloneCharacter:GetDescendants()) do
	if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
		v.Transparency = 0.7
	end
end

for i, v in pairs(OriginalCharacter:GetChildren()) do
	if v:IsA("LocalScript") then
		local copyScript = v:Clone()
		copyScript.Disabled = true
		copyScript.Parent = CloneCharacter
	end
end

function EndScript()
	if ScriptActive == false then return end
	if IsDead == false then
		if Loop == true then
			notifyUser("The character used died!\nStopping...")
		else
			notifyUser("Script successfully ended!")
		end
		GroundPart:Destroy()
		if CurrentlyInvisible and OriginalCharacter:FindFirstChild("HumanoidRootPart") then
			Show() 
			PreviouslyInvisible = true
		end
		
		if CurrentlyInvisible == false and Player.Character:WaitForChild("Humanoid").Health == 0 then
			PreviouslyInvisible = true
		end
		
		game:GetService("Workspace").CurrentCamera.CameraSubject = OriginalCharacter:WaitForChild("Humanoid")

		if CloneCharacter then
			CloneCharacter:Destroy()
		end

		if PreviouslyInvisible then
			local charModel = Player.Character
			if charModel:FindFirstChildOfClass("Humanoid") then charModel:FindFirstChildOfClass("Humanoid"):ChangeState(15) end
            
			charModel:ClearAllChildren()
			local newModel = Instance.new("Model")
			newModel.Parent = workspace
            
			Player.Character = newModel
            
			wait()
            
			Player.Character = charModel
            
			newModel:Destroy()
			
			for _,v in pairs(RemoveOnDeath) do
				v:Destroy()
			end
			
		else 
			for _,v in pairs(RemoveOnDeath) do 
				v.ResetOnSpawn = true 
			end 
		end 
		
        Env.Active = false 
        ScriptActive = false 
        
        if Loop == true then 
            loadstring(game:HttpGet('https://raw.githubusercontent.com/Error-Cezar/Roblox-Scripts/main/FE-Invisible.lua'))() 
        end 
		
        Player.CharacterAdded:Connect(function() 
            if ResetFlag == false then return end 
            loadstring(game:HttpGet('https://raw.githubusercontent.com/Error-Cezar/Roblox-Scripts/main/FE-Invisible.lua'))() 
        end) 
		
	end 
end 

OriginalCharacter:WaitForChild("Humanoid").Died:Connect(function() 
	EndScript() 
end)

CloneCharacter:WaitForChild("Humanoid").Died:Connect(function() 
	EndScript() 
end)

function MakeInvisible() 
	CachedPosition = OriginalCharacter:GetPrimaryPartCFrame()
	
if Initial == true then 
    Initial = false 
    for _,v in pairs(Player:WaitForChild("PlayerGui"):GetChildren()) do 
        if v:IsA("ScreenGui") then 
            if v.ResetOnSpawn == true then 
                v.ResetOnSpawn = false 
                table.insert(RemoveOnDeath, v) 
            end 
        end 
    end 
end
	
if BypassCollision == true then 
	for _, child in pairs(CloneCharacter:GetDescendants()) do 
	    if child:IsA("BasePart") and child.CanCollide == true then 
	        child.CanCollide = false 
	    end 
	end 
end 

CloneCharacter:SetPrimaryPartCFrame(CachedPosition) 
CloneCharacter:WaitForChild("HumanoidRootPart").Anchored = false 

Player.Character = CloneCharacter 

game:GetService("Workspace").CurrentCamera.CameraSubject = CloneCharacter:WaitForChild("Humanoid")

for _, child in pairs(OriginalCharacter:GetDescendants()) do 
	if child:IsA("BasePart") and child.CanCollide == true then 
	    child.CanCollide = false 
	end 
end 

OriginalCharacter:SetPrimaryPartCFrame(SafeArea * CFrame.new(0, 5, 0)) 

OriginalCharacter:WaitForChild("Humanoid"):UnequipTools()

for i, v in pairs(CloneCharacter:GetChildren()) do 
	if v:IsA("LocalScript") then 
	    v.Disabled = false 
	end 
end 

end

function Show() 
	CachedPosition = CloneCharacter:GetPrimaryPartCFrame() 

for _, child in pairs(OriginalCharacter:GetDescendants()) do  
	if child:IsA("BasePart") and child.CanCollide == true then  
	    child.CanCollide = true  
	end  
end  

OriginalCharacter:WaitForChild("HumanoidRootPart").Anchored = false  
OriginalCharacter:SetPrimaryPartCFrame(CachedPosition)  
Player.Character = OriginalCharacter  

CloneCharacter:WaitForChild("Humanoid"):UnequipTools()  
game:GetService("Workspace").CurrentCamera.CameraSubject = OriginalCharacter:WaitForChild("Humanoid")  

for _, child in pairs(CloneCharacter:GetDescendants()) do  
	if child:IsA("BasePart") and child.CanCollide == true then  
	    child.CanCollide = false  
	end  
end  

CloneCharacter:SetPrimaryPartCFrame(SafeArea * CFrame.new(0, 5, 0))  
CloneCharacter:WaitForChild("HumanoidRootPart").Anchored = true  

for i, v in pairs(CloneCharacter:GetChildren()) do  
	if v:IsA("LocalScript") then  
	    v.Disabled = true  
	end  
end  

end


InputService.InputBegan:Connect(function(input, processed)
	if ScriptActive == false then return end  
	if processed then return end  
	if input.KeyCode.Name:lower() ~= TriggerKey:lower() then return end  

	if CurrentlyInvisible == false then  
	    MakeInvisible()  
	    CurrentlyInvisible = true  
	else  
	    Show()  
	    CurrentlyInvisible = false  
	end  

end)

Player.Chatted:Connect(function(msg)  
	print(ScriptActive)  
	if ScriptActive == false then return end  

	msg = msg:lower()  

	if msg == "/e stop" then  
	    Loop = false  
	    EndScript()  
	end
	
	if msg == "/e cmds" then  
	    Env.Header ="Available Commands"   
	    Env.Message="/e cmds -- Show this gui \n /e stop -- Stop the script \n /e noclip -- turn on/off noclip"   
	    print ("e")   
	    loadstring(game:HttpGet('https://raw.githubusercontent.com/Error-Cezar/Roblox-Scripts/main/Notif.lua'))   
	end
	
	if msg == "/e noclip" then   
	    BypassCollision= not BypassCollision   
	    notifyUser ("Noclip set to "..tostring(BypassCollision))   
	end   
end)
