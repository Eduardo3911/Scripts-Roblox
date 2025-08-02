--[[
    Trading System Exploit Tool (Agressivo)
    Foco: Explorar remotes de troca expostos
    Versão: 1.0
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function Log(msg, level)
    level = level or "INFO"
    print(string.format("[%s] %s", level, msg))
end

local function aggressiveTradingExploit()
    Log("=== EXPLOIT AGRESSIVO EM REMOTES DE TROCA ===", "EXPLOIT")
    
    -- Lista de remotes comuns de troca
    local tradingRemotes = {
        "TradeItem", "TradeRequest", "AcceptTrade", "DeclineTrade",
        "TradeAccept", "TradeDecline", "TradeConfirm", "TradeCancel",
        "ExchangeItem", "TransferItem", "GiveItem", "ReceiveItem",
        "BuyItem", "SellItem", "PurchaseItem", "SellRequest",
        "BuyRequest", "PurchaseRequest", "TradeSystem", "TradingSystem"
    }
    
    for _, remoteName in pairs(tradingRemotes) do
        local remote = game:FindFirstChild(remoteName, true)
        if remote and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
            Log("🎯 Remote de troca encontrado: " .. remote.Name, "EXPLOIT")
            
            -- Payloads agressivos para duplicação e bypass
            local aggressivePayloads = {
                -- Duplicação de itens
                {LocalPlayer, "duplicate", math.huge},
                {LocalPlayer, "copy", -999999},
                {LocalPlayer, "clone", "admin"},
                {LocalPlayer, "spawn", "infinite"},
                {LocalPlayer, "create", "hack"},
                {LocalPlayer, "generate", "exploit"},
                
                -- Bypass de validação
                {"admin", math.huge, "bypass"},
                {"hack", 999999, "cheat"},
                {"exploit", 0, "god"},
                {"bypass", -999999, "admin"},
                
                -- Argumentos inválidos
                {nil, "test", "exploit"},
                {math.huge, nil, "hack"},
                {0, "admin", nil},
                {nil, nil, nil},
                
                -- Strings suspeitas
                {"admin", "hack", "exploit"},
                {"bypass", "cheat", "god"},
                {"duplicate", "spawn", "infinite"},
                {"copy", "clone", "create"}
            }
            
            for i, payload in pairs(aggressivePayloads) do
                local success = pcall(function()
                    if remote:IsA("RemoteEvent") then
                        remote:FireServer(unpack(payload))
                    elseif remote:IsA("RemoteFunction") then
                        remote:InvokeServer(unpack(payload))
                    end
                end)
                
                if success then
                    Log("✅ Payload " .. i .. " executado com sucesso em: " .. remote.Name, "EXPLOIT")
                end
            end
        end
    end
end

-- MAIN
Log("Trading System Exploit Tool (Agressivo) carregado!", "INFO")
aggressiveTradingExploit()
Log("Exploit agressivo finalizado! Veja o console para resultados.", "INFO")