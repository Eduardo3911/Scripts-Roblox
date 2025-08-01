-- 🔍 SIMPLE VULNERABILITY SCANNER - ROBLOX 🔍
-- Versão simplificada e testada

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local findings = {}

-- Função para adicionar descoberta
local function addFinding(category, severity, item, location, details)
    table.insert(findings, {
        category = category,
        severity = severity,
        item = item,
        location = location,
        details = details
    })
end

-- SCAN BÁSICO
local function simpleScan()
    findings = {}
    
    print("🔍 Iniciando Simple Vulnerability Scanner...")
    
    -- 1. SCAN REMOTES
    print("🔍 Procurando RemoteEvents...")
    local remoteCount = 0
    local function scanRemotes(container, path)
        for _, obj in pairs(container:GetChildren()) do
            if obj:IsA("RemoteEvent") then
                remoteCount = remoteCount + 1
                addFinding("RemoteEvent", "INFO", obj.Name, path, "RemoteEvent encontrado")
            elseif obj:IsA("RemoteFunction") then
                remoteCount = remoteCount + 1
                addFinding("RemoteFunction", "INFO", obj.Name, path, "RemoteFunction encontrada")
            end
            
            if #obj:GetChildren() > 0 then
                scanRemotes(obj, path .. "/" .. obj.Name)
            end
        end
    end
    
    scanRemotes(ReplicatedStorage, "ReplicatedStorage")
    scanRemotes(Workspace, "Workspace")
    
    -- 2. SCAN VALUES
    print("🔍 Procurando Values...")
    local valueCount = 0
    local function scanValues(container, path)
        for _, obj in pairs(container:GetChildren()) do
            if obj:IsA("IntValue") or obj:IsA("StringValue") or obj:IsA("NumberValue") or 
               obj:IsA("BoolValue") or obj:IsA("ObjectValue") then
                valueCount = valueCount + 1
                
                local severity = "INFO"
                local objName = string.lower(obj.Name)
                
                -- Detectar valores suspeitos
                if string.find(objName, "money") or string.find(objName, "cash") or
                   string.find(objName, "coin") or string.find(objName, "gem") or
                   string.find(objName, "level") or string.find(objName, "xp") or
                   string.find(objName, "admin") or string.find(objName, "mod") or
                   string.find(objName, "owner") or string.find(objName, "rank") or
                   string.find(objName, "speed") or string.find(objName, "jump") or
                   string.find(objName, "health") or string.find(objName, "power") then
                    severity = "WARNING"
                end
                
                addFinding("Value", severity, obj.Name .. " (" .. obj.ClassName .. ")", path, 
                          severity == "WARNING" and "Nome sugere dado importante" or "Value comum")
            end
            
            if #obj:GetChildren() > 0 then
                scanValues(obj, path .. "/" .. obj.Name)
            end
        end
    end
    
    scanValues(ReplicatedStorage, "ReplicatedStorage")
    scanValues(Workspace, "Workspace")
    
    -- 3. SCAN SCRIPTS
    print("🔍 Procurando Scripts...")
    local scriptCount = 0
    local function scanScripts(container, path)
        for _, obj in pairs(container:GetChildren()) do
            if obj:IsA("LocalScript") then
                scriptCount = scriptCount + 1
                local severity = container == ReplicatedStorage and "WARNING" or "INFO"
                addFinding("LocalScript", severity, obj.Name, path, 
                          severity == "WARNING" and "LocalScript em local público" or "LocalScript encontrado")
            elseif obj:IsA("ModuleScript") then
                scriptCount = scriptCount + 1
                local severity = container == ReplicatedStorage and "WARNING" or "INFO"
                addFinding("ModuleScript", severity, obj.Name, path, 
                          severity == "WARNING" and "ModuleScript exposto" or "ModuleScript encontrado")
            elseif obj:IsA("Script") then
                scriptCount = scriptCount + 1
                addFinding("Script", "INFO", obj.Name, path, "Script encontrado")
            end
            
            if #obj:GetChildren() > 0 then
                scanScripts(obj, path .. "/" .. obj.Name)
            end
        end
    end
    
    scanScripts(game, "game")
    
    -- 4. VERIFICAR CONFIGURAÇÕES
    print("🔍 Verificando configurações...")
    addFinding("Security", Workspace.FilteringEnabled and "GOOD" or "CRITICAL", 
              "FilteringEnabled: " .. tostring(Workspace.FilteringEnabled), "Workspace", 
              Workspace.FilteringEnabled and "Segurança ativada" or "CRÍTICO: Sem proteção!")
    
    addFinding("Setting", "INFO", "StreamingEnabled: " .. tostring(Workspace.StreamingEnabled), 
              "Workspace", "Configuração de streaming")
    
    -- RESULTADOS
    print("✅ Simple Scan completo!")
    print("📊 ESTATÍSTICAS:")
    print("   🔗 RemoteEvents/Functions: " .. remoteCount)
    print("   📊 Values encontrados: " .. valueCount)
    print("   📜 Scripts encontrados: " .. scriptCount)
    print("   🚨 Total de itens: " .. #findings)
    
    return findings
end

-- INTERFACE SIMPLES
local function createSimpleGUI(items)
    local gui = Instance.new("ScreenGui")
    gui.Name = "SimpleScanResults"
    gui.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 300)
    frame.Position = UDim2.new(0.5, -200, 0.5, -150)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(100, 100, 255)
    frame.Parent = gui
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    title.BorderSizePixel = 0
    title.Text = "🔍 Simple Scanner - " .. #items .. " itens encontrados"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    title.Font = Enum.Font.SourceSansBold
    title.Parent = frame
    
    -- Lista com scroll
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -10, 1, -80)
    scroll.Position = UDim2.new(0, 5, 0, 45)
    scroll.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    scroll.BorderSizePixel = 1
    scroll.BorderColor3 = Color3.fromRGB(70, 70, 70)
    scroll.ScrollBarThickness = 8
    scroll.Parent = frame
    
    -- Categorizar itens
    local categories = {}
    for _, item in ipairs(items) do
        if not categories[item.category] then
            categories[item.category] = {}
        end
        table.insert(categories[item.category], item)
    end
    
    local yPos = 5
    for category, categoryItems in pairs(categories) do
        -- Cabeçalho da categoria
        local categoryHeader = Instance.new("TextLabel")
        categoryHeader.Size = UDim2.new(1, -10, 0, 25)
        categoryHeader.Position = UDim2.new(0, 5, 0, yPos)
        categoryHeader.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        categoryHeader.BorderSizePixel = 0
        categoryHeader.Text = "📁 " .. category .. " (" .. #categoryItems .. ")"
        categoryHeader.TextColor3 = Color3.fromRGB(200, 200, 255)
        categoryHeader.TextSize = 14
        categoryHeader.Font = Enum.Font.SourceSansBold
        categoryHeader.TextXAlignment = Enum.TextXAlignment.Left
        categoryHeader.Parent = scroll
        
        yPos = yPos + 30
        
        -- Itens da categoria
        for _, item in ipairs(categoryItems) do
            local itemLabel = Instance.new("TextLabel")
            itemLabel.Size = UDim2.new(1, -20, 0, 20)
            itemLabel.Position = UDim2.new(0, 15, 0, yPos)
            itemLabel.BackgroundTransparency = 1
            
            -- Cor baseada na severidade
            local colors = {
                CRITICAL = Color3.fromRGB(255, 100, 100),
                WARNING = Color3.fromRGB(255, 200, 100),
                SUSPICIOUS = Color3.fromRGB(255, 255, 100),
                INFO = Color3.fromRGB(200, 200, 200),
                GOOD = Color3.fromRGB(100, 255, 100)
            }
            
            itemLabel.Text = "• " .. item.item
            itemLabel.TextColor3 = colors[item.severity] or Color3.fromRGB(255, 255, 255)
            itemLabel.TextSize = 12
            itemLabel.Font = Enum.Font.SourceSans
            itemLabel.TextXAlignment = Enum.TextXAlignment.Left
            itemLabel.Parent = scroll
            
            yPos = yPos + 22
        end
        
        yPos = yPos + 10
    end
    
    scroll.CanvasSize = UDim2.new(0, 0, 0, yPos)
    
    -- Botão fechar
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 80, 0, 25)
    closeBtn.Position = UDim2.new(1, -85, 1, -30)
    closeBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "Fechar"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 12
    closeBtn.Font = Enum.Font.SourceSans
    closeBtn.Parent = frame
    
    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
end

-- Executar scan
local function runSimpleScan()
    local results = simpleScan()
    createSimpleGUI(results)
    
    -- Mostrar no console
    print("\n🔍 SIMPLE SCAN RESULTS:")
    print("═══════════════════════════════")
    
    local criticalFound = false
    local warningFound = false
    
    for _, item in ipairs(results) do
        if item.severity == "CRITICAL" then
            if not criticalFound then
                print("🚨 CRÍTICOS ENCONTRADOS:")
                criticalFound = true
            end
            print("   " .. item.item .. " - " .. item.details)
        elseif item.severity == "WARNING" then
            if not warningFound then
                print("⚠️ AVISOS:")
                warningFound = true
            end
            print("   " .. item.item .. " - " .. item.details)
        end
    end
    
    if not criticalFound and not warningFound then
        print("✅ Nenhuma vulnerabilidade crítica encontrada!")
    end
    
    print("═══════════════════════════════")
end

-- Auto-executar
spawn(function()
    wait(2)
    runSimpleScan()
end)

_G.SimpleScan = runSimpleScan

print("🔍 Simple Vulnerability Scanner carregado!")
print("💡 Use _G.SimpleScan() para executar manualmente")