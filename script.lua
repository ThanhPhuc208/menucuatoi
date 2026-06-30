-- (Creator = Thanh Phuc)
-- 💟 Thanh Phuc - Big Square Boombox V5 (In Chữ Trực Tiếp Lên Thân Loa Đen - Chớp Theo Nhạc) 💟
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

-- HỆ THỐNG ÂM THANH KÉP CHỐNG RÈ & BASS ĐẬP ẤM
local SoundGroup = Instance.new("SoundGroup")
SoundGroup.Name = "ThanhPhucAudioGroup"
SoundGroup.Volume = 1.6
SoundGroup.Parent = SoundService

local EQ = Instance.new("EqualizerSoundEffect")
EQ.LowGain = 7.5
EQ.MidGain = 0.5
EQ.HighGain = -3
EQ.Parent = SoundGroup

local Sound1 = Instance.new("Sound")
Sound1.Name = "Channel_Left"
Sound1.Looped = true
Sound1.SoundGroup = SoundGroup
Sound1.Parent = LocalPlayer:WaitForChild("PlayerWorkspace", 5) or workspace

local Sound2 = Instance.new("Sound")
Sound2.Name = "Channel_Right"
Sound2.Looped = true
Sound2.SoundGroup = SoundGroup
Sound2.Parent = Sound1.Parent

-- Quản lý Hệ thống Boombox Khóa Tọa Độ
local BoomboxPart = nil
local LedOutline = nil
local NameLabel = nil
local IsPlayingMusic = false
local VisualConnection = nil

local function DestroyOldBoombox()
    if VisualConnection then VisualConnection:Disconnect() VisualConnection = nil end
    if BoomboxPart then pcall(function() BoomboxPart:Destroy() end) BoomboxPart = nil end
end

local function CreateCustomBoombox()
    DestroyOldBoombox()
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local torso = character:WaitForChild("UpperTorso", 2) or character:WaitForChild("Torso", 2)
    if not torso then return end
    
    -- 1. Thân Loa Khối Vuông Lớn Màu Đen
    BoomboxPart = Instance.new("Part")
    BoomboxPart.Name = "ThanhPhucSuperBoombox"
    BoomboxPart.Size = Vector3.new(2.4, 2.4, 1.8)
    BoomboxPart.Color = Color3.fromRGB(15, 15, 15)
    BoomboxPart.Material = Enum.Material.SmoothPlastic
    BoomboxPart.CanCollide = false
    BoomboxPart.Anchored = true
    BoomboxPart.CastShadow = false
    BoomboxPart.Parent = workspace
    
    -- 2. Viền LED Cầu Vồng bao quanh khối vuông
    LedOutline = Instance.new("SelectionBox")
    LedOutline.Name = "RGB_Outline"
    LedOutline.Adornee = BoomboxPart
    LedOutline.LineThickness = 0.08
    LedOutline.SurfaceTransparency = 1
    LedOutline.Parent = BoomboxPart
    
    -- 3. THUẬT TOÁN IN CHỮ LÊN MẶT LOA ĐEN (Dùng SurfaceGui)
    local SurfaceGui = Instance.new("SurfaceGui")
    SurfaceGui.Name = "ThanhPhucTextDisplay"
    SurfaceGui.Face = Enum.NormalId.Back -- In chữ lên mặt SAU của loa (Mặt quay ra ngoài cho mọi người thấy)
    SurfaceGui.CanvasSize = Vector2.new(400, 400) -- Tạo độ phân giải cho chữ sắc nét
    SurfaceGui.AlwaysOnTop = false -- Tắt cái này đi để chữ dính phẳng hoàn toàn vào khối đen
    SurfaceGui.Parent = BoomboxPart
    
    NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(1, 0, 1, 0)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = "Thanh Phuc"
    NameLabel.Font = Enum.Font.SourceSansBold
    NameLabel.TextSize = 55 -- Kích thước chữ lớn nằm trọn trong mặt loa
    NameLabel.TextColor3 = Color3.new(1, 1, 1)
    NameLabel.TextWrapped = true
    NameLabel.Parent = SurfaceGui

    -- VÒNG LẶP KHÓA VỊ TRÍ VÀ ĐỒNG BỘ HIỆU ỨNG RAINBOW BASS
    local hue = 0
    local baseSize = Vector3.new(2.4, 2.4, 1.8)
    
    VisualConnection = RunService.RenderStepped:Connect(function()
        if not character or not character.Parent or not torso or not torso.Parent then
            DestroyOldBoombox()
            return
        end
        
        if not BoomboxPart or not BoomboxPart.Parent then
            CreateCustomBoombox()
            return
        end
        
        -- Giữ loa dính chặt sau lưng (độ lùi 1.1 block để không bị chìm vào người)
        BoomboxPart.CFrame = torso.CFrame * CFrame.new(0, 0.2, 1.1)
        
        -- Phân tích nhịp nhạc
        local loudness = Sound1.PlaybackLoudness
        local intensity = math.clamp(loudness / 280, 0, 1.6)
        
        -- Chạy màu cầu vồng nhấp nháy theo bass
        hue = (hue + 0.6 + (intensity * 0.4)) % 360
        local rainbowColor = Color3.fromHSV(hue / 360, 1, 0.4 + (intensity * 0.6))
        
        -- Áp dụng màu cầu vồng cho viền và chữ IN TRÊN LOA
        LedOutline.Color3 = rainbowColor
        NameLabel.TextColor3 = rainbowColor
        
        -- Loa to nhỏ giật theo Bass (Chữ in trên loa cũng tự động to nhỏ đồng bộ 100%)
        BoomboxPart.Size = baseSize * (1 + (intensity * 0.07))
    end)
end

-- Tự động đeo lại loa khi hồi sinh
Players.LocalPlayer.CharacterAdded:Connect(function(char)
    if IsPlayingMusic then
        task.wait(0.5)
        CreateCustomBoombox()
    end
end)


-- GIAO DIỆN GUI STYLE RGB ĐỒNG BỘ THEO ẢNH CỦA BẠN (1000056634.jpg)
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 230)
MainFrame.Position = UDim2.new(0.5, -130, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.Draggable = true
MainFrame.Active = true
MainFrame.Visible = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Thickness = 2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

coroutine.wrap(function()
    local h = 0
    while task.wait() do
        h = (h + 1) % 360
        UIStroke.Color = Color3.fromHSV(h/360, 1, 1)
    end
end)()

local HideBtn = Instance.new("TextButton", MainFrame)
HideBtn.Size = UDim2.new(0, 30, 0, 30)
HideBtn.Position = UDim2.new(0.85, 0, 0.05, 0)
HideBtn.Text = "×"
HideBtn.TextSize = 22
HideBtn.TextColor3 = Color3.new(1, 1, 1)
HideBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", HideBtn).CornerRadius = UDim.new(0, 8)
HideBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 55, 0, 55)
OpenBtn.Position = UDim2.new(0, 15, 0.5, 0)
OpenBtn.Text = "TP 🎵"
OpenBtn.Font = Enum.Font.SourceSansBold
OpenBtn.TextSize = 16
OpenBtn.TextColor3 = Color3.new(1, 1, 1)
OpenBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
OpenBtn.Draggable = true
OpenBtn.Active = true
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 15)
local ButtonStroke = Instance.new("UIStroke", OpenBtn)
ButtonStroke.Thickness = 2

coroutine.wrap(function()
    local h = 0
    while task.wait() do
        h = (h + 1.5) % 360
        ButtonStroke.Color = Color3.fromHSV(h/360, 1, 1)
    end
end)()
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true end)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(0.8, 0, 0, 30)
Title.Position = UDim2.new(0.05, 0, 0.05, 0)
Title.Text = "🎵 THANH PHÚC PREMIUM"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

local InputBox = Instance.new("TextBox", MainFrame)
InputBox.Size = UDim2.new(0.9, 0, 0, 40)
InputBox.Position = UDim2.new(0.05, 0, 0.25, 0)
InputBox.PlaceholderText = "Nhập ID nhạc..."
InputBox.Font = Enum.Font.SourceSans
InputBox.TextSize = 16
InputBox.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
InputBox.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", InputBox).CornerRadius = UDim.new(0, 8)

local PlayBtn = Instance.new("TextButton", MainFrame)
PlayBtn.Size = UDim2.new(0.9, 0, 0, 45)
PlayBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
PlayBtn.Text = "PHÁT AUDIO KÉP"
PlayBtn.Font = Enum.Font.SourceSansBold
PlayBtn.TextSize = 16
PlayBtn.TextColor3 = Color3.new(1, 1, 1)
PlayBtn.BackgroundColor3 = Color3.fromRGB(0, 175, 85)
Instance.new("UICorner", PlayBtn).CornerRadius = UDim.new(0, 8)

PlayBtn.MouseButton1Click:Connect(function()
    local cleanID = InputBox.Text:match("%d+")
    if cleanID then
        local assetURI = "rbxassetid://" .. cleanID
        
        Sound1.SoundId = assetURI
        Sound2.SoundId = assetURI
        
        Sound1:Play()
        Sound2:Play()
        
        IsPlayingMusic = true
        CreateCustomBoombox()
        print("Thanh Phuc Boombox V5: Đã in dính chữ lên thân loa thành công!")
    else
        InputBox.Text = ""
        InputBox.PlaceholderText = "ID không hợp lệ!"
    end
end)
