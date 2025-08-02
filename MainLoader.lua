--[[
    Main Loader - Roblox Vulnerability Scanner & Exploit Tool
    Carrega todos os módulos e fornece interface unificada
]]

-- Configurações globais
local CONFIG = {
    AUTO_LOAD = true,
    SHOW_MENU = true,
    BYPASS_ANTICHEAT = true,
    ADVANCED_EXPLOITS = true,
    DEBUG_MODE = true
}

-- Função de log unificada
local function Log(message, level)
    level = level or "INFO"
    local timestamp = os.date("%H:%M:%S")
    print(string.format("[%s] [%s] %s", timestamp, level, message))
end

-- Carregar módulos
local function LoadModules()
    Log("=== CARREGANDO MÓDULOS ===", "LOADER")
    
    -- Carregar script principal
    local success, mainModule = pcall(function()
        return loadstring(game:HttpGet("URL_DO_ROBLOXEXPLOIT"))()
    end)
    
    if not success then
        Log("❌ Erro ao carregar módulo principal: " .. tostring(mainModule), "ERROR")
        return false
    end
    
    -- Carregar exploits avançados
    local success2, advancedModule = pcall(function()
        return loadstring(game:HttpGet("URL_DO_ADVANCED"))()
    end)
    
    if not success2 then
        Log("⚠️ Erro ao carregar exploits avançados: " .. tostring(advancedModule), "WARNING")
    end
    
    -- Carregar bypass de anti-cheat
    local success3, bypassModule = pcall(function()
        return loadstring(game:HttpGet("URL_DO_BYPASS"))()
    end)
    
    if not success3 then
        Log("⚠️ Erro ao carregar bypass de anti-cheat: " .. tostring(bypassModule), "WARNING")
    end
    
    -- Expor módulos globalmente
    _G.MainExploit = {
        Main = mainModule,
        Advanced = advancedModule,
        Bypass = bypassModule,
        Config = CONFIG
    }
    
    Log("✅ Módulos carregados com sucesso!", "LOADER")
    return true
end

-- Interface principal
local MainInterface = {}

function MainInterface:ShowMainMenu()
    Log("=== ROBLOX EXPLOIT TOOL - MENU PRINCIPAL ===", "MENU")
    Log("1. Executar scan completo", "MENU")
    Log("2. Executar exploits básicos", "MENU")
    Log("3. Executar exploits avançados", "MENU")
    Log("4. Aplicar bypasses de anti-cheat", "MENU")
    Log("5. Executar tudo automaticamente", "MENU")
    Log("6. Configurações", "MENU")
    Log("7. Sair", "MENU")
end

function MainInterface:RunCompleteScan()
    Log("=== EXECUTANDO SCAN COMPLETO ===", "SCAN")
    
    if _G.MainExploit and _G.MainExploit.Main then
        local vulns = _G.MainExploit.Main.Scanner:RunFullScan()
        return vulns
    else
        Log("❌ Módulo principal não carregado!", "ERROR")
        return {}
    end
end

function MainInterface:RunBasicExploits()
    Log("=== EXECUTANDO EXPLOITS BÁSICOS ===", "EXPLOIT")
    
    if _G.MainExploit and _G.MainExploit.Main then
        _G.MainExploit.Main.Exploit:CharacterSpeedHack()
        _G.MainExploit.Main.Exploit:InfiniteJump()
        _G.MainExploit.Main.Exploit:CombatExploit()
    else
        Log("❌ Módulo principal não carregado!", "ERROR")
    end
end

function MainInterface:RunAdvancedExploits()
    Log("=== EXECUTANDO EXPLOITS AVANÇADOS ===", "EXPLOIT")
    
    if _G.MainExploit and _G.MainExploit.Advanced then
        _G.MainExploit.Advanced:ExecuteAll()
    else
        Log("❌ Módulo avançado não carregado!", "ERROR")
    end
end

function MainInterface:ApplyAntiCheatBypasses()
    Log("=== APLICANDO BYPASSES DE ANTI-CHEAT ===", "BYPASS")
    
    if _G.MainExploit and _G.MainExploit.Bypass then
        _G.MainExploit.Bypass:ApplyAllBypasses()
    else
        Log("❌ Módulo de bypass não carregado!", "ERROR")
    end
end

function MainInterface:RunEverything()
    Log("=== EXECUTANDO TUDO AUTOMATICAMENTE ===", "AUTO")
    
    -- Aplicar bypasses primeiro
    MainInterface:ApplyAntiCheatBypasses()
    
    -- Executar scan
    local vulns = MainInterface:RunCompleteScan()
    
    -- Executar exploits básicos
    MainInterface:RunBasicExploits()
    
    -- Executar exploits avançados
    MainInterface:RunAdvancedExploits()
    
    Log("✅ Tudo executado com sucesso!", "AUTO")
    return vulns
end

function MainInterface:ShowConfig()
    Log("=== CONFIGURAÇÕES ===", "CONFIG")
    for key, value in pairs(CONFIG) do
        Log(string.format("%s: %s", key, tostring(value)), "CONFIG")
    end
end

-- Função de inicialização automática
local function AutoInitialize()
    Log("=== INICIANDO ROBLOX EXPLOIT TOOL ===", "INIT")
    
    -- Carregar módulos
    if not LoadModules() then
        Log("❌ Falha ao carregar módulos!", "ERROR")
        return
    end
    
    -- Aplicar bypasses se configurado
    if CONFIG.BYPASS_ANTICHEAT then
        MainInterface:ApplyAntiCheatBypasses()
    end
    
    -- Executar scan inicial se configurado
    if CONFIG.AUTO_LOAD then
        spawn(function()
            wait(3) -- Aguardar carregamento completo
            Log("Executando scan inicial...", "AUTO")
            MainInterface:RunCompleteScan()
        end)
    end
    
    -- Mostrar menu se configurado
    if CONFIG.SHOW_MENU then
        spawn(function()
            wait(5) -- Aguardar um pouco
            MainInterface:ShowMainMenu()
        end)
    end
    
    Log("✅ Inicialização concluída!", "INIT")
end

-- Expor interface globalmente
_G.MainInterface = MainInterface

-- Auto-inicializar se configurado
if CONFIG.AUTO_LOAD then
    AutoInitialize()
else
    Log("Aguardando inicialização manual...", "INFO")
    Log("Use MainInterface:ShowMainMenu() para ver as opções", "INFO")
end

-- Comandos rápidos
_G.QuickCommands = {
    Scan = function() MainInterface:RunCompleteScan() end,
    Basic = function() MainInterface:RunBasicExploits() end,
    Advanced = function() MainInterface:RunAdvancedExploits() end,
    Bypass = function() MainInterface:ApplyAntiCheatBypasses() end,
    All = function() MainInterface:RunEverything() end,
    Menu = function() MainInterface:ShowMainMenu() end,
    Config = function() MainInterface:ShowConfig() end
}

Log("=== ROBLOX EXPLOIT TOOL CARREGADO ===", "SUCCESS")
Log("Comandos rápidos disponíveis:", "INFO")
Log("  QuickCommands.Scan() - Scan completo", "INFO")
Log("  QuickCommands.Basic() - Exploits básicos", "INFO")
Log("  QuickCommands.Advanced() - Exploits avançados", "INFO")
Log("  QuickCommands.Bypass() - Bypass anti-cheat", "INFO")
Log("  QuickCommands.All() - Executar tudo", "INFO")
Log("  QuickCommands.Menu() - Mostrar menu", "INFO")

return _G.MainInterface