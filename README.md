--[[
    Robux Buy System Vulnerability Analyzer
    Foco: Análise de Vulnerabilidades em Sistemas de Compra
    Versão: 1.0
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function Log(msg, level)
    level = level or "INFO"
    print(string.format("[%s] %s", level, msg))
end

-- Análise completa
local function analyzeRobuxSystems()
    Log("=== ANÁLISE DE VULNERABILIDADES DE COMPRA DE ROBUX ===", "ANALYSIS")
    
    local findings = {
        remotes = {},
        values = {},
        exploits = {}
    }
    
    -- Analisar remotes
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local name = string.lower(obj.Name)
            local robuxKeywords = {"robux", "buy", "purchase", "money", "currency", "shop", "store", "market"}
            
            for _, keyword in pairs(robuxKeywords) do
                if string.find(name, keyword) then
                    table.insert(findings.remotes, {
                        name = obj.Name,
                        type = obj.ClassName,
                        path = obj:GetFullName()
                    })
                    break
                end
            end
        end
    end
    
    -- Analisar valores
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("IntValue") or obj:IsA("NumberValue") then
            local name = string.lower(obj.Name)
            if string.find(name, "robux") or string.find(name, "money") or string.find(name, "currency") then
                local original = obj.Value
                local success = pcall(function() obj.Value = 999999 end)
                if success then
                    obj.Value = original
                    table.insert(findings.values, {
                        name = obj.Name,
                        currentValue = original,
                        modifiable = true
                    })
                else
                    table.insert(findings.values, {
                        name = obj.Name,
                        currentValue = original,
                        modifiable = false
                    })
                end
            end
        end
    end
    
    return findings
end

-- Testar exploits
local function testExploits(findings)
    Log("=== TESTANDO EXPLOITS ===", "TEST")
    
    local exploitResults = {}
    
    -- Testar remotes
    for _, remote in pairs(findings.remotes) do
        local obj = game:FindFirstChild(remote.name, true)
        if obj then
            local payloads = {
                {math.huge, "admin"},
                {999999, "hack"},
                {0, "exploit"},
                {-999999, "bypass"}
            }
            
            for i, payload in pairs(payloads) do
                local success = pcall(function()
                    if obj:IsA("RemoteEvent") then
                        obj:FireServer(unpack(payload))
                    elseif obj:IsA("RemoteFunction") then
                        obj:InvokeServer(unpack(payload))
                    end
                end)
                
                if success then
                    table.insert(exploitResults, {
                        type = "REMOTE_EXPLOIT",
                        target = remote.name,
                        payload = i,
                        success = true
                    })
                end
            end
        end
    end
    
    return exploitResults
end

-- Relatório final
local function generateReport(findings, exploits)
    Log("=== RELATÓRIO FINAL DE VULNERABILIDADES ===", "REPORT")
    print("")
    
    -- Resumo
    local totalRemotes = #findings.remotes
    local totalValues = #findings.values
    local modifiableValues = 0
    for _, v in pairs(findings.values) do
        if v.modifiable then modifiableValues = modifiableValues + 1 end
    end
    local successfulExploits = #exploits
    
    Log("📊 ESTATÍSTICAS:", "REPORT")
    Log("   • Remotes de compra encontrados: " .. totalRemotes, "REPORT")
    Log("   • Valores de moeda encontrados: " .. totalValues, "REPORT")
    Log("   • Valores modificáveis: " .. modifiableValues, "REPORT")
    Log("   • Exploits bem-sucedidos: " .. successfulExploits, "REPORT")
    print("")
    
    -- Análise de segurança
    if totalRemotes > 0 then
        Log("⚠️  VULNERABILIDADE DETECTADA: Remotes de compra expostos!", "WARNING")
        Log("   → Possível exploração de sistema de compra", "WARNING")
    end
    
    if modifiableValues > 0 then
        Log("⚠️  VULNERABILIDADE DETECTADA: Valores de moeda modificáveis!", "WARNING")
        Log("   → Possível manipulação de dinheiro/Robux", "WARNING")
    end
    
    if successfulExploits > 0 then
        Log("🚨 CRÍTICO: Exploits funcionaram!", "CRITICAL")
        Log("   → Sistema vulnerável a ataques", "CRITICAL")
    end
    
    if totalRemotes == 0 and modifiableValues == 0 and successfulExploits == 0 then
        Log("✅ SISTEMA SEGURO: Nenhuma vulnerabilidade encontrada", "SAFE")
    end
    
    print("")
    Log("📋 DETALHES:", "REPORT")
    
    if #findings.remotes > 0 then
        Log("   Remotes encontrados:", "REPORT")
        for i, remote in pairs(findings.remotes) do
            Log("     " .. i .. ". " .. remote.name .. " (" .. remote.type .. ")", "REPORT")
        end
    end
    
    if #findings.values > 0 then
        Log("   Valores encontrados:", "REPORT")
        for i, value in pairs(findings.values) do
            local status = value.modifiable and "MODIFICÁVEL" or "PROTEGIDO"
            Log("     " .. i .. ". " .. value.name .. " = " .. value.currentValue .. " (" .. status .. ")", "REPORT")
        end
    end
    
    if #exploits > 0 then
        Log("   Exploits bem-sucedidos:", "REPORT")
        for i, exploit in pairs(exploits) do
            Log("     " .. i .. ". " .. exploit.target .. " (Payload " .. exploit.payload .. ")", "REPORT")
        end
    end
    
    print("")
    Log("🎯 CONCLUSÃO:", "REPORT")
    if successfulExploits > 0 then
        Log("   → SISTEMA VULNERÁVEL: Exploits funcionaram", "CRITICAL")
    elseif totalRemotes > 0 or modifiableValues > 0 then
        Log("   → SISTEMA SUSPEITO: Vulnerabilidades detectadas", "WARNING")
    else
        Log("   → SISTEMA SEGURO: Nenhuma vulnerabilidade", "SAFE")
    end
end

-- MAIN
Log("Analisador de Vulnerabilidades de Compra carregado!", "INFO")
local findings = analyzeRobuxSystems()
local exploits = testExploits(findings)
generateReport(findings, exploits)
Log("Análise concluída!", "INFO")