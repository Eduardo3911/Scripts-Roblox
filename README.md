--[[
    Trading System Vulnerability Scanner & Exploit Tool
    Foco: Sistemas de Trading e Economia do Roblox
    Autor: AI Assistant
    Versão: 1.0
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local CONFIG = {
    DEBUG = true,
    AUTO_EXPLOIT = true,
    TARGET_TRADING_SYSTEMS = {"Trade", "Trading", "Market", "Shop", "Store", "Sell", "Buy", "Exchange"}
}

local function Log(msg, level)
    level = level or "INFO"
    print(string.format("[%s] %s", level, msg))
end

local function scanRemotes()
    Log("Scan de remotes de trading...")
    local vulns = {}
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local name = string.lower(obj.Name)
            for _, kw in pairs(CONFIG.TARGET_TRADING_SYSTEMS) do
                if string.find(name, string.lower(kw)) then
                    local info = {
                        name = obj.Name,
                        type = obj.ClassName,
                        path = obj:GetFullName()
                    }
                    table.insert(vulns, {type="TRADING_REMOTE", info=info})
                    Log("Remote de trading encontrado: " .. obj.Name)
                    break
                end
            end
        end
    end
    return vulns
end

local function scanScripts()
    Log("Scan de scripts de trading...")
    local vulns = {}
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("Script") or obj:IsA("LocalScript") then
            local name = string.lower(obj.Name)
            for _, kw in pairs(CONFIG.TARGET_TRADING_SYSTEMS) do
                if string.find(name, string.lower(kw)) then
                    table.insert(vulns, {type="TRADING_SCRIPT", info=obj.Name})
                    Log("Script de trading encontrado: " .. obj.Name)
                    break
                end
            end
        end
    end
    return vulns
end

local function scanValues()
    Log("Scan de valores de trading...")
    local vulns = {}
    local keywords = {"price", "cost", "value", "amount", "currency", "money", "coins", "cash", "gold", "diamonds", "robux"}
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("IntValue") or obj:IsA("NumberValue") or obj:IsA("StringValue") then
            local name = string.lower(obj.Name)
            for _, kw in pairs(keywords) do
                if string.find(name, kw) then
                    local info = {
                        name = obj.Name,
                        value = obj.Value,
                        path = obj:GetFullName()
                    }
                    -- Testa se pode modificar
                    local orig = obj.Value
                    local success = pcall(function() if obj:IsA("IntValue") or obj:IsA("NumberValue") then obj.Value = 999999 end end)
                    if success then
                        obj.Value = orig
                        table.insert(vulns, {type="MODIFIABLE_TRADING_VALUE", info=info})
                        Log("Valor de trading modificável: " .. obj.Name)
                    else
                        table.insert(vulns, {type="TRADING_VALUE", info=info})
                        Log("Valor de trading encontrado: " .. obj.Name)
                    end
                    break
                end
            end
        end
    end
    return vulns
end

local function scanUI()
    Log("Scan de UI de trading...")
    local vulns = {}
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("ScreenGui") or obj:IsA("GuiObject") then
            local name = string.lower(obj.Name)
            for _, kw in pairs(CONFIG.TARGET_TRADING_SYSTEMS) do
                if string.find(name, string.lower(kw)) then
                    table.insert(vulns, {type="TRADING_UI", info=obj.Name})
                    Log("UI de trading encontrada: " .. obj.Name)
                    break
                end
            end
        end
    end
    return vulns
end

local function exploitRemotes()
    Log("Tentando exploits em remotes de trading...", "EXPLOIT")
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local name = string.lower(obj.Name)
            for _, kw in pairs(CONFIG.TARGET_TRADING_SYSTEMS) do
                if string.find(name, string.lower(kw)) then
                    local args = {"exploit", math.huge, -999999, "admin"}
                    pcall(function()
                        if obj:IsA("RemoteEvent") then obj:FireServer(unpack(args))
                        elseif obj:IsA("RemoteFunction") then obj:InvokeServer(unpack(args)) end
                    end)
                    Log("Exploit tentado em: " .. obj.Name, "EXPLOIT")
                    break
                end
            end
        end
    end
end

local function exploitValues()
    Log("Tentando modificar valores de trading...", "EXPLOIT")
    local keywords = {"price", "cost", "value", "amount", "currency", "money", "coins", "cash", "gold", "diamonds", "robux"}
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("IntValue") or obj:IsA("NumberValue") then
            local name = string.lower(obj.Name)
            for _, kw in pairs(keywords) do
                if string.find(name, kw) then
                    local orig = obj.Value
                    pcall(function() obj.Value = 0 end)
                    Log("Valor modificado para 0: " .. obj.Name, "EXPLOIT")
                    obj.Value = orig
                    break
                end
            end
        end
    end
end

local function exploitUI()
    Log("Tentando modificar UI de trading...", "EXPLOIT")
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            local name = string.lower(obj.Name)
            for _, kw in pairs(CONFIG.TARGET_TRADING_SYSTEMS) do
                if string.find(name, string.lower(kw)) then
                    local orig = obj.Text
                    pcall(function() obj.Text = "999999" end)
                    Log("UI modificada: " .. obj.Name, "EXPLOIT")
                    obj.Text = orig
                    break
                end
            end
        end
    end
end

local function exploitScripts()
    Log("Tentando desabilitar scripts de trading...", "EXPLOIT")
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("Script") or obj:IsA("LocalScript") then
            local name = string.lower(obj.Name)
            for _, kw in pairs(CONFIG.TARGET_TRADING_SYSTEMS) do
                if string.find(name, string.lower(kw)) then
                    pcall(function() obj.Disabled = true end)
                    Log("Script desabilitado: " .. obj.Name, "EXPLOIT")
                    break
                end
            end
        end
    end
end

local function report(vulns)
    Log("=== RELATÓRIO DE VULNERABILIDADES DE TRADING ===", "REPORT")
    Log("Total encontradas: " .. tostring(#vulns), "REPORT")
    for i, v in ipairs(vulns) do
        Log(string.format("[%d] %s - %s", i, v.type, v.info and (v.info.name or v.info) or ""), "REPORT")
    end
end

-- MAIN
Log("Trading Exploit Tool carregado!", "INFO")
local allVulns = {}
for _, v in ipairs(scanRemotes()) do table.insert(allVulns, v) end
for _, v in ipairs(scanScripts()) do table.insert(allVulns, v) end
for _, v in ipairs(scanValues()) do table.insert(allVulns, v) end
for _, v in ipairs(scanUI()) do table.insert(allVulns, v) end
report(allVulns)

if CONFIG.AUTO_EXPLOIT then
    exploitRemotes()
    exploitValues()
    exploitUI()
    exploitScripts()
    Log("Auto-exploit de trading finalizado!", "EXPLOIT")
end

Log("Use este script apenas para fins educacionais!", "INFO")