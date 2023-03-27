--| Super Power Evolution Simulator fully automatic Autofarm
--| Credits: ixnx
--| ___________________ |   VARIABLES TO CHANGE   | ___________________ |--

-- This is the GitHub-loadstring version of the script. to use the source-code, remove the '--' before the following two lines:
--getgenv().CurrentStat = "Endurance" --| Options: "Endurance", "Psychic", "Strength"
--getgenv().Enabled = true            --| Set to false, then re-execute to disable

--| ___________________ | END VARIABLES TO CHANGE | ___________________ |--
--| 
--| Do NOT touch anything below this line!
repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer.Character
if getgenv().Loop ~= nil then getgenv().Loop:Disconnect() end
--|
if not getgenv().Enabled then getgenv().Loop:Disconnect() return end
--|
local s = setmetatable({}, {
    __index = function(self, serv)
        return game:GetService(serv)
    end
})
--|
local stats = s.Players.LocalPlayer.displayStats
local char = s.Players.LocalPlayer.Character.HumanoidRootPart
local curStat
local activateToolTraining = false
local toolTrainingDebounce = false
--|
local currentEnduranceArea = 0
local currentStrengthArea = 0
local currentPsychicArea = 0
--|
local enduranceAreas = {}
local psychicAreas = {}
local strengthAreas = {}
--|
local areaFolder = game:GetService("Workspace").TrainingZones:GetDescendants()
for i,v in pairs(areaFolder) do 
    if v.Name == "Stat" and v.Value == "Endurance" then
        enduranceAreas[v.Parent.Requirement.Value] = v.Parent.Root.Position
    elseif v.Name == "Stat" and v.Value == "Psychic" then
        psychicAreas[v.Parent.Requirement.Value] = v.Parent.Root.Position
    elseif v.Name == "Stat" and v.Value == "Strength" then
        strengthAreas[v.Parent.Requirement.Value] = v.Parent.Root.Position
    end
end
--|
getgenv().Loop = s.RunService.Stepped:Connect(function()
    if getgenv().CurrentStat == "Endurance" and stats.Endurance.Value >= 100 then
        for i,v in pairs(enduranceAreas) do 
            if stats.Endurance.Value >= i and currentEnduranceArea <= i then
                currentEnduranceArea = i
                char.CFrame = CFrame.new(v)
                task.wait()
            end
        end
        activateToolTraining = false
        if s.Players.LocalPlayer.Backpack:FindFirstChild("Psychic") ~= nil then 
            s.Players.LocalPlayer.PlayerGui.UI["Hotbar UI"].EquipTool:FireServer(s.Players.LocalPlayer.Backpack.Psychic, s.Players.LocalPlayer.Backpack.Psychic.Parent) 
        end
    elseif getgenv().CurrentStat == "Endurance" and stats.Endurance.Value < 100 then
        activateToolTraining = true
        curStat = "PushUp"
        if s.Players.LocalPlayer.Backpack:FindFirstChild("PushUp") ~= nil then 
            s.Players.LocalPlayer.PlayerGui.UI["Hotbar UI"].EquipTool:FireServer(s.Players.LocalPlayer.Backpack.PushUp, s.Players.LocalPlayer.Backpack.PushUp.Parent) 
        end
    elseif getgenv().CurrentStat == "Psychic" then
        for i,v in pairs(psychicAreas) do 
            if stats.Psychic.Value >= i and currentPsychicArea <= i then
                currentPsychicArea = i
                char.CFrame = CFrame.new(v)
                task.wait()
            end
        end
        activateToolTraining = false
        if s.Players.LocalPlayer.Backpack:FindFirstChild("Psychic") ~= nil then 
            s.Players.LocalPlayer.PlayerGui.UI["Hotbar UI"].EquipTool:FireServer(s.Players.LocalPlayer.Backpack.Psychic, s.Players.LocalPlayer.Backpack.Psychic.Parent)  
        end
    elseif getgenv().CurrentStat == "Strength" then
        curStat = "Punch"
        for i,v in pairs(strengthAreas) do 
            if stats.Strength.Value >= i and currentStrengthArea <= i then
                currentStrengthArea = i
                char.CFrame = CFrame.new(v)
                task.wait()
            end
        end
        activateToolTraining = true
        if s.Players.LocalPlayer.Backpack:FindFirstChild("Punch") ~= nil then 
            s.Players.LocalPlayer.PlayerGui.UI["Hotbar UI"].EquipTool:FireServer(s.Players.LocalPlayer.Backpack.Punch, s.Players.LocalPlayer.Backpack.Punch.Parent)
        end
    end
    
    if activateToolTraining then game.Players.LocalPlayer.Character:FindFirstChild(curStat):Activate() end

    for i,v in pairs(s.Players.LocalPlayer.Character:GetDescendants()) do
        if v.ClassName == "Part" then v.CanCollide = false elseif v.ClassName == "Model" then v.CanCollide = false end
    end
end)
--|
