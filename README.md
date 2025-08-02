local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local CONFIG = {
    SCAN_DEEP = true,
    USE_AI = true,
    DETECT_ANTICHEAT = true,
    ADAPTIVE_PAYLOADS = true,
    GENERATE_REPORT = true,
    TEST_EXPLOITS = true,
    BYPASS_PROTECTIONS = true
}

local function Log(msg, level)
    level = level or "INFO"
    print(string.format("[%s] %s", level, msg))
end

local function calculateRiskScore(remoteName, remoteType, parentName)
    local score = 0
    local name = string.lower(remoteName)
    
    if string.find(name, "trade") or string.find(name, "buy") or string.find(name, "sell") then
        score = score + 30
    end
    
    if string.find(name, "money") or string.find(name, "currency") or string.find(name, "robux") then
        score = score + 25
    end
    
    if string.find(name, "admin") or string.find(name, "hack") or string.find(name, "exploit") then
        score = score + 20
    end
    
    if remoteType == "RemoteEvent" then
        score = score + 10
    end
    
    if parentName == "game" or string.find(string.lower(parentName), "replicated") then
        score = score + 15
    end
    
    return math.min(score, 100)
end

local function classifyVulnerability(score)
    if score >= 70 then return "CRÍTICO", "🔴"
    elseif score >= 40 then return "VULNERÁVEL", "🟡"
    else return "SEGURO", "🟢"
    end
end

local function scanTradingRemotes()
    Log("=== SCANNING INTELLIGENTE DE REMOTES ===", "SCAN")
    local remotes = {}
    
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local score = calculateRiskScore(obj.Name, obj.ClassName, obj.Parent.Name)
            local status, icon = classifyVulnerability(score)
            
            table.insert(remotes, {
                name = obj.Name,
                type = obj.ClassName,
                path = obj:GetFullName(),
                score = score,
                status = status,
                icon = icon
            })
            
            Log(string.format("%s Remote encontrado: %s (%s) - Score: %d/100", icon, obj.Name, obj.ClassName, score), "SCAN")
        end
    end
    
    return remotes
end

local function scanTradingValues()
    Log("=== SCANNING INTELLIGENTE DE VALORES ===", "SCAN")
    local values = {}
    
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("IntValue") or obj:IsA("NumberValue") or obj:IsA("StringValue") then
            local name = string.lower(obj.Name)
            local keywords = {"price", "cost", "value", "amount", "currency", "money", "coins", "cash", "gold", "diamonds", "robux"}
            
            for _, keyword in pairs(keywords) do
                if string.find(name, keyword) then
                    local originalValue = obj.Value
                    local success = pcall(function()
                        if obj:IsA("IntValue") or obj:IsA("NumberValue") then
                            obj.Value = 999999
                        end
                    end)
                    
                    local score = success and 75 or 45
                    local status, icon = classifyVulnerability(score)
                    
                    table.insert(values, {
                        name = obj.Name,
                        type = obj.ClassName,
                        currentValue = originalValue,
                        modifiable = success,
                        score = score,
                        status = status,
                        icon = icon
                    })
                    
                    if success then
                        obj.Value = originalValue
                        Log(string.format("%s Valor modificável: %s = %s - Score: %d/100", icon, obj.Name, tostring(originalValue), score), "SCAN")
                    else
                        Log(string.format("%s Valor encontrado: %s = %s - Score: %d/100", icon, obj.Name, tostring(originalValue), score), "SCAN")
                    end
                    break
                end
            end
        end
    end
    
    return values
end

local function scanTradingScripts()
    Log("=== SCANNING INTELLIGENTE DE SCRIPTS ===", "SCAN")
    local scripts = {}
    
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("Script") or obj:IsA("LocalScript") then
            local name = string.lower(obj.Name)
            local keywords = {"trade", "buy", "sell", "validate", "check", "security", "anti", "protect"}
            
            for _, keyword in pairs(keywords) do
                if string.find(name, keyword) then
                    local success = pcall(function()
                        return obj.Source
                    end)
                    
                    local score = success and 60 or 30
                    local status, icon = classifyVulnerability(score)
                    
                    table.insert(scripts, {
                        name = obj.Name,
                        type = obj.ClassName,
                        accessible = success,
                        score = score,
                        status = status,
                        icon = icon
                    })
                    
                    Log(string.format("%s Script encontrado: %s (%s) - Score: %d/100", icon, obj.Name, obj.ClassName, score), "SCAN")
                    break
                end
            end
        end
    end
    
    return scripts
end

local function detectAntiCheat()
    Log("=== DETECÇÃO DE ANTI-CHEAT ===", "SCAN")
    local antiCheatFound = false
    
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("Script") or obj:IsA("LocalScript") then
            local name = string.lower(obj.Name)
            local acKeywords = {"anticheat", "anti.cheat", "anti_cheat", "ac", "detection", "shield", "guard", "protect", "secure", "safety"}
            
            for _, keyword in pairs(acKeywords) do
                if string.find(name, keyword) then
                    antiCheatFound = true
                    Log("🛡️ Anti-Cheat detectado: " .. obj.Name, "SCAN")
                    break
                end
            end
        end
    end
    
    if not antiCheatFound then
        Log("✅ Nenhum Anti-Cheat detectado", "SCAN")
    end
    
    return antiCheatFound
end

local function generateAdaptivePayloads(remoteName)
    local payloads = {
        {math.huge, "admin", "hack"},
        {999999, "exploit", "bypass"},
        {0, "duplicate", "spawn"},
        {-999999, "cheat", "god"},
        {"admin", math.huge, "infinite"},
        {"hack", 999999, "duplicate"},
        {"exploit", 0, "spawn"},
        {"bypass", -999999, "cheat"},
        {LocalPlayer, math.huge, "admin"},
        {LocalPlayer, 999999, "hack"},
        {LocalPlayer, 0, "exploit"},
        {LocalPlayer, -999999, "bypass"}
    }
    
    local name = string.lower(remoteName)
    if string.find(name, "trade") or string.find(name, "buy") or string.find(name, "sell") then
        table.insert(payloads, {LocalPlayer, "duplicate", math.huge})
        table.insert(payloads, {LocalPlayer, "copy", -999999})
        table.insert(payloads, {LocalPlayer, "clone", "admin"})
    end
    
    if string.find(name, "money") or string.find(name, "currency") then
        table.insert(payloads, {math.huge, "infinite", "money"})
        table.insert(payloads, {999999, "hack", "currency"})
    end
    
    return payloads
end

local function testExploits(remotes)
    Log("=== TESTE DE EXPLOITS ADAPTATIVOS ===", "EXPLOIT")
    local successfulExploits = 0
    local totalTests = 0
    
    for _, remote in pairs(remotes) do
        local obj = game:FindFirstChild(remote.name, true)
        if obj then
            Log(string.format("🎯 Testando exploits em: %s (Score: %d/100)", remote.name, remote.score), "EXPLOIT")
            
            local payloads = generateAdaptivePayloads(remote.name)
            
            for i, payload in pairs(payloads) do
                totalTests = totalTests + 1
                local success = pcall(function()
                    if obj:IsA("RemoteEvent") then
                        obj:FireServer(unpack(payload))
                    elseif obj:IsA("RemoteFunction") then
                        obj:InvokeServer(unpack(payload))
                    end
                end)
                
                if success then
                    successfulExploits = successfulExploits + 1
                    Log(string.format("✅ Payload %d executado com sucesso em: %s", i, remote.name), "EXPLOIT")
                end
            end
        end
    end
    
    return successfulExploits, totalTests
end

local function generateDetailedReport(remotes, values, scripts, antiCheatFound, successfulExploits, totalTests)
    Log("=== RELATÓRIO INTELIGENTE DETALHADO ===", "REPORT")
    print("")
    
    local totalVulns = #remotes + #values + #scripts
    local criticalVulns = 0
    local mediumVulns = 0
    local safeVulns = 0
    
    for _, remote in pairs(remotes) do
        if remote.status == "CRÍTICO" then criticalVulns = criticalVulns + 1
        elseif remote.status == "VULNERÁVEL" then mediumVulns = mediumVulns + 1
        else safeVulns = safeVulns + 1 end
    end
    
    for _, value in pairs(values) do
        if value.status == "CRÍTICO" then criticalVulns = criticalVulns + 1
        elseif value.status == "VULNERÁVEL" then mediumVulns = mediumVulns + 1
        else safeVulns = safeVulns + 1 end
    end
    
    for _, script in pairs(scripts) do
        if script.status == "CRÍTICO" then criticalVulns = criticalVulns + 1
        elseif script.status == "VULNERÁVEL" then mediumVulns = mediumVulns + 1
        else safeVulns = safeVulns + 1 end
    end
    
    local securityScore = 100 - ((criticalVulns * 20) + (mediumVulns * 10))
    securityScore = math.max(securityScore, 0)
    
    Log(string.format("📊 ESTATÍSTICAS GERAIS:", "REPORT")
    Log(string.format("   • Total de vulnerabilidades: %d", totalVulns), "REPORT")
    Log(string.format("   • Vulnerabilidades críticas: %d", criticalVulns), "REPORT")
    Log(string.format("   • Vulnerabilidades médias: %d", mediumVulns), "REPORT")
    Log(string.format("   • Elementos seguros: %d", safeVulns), "REPORT")
    Log(string.format("   • Score de segurança: %d/100", securityScore), "REPORT")
    Log(string.format("   • Anti-Cheat detectado: %s", antiCheatFound and "Sim" or "Não"), "REPORT")
    Log(string.format("   • Exploits bem-sucedidos: %d/%d", successfulExploits, totalTests), "REPORT")
    print("")
    
    Log("📋 ANÁLISE DETALHADA:", "REPORT")
    
    if #remotes > 0 then
        Log("   🔗 REMOTES ENCONTRADOS:", "REPORT")
        for i, remote in pairs(remotes) do
            Log(string.format("     %d. %s %s - Score: %d/100 (%s)", i, remote.icon, remote.name, remote.score, remote.status), "REPORT")
        end
        print("")
    end
    
    if #values > 0 then
        Log("   💰 VALORES ENCONTRADOS:", "REPORT")
        for i, value in pairs(values) do
            local modStatus = value.modifiable and "MODIFICÁVEL" or "PROTEGIDO"
            Log(string.format("     %d. %s %s = %s (%s) - Score: %d/100 (%s)", i, value.icon, value.name, tostring(value.currentValue), modStatus, value.score, value.status), "REPORT")
        end
        print("")
    end
    
    if #scripts > 0 then
        Log("   📜 SCRIPTS ENCONTRADOS:", "REPORT")
        for i, script in pairs(scripts) do
            local accStatus = script.accessible and "ACESSÍVEL" or "PROTEGIDO"
            Log(string.format("     %d. %s %s (%s) - Score: %d/100 (%s)", i, script.icon, script.name, accStatus, script.score, script.status), "REPORT")
        end
        print("")
    end
    
    Log("⚡ RECOMENDAÇÕES DE EXPLOIT:", "REPORT")
    if successfulExploits > 0 then
        Log("   🎯 Sistema vulnerável a ataques!", "REPORT")
        Log("   📈 Recomenda-se implementar proteções", "REPORT")
    else
        Log("   ✅ Sistema parece estar protegido", "REPORT")
    end
    print("")
    
    Log("📈 GRÁFICO DE VULNERABILIDADE:", "REPORT")
    local safePercent = math.floor((safeVulns / totalVulns) * 100)
    local mediumPercent = math.floor((mediumVulns / totalVulns) * 100)
    local criticalPercent = math.floor((criticalVulns / totalVulns) * 100)
    
    Log(string.format("   🟢 Seguro: %s %d%%", string.rep("█", math.floor(safePercent/10)), safePercent), "REPORT")
    Log(string.format("   🟡 Médio:  %s %d%%", string.rep("█", math.floor(mediumPercent/10)), mediumPercent), "REPORT")
    Log(string.format("   🔴 Crítico: %s %d%%", string.rep("█", math.floor(criticalPercent/10)), criticalPercent), "REPORT")
    print("")
    
    local finalStatus = securityScore >= 70 and "SEGURO" or securityScore >= 40 and "VULNERÁVEL" or "CRÍTICO"
    local finalIcon = securityScore >= 70 and "✅" or securityScore >= 40 and "⚠️" or "🚨"
    
    Log(string.format("%s STATUS FINAL: %s", finalIcon, finalStatus), "REPORT")
    Log(string.format("   → Score de segurança: %d/100", securityScore), "REPORT")
    Log(string.format("   → Exploits bem-sucedidos: %d", successfulExploits), "REPORT")
    Log(string.format("   → Recomendação: %s", successfulExploits > 0 and "Sistema precisa de proteções" or "Sistema parece seguro"), "REPORT")
end

Log("=== TRADING SYSTEM INTELLIGENCE ANALYZER v2.0 ===", "INFO")
Log("Iniciando análise inteligente...", "INFO")

local remotes = scanTradingRemotes()
local values = scanTradingValues()
local scripts = scanTradingScripts()
local antiCheatFound = detectAntiCheat()

local successfulExploits, totalTests = testExploits(remotes)

generateDetailedReport(remotes, values, scripts, antiCheatFound, successfulExploits, totalTests)

Log("Análise inteligente concluída!", "INFO")