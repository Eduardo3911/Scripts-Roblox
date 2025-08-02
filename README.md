local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function Log(msg, level)
    level = level or "INFO"
    print(string.format("[%s] %s", level, msg))
end

local function exploitSpecificRemotes()
    Log("=== EXPLOIT ESPECÍFICO NOS REMOTES ENCONTRADOS ===", "EXPLOIT")
    
    local specificRemotes = {
        "cost_val", "highest", "exploit", "trade", "buy", "sell", "money", "currency"
    }
    
    for _, remoteName in pairs(specificRemotes) do
        local remote = game:FindFirstChild(remoteName, true)
        if remote and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
            Log("🎯 Remote específico encontrado: " .. remote.Name, "EXPLOIT")
            
            local specificPayloads = {
                {0, "free", "hack"},
                {-100, "negative", "exploit"},
                {math.huge, "infinite", "admin"},
                {999999, "max", "bypass"},
                {math.huge, "admin", "hack"},
                {999999, "exploit", "bypass"},
                {0, "reset", "cheat"},
                {-999999, "negative", "god"},
                {"admin", "hack", "exploit"},
                {"bypass", "cheat", "god"},
                {"duplicate", "spawn", "infinite"},
                {"copy", "clone", "create"},
                {LocalPlayer, math.huge, "admin"},
                {LocalPlayer, 999999, "hack"},
                {LocalPlayer, 0, "exploit"},
                {LocalPlayer, -999999, "bypass"}
            }
            
            for i, payload in pairs(specificPayloads) do
                local success = pcall(function()
                    if remote:IsA("RemoteEvent") then
                        remote:FireServer(unpack(payload))
                    elseif remote:IsA("RemoteFunction") then
                        remote:InvokeServer(unpack(payload))
                    end
                end)
                
                if success then
                    Log("✅ Payload " .. i .. " executado em: " .. remote.Name, "EXPLOIT")
                end
            end
        end
    end
end

Log("Exploit específico para remotes vulneráveis carregado!", "INFO")
exploitSpecificRemotes()
Log("Exploit finalizado!", "INFO")