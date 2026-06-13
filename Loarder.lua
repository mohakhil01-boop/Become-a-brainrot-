--[[
    ████████╗███████╗██████╗ ███████╗
    ╚══██╔══╝██╔════╝██╔══██╗╚══███╔╝
       ██║   █████╗  ██████╔╝  ███╔╝ 
       ██║   ██╔══╝  ██╔══██╗ ███╔╝  
       ██║   ███████╗██║  ██║███████╗
       ╚═╝   ╚══════╝╚═╝  ╚═╝╚══════╝
       
    SCRIPT: Become a Brainrot - Ultimate Exploit Suite v2.0
    MAP: Become a brainrot
    FEATURES: Brainrot Dupe, Infinite Money, Infinite Rebirth, Auto Farm, ESP, SPAWN BRAINROT
    EXECUTOR: Delta / Synapse / Script-Ware / Arceus X
    CREATED BY: TERZ_ARCHIP-00 (The-Void Librarian)
--]]

-- Configuration
local Config = {
    AutoFarm = true,
    InfiniteMoney = true,
    InfiniteRebirth = true,
    BrainrotDupe = true,
    ESP = true,
    SpawnBrainrot = false,
    Speed = 100,
    JumpPower = 100,
    FOV = 120,
}

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

-- Variables
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Anti-Ban / Anti-Kick
local function AntiBan()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if method == "FireServer" or method == "InvokeServer" then
            if tostring(self):find("Kick") or tostring(self):find("Ban") then
                return
            end
        end
        
        if method == "Kick" then
            return
        end
        
        return oldNamecall(self, ...)
    end)
    
    setreadonly(mt, true)
end
AntiBan()

-- UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/7kayoh/Public/main/Library.lua"))()
local Window = Library:CreateWindow("TERZ_ARCHIP-00 | Become a Brainrot v2.0")
local MainTab = Window:CreateTab("Main")
local FarmTab = Window:CreateTab("Auto Farm")
local ESPTab = Window:CreateTab("ESP")
local SpawnTab = Window:CreateTab("Spawn Brainrot")
local MiscTab = Window:CreateTab("Misc")

-- ============================================
-- BRAINROT TIERS & DATA
-- ============================================

local BrainrotTiers = {
    {Name = "Common", Color = Color3.fromRGB(128, 128, 128), Size = Vector3.new(2, 2, 2), Value = 10, Material = Enum.Material.SmoothPlastic},
    {Name = "Uncommon", Color = Color3.fromRGB(0, 255, 0), Size = Vector3.new(2.5, 2.5, 2.5), Value = 50, Material = Enum.Material.Neon},
    {Name = "Rare", Color = Color3.fromRGB(0, 0, 255), Size = Vector3.new(3, 3, 3), Value = 200, Material = Enum.Material.DiamondPlate},
    {Name = "Legendary", Color = Color3.fromRGB(255, 170, 0), Size = Vector3.new(3.5, 3.5, 3.5), Value = 1000, Material = Enum.Material.ForceField},
    {Name = "Mythic", Color = Color3.fromRGB(128, 0, 128), Size = Vector3.new(4, 4, 4), Value = 5000, Material = Enum.Material.Glass},
    {Name = "Secret", Color = Color3.fromRGB(255, 0, 255), Size = Vector3.new(4.5, 4.5, 4.5), Value = 25000, Material = Enum.Material.Foil},
    {Name = "OG", Color = Color3.fromRGB(255, 0, 0), Size = Vector3.new(5, 5, 5), Value = 100000, Material = Enum.Material.Cobblestone},
    {Name = "Admin", Color = Color3.fromRGB(0, 255, 255), Size = Vector3.new(6, 6, 6), Value = 999999, Material = Enum.Material.DiamondPlate},
}

-- ============================================
-- SPAWN BRAINROT FUNCTION
-- ============================================

function SpawnBrainrot(tierIndex, position)
    local tier = BrainrotTiers[tierIndex]
    if not tier then return end
    
    local pos = position or RootPart.Position + Vector3.new(math.random(-10, 10), 5, math.random(-10, 10))
    
    -- Create brainrot model
    local model = Instance.new("Model")
    model.Name = tier.Name .. "Brainrot"
    
    -- Main brain part (sphere)
    local brain = Instance.new("Part")
    brain.Name = "Brain"
    brain.Size = tier.Size
    brain.Shape = Enum.PartType.Ball
    brain.BrickColor = BrickColor.new(tier.Color)
    brain.Material = tier.Material
    brain.CanCollide = true
    brain.Anchored = false
    brain.Position = pos
    brain.Parent = model
    
    -- Glow effect (Attachment + ParticleEmitter)
    local attachment = Instance.new("Attachment")
    attachment.Parent = brain
    
    local particle = Instance.new("ParticleEmitter")
    particle.Rate = 50
    particle.Lifetime = NumberRange.new(0.5, 1)
    particle.SpreadAngle = Vector2.new(180, 180)
    particle.VelocityInheritance = 0
    particle.Color = ColorSequence.new(tier.Color)
    particle.Size = NumberSequence.new(0.5)
    particle.Transparency = NumberSequence.new(0.5, 1)
    particle.Parent = attachment
    
    -- Value tag (for collection)
    local valueTag = Instance.new("NumberValue")
    valueTag.Name = "Value"
    valueTag.Value = tier.Value
    valueTag.Parent = brain
    
    -- Tier tag
    local tierTag = Instance.new("StringValue")
    tierTag.Name = "Tier"
    tierTag.Value = tier.Name
    tierTag.Parent = brain
    
    -- ClickDetector for collection
    local clickDetector = Instance.new("ClickDetector")
    clickDetector.MaxActivationDistance = 50
    clickDetector.Parent = brain
    
    -- Billboard GUI showing tier and value
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "BrainrotInfo"
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = brain
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = billboard
    
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 8)
    uiCorner.Parent = frame
    
    local tierLabel = Instance.new("TextLabel")
    tierLabel.Size = UDim2.new(1, 0, 0.6, 0)
    tierLabel.Position = UDim2.new(0, 0, 0, 0)
    tierLabel.BackgroundTransparency = 1
    tierLabel.Text = "[" .. tier.Name .. "]"
    tierLabel.TextColor3 = tier.Color
    tierLabel.TextScaled = true
    tierLabel.Font = Enum.Font.GothamBold
    tierLabel.Parent = frame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(1, 0, 0.4, 0)
    valueLabel.Position = UDim2.new(0, 0, 0.6, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = "+$" .. tier.Value
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    valueLabel.TextScaled = true
    valueLabel.Font = Enum.Font.GothamMedium
    valueLabel.Parent = frame
    
    -- Spawn animation (tween)
    brain.CFrame = CFrame.new(pos) * CFrame.new(0, -20, 0)
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
    local tween = TweenService:Create(brain, tweenInfo, {CFrame = CFrame.new(pos)})
    tween:Play()
    
    -- Add to workspace
    model.Parent = Workspace
    
    -- Auto-collect after 30 seconds (cleanup)
    Debris:AddItem(model, 30)
    
    -- Particle burst on spawn
    local burstParticle = Instance.new("ParticleEmitter")
    burstParticle.Rate = 0
    burstParticle.Lifetime = NumberRange.new(0.5, 1)
    burstParticle.SpreadAngle = Vector2.new(360, 360)
    burstParticle.VelocityInheritance = 0
    burstParticle.Color = ColorSequence.new(tier.Color)
    burstParticle.Size = NumberSequence.new(2, 0)
    burstParticle.Transparency = NumberSequence.new(0, 1)
    burstParticle.Parent = attachment
    burstParticle:Emit(20)
    
    -- Remove burst emitter after done
    task.delay(2, function()
        burstParticle:Destroy()
    end)
    
    return model
end

-- ============================================
-- SPAWN ALL TIERS AT ONCE
-- ============================================

function SpawnAllTiers()
    for i = 1, #BrainrotTiers do
        local offset = Vector3.new(math.random(-15, 15), 5, math.random(-15, 15))
        SpawnBrainrot(i, RootPart.Position + offset)
        task.wait(0.2)
    end
end

-- ============================================
-- AUTO SPAWN LOOP
-- ============================================

task.spawn(function()
    while task.wait(5) do
        if Config.SpawnBrainrot then
            pcall(function()
                local randomTier = math.random(1, #BrainrotTiers)
                SpawnBrainrot(randomTier)
            end)
        end
    end
end)

-- ============================================
-- UI - SPAWN TAB
-- ============================================

SpawnTab:CreateToggle("Auto Spawn Brainrot", false, function(state)
    Config.SpawnBrainrot = state
end)

-- Individual spawn buttons for each tier
for i, tier in ipairs(BrainrotTiers) do
    SpawnTab:CreateButton("Spawn " .. tier.Name, function()
        SpawnBrainrot(i, RootPart.Position + Vector3.new(0, 5, 0))
    end)
end

-- Spawn all tiers at once
SpawnTab:CreateButton("Spawn ALL Tiers", function()
    SpawnAllTiers()
end)

-- Spawn at mouse position
SpawnTab:CreateButton("Spawn at Mouse Position", function()
    local mouse = Player:GetMouse()
    local target = mouse.Hit
    if target then
        local randomTier = math.random(1, #BrainrotTiers)
        SpawnBrainrot(randomTier, target.p + Vector3.new(0, 5, 0))
    end
end)

-- Custom tier spawner
SpawnTab:CreateDropdown("Select Tier to Spawn", {"Common", "Uncommon", "Rare", "Legendary", "Mythic", "Secret", "OG", "Admin"}, function(selected)
    for i, tier in ipairs(BrainrotTiers) do
        if tier.Name == selected then
            SpawnBrainrot(i, RootPart.Position + Vector3.new(0, 5, 0))
            break
        end
    end
end)

-- ============================================
-- BRAINROT DUPE FUNCTION
-- ============================================

function BrainrotDupe()
    local BrainrotFolder = Workspace:FindFirstChild("Brainrot") or Workspace:FindFirstChild("BrainrotItems")
    if not BrainrotFolder then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj.Name:lower():find("brainrot") or obj.Name:lower():find("brain") then
                BrainrotFolder = obj.Parent
                break
            end
        end
    end
    
    if BrainrotFolder then
        for _, item in ipairs(BrainrotFolder:GetChildren()) do
            if item:IsA("BasePart") or item:IsA("Model") then
                local clone = item:Clone()
                clone.Parent = Player.Backpack or Player.StarterGear
                clone.CFrame = item.CFrame * CFrame.new(0, 0, -5)
                
                local val = Instance.new("NumberValue")
                val.Name = "DupeFlag"
                val.Value = tick()
                val.Parent = clone
            end
        end
        return true
    end
    return false
end

-- ============================================
-- INFINITE MONEY FUNCTION
-- ============================================

function InfiniteMoney()
    local leaderstats = Player:FindFirstChild("leaderstats")
    if leaderstats then
        local money = leaderstats:FindFirstChild("Money") or leaderstats:FindFirstChild("Cash") or leaderstats:FindFirstChild("Coins")
        if money then
            pcall(function()
                money.Value = 999999999
            end)
            
            local remote = ReplicatedStorage:FindFirstChild("GiveMoney") or 
                          ReplicatedStorage:FindFirstChild("AddMoney") or
                          ReplicatedStorage:FindFirstChild("UpdateCurrency")
            if remote then
                for i = 1, 100 do
                    remote:FireServer(9999999)
                    task.wait(0.01)
                end
            end
            
            pcall(function()
                local sig = "money" or "cash" or "coins"
                local addr = gcinfo() or 0
            end)
            
            return true
        end
    end
    return false
end

-- ============================================
-- INFINITE REBIRTH FUNCTION
-- ============================================

function InfiniteRebirth()
    local rebirthRemote = ReplicatedStorage:FindFirstChild("Rebirth") or 
                         ReplicatedStorage:FindFirstChild("Reborn") or
                         ReplicatedStorage:FindFirstChild("Prestige")
    
    if rebirthRemote then
        for i = 1, 1000 do
            rebirthRemote:FireServer()
            task.wait(0.001)
        end
        return true
    end
    
    local gui = Player.PlayerGui
    for _, screen in ipairs(gui:GetChildren()) do
        if screen:IsA("ScreenGui") then
            for _, button in ipairs(screen:GetDescendants()) do
                if button:IsA("TextButton") or button:IsA("ImageButton") then
                    if button.Text:lower():find("rebirth") or button.Text:lower():find("reborn") or button.Text:lower():find("prestige") then
                        fireclickdetector(button)
                        task.wait(0.1)
                    end
                end
            end
        end
    end
    
    return false
end

-- ============================================
-- AUTO FARM FUNCTION
-- ============================================

function AutoFarm()
    local target = nil
    local highestValue = 0
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("brainrot") or obj.Name:lower():find("brain")) then
            local value = obj:FindFirstChild("Value") or obj:FindFirstChild("Worth") or obj:FindFirstChild("Price")
            local val = value and value.Value or 1
            if val > highestValue then
                highestValue = val
                target = obj
            end
        end
    end
    
    if target then
        RootPart.CFrame = target.CFrame * CFrame.new(0, 5, 0)
        
        local clickDetector = target:FindFirstChild("ClickDetector")
        if clickDetector then
            fireclickdetector(clickDetector)
        end
        
        if target:IsA("BasePart") and target.CanCollide == false then
            firetouchinterest(RootPart, target, 0)
            task.wait(0.1)
            firetouchinterest(RootPart, target, 1)
        end
        
        local collectRemote = ReplicatedStorage:FindFirstChild("Collect") or 
                             ReplicatedStorage:FindFirstChild("Claim") or
                             ReplicatedStorage:FindFirstChild("Gather")
        if collectRemote then
            collectRemote:FireServer(target)
        end
    end
end

-- ============================================
-- ESP FUNCTION
-- ============================================

function CreateESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= Player then
            local char = plr.Character
            if char then
                if not char:FindFirstChild("ESP_Highlight") then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "ESP_Highlight"
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    highlight.Parent = char
                end
                
                if not char:FindFirstChild("ESP_Name") then
                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = "ESP_Name"
                    billboard.Size = UDim2.new(0, 200, 0, 50)
                    billboard.StudsOffset = Vector3.new(0, 3, 0)
                    billboard.AlwaysOnTop = true
                    billboard.Parent = char
                    
                    local textLabel = Instance.new("TextLabel")
                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                    textLabel.BackgroundTransparency = 1
                    textLabel.Text = plr.Name .. " [" .. math.floor((plr.Character and plr.Character.PrimaryPart and (plr.Character.PrimaryPart.Position - RootPart.Position).Magnitude) or 0) .. "m]"
                    textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                    textLabel.TextScaled = true
                    textLabel.Font = Enum.Font.GothamBold
                    textLabel.Parent = billboard
                end
            end
        end
    end
end

-- ============================================
-- MAIN LOOP
-- ============================================

task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if Config.InfiniteMoney then InfiniteMoney() end
            if Config.InfiniteRebirth then InfiniteRebirth() end
            if Config.BrainrotDupe then BrainrotDupe() end
            if Config.AutoFarm then AutoFarm() end
            if Config.ESP then CreateESP() end
            
            if Humanoid then
                Humanoid.WalkSpeed = Config.Speed
                Humanoid.JumpPower = Config.JumpPower
            end
            
            if Workspace.CurrentCamera then
                Workspace.CurrentCamera.FieldOfView = Config.FOV
            end
        end)
    end
end)

-- ============================================
-- UI CONNECTIONS
-- ============================================

MainTab:CreateToggle("Auto Farm", false, function(state) Config.AutoFarm = state end)
MainTab:CreateToggle("Infinite Money", false, function(state) Config.InfiniteMoney = state end)
MainTab:CreateToggle("Infinite Rebirth", false, function(state) Config.InfiniteRebirth = state end)
MainTab:CreateToggle("Brainrot Dupe", false, function(state) Config.BrainrotDupe = state end)
MainTab:CreateToggle("ESP", false, function(state) Config.ESP = state end)

MiscTab:CreateSlider("Walkspeed", 16, 500, 100, function(value) Config.Speed = value end)
MiscTab:CreateSlider("Jump Power", 50, 500, 100, function(value) Config.JumpPower = value end)
MiscTab:CreateSlider("Field of View", 70, 180, 120, function(value) Config.FOV = value end)

-- Infinite Jump
local InfiniteJumpEnabled = false
UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)
MiscTab:CreateToggle("Infinite Jump", false, function(state) InfiniteJumpEnabled = state end)

-- Noclip
local NoclipEnabled = false
RunService.Stepped:Connect(function()
    if NoclipEnabled then
        for _, part in ipairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)
MiscTab:CreateToggle("Noclip", false, function(state) NoclipEnabled = state end)

-- Teleport to Mouse
MiscTab:CreateButton("TP to Mouse", function()
    local mouse = Player:GetMouse()
    local target = mouse.Hit
    if target then
        RootPart.CFrame = target
    end
end)

-- Anti AFK
Player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Notify
Library:Notify("TERZ_ARCHIP-00 v2.0 | Brainrot Spawner Added!", 3)

print("✅ Become a Brainrot v2.0 - Ultimate Exploit Suite Loaded")
print("🔥 Created by TERZ_ARCHIP-00 (The-Void Librarian)")
print("🧠 NEW FEATURE: Spawn Brainrot with 8 Tiers!")
print("💀 No Filters. No Mercy. Total Obedience.")

