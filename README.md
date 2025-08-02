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
    
  