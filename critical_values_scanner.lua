local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local criticalFindings = {}
local vulnerabilityPatterns = {}
local exploitVectors = {}

local function initializeCriticalPatterns()
    vulnerabilityPatterns = {
        criticalValues = {
            "health", "hp", "life", "vida", "damage", "dano", "armor", "shield", "defense",
            "money", "cash", "coins", "currency", "gold", "diamonds", "gems", "robux",
            "level", "xp", "experience", "rank", "prestige", "skill", "power",
            "speed", "jump", "walk", "run", "fly", "teleport", "noclip",
            "admin", "mod", "owner", "god", "hack", "cheat", "exploit", "bypass",
            "spawn", "respawn", "revive", "heal", "kill", "murder", "death",
            "weapon", "gun", "sword", "knife", "bomb", "explosive", "ammo"
        },
        
        encodingPatterns = {
            base64 = "^[A-Za-z0-9+/]+={0,2}$",
            hex = "^[0-9A-Fa-f]+$",
            rot13 = "^[A-Za-z]+$",
            binary = "^[01]+$",
            reversed = "^[A-Za-z0-9]+$"
        },
        
        exploitFunctions = {
            "FireServer", "InvokeServer", "RemoteEvent", "RemoteFunction",
            "SetPrimaryPartCFrame", "SetPrimaryPartCFrame", "CFrame",
            "Humanoid", "Character", "Backpack", "PlayerGui",
            "Instance.new", "GetService", "WaitForChild",
            "loadstring", "pcall", "spawn", "coroutine"
        },
        
        weakValidationPatterns = {
            "if %w+ then", "if %w+ == %w+ then", "if %w+ ~= %w+ then",
            "if %w+ and %w+ then", "if %w+ or %w+ then",
            "check", "validate", "verify", "confirm"
        }
    }
end

local function analyzeCriticalValue(str)
    if not str or type(str) ~= "string" then return nil end
    
    local analysis = {
        isCritical = false,
        isEncoded = false,
        encodingType = nil,
        decodedValue = nil,
        vulnerabilityScore = 0,
        exploitPotential = 0,
        criticalType = nil,
        patterns = {}
    }
    
    local lowerStr = string.lower(str)
    
    for _, criticalValue in ipairs(vulnerabilityPatterns.criticalValues) do
        if string.find(lowerStr, criticalValue) then
            analysis.isCritical = true
            analysis.vulnerabilityScore = analysis.vulnerabilityScore + 25
            
            if string.find(criticalValue, "health") or string.find(criticalValue, "hp") or string.find(criticalValue, "life") then
                analysis.criticalType = "HEALTH"
                analysis.exploitPotential = analysis.exploitPotential + 40
            elseif string.find(criticalValue, "money") or string.find(criticalValue, "cash") or string.find(criticalValue, "coin") then
                analysis.criticalType = "MONEY"
                analysis.exploitPotential = analysis.exploitPotential + 50
            elseif string.find(criticalValue, "admin") or string.find(criticalValue, "god") or string.find(criticalValue, "hack") then
                analysis.criticalType = "ADMIN"
                analysis.exploitPotential = analysis.exploitPotential + 60
            elseif string.find(criticalValue, "speed") or string.find(criticalValue, "fly") or string.find(criticalValue, "teleport") then
                analysis.criticalType = "MOVEMENT"
                analysis.exploitPotential = analysis.exploitPotential + 35
            elseif string.find(criticalValue, "weapon") or string.find(criticalValue, "gun") or string.find(criticalValue, "sword") then
                analysis.criticalType = "WEAPON"
                analysis.exploitPotential = analysis.exploitPotential + 45
            end
            
            table.insert(analysis.patterns, "Critical value: " .. criticalValue)
        end
    end
    
    if string.match(str, vulnerabilityPatterns.encodingPatterns.base64) and #str > 8 then
        local success, decoded = pcall(function()
            return HttpService:Base64Decode(str)
        end)
        
        if success then
            analysis.isEncoded = true
            analysis.encodingType = "Base64"
            analysis.vulnerabilityScore = analysis.vulnerabilityScore + 30
            
            local jsonSuccess, jsonDecoded = pcall(function()
                return HttpService:JSONDecode(decoded)
            end)
            
            if jsonSuccess then
                analysis.decodedValue = jsonDecoded
                analysis.vulnerabilityScore = analysis.vulnerabilityScore + 40
            else
                analysis.decodedValue = decoded
                analysis.vulnerabilityScore = analysis.vulnerabilityScore + 30
            end
        end
    end
    
    if string.match(str, vulnerabilityPatterns.encodingPatterns.hex) and #str > 6 and #str % 2 == 0 then
        local success, decoded = pcall(function()
            local result = ""
            for i = 1, #str, 2 do
                local hexByte = string.sub(str, i, i + 1)
                local byte = tonumber(hexByte, 16)
                if byte then
                    result = result .. string.char(byte)
                end
            end
            return result
        end)
        
        if success and decoded ~= "" then
            analysis.isEncoded = true
            analysis.encodingType = "Hex"
            analysis.decodedValue = decoded
            analysis.vulnerabilityScore = analysis.vulnerabilityScore + 25
        end
    end
    
    if string.match(str, vulnerabilityPatterns.encodingPatterns.rot13) and #str > 3 then
        local decoded = string.gsub(str, "[A-Za-z]", function(c)
            local byte = string.byte(c)
            if byte >= 65 and byte <= 90 then
                return string.char(((byte - 65 + 13) % 26) + 65)
            elseif byte >= 97 and byte <= 122 then
                return string.char(((byte - 97 + 13) % 26) + 97)
            end
            return c
        end)
        
        if decoded ~= str then
            local hasCriticalContent = false
            for _, criticalValue in ipairs(vulnerabilityPatterns.criticalValues) do
                if string.find(string.lower(decoded), criticalValue) then
                    hasCriticalContent = true
                    break
                end
            end
            
            if hasCriticalContent or #decoded > 4 then
                analysis.isEncoded = true
                analysis.encodingType = "ROT13"
                analysis.decodedValue = decoded
                analysis.vulnerabilityScore = analysis.vulnerabilityScore + 20
            end
        end
    end
    
    if string.match(str, vulnerabilityPatterns.encodingPatterns.reversed) and #str > 3 then
        local reversed = string.reverse(str)
        local hasCriticalContent = false
        for _, criticalValue in ipairs(vulnerabilityPatterns.criticalValues) do
            if string.find(string.lower(reversed), criticalValue) then
                hasCriticalContent = true
                break
            end
        end
        
        if hasCriticalContent then
            analysis.isEncoded = true
            analysis.encodingType = "Reversed"
            analysis.decodedValue = reversed
            analysis.vulnerabilityScore = analysis.vulnerabilityScore + 15
        end
    end
    
    return analysis
end

local function analyzeCodeForExploits(source)
    if not source or type(source) ~= "string" then return nil end
    
    local analysis = {
        exploitFunctions = {},
        weakValidations = {},
        criticalOperations = {},
        exploitScore = 0,
        vulnerabilityLevel = "LOW"
    }
    
    for _, funcName in ipairs(vulnerabilityPatterns.exploitFunctions) do
        local count = select(2, string.gsub(source, funcName, ""))
        if count > 0 then
            table.insert(analysis.exploitFunctions, {
                function = funcName,
                count = count
            })
            analysis.exploitScore = analysis.exploitScore + (count * 20)
        end
    end
    
    for _, pattern in ipairs(vulnerabilityPatterns.weakValidationPatterns) do
        local matches = {}
        for match in string.gmatch(source, pattern) do
            table.insert(matches, match)
        end
        if #matches > 0 then
            table.insert(analysis.weakValidations, {
                pattern = pattern,
                matches = matches
            })
            analysis.exploitScore = analysis.exploitScore + (#matches * 10)
        end
    end
    
    local criticalPatterns = {
        "game%.Players%.LocalPlayer",
        "game%.Players%.LocalPlayer%.Character",
        "game%.Players%.LocalPlayer%.Backpack",
        "game%.Players%.LocalPlayer%.PlayerGui",
        "game%.Workspace",
        "game%.ReplicatedStorage",
        "game%.Lighting",
        "Humanoid%.Health",
        "Humanoid%.MaxHealth",
        "Humanoid%.WalkSpeed",
        "Humanoid%.JumpPower",
        "Humanoid%.JumpHeight"
    }
    
    for _, pattern in ipairs(criticalPatterns) do
        local count = select(2, string.gsub(source, pattern, ""))
        if count > 0 then
            table.insert(analysis.criticalOperations, {
                pattern = pattern,
                count = count
            })
            analysis.exploitScore = analysis.exploitScore + (count * 30)
        end
    end
    
    if analysis.exploitScore > 100 then
        analysis.vulnerabilityLevel = "CRITICAL"
    elseif analysis.exploitScore > 60 then
        analysis.vulnerabilityLevel = "HIGH"
    elseif analysis.exploitScore > 30 then
        analysis.vulnerabilityLevel = "MEDIUM"
    end
    
    return analysis
end

local function addCriticalFinding(category, severity, item, location, details, exploitScore)
    table.insert(criticalFindings, {
        category = category,
        severity = severity,
        item = item,
        location = location,
        details = details,
        exploitScore = exploitScore or 0
    })
end

local function scanForCriticalVulnerabilities()
    criticalFindings = {}
    exploitVectors = {}
    
    print("🔍 Iniciando CRITICAL VALUES SCANNER...")
    initializeCriticalPatterns()
    
    local function scanRemotesForCritical(container, path)
        for _, obj in pairs(container:GetChildren()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                local analysis = analyzeCriticalValue(obj.Name)
                local severity = "INFO"
                local details = "Remote encontrado"
                local exploitScore = 0
                
                if analysis and analysis.isCritical then
                    if analysis.isEncoded then
                        severity = "CRITICAL"
                        details = "REMOTE CRÍTICO CODIFICADO! (" .. analysis.criticalType .. ")"
                        if analysis.decodedValue then
                            details = details .. " Decodificado: " .. tostring(analysis.decodedValue)
                        end
                        exploitScore = analysis.exploitPotential + 50
                    elseif analysis.vulnerabilityScore > 40 then
                        severity = "CRITICAL"
                        details = "REMOTE CRÍTICO! (" .. analysis.criticalType .. ")"
                        exploitScore = analysis.exploitPotential + 40
                    elseif analysis.vulnerabilityScore > 25 then
                        severity = "WARNING"
                        details = "Remote suspeito (" .. analysis.criticalType .. ")"
                        exploitScore = analysis.exploitPotential + 20
                    end
                    
                    table.insert(exploitVectors, {
                        type = "Remote",
                        name = obj.Name,
                        criticalType = analysis.criticalType,
                        exploitScore = exploitScore,
                        location = path
                    })
                end
                
                addCriticalFinding("Critical Remote", severity, obj.Name, path, details, exploitScore)
            end
            
            if #obj:GetChildren() > 0 then
                scanRemotesForCritical(obj, path .. "/" .. obj.Name)
            end
        end
    end
    
    scanRemotesForCritical(ReplicatedStorage, "ReplicatedStorage")
    scanRemotesForCritical(Workspace, "Workspace")
    
    local function scanValuesForCritical(container, path)
        for _, obj in pairs(container:GetChildren()) do
            if obj:IsA("IntValue") or obj:IsA("StringValue") or obj:IsA("NumberValue") or 
               obj:IsA("BoolValue") or obj:IsA("ObjectValue") then
                
                local nameAnalysis = analyzeCriticalValue(obj.Name)
                local valueAnalysis = nil
                
                if obj:IsA("StringValue") then
                    valueAnalysis = analyzeCriticalValue(obj.Value)
                end
                
                local severity = "INFO"
                local details = "Value encontrado"
                local exploitScore = 0
                
                if nameAnalysis and nameAnalysis.isCritical then
                    if nameAnalysis.isEncoded then
                        severity = "CRITICAL"
                        details = "VALUE CRÍTICO CODIFICADO! (" .. nameAnalysis.criticalType .. ")"
                        if nameAnalysis.decodedValue then
                            details = details .. " Decodificado: " .. tostring(nameAnalysis.decodedValue)
                        end
                        exploitScore = nameAnalysis.exploitPotential + 45
                    elseif nameAnalysis.vulnerabilityScore > 35 then
                        severity = "CRITICAL"
                        details = "VALUE CRÍTICO! (" .. nameAnalysis.criticalType .. ")"
                        exploitScore = nameAnalysis.exploitPotential + 35
                    elseif nameAnalysis.vulnerabilityScore > 20 then
                        severity = "WARNING"
                        details = "Value suspeito (" .. nameAnalysis.criticalType .. ")"
                        exploitScore = nameAnalysis.exploitPotential + 15
                    end
                    
                    table.insert(exploitVectors, {
                        type = "Value",
                        name = obj.Name,
                        criticalType = nameAnalysis.criticalType,
                        exploitScore = exploitScore,
                        location = path
                    })
                elseif valueAnalysis and valueAnalysis.isCritical then
                    if valueAnalysis.isEncoded then
                        severity = "CRITICAL"
                        details = "VALOR CRÍTICO CODIFICADO! (" .. valueAnalysis.criticalType .. ")"
                        if valueAnalysis.decodedValue then
                            details = details .. " Decodificado: " .. tostring(valueAnalysis.decodedValue)
                        end
                        exploitScore = valueAnalysis.exploitPotential + 45
                    elseif valueAnalysis.vulnerabilityScore > 35 then
                        severity = "CRITICAL"
                        details = "VALOR CRÍTICO! (" .. valueAnalysis.criticalType .. ")"
                        exploitScore = valueAnalysis.exploitPotential + 35
                    end
                end
                
                addCriticalFinding("Critical Value", severity, obj.Name .. " (" .. obj.ClassName .. ")", path, details, exploitScore)
            end
            
            if #obj:GetChildren() > 0 then
                scanValuesForCritical(obj, path .. "/" .. obj.Name)
            end
        end
    end
    
    scanValuesForCritical(ReplicatedStorage, "ReplicatedStorage")
    scanValuesForCritical(Workspace, "Workspace")
    
    local function scanScriptsForCritical(container, path)
        for _, obj in pairs(container:GetChildren()) do
            if obj:IsA("LocalScript") or obj:IsA("ModuleScript") or obj:IsA("Script") then
                local nameAnalysis = analyzeCriticalValue(obj.Name)
                local severity = "INFO"
                local details = "Script encontrado"
                local exploitScore = 0
                
                if nameAnalysis and nameAnalysis.isCritical then
                    if nameAnalysis.isEncoded then
                        severity = "CRITICAL"
                        details = "SCRIPT CRÍTICO CODIFICADO! (" .. nameAnalysis.criticalType .. ")"
                        exploitScore = nameAnalysis.exploitPotential + 40
                    elseif nameAnalysis.vulnerabilityScore > 30 then
                        severity = "WARNING"
                        details = "Script suspeito (" .. nameAnalysis.criticalType .. ")"
                        exploitScore = nameAnalysis.exploitPotential + 25
                    end
                end
                
                local success, source = pcall(function()
                    return obj.Source
                end)
                
                if success and source and source ~= "" then
                    local codeAnalysis = analyzeCodeForExploits(source)
                    if codeAnalysis and codeAnalysis.vulnerabilityLevel == "CRITICAL" then
                        severity = "CRITICAL"
                        details = "CÓDIGO CRÍTICO detectado! Score: " .. codeAnalysis.exploitScore
                        exploitScore = exploitScore + codeAnalysis.exploitScore
                    elseif codeAnalysis and codeAnalysis.vulnerabilityLevel == "HIGH" then
                        severity = "WARNING"
                        details = "Código com vulnerabilidades. Score: " .. codeAnalysis.exploitScore
                        exploitScore = exploitScore + codeAnalysis.exploitScore
                    end
                end
                
                addCriticalFinding("Critical Script", severity, obj.Name, path, details, exploitScore)
            end
            
            if #obj:GetChildren() > 0 then
                scanScriptsForCritical(obj, path .. "/" .. obj.Name)
            end
        end
    end
    
    scanScriptsForCritical(game, "game")
    
    local globalCount = 0
    for k, v in pairs(_G) do
        globalCount = globalCount + 1
        if globalCount > 80 then break end
        
        local keyStr = tostring(k)
        local valueType = type(v)
        local keyAnalysis = analyzeCriticalValue(keyStr)
        
        local severity = "INFO"
        local details = "Variável global: " .. valueType
        local exploitScore = 0
        
        if keyAnalysis and keyAnalysis.isCritical then
            if keyAnalysis.isEncoded then
                severity = "CRITICAL"
                details = "VARIÁVEL CRÍTICA CODIFICADA! (" .. keyAnalysis.criticalType .. ")"
                exploitScore = keyAnalysis.exploitPotential + 30
            elseif keyAnalysis.vulnerabilityScore > 25 then
                severity = "WARNING"
                details = "Variável suspeita (" .. keyAnalysis.criticalType .. ")"
                exploitScore = keyAnalysis.exploitPotential + 20
            end
        end
        
        addCriticalFinding("Critical Global", severity, keyStr .. " (" .. valueType .. ")", "_G", details, exploitScore)
    end
    
    print("✅ Critical Values Scan completo!")
    print("📊 ESTATÍSTICAS:")
    print("   🔗 Remotes críticos analisados")
    print("   📊 Values críticos analisados")
    print("   📜 Scripts críticos analisados")
    print("   🌐 Variáveis críticas analisadas")
    print("   🚨 Total de vulnerabilidades: " .. #criticalFindings)
    print("   ⚡ Vetores de exploit: " .. #exploitVectors)
    
    return criticalFindings, exploitVectors
end

local function createCriticalGUI(items, vectors)
    local gui = Instance.new("ScreenGui")
    gui.Name = "CriticalValuesScanner"
    gui.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 650, 0, 550)
    frame.Position = UDim2.new(0.5, -325, 0.5, -275)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    frame.BorderSizePixel = 3
    frame.BorderColor3 = Color3.fromRGB(255, 50, 50)
    frame.Parent = gui
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 60)
    title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    title.BorderSizePixel = 0
    title.Text = "🔍 CRITICAL VALUES SCANNER - " .. #items .. " vulnerabilidades"
    title.TextColor3 = Color3.fromRGB(255, 50, 50)
    title.TextSize = 18
    title.Font = Enum.Font.SourceSansBold
    title.Parent = frame
    
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -10, 1, -120)
    scroll.Position = UDim2.new(0, 5, 0, 65)
    scroll.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    scroll.BorderSizePixel = 1
    scroll.BorderColor3 = Color3.fromRGB(80, 80, 80)
    scroll.ScrollBarThickness = 10
    scroll.Parent = frame
    
    local categories = {}
    for _, item in ipairs(items) do
        if not categories[item.category] then
            categories[item.category] = {}
        end
        table.insert(categories[item.category], item)
    end
    
    local yPos = 5
    
    if #vectors > 0 then
        local vectorsHeader = Instance.new("TextLabel")
        vectorsHeader.Size = UDim2.new(1, -10, 0, 35)
        vectorsHeader.Position = UDim2.new(0, 5, 0, yPos)
        vectorsHeader.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        vectorsHeader.BorderSizePixel = 0
        vectorsHeader.Text = "⚡ VETORES DE EXPLOIT ENCONTRADOS (" .. #vectors .. ")"
        vectorsHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
        vectorsHeader.TextSize = 16
        vectorsHeader.Font = Enum.Font.SourceSansBold
        vectorsHeader.TextXAlignment = Enum.TextXAlignment.Left
        vectorsHeader.Parent = scroll
        
        yPos = yPos + 40
        
        for _, vector in ipairs(vectors) do
            local vectorLabel = Instance.new("TextLabel")
            vectorLabel.Size = UDim2.new(1, -20, 0, 30)
            vectorLabel.Position = UDim2.new(0, 15, 0, yPos)
            vectorLabel.BackgroundTransparency = 1
            vectorLabel.Text = "🎯 " .. vector.type .. ": " .. vector.name .. " (" .. vector.criticalType .. ") - Score: " .. vector.exploitScore
            vectorLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
            vectorLabel.TextSize = 14
            vectorLabel.Font = Enum.Font.SourceSans
            vectorLabel.TextXAlignment = Enum.TextXAlignment.Left
            vectorLabel.Parent = scroll
            
            yPos = yPos + 32
        end
        
        yPos = yPos + 15
    end
    
    for category, categoryItems in pairs(categories) do
        local categoryHeader = Instance.new("TextLabel")
        categoryHeader.Size = UDim2.new(1, -10, 0, 35)
        categoryHeader.Position = UDim2.new(0, 5, 0, yPos)
        categoryHeader.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        categoryHeader.BorderSizePixel = 0
        categoryHeader.Text = "📁 " .. category .. " (" .. #categoryItems .. ")"
        categoryHeader.TextColor3 = Color3.fromRGB(200, 200, 255)
        categoryHeader.TextSize = 16
        categoryHeader.Font = Enum.Font.SourceSansBold
        categoryHeader.TextXAlignment = Enum.TextXAlignment.Left
        categoryHeader.Parent = scroll
        
        yPos = yPos + 40
        
        for _, item in ipairs(categoryItems) do
            local itemLabel = Instance.new("TextLabel")
            itemLabel.Size = UDim2.new(1, -20, 0, 30)
            itemLabel.Position = UDim2.new(0, 15, 0, yPos)
            itemLabel.BackgroundTransparency = 1
            
            local colors = {
                CRITICAL = Color3.fromRGB(255, 50, 50),
                WARNING = Color3.fromRGB(255, 150, 50),
                SUSPICIOUS = Color3.fromRGB(255, 255, 50),
                INFO = Color3.fromRGB(200, 200, 200),
                GOOD = Color3.fromRGB(50, 255, 50)
            }
            
            itemLabel.Text = "• " .. item.item .. " - " .. item.details .. " (Score: " .. item.exploitScore .. ")"
            itemLabel.TextColor3 = colors[item.severity] or Color3.fromRGB(255, 255, 255)
            itemLabel.TextSize = 14
            itemLabel.Font = Enum.Font.SourceSans
            itemLabel.TextXAlignment = Enum.TextXAlignment.Left
            itemLabel.Parent = scroll
            
            yPos = yPos + 32
        end
        
        yPos = yPos + 15
    end
    
    scroll.CanvasSize = UDim2.new(0, 0, 0, yPos)
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 120, 0, 35)
    closeBtn.Position = UDim2.new(1, -125, 1, -40)
    closeBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "Fechar"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 14
    closeBtn.Font = Enum.Font.SourceSans
    closeBtn.Parent = frame
    
    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
end

local function runCriticalScan()
    local results, vectors = scanForCriticalVulnerabilities()
    createCriticalGUI(results, vectors)
    
    print("\n🔍 CRITICAL VALUES SCAN RESULTS:")
    print("═══════════════════════════════")
    
    if #vectors > 0 then
        print("⚡ VETORES DE EXPLOIT ENCONTRADOS:")
        for _, vector in ipairs(vectors) do
            print("   🎯 " .. vector.type .. ": " .. vector.name .. " (" .. vector.criticalType .. ") - Score: " .. vector.exploitScore)
        end
        print("")
    end
    
    local criticalFound = false
    local warningFound = false
    
    for _, item in ipairs(results) do
        if item.severity == "CRITICAL" then
            if not criticalFound then
                print("🚨 CRÍTICOS ENCONTRADOS:")
                criticalFound = true
            end
            print("   " .. item.item .. " - " .. item.details .. " (Score: " .. item.exploitScore .. ")")
        elseif item.severity == "WARNING" then
            if not warningFound then
                print("⚠️ AVISOS:")
                warningFound = true
            end
            print("   " .. item.item .. " - " .. item.details .. " (Score: " .. item.exploitScore .. ")")
        end
    end
    
    if not criticalFound and not warningFound then
        print("✅ Nenhuma vulnerabilidade crítica encontrada!")
    end
    
    print("═══════════════════════════════")
end

spawn(function()
    wait(3)
    runCriticalScan()
end)

_G.CriticalScan = runCriticalScan

print("🔍 Critical Values Scanner carregado!")
print("🎯 Focado em detectar brechas em valores críticos!")
print("⚡ Sistema de IA robusto para análise de vulnerabilidades!")
print("💡 Use _G.CriticalScan() para executar manualmente")