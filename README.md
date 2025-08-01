-- 🛡️ VULNERABILITY SCANNER - DETECTOR DE FALHAS 🛡️
-- Script para identificar vulnerabilidades em jogos do Roblox
-- Criado para fins educacionais e de segurança

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local ServerScriptService = game:GetService("ServerScriptService")
local StarterPlayerScripts = game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ==================== SISTEMA DE DETECÇÃO ====================

local VulnerabilityScanner = {}
local vulnerabilities = {}
local scanResults = {}

-- Função para adicionar vulnerabilidade encontrada
local function addVulnerability(category, severity, description, location, details)
    table.insert(vulnerabilities, {
        category = category,
        severity = severity, -- LOW, MEDIUM, HIGH, CRITICAL
        description = description,
        location = location,
        details = details or "",
        timestamp = tick()
    })
end

-- ==================== DETECTORES DE VULNERABILIDADES ====================

-- 1. Verificar RemoteEvents/RemoteFunctions expostos
function VulnerabilityScanner.scanRemoteEvents()
    print("🔍 Escaneando RemoteEvents e RemoteFunctions...")
    
    local function scanContainer(container, path)
        for _, obj in pairs(container:GetChildren()) do
            if obj:IsA("RemoteEvent") then
                addVulnerability(
                    "Remote Events",
                    "HIGH",
                    "RemoteEvent exposto encontrado: " .. obj.Name,
                    path .. "/" .. obj.Name,
                    "Pode ser explorado para executar ações não autorizadas"
                )
            elseif obj:IsA("RemoteFunction") then
                addVulnerability(
                    "Remote Functions",
                    "HIGH",
                    "RemoteFunction exposta encontrada: " .. obj.Name,
                    path .. "/" .. obj.Name,
                    "Pode ser explorada para obter informações sensíveis"
                )
            end
            
            if #obj:GetChildren() > 0 then
                scanContainer(obj, path .. "/" .. obj.Name)
            end
        end
    end
    
    scanContainer(ReplicatedStorage, "ReplicatedStorage")
    scanContainer(Workspace, "Workspace")
end

-- 2. Verificar BindableEvents/BindableFunctions
function VulnerabilityScanner.scanBindables()
    print("🔍 Escaneando BindableEvents e BindableFunctions...")
    
    local function findBindables(container, path)
        for _, obj in pairs(container:GetChildren()) do
            if obj:IsA("BindableEvent") then
                addVulnerability(
                    "Bindable Events",
                    "MEDIUM",
                    "BindableEvent encontrado: " .. obj.Name,
                    path .. "/" .. obj.Name,
                    "Pode ser usado para interferir em sistemas internos"
                )
            elseif obj:IsA("BindableFunction") then
                addVulnerability(
                    "Bindable Functions",
                    "MEDIUM",
                    "BindableFunction encontrada: " .. obj.Name,
                    path .. "/" .. obj.Name,
                    "Pode expor lógica interna do jogo"
                )
            end
            
            if #obj:GetChildren() > 0 then
                findBindables(obj, path .. "/" .. obj.Name)
            end
        end
    end
    
    findBindables(ReplicatedStorage, "ReplicatedStorage")
    findBindables(Workspace, "Workspace")
end

-- 3. Verificar _G e shared globals
function VulnerabilityScanner.scanGlobalVariables()
    print("🔍 Escaneando variáveis globais...")
    
    -- Verificar _G
    for key, value in pairs(_G) do
        if type(value) == "function" then
            addVulnerability(
                "Global Variables",
                "MEDIUM",
                "Função global exposta em _G: " .. tostring(key),
                "_G." .. tostring(key),
                "Função pode ser chamada por exploits"
            )
        elseif type(value) == "table" then
            addVulnerability(
                "Global Variables",
                "LOW",
                "Tabela global em _G: " .. tostring(key),
                "_G." .. tostring(key),
                "Dados podem ser acessados/modificados"
            )
        end
    end
    
    -- Verificar shared
    for key, value in pairs(shared) do
        addVulnerability(
            "Shared Variables",
            "MEDIUM",
            "Variável shared exposta: " .. tostring(key),
            "shared." .. tostring(key),
            "Pode ser acessada por qualquer script"
        )
    end
end

-- 4. Verificar LocalScripts em locais perigosos
function VulnerabilityScanner.scanLocalScripts()
    print("🔍 Escaneando LocalScripts em locais vulneráveis...")
    
    local function scanForLocalScripts(container, path)
        for _, obj in pairs(container:GetChildren()) do
            if obj:IsA("LocalScript") then
                local severity = "LOW"
                if container == ReplicatedStorage then
                    severity = "HIGH"
                elseif container == Workspace then
                    severity = "MEDIUM"
                end
                
                addVulnerability(
                    "LocalScript Placement",
                    severity,
                    "LocalScript em local vulnerável: " .. obj.Name,
                    path .. "/" .. obj.Name,
                    "LocalScript pode ser lido/modificado por exploits"
                )
            end
            
            if #obj:GetChildren() > 0 then
                scanForLocalScripts(obj, path .. "/" .. obj.Name)
            end
        end
    end
    
    scanForLocalScripts(ReplicatedStorage, "ReplicatedStorage")
    scanForLocalScripts(Workspace, "Workspace")
end

-- 5. Verificar ModuleScripts expostos
function VulnerabilityScanner.scanModuleScripts()
    print("🔍 Escaneando ModuleScripts expostos...")
    
    local function scanModules(container, path)
        for _, obj in pairs(container:GetChildren()) do
            if obj:IsA("ModuleScript") then
                local severity = "MEDIUM"
                if container == ReplicatedStorage then
                    severity = "HIGH"
                end
                
                addVulnerability(
                    "Module Scripts",
                    severity,
                    "ModuleScript exposto: " .. obj.Name,
                    path .. "/" .. obj.Name,
                    "Código pode ser lido e lógica pode ser comprometida"
                )
            end
            
            if #obj:GetChildren() > 0 then
                scanModules(obj, path .. "/" .. obj.Name)
            end
        end
    end
    
    scanModules(ReplicatedStorage, "ReplicatedStorage")
    scanModules(Workspace, "Workspace")
end

-- 6. Verificar valores importantes expostos
function VulnerabilityScanner.scanExposedValues()
    print("🔍 Escaneando valores expostos...")
    
    local dangerousTypes = {
        "IntValue", "StringValue", "BoolValue", "NumberValue",
        "Vector3Value", "CFrameValue", "ObjectValue"
    }
    
    local function scanValues(container, path)
        for _, obj in pairs(container:GetChildren()) do
            for _, valueType in pairs(dangerousTypes) do
                if obj:IsA(valueType) then
                    local severity = "LOW"
                    if string.find(string.lower(obj.Name), "admin") or 
                       string.find(string.lower(obj.Name), "owner") or
                       string.find(string.lower(obj.Name), "mod") or
                       string.find(string.lower(obj.Name), "money") or
                       string.find(string.lower(obj.Name), "cash") or
                       string.find(string.lower(obj.Name), "level") then
                        severity = "HIGH"
                    end
                    
                    addVulnerability(
                        "Exposed Values",
                        severity,
                        valueType .. " exposto: " .. obj.Name,
                        path .. "/" .. obj.Name,
                        "Valor pode ser modificado por exploits"
                    )
                end
            end
            
            if #obj:GetChildren() > 0 then
                scanValues(obj, path .. "/" .. obj.Name)
            end
        end
    end
    
    scanValues(ReplicatedStorage, "ReplicatedStorage")
    scanValues(Workspace, "Workspace")
end

-- 7. Verificar configurações de segurança
function VulnerabilityScanner.scanSecuritySettings()
    print("🔍 Verificando configurações de segurança...")
    
    -- Verificar FilteringEnabled (sempre deve estar ativo)
    if not Workspace.FilteringEnabled then
        addVulnerability(
            "Security Settings",
            "CRITICAL",
            "FilteringEnabled está DESATIVADO!",
            "Workspace.FilteringEnabled",
            "CRÍTICO: Exploits podem modificar qualquer coisa!"
        )
    end
    
    -- Verificar se há proteção contra exploits conhecidos
    if not game:GetService("Players").CharacterAutoLoads then
        addVulnerability(
            "Security Settings",
            "LOW",
            "CharacterAutoLoads desativado",
            "Players.CharacterAutoLoads",
            "Pode indicar sistema customizado, verificar implementação"
        )
    end
end

-- 8. Verificar estrutura de pastas suspeitas
function VulnerabilityScanner.scanSuspiciousFolders()
    print("🔍 Procurando estruturas suspeitas...")
    
    local suspiciousNames = {
        "admin", "owner", "mod", "vip", "admin commands", "commands",
        "exploit", "hack", "cheat", "bypass", "fe", "filtering"
    }
    
    local function scanFolders(container, path)
        for _, obj in pairs(container:GetChildren()) do
            for _, suspName in pairs(suspiciousNames) do
                if string.find(string.lower(obj.Name), suspName) then
                    addVulnerability(
                        "Suspicious Structure",
                        "MEDIUM",
                        "Pasta/objeto suspeito encontrado: " .. obj.Name,
                        path .. "/" .. obj.Name,
                        "Nome sugere funcionalidade sensível"
                    )
                end
            end
            
            if #obj:GetChildren() > 0 then
                scanFolders(obj, path .. "/" .. obj.Name)
            end
        end
    end
    
    scanFolders(game, "game")
end

-- 9. Verificar eventos de mouse/teclado não protegidos
function VulnerabilityScanner.scanInputVulnerabilities()
    print("🔍 Verificando vulnerabilidades de input...")
    
    local mouse = player:GetMouse()
    
    -- Verificar se há listeners de mouse perigosos
    local connections = getconnections or false
    if connections then
        addVulnerability(
            "Input Security",
            "MEDIUM",
            "Função getconnections disponível",
            "Global Environment",
            "Exploits podem interceptar eventos de input"
        )
    end
end

-- ==================== INTERFACE DE RESULTADOS ====================

function VulnerabilityScanner.createResultsGUI()
    -- Criar GUI principal
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "VulnerabilityScanner"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 600, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Borda
    local border = Instance.new("UIStroke")
    border.Color = Color3.fromRGB(255, 100, 100)
    border.Thickness = 3
    border.Parent = mainFrame
    
    -- Cantos arredondados
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🛡️ VULNERABILITY SCANNER RESULTS 🛡️"
    title.TextColor3 = Color3.fromRGB(255, 100, 100)
    title.TextScaled = true
    title.Font = Enum.Font.CodeBold
    title.Parent = mainFrame
    
    -- Estatísticas
    local stats = Instance.new("TextLabel")
    stats.Size = UDim2.new(1, 0, 0, 30)
    stats.Position = UDim2.new(0, 0, 0, 50)
    stats.BackgroundTransparency = 1
    stats.Text = string.format("Total: %d vulnerabilidades encontradas", #vulnerabilities)
    stats.TextColor3 = Color3.fromRGB(255, 255, 255)
    stats.TextScaled = true
    stats.Font = Enum.Font.Code
    stats.Parent = mainFrame
    
    -- ScrollingFrame para resultados
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -20, 1, -100)
    scrollFrame.Position = UDim2.new(0, 10, 0, 80)
    scrollFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 10
    scrollFrame.Parent = mainFrame
    
    local scrollCorner = Instance.new("UICorner")
    scrollCorner.CornerRadius = UDim.new(0, 5)
    scrollCorner.Parent = scrollFrame
    
    -- Layout para os resultados
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = scrollFrame
    
    -- Criar entradas para cada vulnerabilidade
    for i, vuln in ipairs(vulnerabilities) do
        local vulnFrame = Instance.new("Frame")
        vulnFrame.Size = UDim2.new(1, -10, 0, 80)
        vulnFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        vulnFrame.BorderSizePixel = 0
        vulnFrame.LayoutOrder = i
        vulnFrame.Parent = scrollFrame
        
        local vulnCorner = Instance.new("UICorner")
        vulnCorner.CornerRadius = UDim.new(0, 3)
        vulnCorner.Parent = vulnFrame
        
        -- Cor baseada na severidade
        local severityColors = {
            LOW = Color3.fromRGB(100, 200, 100),
            MEDIUM = Color3.fromRGB(255, 200, 100),
            HIGH = Color3.fromRGB(255, 150, 100),
            CRITICAL = Color3.fromRGB(255, 100, 100)
        }
        
        local severityBorder = Instance.new("UIStroke")
        severityBorder.Color = severityColors[vuln.severity] or Color3.fromRGB(255, 255, 255)
        severityBorder.Thickness = 2
        severityBorder.Parent = vulnFrame
        
        -- Texto da vulnerabilidade
        local vulnText = Instance.new("TextLabel")
        vulnText.Size = UDim2.new(1, -10, 1, 0)
        vulnText.Position = UDim2.new(0, 5, 0, 0)
        vulnText.BackgroundTransparency = 1
        vulnText.Text = string.format("[%s] %s\n📍 %s\n💡 %s", 
            vuln.severity, vuln.description, vuln.location, vuln.details)
        vulnText.TextColor3 = Color3.fromRGB(255, 255, 255)
        vulnText.TextXAlignment = Enum.TextXAlignment.Left
        vulnText.TextYAlignment = Enum.TextYAlignment.Top
        vulnText.TextWrapped = true
        vulnText.Font = Enum.Font.Code
        vulnText.TextSize = 12
        vulnText.Parent = vulnFrame
    end
    
    -- Atualizar tamanho do scroll
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
    
    -- Botão para fechar
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "✕"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.CodeBold
    closeButton.Parent = mainFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 15)
    closeCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Tornar arrastável
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
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, 
                                          startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- ==================== FUNÇÃO PRINCIPAL ====================

function VulnerabilityScanner.runFullScan()
    print("🚀 Iniciando scan completo de vulnerabilidades...")
    
    vulnerabilities = {} -- Limpar resultados anteriores
    
    -- Executar todos os scans
    VulnerabilityScanner.scanRemoteEvents()
    VulnerabilityScanner.scanBindables()
    VulnerabilityScanner.scanGlobalVariables()
    VulnerabilityScanner.scanLocalScripts()
    VulnerabilityScanner.scanModuleScripts()
    VulnerabilityScanner.scanExposedValues()
    VulnerabilityScanner.scanSecuritySettings()
    VulnerabilityScanner.scanSuspiciousFolders()
    VulnerabilityScanner.scanInputVulnerabilities()
    
    print("✅ Scan completo! Encontradas " .. #vulnerabilities .. " vulnerabilidades.")
    
    -- Mostrar resultados
    VulnerabilityScanner.createResultsGUI()
    
    -- Relatório no console
    print("\n🛡️ RELATÓRIO DE VULNERABILIDADES:")
    print("═══════════════════════════════════")
    
    local severityCount = {LOW = 0, MEDIUM = 0, HIGH = 0, CRITICAL = 0}
    
    for _, vuln in ipairs(vulnerabilities) do
        severityCount[vuln.severity] = severityCount[vuln.severity] + 1
        print(string.format("[%s] %s", vuln.severity, vuln.description))
    end
    
    print("\n📊 RESUMO:")
    print("CRÍTICAS: " .. severityCount.CRITICAL)
    print("ALTAS: " .. severityCount.HIGH)
    print("MÉDIAS: " .. severityCount.MEDIUM)
    print("BAIXAS: " .. severityCount.LOW)
    print("═══════════════════════════════════")
end

-- Exportar para uso global
_G.VulnerabilityScanner = VulnerabilityScanner

-- Auto-executar scan
spawn(function()
    wait(2) -- Aguardar carregamento completo
    VulnerabilityScanner.runFullScan()
end)

print("🛡️ VULNERABILITY SCANNER CARREGADO!")
print("💻 Use _G.VulnerabilityScanner.runFullScan() para executar manualmente")
