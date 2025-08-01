-- 🛡️ VULNERABILITY SCANNER V2 - FOCO NAS CRÍTICAS 🛡️
-- Versão melhorada para focar no que realmente importa

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local VulnerabilityScanner = {}
local vulnerabilities = {}

-- Função para adicionar vulnerabilidade
local function addVulnerability(category, severity, description, location, details)
    table.insert(vulnerabilities, {
        category = category,
        severity = severity,
        description = description,
        location = location,
        details = details or "",
        timestamp = tick()
    })
end

-- SCAN FOCADO - Apenas as vulnerabilidades REALMENTE importantes
function VulnerabilityScanner.runCriticalScan()
    print("🚨 Iniciando scan CRÍTICO (apenas vulnerabilidades importantes)...")
    
    vulnerabilities = {}
    
    -- 1. VERIFICAR FILTERING ENABLED (MAIS IMPORTANTE!)
    print("🔍 Verificando FilteringEnabled...")
    if not Workspace.FilteringEnabled then
        addVulnerability(
            "Security Settings",
            "CRITICAL",
            "🚨 FilteringEnabled está DESATIVADO!",
            "Workspace.FilteringEnabled",
            "EXTREMAMENTE PERIGOSO: Exploits podem fazer qualquer coisa!"
        )
    else
        print("✅ FilteringEnabled está ATIVO (bom!)")
    end
    
    -- 2. REMOTE EVENTS PERIGOSOS (apenas com nomes suspeitos)
    print("🔍 Procurando RemoteEvents perigosos...")
    local dangerousRemoteNames = {
        "admin", "ban", "kick", "give", "money", "cash", "teleport",
        "kill", "god", "fly", "speed", "jump", "owner", "mod"
    }
    
    local function scanDangerousRemotes(container, path)
        for _, obj in pairs(container:GetChildren()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                for _, dangerousName in pairs(dangerousRemoteNames) do
                    if string.find(string.lower(obj.Name), dangerousName) then
                        addVulnerability(
                            "Dangerous Remotes",
                            "HIGH",
                            "🚨 RemoteEvent perigoso: " .. obj.Name,
                            path .. "/" .. obj.Name,
                            "Nome sugere funcionalidade de admin/hack"
                        )
                    end
                end
            end
            
            if #obj:GetChildren() > 0 then
                scanDangerousRemotes(obj, path .. "/" .. obj.Name)
            end
        end
    end
    
    scanDangerousRemotes(ReplicatedStorage, "ReplicatedStorage")
    
    -- 3. VALORES SENSÍVEIS (apenas os realmente perigosos)
    print("🔍 Procurando valores sensíveis...")
    local function scanSensitiveValues(container, path)
        for _, obj in pairs(container:GetChildren()) do
            if obj:IsA("IntValue") or obj:IsA("StringValue") or obj:IsA("NumberValue") then
                local objName = string.lower(obj.Name)
                if string.find(objName, "admin") or 
                   string.find(objName, "owner") or
                   string.find(objName, "money") or
                   string.find(objName, "cash") or
                   string.find(objName, "level") or
                   string.find(objName, "rank") or
                   string.find(objName, "god") or
                   string.find(objName, "mod") then
                    addVulnerability(
                        "Sensitive Values",
                        "HIGH",
                        "💰 Valor sensível exposto: " .. obj.Name,
                        path .. "/" .. obj.Name,
                        "Pode ser modificado para dar vantagens"
                    )
                end
            end
            
            if #obj:GetChildren() > 0 then
                scanSensitiveValues(obj, path .. "/" .. obj.Name)
            end
        end
    end
    
    scanSensitiveValues(ReplicatedStorage, "ReplicatedStorage")
    
    -- 4. GLOBALS PERIGOSOS
    print("🔍 Verificando _G perigosos...")
    for key, value in pairs(_G) do
        local keyName = string.lower(tostring(key))
        if string.find(keyName, "admin") or 
           string.find(keyName, "hack") or
           string.find(keyName, "exploit") or
           string.find(keyName, "bypass") then
            addVulnerability(
                "Dangerous Globals",
                "MEDIUM",
                "🔓 Variável global suspeita: " .. tostring(key),
                "_G." .. tostring(key),
                "Nome sugere funcionalidade perigosa"
            )
        end
    end
    
    -- 5. CONTAR TODOS OS REMOTES (para estatística)
    local totalRemotes = 0
    local function countRemotes(container)
        for _, obj in pairs(container:GetChildren()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                totalRemotes = totalRemotes + 1
            end
            if #obj:GetChildren() > 0 then
                countRemotes(obj)
            end
        end
    end
    
    countRemotes(ReplicatedStorage)
    
    print("📊 Total de RemoteEvents/Functions encontrados: " .. totalRemotes)
    print("⚠️ Vulnerabilidades CRÍTICAS encontradas: " .. #vulnerabilities)
    
    -- Mostrar interface
    VulnerabilityScanner.createSimpleGUI()
    
    -- Relatório no console
    print("\n🛡️ RELATÓRIO CRÍTICO:")
    print("═══════════════════════════════════")
    
    if #vulnerabilities == 0 then
        print("✅ PARABÉNS! Nenhuma vulnerabilidade crítica encontrada!")
    else
        for _, vuln in ipairs(vulnerabilities) do
            print(string.format("[%s] %s", vuln.severity, vuln.description))
        end
    end
    
    print("═══════════════════════════════════")
end

-- Interface mais simples
function VulnerabilityScanner.createSimpleGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "VulnerabilityScanner"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 500, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame
    
    local border = Instance.new("UIStroke")
    border.Color = #vulnerabilities > 0 and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
    border.Thickness = 3
    border.Parent = mainFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.BackgroundTransparency = 1
    title.Text = "🛡️ VULNERABILITY SCAN RESULTS"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.CodeBold
    title.Parent = mainFrame
    
    local summary = Instance.new("TextLabel")
    summary.Size = UDim2.new(1, 0, 0, 40)
    summary.Position = UDim2.new(0, 0, 0, 50)
    summary.BackgroundTransparency = 1
    
    if #vulnerabilities == 0 then
        summary.Text = "✅ SEGURO: Nenhuma vulnerabilidade crítica!"
        summary.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        summary.Text = string.format("⚠️ ENCONTRADAS: %d vulnerabilidades críticas", #vulnerabilities)
        summary.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
    
    summary.TextScaled = true
    summary.Font = Enum.Font.Code
    summary.Parent = mainFrame
    
    -- Lista de vulnerabilidades
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -20, 1, -120)
    scrollFrame.Position = UDim2.new(0, 10, 0, 90)
    scrollFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 8
    scrollFrame.Parent = mainFrame
    
    local scrollCorner = Instance.new("UICorner")
    scrollCorner.CornerRadius = UDim.new(0, 5)
    scrollCorner.Parent = scrollFrame
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = scrollFrame
    
    for i, vuln in ipairs(vulnerabilities) do
        local vulnFrame = Instance.new("TextLabel")
        vulnFrame.Size = UDim2.new(1, -10, 0, 60)
        vulnFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        vulnFrame.BorderSizePixel = 0
        vulnFrame.Text = string.format("%s\n📍 %s", vuln.description, vuln.location)
        vulnFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
        vulnFrame.TextWrapped = true
        vulnFrame.TextXAlignment = Enum.TextXAlignment.Left
        vulnFrame.Font = Enum.Font.Code
        vulnFrame.TextSize = 12
        vulnFrame.Parent = scrollFrame
        
        local vulnCorner = Instance.new("UICorner")
        vulnCorner.CornerRadius = UDim.new(0, 3)
        vulnCorner.Parent = vulnFrame
    end
    
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
    
    -- Botão fechar
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
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
end

-- Exportar
_G.VulnerabilityScanner = VulnerabilityScanner

-- Auto-executar versão focada
spawn(function()
    wait(2)
    VulnerabilityScanner.runCriticalScan()
end)

print("🛡️ VULNERABILITY SCANNER V2 CARREGADO!")
print("🎯 Agora focando apenas nas vulnerabilidades REALMENTE importantes!")
