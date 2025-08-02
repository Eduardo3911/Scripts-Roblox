local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function Log(msg, level)
    level = level or "INFO"
    print(string.format("[%s] %s", level, msg))
end

local function scanRemotes()
    Log("=== SCANNING REMOTES ===", "SCAN")
    local remotes = {}
    
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local name = string.lower(obj.Name)
            local keywords = {"trade", "buy", "sell", "money", "currency", "robux", "shop", "store", "market"}
            
            for _, keyword in pairs(keywords) do
                if string.find(name, keyword) then
                    table.insert(remotes, {
                        name = obj.Name,
                        type = obj.ClassName,
                        path = obj:GetFullName()
                    })
                    Log("🔍 Remote encontrado: " .. obj.Name, "SCAN")
                    break
                end
            end
        end
    end
    
    return remotes
end

local function scanValues()
    Log("=== SCANNING VALORES ===", "SCAN")
    local values = {}
    
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("IntValue") or obj:IsA("NumberValue") then
            local name = string.lower(obj.Name)
            local keywords = {"price", "cost", "value", "amount", "currency", "money", "coins", "cash", "gold", "diamonds", "robux"}
            
            for _, keyword in pairs(keywords) do
                if string.find(name, keyword) then
                    local original = obj.Value
                    local success = pcall(function() obj.Value = 999999 end)
                    
                    if success then
                        obj.Value = original
                        table.insert(values, {
                            name = obj.Name,
                            value = original,
                            modifiable = true
                        })
                        Log("💰 Valor modificável: " .. obj.Name .. " = " .. original, "SCAN")
                    else
                        table.insert(values, {
                            name = obj.Name,
                            value = original,
                            modifiable = false
                        })
                        Log("💰 Valor encontrado: " .. obj.Name .. " = " .. original, "SCAN")
                    end
                    break
                end
            end
        end
    end
    
    return values
end

local function testExploits(remotes)
    Log("=== TESTANDO EXPLOITS ===", "EXPLOIT")
    local successful = 0
    
    for _, remote in pairs(remotes) do
        local obj = game:FindFirstChild(remote.name, true)
        if obj then
            Log("🎯 Testando: " .. remote.name, "EXPLOIT")
            
            local payloads = {
                {math.huge, "admin", "hack"},
                {999999, "exploit", "bypass"},
                {0, "duplicate", "spawn"},
                {-999999, "cheat", "god"},
                {"admin", math.huge, "infinite"},
                {"hack", 999999, "duplicate"},
                {"exploit", 0, "spawn"},
                {"bypass", -999999, "cheat"}
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
                    successful = successful + 1
                    Log("✅ Payload " .. i .. " executado em: " .. remote.name, "EXPLOIT")
                end
            end
        end
    end
    
    return successful
end

local function generateReport(remotes, values, successfulExploits)
    Log("=== RELATÓRIO FINAL ===", "REPORT")
    print("")
    
    Log("📊 ESTATÍSTICAS:", "REPORT")
    Log("   • Remotes encontrados: " .. #remotes, "REPORT")
    Log("   • Valores encontrados: " .. #values, "REPORT")
    Log("   • Exploits bem-sucedidos: " .. successfulExploits, "REPORT")
    print("")
    
    if #remotes > 0 then
        Log("🔗 REMOTES ENCONTRADOS:", "REPORT")
        for i, remote in pairs(remotes) do
            Log("   " .. i .. ". " .. remote.name .. " (" .. remote.type .. ")", "REPORT")
        end
        print("")
    end
    
    if #values > 0 then
        Log("💰 VALORES ENCONTRADOS:", "REPORT")
        for i, value in pairs(values) do
            local status = value.modifiable and "MODIFICÁVEL" or "PROTEGIDO"
            Log("   " .. i .. ". " .. value.name .. " = " .. value.value .. " (" .. status .. ")", "REPORT")
        end
        print("")
    end
    
    if successfulExploits > 0 then
        Log("🚨 SISTEMA VULNERÁVEL: " .. successfulExploits .. " exploits funcionaram!", "CRITICAL")
    else
        Log("✅ SISTEMA PROTEGIDO: Nenhum exploit funcionou", "SAFE")
    end
end

Log("Trading System Analyzer carregado!", "INFO")
local remotes = scanRemotes()
local values = scanValues()
local successfulExploits = testExploits(remotes)
generateReport(remotes, values, successfulExploits)
Log("Análise concluída!", "INFO")