local Visuals = loadstring(game:HttpGet("https://raw.githubusercontent.com/0zBug/Highlight/main/main.lua"))()
local CurrentCamera,RunService = game:GetService("Workspace").CurrentCamera, game:GetService("RunService")
local Players = game:GetService("Players") local Client = Players.LocalPlayer Visuals.CreateGui(0.25)
local returntable = {} function returntable.Toggle(bool) Visuals.GetGuiObjects().Parent.Enabled = bool end
local function isVisible(Character)
    if not (Character or Client.Character) then return false end
    local Head = Character:FindFirstChild("Head")
    if not Head then return false end
    local Cast, Ignore = {Head.Position, Client.Character, Character}, {Client.Character, Character}
    local Obsc = #CurrentCamera:GetPartsObscuringTarget(Cast, Ignore)
    return ((Obsc == 0 and true) or (Obsc > 0 and false))
end
local function AddChams(Character)
    repeat task.wait() until Character:FindFirstChildWhichIsA("Humanoid")
    repeat task.wait() until Character:FindFirstChild("HumanoidRootPart")
    task.wait(0.02) local Highlight = Visuals.HighlightBody(Character,Color3.fromRGB(255,0,0),false)
    Clock = os.clock()
    RenderStepped = RunService.RenderStepped:Connect(function()
        if (Clock - os.clock()) < 0.5 then
            if isVisible(Character) then
                for _,Part in next, Highlight:GetDescendants() do
                    if Part:IsA("BasePart") then
                        Part.Color = Color3.fromRGB(146, 255, 255)
                    end
                end
            else
                for _,Part in next, Highlight:GetDescendants() do
                    if Part:IsA("BasePart") then
                        Part.Color = Color3.fromRGB(255,0,0)
                    end
                end
            end
            Clock = os.clock()
        end
    end)
    Character:FindFirstChildWhichIsA("Humanoid").Died:Connect(function()
        RenderStepped:Disconnect()
        Highlight:Destroy()
    end)
end
local function HookChamPlayer(Player)
    if Player.Character then
        AddChams(Player.Character)
    end
    CharacterAdded = Player.CharacterAdded:Connect(function()
        repeat task.wait() until Player.Character:FindFirstChildWhichIsA("Humanoid")
        repeat task.wait() until Player.Character:FindFirstChild("HumanoidRootPart")
        task.wait(0.15)
        AddChams(Player.Character)
    end)
    Players.PlayerRemoving:Connect(function(PlayerV)
        if PlayerV == Player then
            CharacterAdded:Disconnect()
        end
    end)
end
Players.PlayerAdded:Connect(function(Player)
    task.wait(0.5) HookChamPlayer(Player)
end)
for _, Player in next, Players:GetPlayers() do
    spawn(function()
        if Player ~= Client then HookChamPlayer(Player) end
    end)
end
return returntable
