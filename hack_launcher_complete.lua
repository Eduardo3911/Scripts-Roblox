-- 🚀 HACK LAUNCHER COMPLETO COM GUI 🚀
-- Script completo para Roblox: Launcher + Interface
-- Temática: Hackers vs Anti-Hackers

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ==================== SISTEMA DE LANÇAMENTO ====================

-- Configurações do launcher
local LAUNCH_FORCE = 500
local LAUNCH_HEIGHT = 200
local EFFECT_DURATION = 0.5

-- Função para criar efeito visual de "hack"
local function createHackEffect(character)
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local attachment = Instance.new("Attachment")
    attachment.Parent = humanoidRootPart
    
    local particles = Instance.new("ParticleEmitter")
    particles.Parent = attachment
    particles.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    particles.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 255, 255))
    particles.Lifetime = NumberRange.new(0.5, 1.0)
    particles.Rate = 200
    particles.SpreadAngle = Vector2.new(45, 45)
    particles.Speed = NumberRange.new(10, 20)
    
    game:GetService("Debris"):AddItem(attachment, EFFECT_DURATION)
end

-- Função para lançar um jogador específico
local function launchPlayer(targetPlayer, direction)
    if not targetPlayer.Character then return end
    
    local character = targetPlayer.Character
    local humanoid = character:FindFirstChild("Humanoid")
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not humanoidRootPart then return end
    
    createHackEffect(character)
    
    local launchDirection = direction or Vector3.new(
        math.random(-1, 1),
        1,
        math.random(-1, 1)
    ).Unit
    
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = launchDirection * LAUNCH_FORCE + Vector3.new(0, LAUNCH_HEIGHT, 0)
    bodyVelocity.Parent = humanoidRootPart
    
    game:GetService("Debris"):AddItem(bodyVelocity, 2)
    
    humanoid.PlatformStand = true
    
    spawn(function()
        wait(1)
        if humanoid and humanoid.Parent then
            humanoid.PlatformStand = false
        end
    end)
end

-- Função para lançar todos os jogadores (exceto o hacker)
local function launchAllPlayers(hackerPlayer)
    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if targetPlayer ~= hackerPlayer and targetPlayer.Character then
            launchPlayer(targetPlayer)
            wait(0.1)
        end
    end
end

-- Função para lançar jogadores em uma área específica
local function launchPlayersInArea(centerPosition, radius, excludePlayer)
    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if targetPlayer ~= excludePlayer and targetPlayer.Character then
            local humanoidRootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local distance = (humanoidRootPart.Position - centerPosition).Magnitude
                if distance <= radius then
                    local direction = (humanoidRootPart.Position - centerPosition).Unit
                    launchPlayer(targetPlayer, direction)
                end
            end
        end
    end
end

-- Função para criar "explosão" que lança jogadores
local function createLaunchExplosion(position, radius, excludePlayer)
    local explosion = Instance.new("Explosion")
    explosion.Position = position
    explosion.BlastRadius = radius
    explosion.BlastPressure = 0
    explosion.Parent = workspace
    
    launchPlayersInArea(position, radius, excludePlayer)
end

-- Função principal para ativar o "hack launcher"
local function activateHackLauncher(hackerPlayer)
    if not hackerPlayer.Character then return end
    
    local humanoidRootPart = hackerPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    createLaunchExplosion(humanoidRootPart.Position, 50, hackerPlayer)
    
    spawn(function()
        wait(1)
        launchAllPlayers(hackerPlayer)
    end)
end

-- Função para lançar jogador específico por nome
local function launchPlayerByName(playerName, hackerPlayer)
    local targetPlayer = Players:FindFirstChild(playerName)
    if targetPlayer and targetPlayer ~= hackerPlayer then
        launchPlayer(targetPlayer)
        return true
    end
    return false
end

-- Exportar funções
_G.HackLauncher = {
    launchPlayer = launchPlayer,
    launchAllPlayers = launchAllPlayers,
    launchPlayersInArea = launchPlayersInArea,
    createLaunchExplosion = createLaunchExplosion,
    activateHackLauncher = activateHackLauncher,
    launchPlayerByName = launchPlayerByName
}

-- ==================== INTERFACE GUI ====================

-- Criar a ScreenGui principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HackLauncherGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Frame principal com tema hacker
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 320, 0, 450)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Adicionar borda neon
local border = Instance.new("UIStroke")
border.Color = Color3.fromRGB(0, 255, 255)
border.Thickness = 3
border.Parent = mainFrame

-- Cantos arredondados
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Título com efeito hacker
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 60)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🚀 HACK LAUNCHER 🚀"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.Code
title.Parent = mainFrame

-- Subtítulo
local subtitle = Instance.new("TextLabel")
subtitle.Name = "Subtitle"
subtitle.Size = UDim2.new(1, 0, 0, 30)
subtitle.Position = UDim2.new(0, 0, 0, 60)
subtitle.BackgroundTransparency = 1
subtitle.Text = "[SISTEMA ATIVADO]"
subtitle.TextColor3 = Color3.fromRGB(255, 0, 0)
subtitle.TextScaled = true
subtitle.Font = Enum.Font.Code
subtitle.Parent = mainFrame

-- Container para botões
local buttonContainer = Instance.new("Frame")
buttonContainer.Name = "ButtonContainer"
buttonContainer.Size = UDim2.new(1, -20, 1, -100)
buttonContainer.Position = UDim2.new(0, 10, 0, 90)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = mainFrame

-- Layout para organizar botões
local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 12)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.Parent = buttonContainer

-- Função para criar botões com efeito
local function createHackButton(name, text, color, callback)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(0, 280, 0, 55)
    button.BackgroundColor3 = color
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.CodeBold
    button.Parent = buttonContainer
    
    -- Borda neon do botão
    local buttonBorder = Instance.new("UIStroke")
    buttonBorder.Color = Color3.fromRGB(255, 255, 255)
    buttonBorder.Thickness = 2
    buttonBorder.Parent = button
    
    -- Cantos arredondados
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = button
    
    -- Efeitos de hover e clique
    local originalSize = button.Size
    
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {
            Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset + 15, originalSize.Y.Scale, originalSize.Y.Offset + 8),
            BackgroundColor3 = Color3.fromRGB(
                math.min(255, color.R * 255 + 60), 
                math.min(255, color.G * 255 + 60), 
                math.min(255, color.B * 255 + 60)
            )
        })
        tween:Play()
        buttonBorder.Color = Color3.fromRGB(0, 255, 255)
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {
            Size = originalSize,
            BackgroundColor3 = color
        })
        tween:Play()
        buttonBorder.Color = Color3.fromRGB(255, 255, 255)
    end)
    
    button.MouseButton1Click:Connect(function()
        -- Efeito de clique
        local clickTween = TweenService:Create(button, TweenInfo.new(0.1), {
            Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset - 8, originalSize.Y.Scale, originalSize.Y.Offset - 5)
        })
        clickTween:Play()
        
        clickTween.Completed:Connect(function()
            local returnTween = TweenService:Create(button, TweenInfo.new(0.1), {
                Size = originalSize
            })
            returnTween:Play()
        end)
        
        if callback then
            callback()
        end
    end)
    
    return button
end

-- Função para mostrar notificação
local function showNotification(message, color)
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 280, 0, 60)
    notification.Position = UDim2.new(1, 10, 0, 100)
    notification.BackgroundColor3 = color or Color3.fromRGB(0, 0, 0)
    notification.BorderSizePixel = 0
    notification.Parent = screenGui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 10)
    notifCorner.Parent = notification
    
    local notifBorder = Instance.new("UIStroke")
    notifBorder.Color = Color3.fromRGB(255, 255, 255)
    notifBorder.Thickness = 2
    notifBorder.Parent = notification
    
    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, 0, 1, 0)
    notifText.BackgroundTransparency = 1
    notifText.Text = message
    notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifText.TextScaled = true
    notifText.Font = Enum.Font.CodeBold
    notifText.Parent = notification
    
    -- Animação de entrada
    local enterTween = TweenService:Create(notification, TweenInfo.new(0.5), {
        Position = UDim2.new(1, -290, 0, 100)
    })
    enterTween:Play()
    
    -- Remover após 3 segundos
    spawn(function()
        wait(3)
        local exitTween = TweenService:Create(notification, TweenInfo.new(0.5), {
            Position = UDim2.new(1, 10, 0, 100)
        })
        exitTween:Play()
        
        exitTween.Completed:Connect(function()
            notification:Destroy()
        end)
    end)
end

-- Criar botões funcionais
local launchAllButton = createHackButton("LaunchAll", "🚀 LANÇAR TODOS OS JOGADORES", Color3.fromRGB(255, 0, 0), function()
    _G.HackLauncher.launchAllPlayers(player)
    spawn(function()
        showNotification("💥 TODOS OS JOGADORES LANÇADOS!", Color3.fromRGB(255, 0, 0))
    end)
end)

local explosionButton = createHackButton("Explosion", "💣 EXPLOSÃO EM ÁREA", Color3.fromRGB(255, 100, 0), function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local position = player.Character.HumanoidRootPart.Position
        _G.HackLauncher.createLaunchExplosion(position, 50, player)
        spawn(function()
            showNotification("💣 EXPLOSÃO ATIVADA!", Color3.fromRGB(255, 100, 0))
        end)
    end
end)

local megaLaunchButton = createHackButton("MegaLaunch", "⚡ MEGA LAUNCHER SUPREMO", Color3.fromRGB(0, 255, 0), function()
    _G.HackLauncher.activateHackLauncher(player)
    spawn(function()
        showNotification("⚡ MEGA LAUNCHER ATIVADO!", Color3.fromRGB(0, 255, 0))
    end)
end)

-- Campo para lançar jogador específico
local targetFrame = Instance.new("Frame")
targetFrame.Name = "TargetFrame"
targetFrame.Size = UDim2.new(0, 280, 0, 100)
targetFrame.BackgroundTransparency = 1
targetFrame.Parent = buttonContainer

local targetInput = Instance.new("TextBox")
targetInput.Size = UDim2.new(1, 0, 0, 40)
targetInput.Position = UDim2.new(0, 0, 0, 0)
targetInput.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
targetInput.BorderSizePixel = 0
targetInput.Text = "Nome do Jogador"
targetInput.TextColor3 = Color3.fromRGB(255, 255, 255)
targetInput.TextScaled = true
targetInput.Font = Enum.Font.Code
targetInput.PlaceholderText = "Digite o nome do jogador..."
targetInput.Parent = targetFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = targetInput

local inputBorder = Instance.new("UIStroke")
inputBorder.Color = Color3.fromRGB(0, 255, 255)
inputBorder.Thickness = 2
inputBorder.Parent = targetInput

local targetButton = createHackButton("LaunchTarget", "🎯 LANÇAR JOGADOR ESPECÍFICO", Color3.fromRGB(0, 0, 255), function()
    local targetName = targetInput.Text
    if targetName and targetName ~= "Nome do Jogador" and targetName ~= "" then
        local success = _G.HackLauncher.launchPlayerByName(targetName, player)
        spawn(function()
            if success then
                showNotification("🎯 " .. targetName .. " LANÇADO!", Color3.fromRGB(0, 0, 255))
            else
                showNotification("❌ JOGADOR NÃO ENCONTRADO!", Color3.fromRGB(255, 0, 0))
            end
        end)
    else
        spawn(function()
            showNotification("⚠️ DIGITE UM NOME VÁLIDO!", Color3.fromRGB(255, 255, 0))
        end)
    end
end)
targetButton.Size = UDim2.new(1, 0, 0, 50)
targetButton.Position = UDim2.new(0, 0, 0, 50)
targetButton.Parent = targetFrame

-- Botão para fechar/minimizar
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 35, 0, 35)
closeButton.Position = UDim2.new(1, -40, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.CodeBold
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 17)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Tornar a GUI arrastável
local dragging = false
local dragStart = nil
local startPos = nil

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Efeito de texto piscando no título
spawn(function()
    while true do
        for i = 1, 10 do
            title.TextTransparency = i / 10
            wait(0.15)
        end
        for i = 10, 1, -1 do
            title.TextTransparency = i / 10
            wait(0.15)
        end
    end
end)

-- Mensagem de inicialização
spawn(function()
    wait(1)
    showNotification("🚀 HACK LAUNCHER ONLINE!", Color3.fromRGB(0, 255, 0))
end)

print("🚀💻 HACK LAUNCHER COMPLETO CARREGADO! Interface e sistema prontos para uso!")
print("🎮 Use os botões da interface para ativar as funções de lançamento!")