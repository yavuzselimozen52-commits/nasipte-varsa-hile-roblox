-- ==========================================================
--    NASİPTE VARSA BETA V1.2 (ANİMASYONLU & HAVALI SÜRÜM)
-- ==========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Config = {
    ESP = false,
    RoketActive = false,
    EndermenActive = false,
    ActiveAnimationTrack = nil
}

local function getRGB()
    local t = tick() * 5
    return Color3.fromHSV(t % 1, 1, 1)
end

if CoreGui:FindFirstChild("NasipBetaGui") then
    CoreGui.NasipBetaGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NasipBetaGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 540)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -270)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "nasipte varsa beta v1.2"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

task.spawn(function()
    while ScreenGui.Parent do
        Title.TextColor3 = getRGB()
        task.wait(0.1)
    end
end)

local function createFeature(titleText, descText, yPos, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(0, 280, 0, 55)
    Container.Position = UDim2.new(0.5, -140, 0, yPos)
    Container.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Container.BorderSizePixel = 0
    Container.Parent = MainFrame

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Container

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -10, 0, 26)
    Btn.Position = UDim2.new(0, 5, 0, 4)
    Btn.BackgroundTransparency = 1
    Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    Btn.TextSize = 13
    Btn.Font = Enum.Font.GothamBold
    Btn.Text = titleText .. " [OFF]"
    Btn.Parent = Container

    local Desc = Instance.new("TextLabel")
    Desc.Size = UDim2.new(1, -10, 0, 18)
    Desc.Position = UDim2.new(0, 5, 0, 31)
    Desc.BackgroundTransparency = 1
    Desc.TextColor3 = Color3.fromRGB(110, 110, 110)
    Desc.TextSize = 11
    Desc.Font = Enum.Font.Gotham
    Desc.Text = descText
    Desc.Parent = Container

    local state = false
    Btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            Btn.Text = titleText .. " [ON]"
            Btn.TextColor3 = Color3.fromRGB(0, 255, 100)
        else
            Btn.Text = titleText .. " [OFF]"
            Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        callback(state)
    end)
end

-- 1. Duvardan Bakıyoz Aga (ESP)
createFeature("Duvardan Bakıyoz Aga", "Duvardan görüyoz pusu kuruyoz", 45, function(state)
    Config.ESP = state
    if not state then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character then
                local hl = plr.Character:FindFirstChild("NasipHighlight")
                if hl then hl:Destroy() end
            end
        end
    end
end)

-- 2. Roket (Fling)
createFeature("Roket", "vizesiz tatil daa ne istiyon kral", 105, function(state)
    Config.RoketActive = state
end)

-- 3. Endermen (Random TP)
createFeature("Endermen", "mc den geldik :P", 165, function(state)
    if state and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local otherPlayers = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(otherPlayers, p)
            end
        end
        if #otherPlayers > 0 then
            local target = otherPlayers[math.random(1, #otherPlayers)]
            local targetRoot = target.Character.HumanoidRootPart
            LocalPlayer.Character.HumanoidRootPart.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3)
        end
    end
end)

-- 4. ANİMASYONLU ÖZELLİK: Havalı Hareketler / Şekil Başladı
createFeature("Şekil Önemli", "havalı animasyonla ortamlardayız", 225, function(state)
    local character = LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    if state then
        pcall(function()
            local anim = Instance.new("Animation")
            -- Örnek havalı dans/aksiyon animasyon ID'si (R15 uyumlu havalı duruş)
            anim.AnimationId = "rbxassetid://33380097" 
            Config.ActiveAnimationTrack = humanoid:LoadAnimation(anim)
            Config.ActiveAnimationTrack.Looped = true
            Config.ActiveAnimationTrack:Play()
        end)
    else
        if Config.ActiveAnimationTrack then
            Config.ActiveAnimationTrack:Stop()
            Config.ActiveAnimationTrack = nil
        end
    end
end)

-- REJOIN BUTONU
local RejoinContainer = Instance.new("Frame")
RejoinContainer.Size = UDim2.new(0, 280, 0, 50)
RejoinContainer.Position = UDim2.new(0.5, -140, 0, 285)
RejoinContainer.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
RejoinContainer.BorderSizePixel = 0
RejoinContainer.Parent = MainFrame

local RejoinCorner = Instance.new("UICorner")
RejoinCorner.CornerRadius = UDim.new(0, 6)
RejoinCorner.Parent = RejoinContainer

local RejoinBtn = Instance.new("TextButton")
RejoinBtn.Size = UDim2.new(1, -10, 0, 24)
RejoinBtn.Position = UDim2.new(0, 5, 0, 4)
RejoinBtn.BackgroundTransparency = 1
RejoinBtn.TextColor3 = Color3.fromRGB(255, 200, 0)
RejoinBtn.TextSize = 13
RejoinBtn.Font = Enum.Font.GothamBold
RejoinBtn.Text = "Rejoin [OYUNDAN ÇIK GİR]"
RejoinBtn.Parent = RejoinContainer

local RejoinDesc = Instance.new("TextLabel")
RejoinDesc.Size = UDim2.new(1, -10, 0, 18)
RejoinDesc.Position = UDim2.new(0, 5, 0, 28)
RejoinDesc.BackgroundTransparency = 1
RejoinDesc.TextColor3 = Color3.fromRGB(110, 110, 110)
RejoinDesc.TextSize = 11
RejoinDesc.Font = Enum.Font.Gotham
RejoinDesc.Text = "bak hemen burdayım"
RejoinDesc.Parent = RejoinContainer

RejoinBtn.MouseButton1Click:Connect(function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

-- UNLOAD BUTONU
local UnloadBtn = Instance.new("TextButton")
UnloadBtn.Size = UDim2.new(0, 280, 0, 35)
UnloadBtn.Position = UDim2.new(0.5, -140, 0, 350)
UnloadBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
UnloadBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
UnloadBtn.TextSize = 13
UnloadBtn.Font = Enum.Font.GothamBold
UnloadBtn.Text = "KENDİNİ İMHA ET (UNLOAD)"
UnloadBtn.Parent = MainFrame

local UnloadCorner = Instance.new("UICorner")
UnloadCorner.CornerRadius = UDim.new(0, 6)
UnloadCorner.Parent = UnloadBtn

UnloadBtn.MouseButton1Click:Connect(function()
    if Config.ActiveAnimationTrack then
        Config.ActiveAnimationTrack:Stop()
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character then
            local hl = plr.Character:FindFirstChild("NasipHighlight")
            if hl then hl:Destroy() end
        end
    end
    ScreenGui:Destroy()
end)

local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1, 0, 0, 30)
Info.Position = UDim2.new(0, 0, 1, -35)
Info.BackgroundTransparency = 1
Info.Text = "nasipte varsa beta v1.2 - Sürüklenebilir"
Info.TextColor3 = Color3.fromRGB(90, 90, 90)
Info.TextSize = 10
Info.Font = Enum.Font.Gotham
Info.Parent = MainFrame

-- ARKA PLAN DÖNGÜLERİ
RunService.RenderStepped:Connect(function()
    -- ESP Loop
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local char = plr.Character
            local hum = char:FindFirstChild("Humanoid")
            if Config.ESP and hum and hum.Health > 0 then
                local hl = char:FindFirstChild("NasipHighlight")
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "NasipHighlight"
                    hl.Adornee = char
                    hl.FillTransparency = 0.5
                    hl.OutlineTransparency = 0
                    hl.Parent = char
                end
                local rgb = getRGB()
                hl.FillColor = rgb
                hl.OutlineColor = rgb
            else
                local hl = char:FindFirstChild("NasipHighlight")
                if hl then hl:Destroy() end
            end
        end
    end

    -- Fling (Roket) Loop
    if Config.RoketActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local myRoot = LocalPlayer.Character.HumanoidRootPart
        local closestPlr = nil
        local shortestDist = math.huge
        
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (myRoot.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    closestPlr = plr
                end
            end
        end
        
        if closestPlr and closestPlr.Character:FindFirstChild("HumanoidRootPart") then
            local tRoot = closestPlr.Character.HumanoidRootPart
            tRoot.AssemblyLinearVelocity = Vector3.new(0, 500, 0)
            tRoot.AssemblyAngularVelocity = Vector3.new(500, 500, 500)
        end
    end
end)
