-[[
    Universal Remote Exploit Tool
    Foco: Explorar TODOS os remotes do jogo
    Versão: 1.0
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function Log(msg, level)
    level = level or "INFO"
    print(string.format("[%s] %s", level, msg))
end

local function universalRemoteExploit()
    Log("=== EXPLOIT UNIVERSAL EM TODOS OS REMOTES ===", "EXPLOIT")
    
    local foundRemotes = 0
    local successfulExploits = 0
    
    -- Procurar TODOS os remotes do jogo
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            foundRemotes = foundRemotes + 1
            Log("🎯 Remote encontrado: " .. obj.Name .. " (" .. obj.ClassName .. ")", "EXPLOIT")
            
            -- Payloads universais
            local universalPayloads = {
                -- Valores extremos
                {math.huge, "admin", "hack"},
                {999999, "exploit", "bypass"},
                {0, "duplicate", "spawn"},
                {-999999, "cheat", "god"},
                
                -- Strings suspeitas
                {"admin", "hack", "exploit"},
                {"bypass", "cheat", "god"},
                {"duplicate", "spawn", "infinite"},
                {"copy", "clone", "create"},
                
                -- Argumentos com jogador
                {LocalPlayer, math.huge, "admin"},
                {LocalPlayer, 999999, "hack"},
                {LocalPlayer, 0, "exploit"},
                {LocalPlayer, -999999, "bypass"},
                
                -- Argumentos inválidos
                {nil, "test", "exploit"},
                {math.huge, nil, "hack"},
                {0, "admin", nil},
                {nil, nil, nil}
            }
            
            for i, payload in pairs(universalPayloads) do
                local success = pcall(function()
                    if obj:IsA("RemoteEvent") then
                        obj:FireServer(unpack(payload))
                    elseif obj:IsA("RemoteFunction") then
                        obj:InvokeServer(unpack(payload))
                    end
                end)
                
                if success then
                    successfulExploits = successfulExploits + 1
                    Log("✅ Payload " .. i .. " executado em: " .. obj.Name, "EXPLOIT")
                end
            end
        end
    end
    
    -- Relatório final
    Log("=== RELATÓRIO FINAL ===", "REPORT")
    Log("Total de remotes encontrados: " .. foundRemotes, "REPORT")
    Log("Total de exploits bem-sucedidos: " .. successfulExploits, "REPORT")
    
    if successfulExploits > 0 then
        Log("🚨 SISTEMA VULNERÁVEL: Exploits funcionaram!", "CRITICAL")
    else
        Log("✅ SISTEMA PROTEGIDO: Nenhum exploit funcionou", "SAFE")
    end
end

-- MAIN
Log("Universal Remote Exploit Tool carregado!", "INFO")
universalRemoteExploit()
Log("Exploit universal finalizado!", "INFO")