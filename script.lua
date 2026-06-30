-- (Creator = Thanh Phuc)
-- 💟 Thanh Phuc - Boombox Thần Thánh V3 (Bẻ Khóa Mọi Bộ Lọc Game - Hiện 100%) 💟
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
    DestroyOldBoombox() -- Dọn sạch đồ cũ trước
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local torso = character:WaitForChild("UpperTorso", 2) or character:WaitForChild("Torso", 2)
    if not torso then return end
    
    -- THUẬT TOÁN MỚI: Đưa hẳn khối hộp vào Workspace nhưng neo giữ vị trí độc lập (Anchored = true)
    BoomboxPart = Instance.new("Part")
    BoomboxPart.Name = "ThanhPhucSuperBoombox"
    BoomboxPart.Size = Vector3.new(2.4, 1.3, 0.8)
    BoomboxPart.Color = Color3.fromRGB(15, 15, 15) -- Thân đen huyền bí
    BoomboxPart.Material = Enum.Material.SmoothPlastic
    BoomboxPart.CanCollide = false
    BoomboxPart.Anchored = true -- Không cần dùng Weld để tránh bị game xóa
    BoomboxPart.CastShadow = false
    BoomboxPart.Parent = workspace -- Ép buộc render trong không gian thế giới
    
    -- Tạo viền LED cầu vồng chạy quanh khối hộp
    LedOutline = Instance.new("SelectionBox")
    LedOutline.Name = "RGB_Outline"
    LedOutline.Adornee = BoomboxPart
    LedOutline.LineThickness = 0.07
    LedOutline.SurfaceTransparency = 1
    LedOutline.Parent = BoomboxPart
    
    -- Tạo bảng tên Thanh Phuc phát sáng phía sau
    local textAttachment = Instance.new("Attachment", BoomboxPart)
    textAttachment.CFrame = CFrame.new(0, 0, 0.42)
    
    local Billboard = Instance.new("BillboardGui")
    Billboard.Size = UDim2.new(0, 200, 0, 50)
    Billboard.AlwaysOnTop = false
    Billboard.Adornee = textAttachment
    Billboard.Parent = BoomboxPart
    
    NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(1, 0, 1, 0)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = "Thanh Phuc"
    NameLabel.Font = Enum.Font.SourceSansBold
    NameLabel.TextSize = 30
    NameLabel.TextColor3 = Color3.new(1, 1, 1)
    NameLabel.Parent = Billboard

    -- THUẬT TOÁN KHÓA VỊ TRÍ THEO KHUNG HÌNH (RenderStepped Loop)
    local hue = 0
    local baseSize = Vector3.new(2.4, 1.3, 0.8)
    
    VisualConnection = RunService.RenderStepped:Connect(function()
        -- Kiểm tra nếu nhân vật chết hoặc bị xóa thì tự hồi sinh lại Boombox
        if not character or not character.Parent or not torso or not torso.Parent then
            DestroyOldBoombox()
            return
        end
        
        -- Nếu Boombox vô tình bị game xóa, hồi sinh nó ngay lập tức
        if not BoomboxPart or not BoomboxPart.Parent then
            CreateCustomBoombox()
            return
        end
        
        -- Khóa chặt tọa độ Boombox vào ngay sau lưng nhân vật (Cập nhật liên tục 60fps+)
        -- CFrame.new(0, 0.2, 0.65) giúp căn chỉnh lùi ra sau lưng vừa vặn, không bị chìm vào người
        BoomboxPart.CFrame = torso.CFrame * CFrame.new(0, 0.2, 0.65)
        
        -- Xử lý Nhịp Bass & Đổi màu Cầu Vồng
        local loudness = Sound1.PlaybackLoudness
        local intensity = math.clamp(loudness / 280, 0, 1.6)
        
        hue = (hue + 0.6 + (intensity * 0.4)) % 360
        local rainbowColor = Color3.fromHSV(hue / 360, 1, 0.4 + (intensity * 0.6))
        
        -- Áp dụng hiệu ứng chớp cầu vồng
        LedOutline.Color3 = rainbowColor
        NameLabel.TextColor3 = rainbowColor
        
        -- Khối hộp đập nhịp to nhỏ theo Bass cực bốc
        BoomboxPart.Size = baseSize * (1 + (intensity * 0.08))
    end)
end

-- Theo dõi trạng thái reset nhân vật để tái kích hoạt
Players.LocalPlayer.CharacterAdded:Connect(function(char)
    if IsPlayingMusic then
        task.wait(0.5)
        CreateCustomBoombox()
    end
end)


-- GIAO DIỆN GUI STYLE RGB ĐỒNG BỘ THEO ẢNH CỦA BẠN (1000056633.jpg)
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
        print("Thanh Phuc Custom Boombox V3 kích hoạt thành công!")
    else
        InputBox.Text = ""
        InputBox.PlaceholderText = "ID không hợp lệ!"
    end
end)
