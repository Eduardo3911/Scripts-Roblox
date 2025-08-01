-- GUI para Hack Launcher - Interface com Botão
-- Para jogo temático: Hackers vs Anti-Hackers

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Primeiro, carregar o script do launcher se não estiver carregado
if not _G.HackLauncher then
    -- Incluir o código do launcher aqui ou garantir que seja carregado
    loadstring(game:HttpGet("path_to_your_launcher_script"))() -- Substitua pelo caminho do seu script
end

-- Configurações da GUI
local GUI_SIZE = UDim2.new(0, 300, 0, 400)
local BUTTON_SIZE = UDim2.new(0, 250, 0, 50)

-- Criar a ScreenGui principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HackLauncherGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Frame principal com tema hacker
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = GUI_SIZE
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Adicionar borda neon
local border = Instance.new("UIStroke")
border.Color = Color3.fromRGB(0, 255, 255)
border.Thickness = 2
border.Parent = mainFrame

-- Adicionar cantos arredondados
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
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
title.Text = "[SISTEMA ATIVADO]"
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
listLayout.Padding = UDim.new(0, 10)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.Parent = buttonContainer

-- Função para criar botões com efeito
local function createHackButton(name, text, color, callback)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = BUTTON_SIZE
    button.BackgroundColor3 = color
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.CodeBold
    button.Parent = buttonContainer
    
    -- Adicionar borda neon ao botão
    local buttonBorder = Instance.new("UIStroke")
    buttonBorder.Color = Color3.fromRGB(255, 255, 255)
    buttonBorder.Thickness = 1
    buttonBorder.Parent = button
    
    -- Cantos arredondados
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    -- Efeitos de hover e clique
    local originalSize = button.Size
    
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {
            Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset + 10, originalSize.Y.Scale, originalSize.Y.Offset + 5),
            BackgroundColor3 = Color3.fromRGB(math.min(255, color.R * 255 + 50), math.min(255, color.G * 255 + 50), math.min(255, color.B * 255 + 50))
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
            Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset - 5, originalSize.Y.Scale, originalSize.Y.Offset - 3)
        })
        clickTween:Play()
        
        clickTween.Completed:Connect(function()
            local returnTween = TweenService:Create(button, TweenInfo.new(0.1), {
                Size = originalSize
            })
            returnTween:Play()
        end)
        
        -- Executar callback
        if callback then
            callback()
        end
    end)
    
    return button
end

-- Função para mostrar notificação
local function showNotification(message, color)
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 250, 0, 50)
    notification.Position = UDim2.new(1, 10, 0, 100)
    notification.BackgroundColor3 = color or Color3.fromRGB(0, 0, 0)
    notification.BorderSizePixel = 0
    notification.Parent = screenGui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 8)
    notifCorner.Parent = notification
    
    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, 0, 1, 0)
    notifText.BackgroundTransparency = 1
    notifText.Text = message
    notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifText.TextScaled = true
    notifText.Font = Enum.Font.Code
    notifText.Parent = notification
    
    -- Animação de entrada
    local enterTween = TweenService:Create(notification, TweenInfo.new(0.5), {
        Position = UDim2.new(1, -260, 0, 100)
    })
    enterTween:Play()
    
    -- Remover após 3 segundos
    wait(3)
    local exitTween = TweenService:Create(notification, TweenInfo.new(0.5), {
        Position = UDim2.new(1, 10, 0, 100)
    })
    exitTween:Play()
    
    exitTween.Completed:Connect(function()
        notification:Destroy()
    end)
end

-- Criar botões funcionais
local launchAllButton = createHackButton("LaunchAll", "🚀 LANÇAR TODOS", Color3.fromRGB(255, 0, 0), function()
    if _G.HackLauncher then
        _G.HackLauncher.launchAllPlayers(player)
        spawn(function()
            showNotification("💥 TODOS OS JOGADORES LANÇADOS!", Color3.fromRGB(255, 0, 0))
        end)
    end
end)

local explosionButton = createHackButton("Explosion", "💣 EXPLOSÃO ÁREA", Color3.fromRGB(255, 100, 0), function()
    if _G.HackLauncher and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local position = player.Character.HumanoidRootPart.Position
        _G.HackLauncher.createLaunchExplosion(position, 50, player)
        spawn(function()
            showNotification("💣 EXPLOSÃO ATIVADA!", Color3.fromRGB(255, 100, 0))
        end)
    end
end)

local megaLaunchButton = createHackButton("MegaLaunch", "⚡ MEGA LAUNCHER", Color3.fromRGB(0, 255, 0), function()
    if _G.HackLauncher then
        _G.HackLauncher.activateHackLauncher(player)
        spawn(function()
            showNotification("⚡ MEGA LAUNCHER ATIVADO!", Color3.fromRGB(0, 255, 0))
        end)
    end
end)

-- Campo para lançar jogador específico
local targetFrame = Instance.new("Frame")
targetFrame.Name = "TargetFrame"
targetFrame.Size = UDim2.new(0, 250, 0, 80)
targetFrame.BackgroundTransparency = 1
targetFrame.Parent = buttonContainer

local targetInput = Instance.new("TextBox")
targetInput.Size = UDim2.new(1, 0, 0, 30)
targetInput.Position = UDim2.new(0, 0, 0, 0)
targetInput.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
targetInput.BorderSizePixel = 0
targetInput.Text = "Nome do Jogador"
targetInput.TextColor3 = Color3.fromRGB(255, 255, 255)
targetInput.TextScaled = true
targetInput.Font = Enum.Font.Code
targetInput.Parent = targetFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 5)
inputCorner.Parent = targetInput

local targetButton = createHackButton("LaunchTarget", "🎯 LANÇAR ALVO", Color3.fromRGB(0, 0, 255), function()
    local targetName = targetInput.Text
    if targetName and targetName ~= "Nome do Jogador" and _G.HackLauncher then
        local success = _G.HackLauncher.launchPlayerByName(targetName, player)
        spawn(function()
            if success then
                showNotification("🎯 " .. targetName .. " LANÇADO!", Color3.fromRGB(0, 0, 255))
            else
                showNotification("❌ JOGADOR NÃO ENCONTRADO!", Color3.fromRGB(255, 0, 0))
            end
        end)
    end
end)
targetButton.Size = UDim2.new(1, 0, 0, 40)
targetButton.Position = UDim2.new(0, 0, 0, 40)
targetButton.Parent = targetFrame

-- Botão para fechar/minimizar
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.BorderSizePixel = 0
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.CodeBold
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 15)
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
            wait(0.1)
        end
        for i = 10, 1, -1 do
            title.TextTransparency = i / 10
            wait(0.1)
        end
    end
end)

-- Mensagem de inicialização
spawn(function()
    wait(1)
    showNotification("🚀 HACK LAUNCHER ONLINE!", Color3.fromRGB(0, 255, 0))
end)

print("🖥️ GUI do Hack Launcher carregada! Interface pronta para uso.")