-- 🚀 ULTIMATE VULNERABILITY SCANNER - ROBLOX 🚀
-- Versão OTIMIZADA para Codex

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local findings = {}
local encodedStrings = {}
local aiPatterns = {}

-- 🧠 AI PATTERN DETECTION SYSTEM
local function initializeAIPatterns()
    aiPatterns = {
        -- Padrões de codificação
        encodings = {
            base64 = "^[A-Za-z0-9+/]+={0,2}$",
            hex = "^[0-9A-Fa-f]+$",
            rot13 = "^[A-Za-z]+$",
            binary = "^[01]+$"
        },
        
        -- Palavras-chave críticas
        criticalKeywords = {
            "admin", "mod", "owner", "god", "hack", "cheat", "exploit", "bypass",
            "money", "cash", "coin", "gem", "diamond", "gold", "currency",
            "speed", "jump", "fly", "noclip", "teleport", "flyhack",
            "health", "damage", "power", "weapon", "kill", "murder",
            "spawn", "respawn", "revive", "heal", "shield", "armor",
            "level", "xp", "experience", "rank", "premium", "vip",
            "script", "execute", "run", "load", "inject", "injection"
        },
        
        -- Padrões de código suspeito
        suspiciousCode = {
            "loadstring", "pcall", "spawn", "wait", "print", "warn", "error",
            "game.Players.LocalPlayer", "game.Workspace", "game.ReplicatedStorage",
            "Instance.new", "GetService", "FireServer", "InvokeServer"
        }
    }
end

-- 🔍 AI STRING ANALYSIS - VERSÃO OTIMIZADA
local function analyzeStringWithAI(str)
    if not str or type(str) ~= "string" then return nil end
    
    local analysis = {
        isEncoded = false,
        encodingType = nil,
        suspiciousScore = 0,
        decodedValue = nil,
        patterns = {}
    }
    
    -- Detectar Base64
    if string.match(str, aiPatterns.encodings.base64) and #str > 8 then
        local success, decoded = pcall(function()
            return HttpService:Base64Decode(str)
        end)
        
        if success then
            analysis.isEncoded = true
            analysis.encodingType = "Base64"
            analysis.suspiciousScore = analysis.suspiciousScore + 40
            
            -- Tentar JSON decode
            local jsonSuccess, jsonDecoded = pcall(function()
                return HttpService:JSONDecode(decoded)
            end)
            
            if jsonSuccess then
                analysis.decodedValue = jsonDecoded
                analysis.suspiciousScore = analysis.suspiciousScore + 60
            else
                analysis.decodedValue = decoded
                analysis.suspiciousScore = analysis.suspiciousScore + 50
            end
        end
    end
    
    -- Detectar Hex
    if string.match(str, aiPatterns.encodings.hex) and #str > 6 and #str % 2 == 0 then
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
            analysis.suspiciousScore = analysis.suspiciousScore + 35
        end
    end
    
    -- Detectar ROT13
    if string.match(str, aiPatterns.encodings.rot13) and #str > 3 then
        local decoded = string.gsub(str, "[A-Za-z]", function(c)
            local byte = string.byte(c)
            if byte >= 65 and byte <= 90 then -- A-Z
                return string.char(((byte - 65 + 13) % 26) + 65)
            elseif byte >= 97 and byte <= 122 then -- a-z
                return string.char(((byte - 97 + 13) % 26) + 97)
            end
            return c
        end)
        
        if decoded ~= str then
            -- Verificar se o resultado faz sentido
            local hasMeaningfulContent = false
            for _, keyword in ipairs(aiPatterns.criticalKeywords) do
                if string.find(string.lower(decoded), keyword) then
                    hasMeaningfulContent = true
                    break
                end
            end
            
            if hasMeaningfulContent or #decoded > 4 then
                analysis.isEncoded = true
                analysis.encodingType = "ROT13"
                analysis.decodedValue = decoded
                analysis.suspiciousScore = analysis.suspiciousScore + 25
            end
        end
    end
    
    -- Detectar palavras críticas
    local lowerStr = string.lower(str)
    for _, keyword in ipairs(aiPatterns.criticalKeywords) do
        if string.find(lowerStr, keyword) then
            table.insert(analysis.patterns, "Critical keyword: " .. keyword)
            analysis.suspiciousScore = analysis.suspiciousScore + 20
        end
    end
    
    -- Detectar padrões suspeitos
    if string.find(lowerStr, "hack") or string.find(lowerStr, "cheat") or 
       string.find(lowerStr, "exploit") or string.find(lowerStr, "bypass") then
        analysis.suspiciousScore = analysis.suspiciousScore + 30
    end
    
    return analysis
end

-- 🧠 AI CODE ANALYSIS - VERSÃO OTIMIZADA
local function analyzeCodeWithAI(source)
    if not source or type(source) ~= "string" then return nil end
    
    local analysis = {
        suspiciousFunctions = {},
        suspiciousScore = 0
    }
    
    -- Detectar funções suspeitas
    for _, funcName in ipairs(aiPatterns.suspiciousCode) do
        local count = select(2, string.gsub(source, funcName, ""))
        if count > 0 then
            table.insert(analysis.suspiciousFunctions, {
                function = funcName,
                count = count
            })
            analysis.suspiciousScore = analysis.suspiciousScore + (count * 15)
        end
    end
    
    -- Detectar exploits específicos
    local exploitPatterns = {
        "game%.Players%.LocalPlayer",
        "game%.Players%.LocalPlayer%.Character",
        "game%.Players%.LocalPlayer%.Backpack",
        "game%.Players%.LocalPlayer%.PlayerGui",
        "game%.Workspace",
        "game%.ReplicatedStorage",
        "game%.Lighting",
        "Instance%.new",
        "GetService",
        "FireServer",
        "InvokeServer"
    }
    
    for _, pattern in ipairs(exploitPatterns) do
        local count = select(2, string.gsub(source, pattern, ""))
        if count > 0 then
            analysis.suspiciousScore = analysis.suspiciousScore + (count * 25)
        end
    end
    
    return analysis
end

-- 🔍 ULTIMATE DEEP SCAN
local function ultimateDeepScan()
    findings = {}
    encodedStrings = {}
    
    print("🚀 Iniciando ULTIMATE VULNERABILITY SCANNER...")
    initializeAIPatterns()
    
    -- 1. SCAN REMOTES COM IA
    print("🧠 Analisando RemoteEvents/Functions...")
    local function scanRemotesWithAI(container, path)
        for _, obj in pairs(container:GetChildren()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                local nameAnalysis = analyzeStringWithAI(obj.Name)
                local severity = "INFO"
                local details = "Remote encontrado"
                
                if nameAnalysis and nameAnalysis.isEncoded then
                    severity = "CRITICAL"
                    details = "Nome CODIFICADO detectado! (" .. nameAnalysis.encodingType .. ")"
                    if nameAnalysis.decodedValue then
                        details = details .. " Decodificado: " .. tostring(nameAnalysis.decodedValue)
                    end
                    table.insert(encodedStrings, {
                        original = obj.Name,
                        decoded = nameAnalysis.decodedValue,
                        type = nameAnalysis.encodingType
                    })
                elseif nameAnalysis and nameAnalysis.suspiciousScore > 25 then
                    severity = "WARNING"
                    details = "Nome SUSPEITO detectado! Score: " .. nameAnalysis.suspiciousScore
                elseif nameAnalysis and nameAnalysis.suspiciousScore > 15 then
                    severity = "SUSPICIOUS"
                    details = "Nome com padrões suspeitos. Score: " .. nameAnalysis.suspiciousScore
                end
                
                addFinding("RemoteEvent", severity, obj.Name, path, details)
            end
            
            if #obj:GetChildren() > 0 then
                scanRemotesWithAI(obj, path .. "/" .. obj.Name)
            end
        end
    end
    
    scanRemotesWithAI(ReplicatedStorage, "ReplicatedStorage")
    scanRemotesWithAI(Workspace, "Workspace")
    
    -- 2. SCAN VALUES COM IA
    print("🧠 Analisando Values...")
    local function scanValuesWithAI(container, path)
        for _, obj in pairs(container:GetChildren()) do
            if obj:IsA("IntValue") or obj:IsA("StringValue") or obj:IsA("NumberValue") or 
               obj:IsA("BoolValue") or obj:IsA("ObjectValue") then
                
                local nameAnalysis = analyzeStringWithAI(obj.Name)
                local valueAnalysis = nil
                
                if obj:IsA("StringValue") then
                    valueAnalysis = analyzeStringWithAI(obj.Value)
                end
                
                local severity = "INFO"
                local details = "Value encontrado"
                
                if nameAnalysis and nameAnalysis.isEncoded then
                    severity = "CRITICAL"
                    details = "Nome CODIFICADO! (" .. nameAnalysis.encodingType .. ")"
                    if nameAnalysis.decodedValue then
                        details = details .. " Decodificado: " .. tostring(nameAnalysis.decodedValue)
                    end
                elseif valueAnalysis and valueAnalysis.isEncoded then
                    severity = "CRITICAL"
                    details = "Valor CODIFICADO! (" .. valueAnalysis.encodingType .. ")"
                    if valueAnalysis.decodedValue then
                        details = details .. " Decodificado: " .. tostring(valueAnalysis.decodedValue)
                    end
                elseif (nameAnalysis and nameAnalysis.suspiciousScore > 20) or 
                       (valueAnalysis and valueAnalysis.suspiciousScore > 20) then
                    severity = "WARNING"
                    details = "Conteúdo SUSPEITO detectado!"
                elseif (nameAnalysis and nameAnalysis.suspiciousScore > 10) or 
                       (valueAnalysis and valueAnalysis.suspiciousScore > 10) then
                    severity = "SUSPICIOUS"
                    details = "Conteúdo com padrões suspeitos."
                end
                
                addFinding("Value", severity, obj.Name .. " (" .. obj.ClassName .. ")", path, details)
            end
            
            if #obj:GetChildren() > 0 then
                scanValuesWithAI(obj, path .. "/" .. obj.Name)
            end
        end
    end
    
    scanValuesWithAI(ReplicatedStorage, "ReplicatedStorage")
    scanValuesWithAI(Workspace, "Workspace")
    
    -- 3. SCAN SCRIPTS COM IA
    print("🧠 Analisando Scripts...")
    local function scanScriptsWithAI(container, path)
        for _, obj in pairs(container:GetChildren()) do
            if obj:IsA("LocalScript") or obj:IsA("ModuleScript") or obj:IsA("Script") then
                local nameAnalysis = analyzeStringWithAI(obj.Name)
                local severity = "INFO"
                local details = "Script encontrado"
                
                if nameAnalysis and nameAnalysis.isEncoded then
                    severity = "CRITICAL"
                    details = "Script com nome CODIFICADO! (" .. nameAnalysis.encodingType .. ")"
                elseif nameAnalysis and nameAnalysis.suspiciousScore > 15 then
                    severity = "WARNING"
                    details = "Script com nome SUSPEITO!"
                elseif nameAnalysis and nameAnalysis.suspiciousScore > 8 then
                    severity = "SUSPICIOUS"
                    details = "Script com padrões suspeitos."
                end
                
                -- Tentar analisar o código fonte
                local success, source = pcall(function()
                    return obj.Source
                end)
                
                if success and source and source ~= "" then
                    local codeAnalysis = analyzeCodeWithAI(source)
                    if codeAnalysis and codeAnalysis.suspiciousScore > 60 then
                        severity = "CRITICAL"
                        details = "CÓDIGO SUSPEITO detectado! Score: " .. codeAnalysis.suspiciousScore
                    elseif codeAnalysis and codeAnalysis.suspiciousScore > 30 then
                        severity = "WARNING"
                        details = "Código com padrões suspeitos. Score: " .. codeAnalysis.suspiciousScore
                    elseif codeAnalysis and codeAnalysis.suspiciousScore > 15 then
                        severity = "SUSPICIOUS"
                        details = "Código com alguns padrões suspeitos. Score: " .. codeAnalysis.suspiciousScore
                    end
                end
                
                addFinding("Script", severity, obj.Name, path, details)
            end
            
            if #obj:GetChildren() > 0 then
                scanScriptsWithAI(obj, path .. "/" .. obj.Name)
            end
        end
    end
    
    scanScriptsWithAI(game, "game")
    
    -- 4. SCAN VARIÁVEIS GLOBAIS
    print("🧠 Analisando variáveis globais...")
    local globalCount = 0
    for k, v in pairs(_G) do
        globalCount = globalCount + 1
        if globalCount > 100 then break end
        
        local keyStr = tostring(k)
        local valueType = type(v)
        local keyAnalysis = analyzeStringWithAI(keyStr)
        
        local severity = "INFO"
        local details = "Variável global: " .. valueType
        
        if keyAnalysis and keyAnalysis.isEncoded then
            severity = "CRITICAL"
            details = "Variável global CODIFICADA! (" .. keyAnalysis.encodingType .. ")"
        elseif keyAnalysis and keyAnalysis.suspiciousScore > 15 then
            severity = "WARNING"
            details = "Variável global SUSPEITA!"
        elseif keyAnalysis and keyAnalysis.suspiciousScore > 8 then
            severity = "SUSPICIOUS"
            details = "Variável global com padrões suspeitos."
        end
        
        addFinding("Global Variable", severity, keyStr .. " (" .. valueType .. ")", "_G", details)
    end
    
    -- 5. VERIFICAR CONFIGURAÇÕES
    print("🧠 Verificando configurações...")
    addFinding("Security", Workspace.FilteringEnabled and "GOOD" or "CRITICAL", 
              "FilteringEnabled: " .. tostring(Workspace.FilteringEnabled), "Workspace", 
              Workspace.FilteringEnabled and "Segurança ativada" or "CRÍTICO: Sem proteção!")
    
    addFinding("Setting", "INFO", "StreamingEnabled: " .. tostring(Workspace.StreamingEnabled), 
              "Workspace", "Configuração de streaming")
    
    local playersService = game:GetService("Players")
    addFinding("Setting", "INFO", "CharacterAutoLoads: " .. tostring(playersService.CharacterAutoLoads), 
              "Players", "Sistema de spawn automático")
    
    -- 6. ANÁLISE DE PADRÕES CODIFICADOS
    if #encodedStrings > 0 then
        addFinding("Encoded Pattern", "CRITICAL", 
                  #encodedStrings .. " strings codificadas encontradas", "AI Analysis", 
                  "Padrões de codificação detectados!")
    end
    
    -- RESULTADOS
    print("✅ ULTIMATE Deep Scan completo!")
    print("📊 ESTATÍSTICAS:")
    print("   🔗 RemoteEvents/Functions analisados")
    print("   📊 Values analisados")
    print("   📜 Scripts analisados")
    print("   🌐 Variáveis globais analisadas")
    print("   🔐 Strings codificadas: " .. #encodedStrings)
    print("   🚨 Total de itens: " .. #findings)
    
    return findings, encodedStrings
end

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

-- 🎨 INTERFACE SIMPLIFICADA
local function createSimpleGUI(items, encodedStrings)
    local gui = Instance.new("ScreenGui")
    gui.Name = "UltimateScanResults"
    gui.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 600, 0, 500)
    frame.Position = UDim2.new(0.5, -300, 0.5, -250)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(255, 100, 100)
    frame.Parent = gui
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    title.BorderSizePixel = 0
    title.Text = "🚀 ULTIMATE SCANNER - " .. #items .. " itens"
    title.TextColor3 = Color3.fromRGB(255, 100, 100)
    title.TextSize = 18
    title.Font = Enum.Font.SourceSansBold
    title.Parent = frame
    
    -- Lista com scroll
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -10, 1, -100)
    scroll.Position = UDim2.new(0, 5, 0, 55)
    scroll.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    scroll.BorderSizePixel = 1
    scroll.BorderColor3 = Color3.fromRGB(80, 80, 80)
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
    
    -- Seção de strings codificadas
    if #encodedStrings > 0 then
        local encodedHeader = Instance.new("TextLabel")
        encodedHeader.Size = UDim2.new(1, -10, 0, 30)
        encodedHeader.Position = UDim2.new(0, 5, 0, yPos)
        encodedHeader.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        encodedHeader.BorderSizePixel = 0
        encodedHeader.Text = "🔐 STRINGS CODIFICADAS (" .. #encodedStrings .. ")"
        encodedHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
        encodedHeader.TextSize = 14
        encodedHeader.Font = Enum.Font.SourceSansBold
        encodedHeader.TextXAlignment = Enum.TextXAlignment.Left
        encodedHeader.Parent = scroll
        
        yPos = yPos + 35
        
        for _, encoded in ipairs(encodedStrings) do
            local encodedLabel = Instance.new("TextLabel")
            encodedLabel.Size = UDim2.new(1, -20, 0, 25)
            encodedLabel.Position = UDim2.new(0, 15, 0, yPos)
            encodedLabel.BackgroundTransparency = 1
            encodedLabel.Text = "🔓 " .. encoded.original .. " → " .. tostring(encoded.decoded) .. " (" .. encoded.type .. ")"
            encodedLabel.TextColor3 = Color3.fromRGB(255, 200, 200)
            encodedLabel.TextSize = 12
            encodedLabel.Font = Enum.Font.SourceSans
            encodedLabel.TextXAlignment = Enum.TextXAlignment.Left
            encodedLabel.Parent = scroll
            
            yPos = yPos + 27
        end
        
        yPos = yPos + 10
    end
    
    -- Categorias normais
    for category, categoryItems in pairs(categories) do
        -- Cabeçalho da categoria
        local categoryHeader = Instance.new("TextLabel")
        categoryHeader.Size = UDim2.new(1, -10, 0, 30)
        categoryHeader.Position = UDim2.new(0, 5, 0