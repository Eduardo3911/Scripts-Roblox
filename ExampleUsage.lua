--[[
    Exemplos de Uso - Roblox Vulnerability Scanner & Exploit Tool
    Demonstrações práticas de como usar o script
]]

-- Exemplo 1: Uso básico do script principal
local function BasicUsage()
    print("=== EXEMPLO 1: USO BÁSICO ===")
    
    -- Carregar o script principal
    local exploit = loadstring(game:HttpGet("URL_DO_ROBLOXEXPLOIT"))()
    
    -- Executar scan completo
    local vulnerabilities = exploit.Scanner:RunFullScan()
    
    -- Aplicar exploits baseado nas vulnerabilidades encontradas
    exploit.Scanner:AutoExploit(vulnerabilities)
    
    print("✅ Uso básico concluído!")
end

-- Exemplo 2: Uso avançado com todos os módulos
local function AdvancedUsage()
    print("=== EXEMPLO 2: USO AVANÇADO ===")
    
    -- Carregar todos os módulos
    local mainExploit = loadstring(game:HttpGet("URL_DO_ROBLOXEXPLOIT"))()
    local advancedExploits = loadstring(game:HttpGet("URL_DO_ADVANCED"))()
    local antiCheatBypass = loadstring(game:HttpGet("URL_DO_BYPASS"))()
    
    -- Aplicar bypasses primeiro
    antiCheatBypass:ApplyAllBypasses()
    
    -- Executar scan
    local vulns = mainExploit.Scanner:RunFullScan()
    
    -- Executar exploits avançados
    advancedExploits:ExecuteAll()
    
    print("✅ Uso avançado concluído!")
end

-- Exemplo 3: Uso com interface unificada
local function UnifiedUsage()
    print("=== EXEMPLO 3: INTERFACE UNIFICADA ===")
    
    -- Carregar interface principal
    local interface = loadstring(game:HttpGet("URL_DO_MAINLOADER"))()
    
    -- Executar tudo automaticamente
    interface:RunEverything()
    
    print("✅ Interface unificada concluída!")
end

-- Exemplo 4: Exploits específicos para jogos de luta
local function FightingGameExploits()
    print("=== EXEMPLO 4: EXPLOITS PARA JOGOS DE LUTA ===")
    
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local character = LocalPlayer.Character
    
    if not character then
        print("❌ Personagem não encontrado!")
        return
    end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then
        print("❌ Humanoid não encontrado!")
        return
    end
    
    -- Speed hack para combate
    humanoid.WalkSpeed = 50
    humanoid.JumpPower = 100
    
    -- Procurar por sistema de stamina
    for _, obj in pairs(character:GetDescendants()) do
        if string.find(string.lower(obj.Name), "stamina") then
            if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                obj.Value = obj.MaxValue or 100
                print("✅ Stamina infinita ativada!")
            end
        end
    end
    
    -- Procurar por sistema de cooldown de habilidades
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("Script") and string.find(string.lower(obj.Name), "ability") then
            for _, child in pairs(obj:GetDescendants()) do
                if child:IsA("NumberValue") and string.find(string.lower(child.Name), "cooldown") then
                    child.Value = 0
                    print("✅ Cooldown removido: " .. obj.Name)
                end
            end
        end
    end
    
    print("✅ Exploits de jogo de luta aplicados!")
end

-- Exemplo 5: Detecção e bypass de anti-cheat
local function AntiCheatExample()
    print("=== EXEMPLO 5: BYPASS DE ANTI-CHEAT ===")
    
    local antiCheatBypass = loadstring(game:HttpGet("URL_DO_BYPASS"))()
    
    -- Detectar anti-cheat
    local detectedAC = antiCheatBypass:DetectAntiCheat()
    
    if #detectedAC > 0 then
        print("⚠️ Anti-Cheat detectado!")
        for _, ac in pairs(detectedAC) do
            print("  - " .. ac.name .. " em " .. ac.path)
        end
        
        -- Aplicar bypasses
        antiCheatBypass:ApplyAllBypasses()
        print("✅ Bypasses aplicados!")
    else
        print("✅ Nenhum Anti-Cheat detectado")
    end
end

-- Exemplo 6: Exploits de networking
local function NetworkingExploits()
    print("=== EXEMPLO 6: EXPLOITS DE NETWORKING ===")
    
    -- Procurar por remotes expostos
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            print("🔍 Remote encontrado: " .. obj.Name)
            
            -- Tentar executar remote
            local success, result = pcall(function()
                if obj:IsA("RemoteEvent") then
                    return obj:FireServer("test", "exploit")
                elseif obj:IsA("RemoteFunction") then
                    return obj:InvokeServer("test", "exploit")
                end
            end)
            
            if success then
                print("✅ Remote executado com sucesso: " .. obj.Name)
            else
                print("❌ Falha ao executar remote: " .. obj.Name)
            end
        end
    end
end

-- Exemplo 7: Exploits de interface
local function UIExploits()
    print("=== EXEMPLO 7: EXPLOITS DE INTERFACE ===")
    
    -- Modificar interface do jogo
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("ScreenGui") or obj:IsA("GuiObject") then
            if string.find(string.lower(obj.Name), "health") or
               string.find(string.lower(obj.Name), "damage") or
               string.find(string.lower(obj.Name), "score") then
                
                if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                    obj.Text = "999999"
                    print("✅ Interface modificada: " .. obj.Name)
                end
            end
        end
    end
end

-- Exemplo 8: Comandos rápidos
local function QuickCommandsExample()
    print("=== EXEMPLO 8: COMANDOS RÁPIDOS ===")
    
    -- Carregar interface
    local interface = loadstring(game:HttpGet("URL_DO_MAINLOADER"))()
    
    -- Usar comandos rápidos
    _G.QuickCommands.Scan()      -- Scan completo
    _G.QuickCommands.Basic()     -- Exploits básicos
    _G.QuickCommands.Advanced()  -- Exploits avançados
    _G.QuickCommands.Bypass()    -- Bypass anti-cheat
    _G.QuickCommands.All()       -- Executar tudo
    _G.QuickCommands.Menu()      -- Mostrar menu
    
    print("✅ Comandos rápidos executados!")
end

-- Função principal para executar todos os exemplos
local function RunAllExamples()
    print("=== EXECUTANDO TODOS OS EXEMPLOS ===")
    
    -- Executar exemplos em sequência
    BasicUsage()
    wait(1)
    
    AdvancedUsage()
    wait(1)
    
    UnifiedUsage()
    wait(1)
    
    FightingGameExploits()
    wait(1)
    
    AntiCheatExample()
    wait(1)
    
    NetworkingExploits()
    wait(1)
    
    UIExploits()
    wait(1)
    
    QuickCommandsExample()
    
    print("✅ Todos os exemplos executados!")
end

-- Expor funções globalmente
_G.Examples = {
    Basic = BasicUsage,
    Advanced = AdvancedUsage,
    Unified = UnifiedUsage,
    Fighting = FightingGameExploits,
    AntiCheat = AntiCheatExample,
    Networking = NetworkingExploits,
    UI = UIExploits,
    Quick = QuickCommandsExample,
    All = RunAllExamples
}

print("=== EXEMPLOS DE USO CARREGADOS ===")
print("Use Examples.All() para executar todos os exemplos")
print("Use Examples.Basic() para exemplo básico")
print("Use Examples.Advanced() para exemplo avançado")
print("Use Examples.Fighting() para exploits de jogo de luta")

return _G.Examples