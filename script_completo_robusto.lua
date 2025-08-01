local success, error = pcall(function()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
    return warn("LocalPlayer não encontrado")
end

local Mouse = LocalPlayer:GetMouse()

local function createGUI()
    local existingGUI = game.CoreGui:FindFirstChild("UniversalScriptGUI")
    if existingGUI then
        existingGUI:Destroy()
        wait(0.1)
    end

    local GUI = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local TitleBar = Instance.new("Frame")
    local TitleLabel = Instance.new("TextLabel")
    local CloseButton = Instance.new("TextButton")
    local MinimizeButton = Instance.new("TextButton")
    local ContentFrame = Instance.new("ScrollingFrame")
    local SpeedSection = Instance.new("Frame")
    local SpeedLabel = Instance.new("TextLabel")
    local SpeedSlider = Instance.new("TextBox")
    local SpeedToggle = Instance.new("TextButton")
    local JumpSection = Instance.new("Frame")
    local JumpLabel = Instance.new("TextLabel")
    local JumpSlider = Instance.new("TextBox")
    local JumpToggle = Instance.new("TextButton")
    local FlySection = Instance.new("Frame")
    local FlyLabel = Instance.new("TextLabel")
    local FlyToggle = Instance.new("TextButton")
    local NoClipSection = Instance.new("Frame")
    local NoClipLabel = Instance.new("TextLabel")
    local NoClipToggle = Instance.new("TextButton")
    local InfiniteJumpSection = Instance.new("Frame")
    local InfiniteJumpLabel = Instance.new("TextLabel")
    local InfiniteJumpToggle = Instance.new("TextButton")
    local StatusLabel = Instance.new("TextLabel")

    GUI.Name = "UniversalScriptGUI"
    GUI.Parent = game.CoreGui
    GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    GUI.ResetOnSpawn = false

    MainFrame.Name = "MainFrame"
    MainFrame.Parent = GUI
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
    MainFrame.Size = UDim2.new(0, 350, 0, 450)
    MainFrame.Active = true
    MainFrame.Draggable = true

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = MainFrame

    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Parent = MainFrame
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0, -15, 0, -15)
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.ZIndex = 0
    shadow.Image = "rbxasset://textures/ui/InspectMenu/Shadow.png"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)

    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainFrame
    TitleBar.BackgroundColor3 = Color3.fromRGB(255, 65, 65)
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 40)

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = TitleBar

    local titleBottom = Instance.new("Frame")
    titleBottom.Parent = TitleBar
    titleBottom.BackgroundColor3 = Color3.fromRGB(255, 65, 65)
    titleBottom.BorderSizePixel = 0
    titleBottom.Position = UDim2.new(0, 0, 0.5, 0)
    titleBottom.Size = UDim2.new(1, 0, 0.5, 0)

    TitleLabel.Name = "TitleLabel"
    TitleLabel.Parent = TitleBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.Size = UDim2.new(1, -80, 1, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = "UNIVERSAL SCRIPT HUB"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Parent = TitleBar
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Position = UDim2.new(1, -70, 0, 8)
    MinimizeButton.Size = UDim2.new(0, 24, 0, 24)
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.TextSize = 18

    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, 12)
    minCorner.Parent = MinimizeButton

    CloseButton.Name = "CloseButton"
    CloseButton.Parent = TitleBar
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 95, 95)
    CloseButton.BorderSizePixel = 0
    CloseButton.Position = UDim2.new(1, -40, 0, 8)
    CloseButton.Size = UDim2.new(0, 24, 0, 24)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 16

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 12)
    closeCorner.Parent = CloseButton

    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Position = UDim2.new(0, 10, 0, 50)
    ContentFrame.Size = UDim2.new(1, -20, 1, -60)
    ContentFrame.ScrollBarThickness = 6
    ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 65, 65)

    StatusLabel.Name = "StatusLabel"
    StatusLabel.Parent = MainFrame
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Position = UDim2.new(0, 10, 1, -25)
    StatusLabel.Size = UDim2.new(1, -20, 0, 20)
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Text = "Status: Carregado com sucesso"
    StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    StatusLabel.TextSize = 12
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

    local function createSection(name, parent, position)
        local section = Instance.new("Frame")
        section.Name = name .. "Section"
        section.Parent = parent
        section.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        section.BorderSizePixel = 0
        section.Position = position
        section.Size = UDim2.new(1, 0, 0, 60)

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = section

        return section
    end

    SpeedSection = createSection("Speed", ContentFrame, UDim2.new(0, 0, 0, 10))
    JumpSection = createSection("Jump", ContentFrame, UDim2.new(0, 0, 0, 80))
    FlySection = createSection("Fly", ContentFrame, UDim2.new(0, 0, 0, 150))
    NoClipSection = createSection("NoClip", ContentFrame, UDim2.new(0, 0, 0, 220))
    InfiniteJumpSection = createSection("InfiniteJump", ContentFrame, UDim2.new(0, 0, 0, 290))

    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 360)

    local function createLabel(text, parent)
        local label = Instance.new("TextLabel")
        label.Parent = parent
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 10, 0, 5)
        label.Size = UDim2.new(0, 100, 0, 25)
        label.Font = Enum.Font.Gotham
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        return label
    end

    local function createSlider(parent, defaultValue)
        local slider = Instance.new("TextBox")
        slider.Parent = parent
        slider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        slider.BorderSizePixel = 0
        slider.Position = UDim2.new(0, 10, 0, 30)
        slider.Size = UDim2.new(0, 80, 0, 25)
        slider.Font = Enum.Font.Gotham
        slider.Text = tostring(defaultValue)
        slider.TextColor3 = Color3.fromRGB(255, 255, 255)
        slider.TextSize = 12
        slider.PlaceholderText = "Valor"

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = slider

        return slider
    end

    local function createToggle(parent, text)
        local toggle = Instance.new("TextButton")
        toggle.Parent = parent
        toggle.BackgroundColor3 = Color3.fromRGB(255, 65, 65)
        toggle.BorderSizePixel = 0
        toggle.Position = UDim2.new(0, 100, 0, 30)
        toggle.Size = UDim2.new(0, 80, 0, 25)
        toggle.Font = Enum.Font.Gotham
        toggle.Text = text .. ": OFF"
        toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggle.TextSize = 12

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = toggle

        return toggle
    end

    SpeedLabel = createLabel("Velocidade:", SpeedSection)
    SpeedSlider = createSlider(SpeedSection, 16)
    SpeedToggle = createToggle(SpeedSection, "SPEED")

    JumpLabel = createLabel("Altura do Pulo:", JumpSection)
    JumpSlider = createSlider(JumpSection, 50)
    JumpToggle = createToggle(JumpSection, "JUMP")

    FlyLabel = createLabel("Voar:", FlySection)
    FlyToggle = createToggle(FlySection, "FLY")
    FlyToggle.Position = UDim2.new(0, 10, 0, 30)
    FlyToggle.Size = UDim2.new(0, 100, 0, 25)

    NoClipLabel = createLabel("Atravessar Paredes:", NoClipSection)
    NoClipToggle = createToggle(NoClipSection, "NOCLIP")
    NoClipToggle.Position = UDim2.new(0, 10, 0, 30)
    NoClipToggle.Size = UDim2.new(0, 120, 0, 25)

    InfiniteJumpLabel = createLabel("Pulo Infinito:", InfiniteJumpSection)
    InfiniteJumpToggle = createToggle(InfiniteJumpSection, "INF JUMP")
    InfiniteJumpToggle.Position = UDim2.new(0, 10, 0, 30)
    InfiniteJumpToggle.Size = UDim2.new(0, 100, 0, 25)

    return {
        GUI = GUI,
        MainFrame = MainFrame,
        ContentFrame = ContentFrame,
        CloseButton = CloseButton,
        MinimizeButton = MinimizeButton,
        SpeedSlider = SpeedSlider,
        SpeedToggle = SpeedToggle,
        JumpSlider = JumpSlider,
        JumpToggle = JumpToggle,
        FlyToggle = FlyToggle,
        NoClipToggle = NoClipToggle,
        InfiniteJumpToggle = InfiniteJumpToggle,
        StatusLabel = StatusLabel
    }
end

local ScriptSettings = {
    Speed = {enabled = false, value = 16},
    Jump = {enabled = false, value = 50},
    Fly = {enabled = false, speed = 50},
    NoClip = {enabled = false},
    InfiniteJump = {enabled = false}
}

local Connections = {}
local OriginalValues = {}

local function safeGetCharacter()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") and character:FindFirstChild("HumanoidRootPart") then
        return character
    end
    return nil
end

local function updateStatus(text, color)
    if GUI and GUI.StatusLabel then
        GUI.StatusLabel.Text = "Status: " .. text
        GUI.StatusLabel.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    end
end

local function toggleSpeed(enabled, value)
    local character = safeGetCharacter()
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end

    if enabled then
        if not OriginalValues.WalkSpeed then
            OriginalValues.WalkSpeed = humanoid.WalkSpeed
        end
        humanoid.WalkSpeed = value
        updateStatus("Speed ativado: " .. value, Color3.fromRGB(100, 255, 100))
    else
        if OriginalValues.WalkSpeed then
            humanoid.WalkSpeed = OriginalValues.WalkSpeed
        end
        updateStatus("Speed desativado", Color3.fromRGB(255, 100, 100))
    end
end

local function toggleJump(enabled, value)
    local character = safeGetCharacter()
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end

    if enabled then
        if not OriginalValues.JumpPower then
            OriginalValues.JumpPower = humanoid.JumpPower
        end
        humanoid.JumpPower = value
        updateStatus("Jump ativado: " .. value, Color3.fromRGB(100, 255, 100))
    else
        if OriginalValues.JumpPower then
            humanoid.JumpPower = OriginalValues.JumpPower
        end
        updateStatus("Jump desativado", Color3.fromRGB(255, 100, 100))
    end
end

local function toggleFly(enabled)
    local character = safeGetCharacter()
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    if enabled then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = humanoidRootPart
        bodyVelocity.Name = "FlyBodyVelocity"

        if Connections.FlyConnection then
            Connections.FlyConnection:Disconnect()
        end

        Connections.FlyConnection = RunService.Heartbeat:Connect(function()
            local character = safeGetCharacter()
            if not character or not ScriptSettings.Fly.enabled then return end
            
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            local bodyVel = humanoidRootPart and humanoidRootPart:FindFirstChild("FlyBodyVelocity")
            
            if humanoidRootPart and bodyVel then
                local moveVector = Vector3.new(0, 0, 0)
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveVector = moveVector + Camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveVector = moveVector - Camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveVector = moveVector - Camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveVector = moveVector + Camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    moveVector = moveVector + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    moveVector = moveVector - Vector3.new(0, 1, 0)
                end
                
                bodyVel.Velocity = moveVector * ScriptSettings.Fly.speed
            end
        end)
        
        updateStatus("Fly ativado", Color3.fromRGB(100, 255, 100))
    else
        if Connections.FlyConnection then
            Connections.FlyConnection:Disconnect()
            Connections.FlyConnection = nil
        end
        
        local bodyVel = humanoidRootPart:FindFirstChild("FlyBodyVelocity")
        if bodyVel then
            bodyVel:Destroy()
        end
        
        updateStatus("Fly desativado", Color3.fromRGB(255, 100, 100))
    end
end

local function toggleNoClip(enabled)
    local character = safeGetCharacter()
    if not character then return end

    if enabled then
        if Connections.NoClipConnection then
            Connections.NoClipConnection:Disconnect()
        end

        Connections.NoClipConnection = RunService.Stepped:Connect(function()
            local character = safeGetCharacter()
            if not character or not ScriptSettings.NoClip.enabled then return end
            
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
        
        updateStatus("NoClip ativado", Color3.fromRGB(100, 255, 100))
    else
        if Connections.NoClipConnection then
            Connections.NoClipConnection:Disconnect()
            Connections.NoClipConnection = nil
        end
        
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
        
        updateStatus("NoClip desativado", Color3.fromRGB(255, 100, 100))
    end
end

local function toggleInfiniteJump(enabled)
    if enabled then
        if Connections.InfiniteJumpConnection then
            Connections.InfiniteJumpConnection:Disconnect()
        end

        Connections.InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
            local character = safeGetCharacter()
            if not character or not ScriptSettings.InfiniteJump.enabled then return end
            
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        
        updateStatus("Infinite Jump ativado", Color3.fromRGB(100, 255, 100))
    else
        if Connections.InfiniteJumpConnection then
            Connections.InfiniteJumpConnection:Disconnect()
            Connections.InfiniteJumpConnection = nil
        end
        
        updateStatus("Infinite Jump desativado", Color3.fromRGB(255, 100, 100))
    end
end

local function cleanup()
    for _, connection in pairs(Connections) do
        if connection then
            connection:Disconnect()
        end
    end
    
    local character = safeGetCharacter()
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        
        if humanoid then
            if OriginalValues.WalkSpeed then
                humanoid.WalkSpeed = OriginalValues.WalkSpeed
            end
            if OriginalValues.JumpPower then
                humanoid.JumpPower = OriginalValues.JumpPower
            end
        end
        
        if humanoidRootPart then
            local bodyVel = humanoidRootPart:FindFirstChild("FlyBodyVelocity")
            if bodyVel then
                bodyVel:Destroy()
            end
        end
        
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
    end
end

GUI = createGUI()

local minimized = false
GUI.MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    local targetSize = minimized and UDim2.new(0, 350, 0, 40) or UDim2.new(0, 350, 0, 450)
    
    local tween = TweenService:Create(GUI.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = targetSize})
    tween:Play()
    
    GUI.MinimizeButton.Text = minimized and "+" or "-"
    GUI.ContentFrame.Visible = not minimized
end)

GUI.CloseButton.MouseButton1Click:Connect(function()
    cleanup()
    GUI.GUI:Destroy()
end)

GUI.SpeedToggle.MouseButton1Click:Connect(function()
    ScriptSettings.Speed.enabled = not ScriptSettings.Speed.enabled
    local value = tonumber(GUI.SpeedSlider.Text) or 16
    ScriptSettings.Speed.value = math.max(1, math.min(500, value))
    
    GUI.SpeedToggle.Text = "SPEED: " .. (ScriptSettings.Speed.enabled and "ON" or "OFF")
    GUI.SpeedToggle.BackgroundColor3 = ScriptSettings.Speed.enabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 65, 65)
    
    toggleSpeed(ScriptSettings.Speed.enabled, ScriptSettings.Speed.value)
end)

GUI.JumpToggle.MouseButton1Click:Connect(function()
    ScriptSettings.Jump.enabled = not ScriptSettings.Jump.enabled
    local value = tonumber(GUI.JumpSlider.Text) or 50
    ScriptSettings.Jump.value = math.max(1, math.min(500, value))
    
    GUI.JumpToggle.Text = "JUMP: " .. (ScriptSettings.Jump.enabled and "ON" or "OFF")
    GUI.JumpToggle.BackgroundColor3 = ScriptSettings.Jump.enabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 65, 65)
    
    toggleJump(ScriptSettings.Jump.enabled, ScriptSettings.Jump.value)
end)

GUI.FlyToggle.MouseButton1Click:Connect(function()
    ScriptSettings.Fly.enabled = not ScriptSettings.Fly.enabled
    
    GUI.FlyToggle.Text = "FLY: " .. (ScriptSettings.Fly.enabled and "ON" or "OFF")
    GUI.FlyToggle.BackgroundColor3 = ScriptSettings.Fly.enabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 65, 65)
    
    toggleFly(ScriptSettings.Fly.enabled)
end)

GUI.NoClipToggle.MouseButton1Click:Connect(function()
    ScriptSettings.NoClip.enabled = not ScriptSettings.NoClip.enabled
    
    GUI.NoClipToggle.Text = "NOCLIP: " .. (ScriptSettings.NoClip.enabled and "ON" or "OFF")
    GUI.NoClipToggle.BackgroundColor3 = ScriptSettings.NoClip.enabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 65, 65)
    
    toggleNoClip(ScriptSettings.NoClip.enabled)
end)

GUI.InfiniteJumpToggle.MouseButton1Click:Connect(function()
    ScriptSettings.InfiniteJump.enabled = not ScriptSettings.InfiniteJump.enabled
    
    GUI.InfiniteJumpToggle.Text = "INF JUMP: " .. (ScriptSettings.InfiniteJump.enabled and "ON" or "OFF")
    GUI.InfiniteJumpToggle.BackgroundColor3 = ScriptSettings.InfiniteJump.enabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 65, 65)
    
    toggleInfiniteJump(ScriptSettings.InfiniteJump.enabled)
end)

GUI.SpeedSlider.FocusLost:Connect(function()
    local value = tonumber(GUI.SpeedSlider.Text)
    if value and value >= 1 and value <= 500 then
        ScriptSettings.Speed.value = value
        if ScriptSettings.Speed.enabled then
            toggleSpeed(true, value)
        end
    else
        GUI.SpeedSlider.Text = tostring(ScriptSettings.Speed.value)
    end
end)

GUI.JumpSlider.FocusLost:Connect(function()
    local value = tonumber(GUI.JumpSlider.Text)
    if value and value >= 1 and value <= 500 then
        ScriptSettings.Jump.value = value
        if ScriptSettings.Jump.enabled then
            toggleJump(true, value)
        end
    else
        GUI.JumpSlider.Text = tostring(ScriptSettings.Jump.value)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if player == LocalPlayer then
        cleanup()
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
    if ScriptSettings.Speed.enabled then
        toggleSpeed(true, ScriptSettings.Speed.value)
    end
    if ScriptSettings.Jump.enabled then
        toggleJump(true, ScriptSettings.Jump.value)
    end
    if ScriptSettings.NoClip.enabled then
        toggleNoClip(true)
    end
    if ScriptSettings.InfiniteJump.enabled then
        toggleInfiniteJump(true)
    end
end)

updateStatus("Script inicializado com sucesso!", Color3.fromRGB(100, 255, 100))

end)

if not success then
    warn("Erro ao executar script: " .. tostring(error))
end