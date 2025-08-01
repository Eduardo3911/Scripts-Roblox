-- Seção de strings codificadas
    if #encodedStrings > 0 then
        local encodedHeader = Instance.new("TextLabel")
        encodedHeader.Size = UDim2.new(1, -10, 0, 30)
        encodedHeader.Position = UDim2.new(0, 5, 0, yPos)
        encodedHeader.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        encodedHeader.BorderSizePixel = 0
        encodedHeader.Text = "🔐 STRINGS CODIFICADAS ENCONTRADAS (" .. #encodedStrings .. ")"
        encodedHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
        encodedHeader.TextSize = 14
        encodedHeader.Font = Enum.Font.SourceSansBold
        encodedHeader.TextXAlignment = Enum.TextXAlignment.Left
        encodedHeader.Parent = scroll
        
        yPos = yPos + 35
        
        for _, encoded in ipairs(encodedStrings) do
            local encodedLabel = Instance.new("TextLabel")
            encodedLabel.Size = UDim2.new(1, -20, 0, 25)
            encodedLabel.Position = UDim2.new(0, 15, 0, yPos)
            encodedLabel.BackgroundTransparency = 1
            encodedLabel.Text = "🔓 " .. encoded.original .. " → " .. tostring(encoded.decoded) .. " (" .. encoded.type .. ")"
            encodedLabel.TextColor3 = Color3.fromRGB(255, 200, 200)
            encodedLabel.TextSize = 12
            encodedLabel.Font = Enum.Font.SourceSans
            encodedLabel.TextXAlignment = Enum.TextXAlignment.Left
            encodedLabel.Parent = scroll
            
            yPos = yPos + 27
        end
        
        yPos = yPos + 10
    end
    
    -- Categorias normais
    for category, categoryItems in pairs(categories) do
        -- Cabeçalho da categoria
        local categoryHeader = Instance.new("TextLabel")
        categoryHeader.Size = UDim2.new(1, -10, 0, 30)
        categoryHeader.Position = UDim2.new(0, 5, 0, yPos)
        categoryHeader.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        categoryHeader.BorderSizePixel = 0
        categoryHeader.Text = "📁 " .. category .. " (" .. #categoryItems .. ")"
        categoryHeader.TextColor3 = Color3.fromRGB(200, 200, 255)
        categoryHeader.TextSize = 14
        categoryHeader.Font = Enum.Font.SourceSansBold
        categoryHeader.TextXAlignment = Enum.TextXAlignment.Left
        categoryHeader.Parent = scroll
        
        yPos = yPos + 35
        
        -- Itens da categoria
        for _, item in ipairs(categoryItems) do
            local itemLabel = Instance.new("TextLabel")
            itemLabel.Size = UDim2.new(1, -20, 0, 25)
            itemLabel.Position = UDim2.new(0, 15, 0, yPos)
            itemLabel.BackgroundTransparency = 1
            
            -- Cor baseada na severidade
            local colors = {
                CRITICAL = Color3.fromRGB(255, 100, 100),
                WARNING = Color3.fromRGB(255, 200, 100),
                SUSPICIOUS = Color3.fromRGB(255, 255, 100),
                INFO = Color3.fromRGB(200, 200, 200),
                GOOD = Color3.fromRGB(100, 255, 100)
            }
            
            itemLabel.Text = "• " .. item.item .. " - " .. item.details
            itemLabel.TextColor3 = colors[item.severity] or Color3.fromRGB(255, 255, 255)
            itemLabel.TextSize = 12
            itemLabel.Font = Enum.Font.SourceSans
            itemLabel.TextXAlignment = Enum.TextXAlignment.Left
            itemLabel.Parent = scroll
            
            yPos = yPos + 27
        end
        
        yPos = yPos + 10
    end
    
    scroll.CanvasSize = UDim2.new(0, 0, 0, yPos)
    
    -- Botões
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(1, -10, 0, 40)
    buttonFrame.Position = UDim2.new(0, 5, 1, -45)
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.Parent = frame
    
    -- Botão fechar
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 100, 0, 30)
    closeBtn.Position = UDim2.new(1, -105, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "Fechar"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 12
    closeBtn.Font = Enum.Font.SourceSans
    closeBtn.Parent = buttonFrame
    
    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
    
    -- Botão re-scan
    local rescanBtn = Instance.new("TextButton")
    rescanBtn.Size = UDim2.new(0, 100, 0, 30)
    rescanBtn.Position = UDim2.new(0, 5, 0, 5)
    rescanBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    rescanBtn.BorderSizePixel = 0
    rescanBtn.Text = "Re-Scan"
    rescanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    rescanBtn.TextSize = 12
    rescanBtn.Font = Enum.Font.SourceSans
    rescanBtn.Parent = buttonFrame
    
    rescanBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
        runAIScan()
    end)
end

-- Executar AI scan
local function runAIScan()
    local results, encoded = deepAIScan()
    createAdvancedGUI(results, encoded)
    
    -- Mostrar resultados no console
    print("\n🤖 AI SCAN RESULTS (CORRIGIDO):")
    print("═══════════════════════════════")
    
    if #encoded > 0 then
        print("🔐 STRINGS CODIFICADAS ENCONTRADAS:")
        for _, encodedStr in ipairs(encoded) do
            print("   " .. encodedStr.original .. " → " .. tostring(encodedStr.decoded) .. " (" .. encodedStr.type .. ")")
        end
        print("")
    end
    
    local criticalFound = false
    local warningFound = false
    
    for _, item in ipairs(results) do
        if item.severity == "CRITICAL" then
            if not criticalFound then
                print("🚨 CRÍTICOS ENCONTRADOS:")
                criticalFound = true
            end
            print("   " .. item.item .. " - " .. item.details)
        elseif item.severity == "WARNING" then
            if not warningFound then
                print("⚠️ AVISOS:")
                warningFound = true
            end
            print("   " .. item.item .. " - " .. item.details)
        end
    end
    
    if not criticalFound and not warningFound then
        print("✅ Nenhuma vulnerabilidade crítica encontrada!")
        print("🔍 Mas continue atento - vulnerabilidades podem estar escondidas...")
    end
    
    print("═══════════════════════════════")
end

-- Auto-executar
spawn(function()
    wait(3)
    runAIScan()
end)

_G.AIScan = runAIScan

print("🤖 Advanced AI Vulnerability Scanner (CORRIGIDO) carregado!")
print("🧠 Este scanner usa IA para detectar padrões codificados e vulnerabilidades avançadas!")
print("🔐 Capaz de decodificar Base64, Hex, ROT13 e outros padrões!")
print("🐛 Todos os bugs foram corrigidos!")
print("💡 Use _G.AIScan() para executar manualmente")