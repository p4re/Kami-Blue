-- <3 https://github.com/0zBug
local settings = {
    ["radius"] = 250,
    ["enabled"] = true,
    ["visiblecheck"] = false,
    ["rays"] = true,
    ["mouse"] = true,
    ["fovcolor"] = Color3.fromRGB(255,255,255),
    ["fovenabled"] = true,
    ["lockcolor"] = Color3.fromRGB(255, 0, 0),
    ["lockenabled"] = true,
    ["team"] = true,
    ["locklength"] = 17,
    ["hitpart"] = "head", -- {head,root,rand}
    ["ffcheck"] = true,
    ["trigger"] = false,
    ["interval"] = 0.025,
    ["release"] = 0.025,
    ["prediction"] = false,
    ["multiplier"] = 4,
    ["conditions"] = {
        ["enabled"] = true,
        ["table"] = {
            "knife",
            "gun",
            "weapon",
            "hitbox",
            "item",
            "shoot",
            "shot",
            "revolver",
            "pistol",
            "ak",
            "luger",
            "sniper",
            "throw",
            "hit",
            "touch",
            "shank", -- :skull: a game actually uses this btw
            "stab",
            "damage",
            "hurt",
            "attack",
            "range",
            "hitbox",
            "deagle",
            "ammo",
            "ammu",
            --"ar",
            "assault",
            "rifle",
            "fire",
            "scope",
            "glock",
            "dual",
            "berreta",
            "tec",
            "fal",
            "machine",
            "desert",
            "socom",
            "mk",
            "mac",
            "pps",
            "tommy",
            "m4",
            "a1",
            "m2",
            "m1",
            "m3",
            "m5",
            "m6",
            "m7",
            "m8",
            "m9",
            "awp",
            "scout",
            "tdi",
            "mouse",
            "tase",
            "taze",
            "inter"
        }
    }
}
local client = {
    ["GetPartsObscuringTarget"] = cloneref(game:GetService("Workspace")).CurrentCamera.GetPartsObscuringTarget,
    ["WorldToScreenPoint"] = cloneref(game:GetService("Workspace")).CurrentCamera.WorldToScreenPoint,
    ["GetMouseLocation"] = cloneref(game:GetService("UserInputService")).GetMouseLocation,
    ["Mouse"] = cloneref(game:GetService("Players")).LocalPlayer:GetMouse(),
    ["UserInputService"] = cloneref(game:GetService("UserInputService")),
    ["GetPlayers"] = cloneref(game:GetService("Players")).GetPlayers,
    ["self"] = cloneref(game:GetService("Players")).LocalPlayer,
    ["RunService"] = cloneref(game:GetService("RunService")),
    ["Players"] = cloneref(game:GetService("Players")),
    ["FindFirstChild"] = game.FindFirstChild,
    ["Camera"] = cloneref(game:GetService("Workspace")).CurrentCamera,
    ["GetChildren"] = game.GetChildren
}
local function addPredict(hit)
    return (settings.prediction == false and Vector3.new(0,0,0) or settings.prediction == true and client.FindFirstChild(hit.Parent, "Humanoid").MoveDirection*settings.multiplier)
end
local function DrawCircle(rad,thick,color)
    local c = Drawing.new("Circle")
    c.Visible = true
    c.Transparency = 1
    c.Filled = false
    c.Radius = rad
    c.Position = Vector2.new(0,0)
    c.Thickness = thick
    c.Color = color
    return c
end
local function DrawLine(thick,color)
    local c = Drawing.new("Line")
    c.Visible = true
    c.Transparency = 1
    c.From = Vector2.new(0,0)
    c.To = Vector2.new(0,0)
    c.Thickness = thick
    c.Color = color
    return c
end
local mhit = nil
local ScreenPositionM = nil
local OnScreenM = nil
local Clock2 = os.clock()
local Clock = os.clock()
local Randomizer = math.random(1,2)
local CircleOutline = DrawCircle(settings.radius,3,Color3.fromRGB(0,0,0))
local Circle = DrawCircle(settings.radius,1,settings.fovcolor)
local LockOutline1 = DrawLine(3,Color3.fromRGB(0,0,0))
local LockOutline2 = DrawLine(3,Color3.fromRGB(0,0,0))
local Lock1 = DrawLine(1,settings.lockcolor)
local Lock2 = DrawLine(1,settings.lockcolor)
function settings.update()
    CircleOutline.Radius = settings.radius
    Circle.Radius = settings.radius
    Circle.Color = settings.fovcolor
    Circle.Visible = settings.fovenabled
    CircleOutline.Visible = settings.fovenabled
    LockOutline1.Visible = settings.lockenabled
    Lock1.Visible = settings.lockenabled
    Lock1.Color = settings.lockcolor
    LockOutline2.Visible = settings.lockenabled
    Lock2.Visible = settings.lockenabled
    Lock2.Color = settings.lockcolor
end
settings.update()
local function MeetsConditions(lookupstring,conditions)
    for _, condition in next, conditions do
        if lookupstring:find(condition) then
            return true
        end
    end
    return false
end
local function GetScreenPosition(Vector)
    local ScreenPosition, OnScreen = client.WorldToScreenPoint(client.Camera, Vector)
    return Vector2.new(ScreenPosition.X, ScreenPosition.Y), OnScreen
end
local function IsPlayerVisible(Target)
    if not settings.visiblecheck then return true end
    local Character = client.self.Character
    if not (Target or Character) then return end 
    local Part = client.FindFirstChild(Target, "Head")
    if not Part then return end 
    local ObscuringObjects = #client.GetPartsObscuringTarget(client.Camera, {Part.Position, Character, Target}, {Character, Target})    
    return ((ObscuringObjects == 0 and true) or (ObscuringObjects > 0 and false))
end
local function GetClosest()
    local Minimum, Closest = ((settings.fovenabled == true and settings.radius) or (settings.fovenabled == false and math.huge))
    local MouseLocation = client.GetMouseLocation(client.UserInputService)
    for _, Player in next, client.GetPlayers(client.Players) do
        if Player == client.self then continue end
        if settings.team and Player.Team == client.self.Team and not (Player.Neutral and client.self.Neutral) then continue end
        local Character = Player.Character
        if not Character or not IsPlayerVisible(Character) then continue end
        if settings.ffcheck and client.FindFirstChild(Character, "ForceField") ~= nil then continue end
        local Part = client.FindFirstChild(Character, "Head")
        if settings.hitpart == "head" then
            Part = client.FindFirstChild(Character, "Head")
        elseif settings.hitpart == "root" then
            Part = client.FindFirstChild(Character, "HumanoidRootPart")
        elseif settings.hitpart == "rand" then
            if Randomizer == 1 then
                Part = client.FindFirstChild(Character, "Head")
            elseif Randomizer == 2 then
                Part = client.FindFirstChild(Character, "HumanoidRootPart")
            end
        end
        local Humanoid = client.FindFirstChild(Character, "Humanoid")
        if not Part or not Humanoid or Humanoid.Health <= 0 then continue end
        local ScreenPosition, OnScreen = GetScreenPosition(Part.Position)
        local Distance = (MouseLocation - ScreenPosition).Magnitude
        if Distance <= Minimum and OnScreen then
            Closest = Part
            Minimum = Distance
        end
    end
    return Closest
end
local __namecall
__namecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
    local method = getnamecallmethod()
    local callingscript = getcallingscript()
    local arguments = {...}
    local self = arguments[1]
	local main = arguments[2]
    if self == workspace and not checkcaller() and settings.rays and settings.enabled then
        if tostring(callingscript):lower() ~= "controlmodule" then
            if settings.conditions.enabled and MeetsConditions(tostring(callingscript):lower(),settings.conditions.table) then else return __namecall(...) end
            if method:lower():find("findpartonray") then
                local hit = GetClosest()
                if hit then
                    local origin = main.Origin
                    local dir = (hit.Position+addPredict(hit) - origin).Unit * 15000
                    arguments[2] = Ray.new(origin, dir)
                    return __namecall(unpack(arguments))
                end
            elseif method == "Raycast" then
                local hit = GetClosest()
                if hit then
                    arguments[3] = (hit.Position - main).Unit * 15000
                    return __namecall(unpack(arguments))
                end
            end
        end
    end
    return __namecall(...)
end))
local __index = nil 
__index = hookmetamethod(game, "__index", newcclosure(function(self, index)
    local callingscript = getcallingscript()
    if self == client.Mouse and not checkcaller() and settings.mouse and settings.enabled then
        if settings.conditions.enabled and MeetsConditions(tostring(callingscript):lower(),settings.conditions.table) then else return __index(self, index) end
        local hit = GetClosest()
        if hit then
            if index:lower() == "target" then
                return hit
            elseif index:lower() == "hit" then
                return hit.CFrame+addPredict(hit)
            elseif index:lower() == "unitray" then
                return Ray.new(self.Origin, (self.Hit - self.Origin).Unit)
            else
                if index:lower() == "x" or index:lower() == "y" then
                    ScreenPositionM, OnScreenM = GetScreenPosition(hit.Position+addPredict(hit))
                end
                if index:lower() == "x" then
                    return ScreenPositionM.X
                elseif index:lower() == "y" then
                    return ScreenPositionM.Y
                end
            end
        end
    end
    return __index(self, index)
end))
client.RunService.RenderStepped:Connect(function()
    local MouseLocation = client.GetMouseLocation(client.UserInputService)
    Circle.Position = Vector2.new(MouseLocation.X,MouseLocation.Y)
    CircleOutline.Position = Vector2.new(MouseLocation.X,MouseLocation.Y)
    if (os.clock() - Clock) > 0.1 and settings.hitpart == "rand" and settings.enabled then
        Randomizer = math.random(1,2)
        Clock = os.clock()
    end
    if settings.lockenabled or settings.trigger and settings.enabled then
        mhit = GetClosest()
    end
    if (os.clock() - Clock2) > settings.interval and settings.trigger and mhit and settings.visiblecheck and settings.enabled then
        spawn(function()
            mouse1press()
            task.wait(settings.release)
            mouse1release()
            Clock2 = os.clock()
        end)
    end
    if settings.lockenabled and settings.enabled then
        if mhit then
            local PartLocation = GetScreenPosition(mhit.Position+addPredict(mhit))
            LockOutline1.Transparency = 1
            LockOutline2.Transparency = 1
            Lock1.Transparency = 1
            Lock2.Transparency = 1
            LockOutline1.From=Vector2.new((PartLocation.X)+(settings.locklength/2+1),PartLocation.Y+36)
            LockOutline1.To=Vector2.new(PartLocation.X-(settings.locklength/2+1),PartLocation.Y+36)
            LockOutline2.From=Vector2.new(PartLocation.X,PartLocation.Y+1+36+(settings.locklength/2))
            LockOutline2.To=Vector2.new(PartLocation.X,PartLocation.Y-1+36-(settings.locklength/2))
            Lock1.From=Vector2.new((PartLocation.X)+(settings.locklength/2),PartLocation.Y+36)
            Lock1.To=Vector2.new(PartLocation.X-(settings.locklength/2),PartLocation.Y+36)
            Lock2.From=Vector2.new(PartLocation.X,PartLocation.Y+36+(settings.locklength/2))
            Lock2.To=Vector2.new(PartLocation.X,PartLocation.Y+36-(settings.locklength/2))
        else
            LockOutline1.Transparency = 0
            LockOutline2.Transparency = 0
            Lock1.Transparency = 0
            Lock2.Transparency = 0
        end
    end
end)
return settings
