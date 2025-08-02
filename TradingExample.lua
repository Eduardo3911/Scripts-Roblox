--[[
    Exemplos de Uso - Trading Exploit Tool
    Demonstrações práticas de como usar os exploits de trading
]]

-- Exemplo 1: Uso básico do scanner de trading
local function BasicTradingScan()
    print("=== EXEMPLO 1: SCAN BÁSICO DE TRADING ===")
    
    -- Carregar o script de trading
    local tradingExploit = loadstring(game:HttpGet("URL_DO_TRADEREXPLOIT"))()
    
    -- Executar scan completo
    local vulnerabilities = tradingExploit.Scanner:RunFullTradingScan()
    
    -- Aplicar exploits baseado nas vulnerabilidades encontradas
    tradingExploit.Scanner:AutoTradingExploit(vulnerabilities)
    
    print("✅ Scan básico de trading concluído!")
end

-- Exemplo 2: Exploits específicos de trading
local function SpecificTradingExploits()
    print("=== EXEMPLO 2: EXPLOITS ESPECÍFICOS DE TRADING ===")
    
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    -- Procurar por remotes de trading específicos
    local tradingRemotes = {
        "TradeItem", "SellItem", "BuyItem", "ExchangeItem", "TransferItem",
        "GiveItem", "ReceiveItem", "DuplicateItem", "CopyItem", "CloneItem"
    }
    
    for _, remoteName in pairs(tradingRemotes) do
        local remote = game:FindFirstChild(remoteName, true)
        if remote and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
            print("🔍 Remote de trading encontrado: " .. remote.Name)
            
            -- Tentar executar o remote
            local success, result = pcall(function()
                if remote:IsA("RemoteEvent") then
                    return remote:FireServer("test", "exploit", "hack")
                elseif remote:IsA("RemoteFunction") then
                    return remote:InvokeServer("test", "exploit", "hack")
                end
            end)
            
            if success then
                print("✅ Remote executado com sucesso: " .. remote.Name)
            end
        end
    end
    
    print("✅ Exploits específicos de trading concluídos!")
end

-- Exemplo 3: Manipulação de preços
local function PriceManipulationExample()
    print("=== EXEMPLO 3: MANIPULAÇÃO DE PREÇOS ===")
    
    -- Procurar por valores de preço
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("IntValue") or obj:IsA("NumberValue") then
            local name = string.lower(obj.Name)
            
            if string.find(name, "price") or string.find(name, "cost") or string.find(name, "value") then
                print("🔍 Valor de preço encontrado: " .. obj.Name .. " | Valor atual: " .. obj.Value)
                
                local originalValue = obj.Value
                
                -- Tentar modificar o preço
                local success = pcall(function()
                    obj.Value = 0 -- Preço zero
                end)
                
                if success then
                    print("✅ Preço modificado com sucesso: " .. obj.Name .. " | Novo valor: 0")
                end
                
                -- Restaurar valor original
                obj.Value = originalValue
            end
        end
    end
    
    print("✅ Manipulação de preços concluída!")
end

-- Exemplo 4: Manipulação de moeda
local function CurrencyManipulationExample()
    print("=== EXEMPLO 4: MANIPULAÇÃO DE MOEDA ===")
    
    -- Procurar por valores de moeda
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("IntValue") or obj:IsA("NumberValue") then
            local name = string.lower(obj.Name)
            
            local currencyKeywords = {"money", "cash", "coins", "currency", "gold", "diamonds", "robux"}
            
            for _, keyword in pairs(currencyKeywords) do
                if string.find(name, keyword) then
                    print("🔍 Moeda encontrada: " .. obj.Name .. " | Valor atual: " .. obj.Value)
                    
                    local originalValue = obj.Value
                    
                    -- Tentar modificar a moeda
                    local success = pcall(function()
                        obj.Value = math.huge
                    end)
                    
                    if success then
                        print("✅ Moeda modificada com sucesso: " .. obj.Name .. " | Novo valor: infinito")
                    end
                    
                    -- Restaurar valor original
                    obj.Value = originalValue
                    break
                end
            end
        end
    end
    
    print("✅ Manipulação de moeda concluída!")
end

-- Exemplo 5: Duplicação de itens
local function ItemDuplicationExample()
    print("=== EXEMPLO 5: DUPLICAÇÃO DE ITENS ===")
    
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local character = LocalPlayer.Character
    
    if not character then
        print("❌ Personagem não encontrado!")
        return
    end
    
    -- Procurar por inventário
    local inventory = LocalPlayer:FindFirstChild("Backpack")
    if inventory then
        print("🔍 Inventário encontrado")
        
        -- Tentar duplicar itens
        for _, item in pairs(inventory:GetChildren()) do
            print("  - Item: " .. item.Name)
            
            -- Tentar duplicar o item
            local success = pcall(function()
                local clone = item:Clone()
                clone.Parent = inventory
            end)
            
            if success then
                print("✅ Item duplicado: " .. item.Name)
            end
        end
    end
    
    print("✅ Duplicação de itens concluída!")
end

-- Exemplo 6: Bypass de validação
local function ValidationBypassExample()
    print("=== EXEMPLO 6: BYPASS DE VALIDAÇÃO ===")
    
    -- Procurar por scripts de validação
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("Script") or obj:IsA("LocalScript") then
            local name = string.lower(obj.Name)
            
            if string.find(name, "validate") or string.find(name, "check") or string.find(name, "verify") then
                print("🔍 Script de validação encontrado: " .. obj.Name)
                
                -- Tentar desabilitar o script
                local success = pcall(function()
                    obj.Disabled = true
                end)
                
                if success then
                    print("✅ Script de validação desabilitado: " .. obj.Name)
                end
            end
        end
    end
    
    print("✅ Bypass de validação concluído!")
end

-- Exemplo 7: Manipulação de interface
local function UIManipulationExample()
    print("=== EXEMPLO 7: MANIPULAÇÃO DE INTERFACE ===")
    
    -- Procurar por elementos de UI de trading
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("ScreenGui") or obj:IsA("GuiObject") then
            local name = string.lower(obj.Name)
            
            if string.find(name, "trade") or string.find(name, "shop") or string.find(name, "store") then
                print("🔍 UI de trading encontrada: " .. obj.Name)
                
                -- Tentar modificar elementos de texto
                if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                    local originalText = obj.Text
                    
                    -- Modificar texto
                    local success = pcall(function()
                        obj.Text = "0"
                    end)
                    
                    if success then
                        print("✅ UI modificada: " .. obj.Name .. " | Novo texto: 0")
                    end
                    
                    -- Restaurar texto original
                    obj.Text = originalText
                end
            end
        end
    end
    
    print("✅ Manipulação de interface concluída!")
end

-- Exemplo 8: Exploits avançados
local function AdvancedTradingExample()
    print("=== EXEMPLO 8: EXPLOITS AVANÇADOS DE TRADING ===")
    
    -- Carregar exploits avançados
    local advancedTrading = loadstring(game:HttpGet("URL_DO_ADVANCEDTRADING"))()
    
    -- Executar todos os exploits avançados
    advancedTrading:ExecuteAllAdvanced()
    
    print("✅ Exploits avançados de trading concluídos!")
end

-- Função principal para executar todos os exemplos
local function RunAllTradingExamples()
    print("=== EXECUTANDO TODOS OS EXEMPLOS DE TRADING ===")
    
    -- Executar exemplos em sequência
    BasicTradingScan()
    wait(1)
    
    SpecificTradingExploits()
    wait(1)
    
    PriceManipulationExample()
    wait(1)
    
    CurrencyManipulationExample()
    wait(1)
    
    ItemDuplicationExample()
    wait(1)
    
    ValidationBypassExample()
    wait(1)
    
    UIManipulationExample()
    wait(1)
    
    AdvancedTradingExample()
    
    print("✅ Todos os exemplos de trading executados!")
end

-- Expor funções globalmente
_G.TradingExamples = {
    Basic = BasicTradingScan,
    Specific = SpecificTradingExploits,
    Price = PriceManipulationExample,
    Currency = CurrencyManipulationExample,
    Items = ItemDuplicationExample,
    Validation = ValidationBypassExample,
    UI = UIManipulationExample,
    Advanced = AdvancedTradingExample,
    All = RunAllTradingExamples
}

print("=== EXEMPLOS DE TRADING CARREGADOS ===")
print("Use TradingExamples.All() para executar todos os exemplos")
print("Use TradingExamples.Basic() para scan básico")
print("Use TradingExamples.Specific() para exploits específicos")
print("Use TradingExamples.Price() para manipulação de preços")
print("Use TradingExamples.Currency() para manipulação de moeda")
print("Use TradingExamples.Items() para duplicação de itens")
print("Use TradingExamples.Validation() para bypass de validação")
print("Use TradingExamples.UI() para manipulação de interface")
print("Use TradingExamples.Advanced() para exploits avançados")

return _G.TradingExamples