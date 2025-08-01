-- Script para lançar jogadores para longe com força extrema
-- Para uso em jogo temático: Hackers vs Anti-Hackers

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Configurações do launcher
local LAUNCH_FORCE = 500 -- Força do lançamento (ajuste conforme necessário)
local LAUNCH_HEIGHT = 200 -- Altura adicional do lançamento
local EFFECT_DURATION = 0.5 -- Duração dos efeitos visuais

-- Função para criar efeito visual de "hack"
local function createHackEffect(character)
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Criar partículas de efeito
    local attachment = Instance.new("Attachment")
    attachment.Parent = humanoidRootPart
    
    local particles = Instance.new("ParticleEmitter")
    particles.Parent = attachment
    particles.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    particles.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 255, 255))
    particles.Lifetime = NumberRange.new(0.5, 1.0)
    particles.Rate = 200
    particles.SpreadAngle = Vector2.new(45, 45)
    particles.Speed = NumberRange.new(10, 20)
    
    -- Remover efeito após duração
    game:GetService("Debris"):AddItem(attachment, EFFECT_DURATION)
end

-- Função para lançar um jogador específico
local function launchPlayer(targetPlayer, direction)
    if not targetPlayer.Character then return end
    
    local character = targetPlayer.Character
    local humanoid = character:FindFirstChild("Humanoid")
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not humanoidRootPart then return end
    
    -- Criar efeito visual antes do lançamento
    createHackEffect(character)
    
    -- Calcular direção do lançamento (aleatória se não especificada)
    local launchDirection = direction or Vector3.new(
        math.random(-1, 1),
        1, -- Sempre para cima
        math.random(-1, 1)
    ).Unit
    
    -- Aplicar força de lançamento
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = launchDirection * LAUNCH_FORCE + Vector3.new(0, LAUNCH_HEIGHT, 0)
    bodyVelocity.Parent = humanoidRootPart
    
    -- Remover a força após um tempo para evitar voo infinito
    game:GetService("Debris"):AddItem(bodyVelocity, 2)
    
    -- Desabilitar controles temporariamente para efeito mais dramático
    humanoid.PlatformStand = true
    
    -- Restaurar controles após um tempo
    wait(1)
    if humanoid and humanoid.Parent then
        humanoid.PlatformStand = false
    end
end

-- Função para lançar todos os jogadores (exceto o hacker)
local function launchAllPlayers(hackerPlayer)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= hackerPlayer and player.Character then
            -- Lançar em direção aleatória
            launchPlayer(player)
            wait(0.1) -- Pequeno delay entre lançamentos para efeito visual
        end
    end
end

-- Função para lançar jogadores em uma área específica
local function launchPlayersInArea(centerPosition, radius, excludePlayer)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= excludePlayer and player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local distance = (humanoidRootPart.Position - centerPosition).Magnitude
                if distance <= radius then
                    -- Calcular direção para longe do centro
                    local direction = (humanoidRootPart.Position - centerPosition).Unit
                    launchPlayer(player, direction)
                end
            end
        end
    end
end

-- Função para criar "explosão" que lança jogadores
local function createLaunchExplosion(position, radius, excludePlayer)
    -- Criar efeito visual de explosão
    local explosion = Instance.new("Explosion")
    explosion.Position = position
    explosion.BlastRadius = radius
    explosion.BlastPressure = 0 -- Sem dano, apenas efeito visual
    explosion.Parent = workspace
    
    -- Lançar jogadores na área
    launchPlayersInArea(position, radius, excludePlayer)
end

-- Função principal para ativar o "hack launcher"
local function activateHackLauncher(hackerPlayer)
    if not hackerPlayer.Character then return end
    
    local humanoidRootPart = hackerPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Criar explosão na posição do hacker
    createLaunchExplosion(humanoidRootPart.Position, 50, hackerPlayer)
    
    -- Aguardar um pouco e lançar jogadores restantes
    wait(1)
    launchAllPlayers(hackerPlayer)
end

-- Função para lançar jogador específico por nome
local function launchPlayerByName(playerName, hackerPlayer)
    local targetPlayer = Players:FindFirstChild(playerName)
    if targetPlayer and targetPlayer ~= hackerPlayer then
        launchPlayer(targetPlayer)
        return true
    end
    return false
end

-- Exportar funções para uso em outros scripts
_G.HackLauncher = {
    launchPlayer = launchPlayer,
    launchAllPlayers = launchAllPlayers,
    launchPlayersInArea = launchPlayersInArea,
    createLaunchExplosion = createLaunchExplosion,
    activateHackLauncher = activateHackLauncher,
    launchPlayerByName = launchPlayerByName
}

-- Exemplo de uso:
--[[
-- Para lançar todos os jogadores (exceto o hacker):
_G.HackLauncher.launchAllPlayers(game.Players.LocalPlayer)

-- Para criar explosão que lança jogadores:
_G.HackLauncher.createLaunchExplosion(Vector3.new(0, 10, 0), 30, game.Players.LocalPlayer)

-- Para lançar jogador específico:
_G.HackLauncher.launchPlayerByName("NomeDoJogador", game.Players.LocalPlayer)

-- Para ativar o launcher completo:
_G.HackLauncher.activateHackLauncher(game.Players.LocalPlayer)
--]]

print("🚀 Hack Launcher carregado! Use _G.HackLauncher para acessar as funções.")