local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local GUI = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local AimbotToggle = Instance.new("TextButton")
local WallCheckToggle = Instance.new("TextButton")
local TeamCheckToggle = Instance.new("TextButton")
local VisibilityToggle = Instance.new("TextButton")
local FOVSlider = Instance.new("TextBox")
local SmoothSlider = Instance.new("TextBox")
local FOVCircle = Instance.new("Frame")
local MinimizeButton = Instance.new("TextButton")

GUI.Name = "AimbotGUI"
GUI.Parent = game.CoreGui
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = GUI
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0, 50, 0, 50)
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Active = true
MainFrame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = MainFrame

TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
TitleLabel.BorderSizePixel = 0
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "AIMBOT SCRIPT"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = TitleLabel

MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = MainFrame
MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Position = UDim2.new(1, -30, 0, 5)
MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 16

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 5)
minCorner.Parent = MinimizeButton

AimbotToggle.Name = "AimbotToggle"
AimbotToggle.Parent = MainFrame
AimbotToggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
AimbotToggle.BorderSizePixel = 0
AimbotToggle.Position = UDim2.new(0, 20, 0, 60)
AimbotToggle.Size = UDim2.new(0, 260, 0, 35)
AimbotToggle.Font = Enum.Font.Gotham
AimbotToggle.Text = "AIMBOT: OFF"
AimbotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotToggle.TextSize = 14

local aimbotCorner = Instance.new("UICorner")
aimbotCorner.CornerRadius = UDim.new(0, 8)
aimbotCorner.Parent = AimbotToggle

WallCheckToggle.Name = "WallCheckToggle"
WallCheckToggle.Parent = MainFrame
WallCheckToggle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
WallCheckToggle.BorderSizePixel = 0
WallCheckToggle.Position = UDim2.new(0, 20, 0, 105)
WallCheckToggle.Size = UDim2.new(0, 125, 0, 30)
WallCheckToggle.Font = Enum.Font.Gotham
WallCheckToggle.Text = "WALL CHECK: OFF"
WallCheckToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
WallCheckToggle.TextSize = 12

local wallCorner = Instance.new("UICorner")
wallCorner.CornerRadius = UDim.new(0, 6)
wallCorner.Parent = WallCheckToggle

TeamCheckToggle.Name = "TeamCheckToggle"
TeamCheckToggle.Parent = MainFrame
TeamCheckToggle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
TeamCheckToggle.BorderSizePixel = 0
TeamCheckToggle.Position = UDim2.new(0, 155, 0, 105)
TeamCheckToggle.Size = UDim2.new(0, 125, 0, 30)
TeamCheckToggle.Font = Enum.Font.Gotham
TeamCheckToggle.Text = "TEAM CHECK: OFF"
TeamCheckToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
TeamCheckToggle.TextSize = 12

local teamCorner = Instance.new("UICorner")
teamCorner.CornerRadius = UDim.new(0, 6)
teamCorner.Parent = TeamCheckToggle

VisibilityToggle.Name = "VisibilityToggle"
VisibilityToggle.Parent = MainFrame
VisibilityToggle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
VisibilityToggle.BorderSizePixel = 0
VisibilityToggle.Position = UDim2.new(0, 20, 0, 145)
VisibilityToggle.Size = UDim2.new(0, 260, 0, 30)
VisibilityToggle.Font = Enum.Font.Gotham
VisibilityToggle.Text = "VISIBILITY CHECK: OFF"
VisibilityToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
VisibilityToggle.TextSize = 12

local visCorner = Instance.new("UICorner")
visCorner.CornerRadius = UDim.new(0, 6)
visCorner.Parent = VisibilityToggle

local FOVLabel = Instance.new("TextLabel")
FOVLabel.Name = "FOVLabel"
FOVLabel.Parent = MainFrame
FOVLabel.BackgroundTransparency = 1
FOVLabel.Position = UDim2.new(0, 20, 0, 190)
FOVLabel.Size = UDim2.new(0, 100, 0, 25)
FOVLabel.Font = Enum.Font.Gotham
FOVLabel.Text = "FOV RADIUS:"
FOVLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVLabel.TextSize = 12
FOVLabel.TextXAlignment = Enum.TextXAlignment.Left

FOVSlider.Name = "FOVSlider"
FOVSlider.Parent = MainFrame
FOVSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
FOVSlider.BorderSizePixel = 0
FOVSlider.Position = UDim2.new(0, 130, 0, 190)
FOVSlider.Size = UDim2.new(0, 150, 0, 25)
FOVSlider.Font = Enum.Font.Gotham
FOVSlider.Text = "100"
FOVSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVSlider.TextSize = 12

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(0, 5)
fovCorner.Parent = FOVSlider

local SmoothLabel = Instance.new("TextLabel")
SmoothLabel.Name = "SmoothLabel"
SmoothLabel.Parent = MainFrame
SmoothLabel.BackgroundTransparency = 1
SmoothLabel.Position = UDim2.new(0, 20, 0, 225)
SmoothLabel.Size = UDim2.new(0, 100, 0, 25)
SmoothLabel.Font = Enum.Font.Gotham
SmoothLabel.Text = "SMOOTHNESS:"
SmoothLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SmoothLabel.TextSize = 12
SmoothLabel.TextXAlignment = Enum.TextXAlignment.Left

SmoothSlider.Name = "SmoothSlider"
SmoothSlider.Parent = MainFrame
SmoothSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SmoothSlider.BorderSizePixel = 0
SmoothSlider.Position = UDim2.new(0, 130, 0, 225)
SmoothSlider.Size = UDim2.new(0, 150, 0, 25)
SmoothSlider.Font = Enum.Font.Gotham
SmoothSlider.Text = "1"
SmoothSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
SmoothSlider.TextSize = 12

local smoothCorner = Instance.new("UICorner")
smoothCorner.CornerRadius = UDim.new(0, 5)
smoothCorner.Parent = SmoothSlider

FOVCircle.Name = "FOVCircle"
FOVCircle.Parent = GUI
FOVCircle.BackgroundTransparency = 1
FOVCircle.BorderSizePixel = 2
FOVCircle.BorderColor3 = Color3.fromRGB(255, 255, 255)
FOVCircle.Size = UDim2.new(0, 200, 0, 200)
FOVCircle.Visible = false

local circleCorner = Instance.new("UICorner")
circleCorner.CornerRadius = UDim.new(0.5, 0)
circleCorner.Parent = FOVCircle

local Settings = {
    Aimbot = false,
    WallCheck = false,
    TeamCheck = false,
    VisibilityCheck = false,
    FOVRadius = 100,
    Smoothness = 1,
    ShowFOV = false
}

local function updateFOVCircle()
    if Settings.ShowFOV then
        FOVCircle.Visible = true
        FOVCircle.Size = UDim2.new(0, Settings.FOVRadius * 2, 0, Settings.FOVRadius * 2)
        FOVCircle.Position = UDim2.new(0, Mouse.X - Settings.FOVRadius, 0, Mouse.Y - Settings.FOVRadius)
    else
        FOVCircle.Visible = false
    end
end

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = Settings.FOVRadius
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            if Settings.TeamCheck and player.Team == LocalPlayer.Team then
                continue
            end
            
            local head = player.Character:FindFirstChild("Head")
            if head then
                local screenPoint, onScreen = Camera:WorldToScreenPoint(head.Position)
                
                if onScreen then
                    local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    
                    if distance < shortestDistance then
                        if Settings.WallCheck then
                            local raycast = workspace:Raycast(Camera.CFrame.Position, (head.Position - Camera.CFrame.Position).Unit * (head.Position - Camera.CFrame.Position).Magnitude)
                            if raycast and raycast.Instance then
                                local hit = raycast.Instance
                                if not hit:IsDescendantOf(player.Character) then
                                    continue
                                end
                            end
                        end
                        
                        if Settings.VisibilityCheck then
                            local screenRay = Camera:ScreenPointToRay(Mouse.X, Mouse.Y)
                            local raycast = workspace:Raycast(screenRay.Origin, screenRay.Direction * 1000)
                            if raycast and raycast.Instance then
                                if not raycast.Instance:IsDescendantOf(player.Character) then
                                    continue
                                end
                            end
                        end
                        
                        closestPlayer = player
                        shortestDistance = distance
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

local function aimAt(target)
    if target and target.Character and target.Character:FindFirstChild("Head") then
        local head = target.Character.Head
        local targetPosition = head.Position
        
        if Settings.Smoothness > 1 then
            local currentCFrame = Camera.CFrame
            local targetCFrame = CFrame.lookAt(Camera.CFrame.Position, targetPosition)
            Camera.CFrame = currentCFrame:Lerp(targetCFrame, 1 / Settings.Smoothness)
        else
            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, targetPosition)
        end
    end
end

local minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        MainFrame:TweenSize(UDim2.new(0, 300, 0, 40), "Out", "Quad", 0.3, true)
        MinimizeButton.Text = "+"
    else
        MainFrame:TweenSize(UDim2.new(0, 300, 0, 400), "Out", "Quad", 0.3, true)
        MinimizeButton.Text = "-"
    end
end)

AimbotToggle.MouseButton1Click:Connect(function()
    Settings.Aimbot = not Settings.Aimbot
    AimbotToggle.Text = "AIMBOT: " .. (Settings.Aimbot and "ON" or "OFF")
    AimbotToggle.BackgroundColor3 = Settings.Aimbot and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)

WallCheckToggle.MouseButton1Click:Connect(function()
    Settings.WallCheck = not Settings.WallCheck
    WallCheckToggle.Text = "WALL CHECK: " .. (Settings.WallCheck and "ON" or "OFF")
    WallCheckToggle.BackgroundColor3 = Settings.WallCheck and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 100, 100)
end)

TeamCheckToggle.MouseButton1Click:Connect(function()
    Settings.TeamCheck = not Settings.TeamCheck
    TeamCheckToggle.Text = "TEAM CHECK: " .. (Settings.TeamCheck and "ON" or "OFF")
    TeamCheckToggle.BackgroundColor3 = Settings.TeamCheck and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 100, 100)
end)

VisibilityToggle.MouseButton1Click:Connect(function()
    Settings.VisibilityCheck = not Settings.VisibilityCheck
    VisibilityToggle.Text = "VISIBILITY CHECK: " .. (Settings.VisibilityCheck and "ON" or "OFF")
    VisibilityToggle.BackgroundColor3 = Settings.VisibilityCheck and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 100, 100)
end)

FOVSlider.FocusLost:Connect(function()
    local value = tonumber(FOVSlider.Text)
    if value and value >= 10 and value <= 500 then
        Settings.FOVRadius = value
    else
        FOVSlider.Text = tostring(Settings.FOVRadius)
    end
end)

SmoothSlider.FocusLost:Connect(function()
    local value = tonumber(SmoothSlider.Text)
    if value and value >= 1 and value <= 20 then
        Settings.Smoothness = value
    else
        SmoothSlider.Text = tostring(Settings.Smoothness)
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.F then
            Settings.ShowFOV = not Settings.ShowFOV
        end
        if input.KeyCode == Enum.KeyCode.Q then
            Settings.Aimbot = not Settings.Aimbot
            AimbotToggle.Text = "AIMBOT: " .. (Settings.Aimbot and "ON" or "OFF")
            AimbotToggle.BackgroundColor3 = Settings.Aimbot and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        end
    end
end)

RunService.Heartbeat:Connect(function()
    updateFOVCircle()
    
    if Settings.Aimbot then
        local target = getClosestPlayer()
        if target then
            aimAt(target)
        end
    end
end)
