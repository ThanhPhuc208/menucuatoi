-- (Creator = Thanh Phuc)
-- 💟 Thanh Phuc - Boombox Black-RGB Custom (Nháy Theo Nhịp Bass + Khóa Chặt Khi Die) 💟
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

-- HỆ THỐNG ÂM THANH KÉP CHỐNG RÈ & BASS ĐẬP ẤM
local SoundGroup = Instance.new("SoundGroup")
SoundGroup.Name = "ThanhPhucAudioGroup"
SoundGroup.Volume = 1.6 -- Tăng nhẹ volume tổng cho căng tai
SoundGroup.Parent = SoundService

local EQ = Instance.new("EqualizerSoundEffect")
EQ.LowGain = 7.5  -- Bass trầm ấm, lực đập mạnh mẽ
EQ.MidGain = 0.5  -- Giữ âm trung trong trẻo
EQ.HighGain = -3  -- Cắt bớt treble cao để tuyệt đối chống rè
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

-- Quản lý Boombox Độ
local BoomboxPart = nil
local IsPlayingMusic = false

local function CreateCustomBoombox()
    -- Dọn dẹp thiết bị cũ tránh trùng lặp
    if BoomboxPart then pcall(function() BoomboxPart:Destroy() end) end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    -- Tự động tương thích cả R6 và R15 (UpperTorso hoặc Torso)
    local torso = character:WaitForChild("UpperTorso", 2) or character:WaitForChild("Torso", 2)
    if not torso then return end
    
    -- 1. Tạo Khối Hộp Thân Loa (Màu đen huyền bí như bạn yêu cầu)
    BoomboxPart = Instance.new("Part")
    BoomboxPart.Name = "ThanhPhucBoombox"
    BoomboxPart.Size = Vector3.new(2.4, 1.3, 0.8) -- Tỷ lệ khối chữ nhật boombox chuẩn đeo lưng
    BoomboxPart.Color = Color3.fromRGB(15, 15, 15) -- Màu đen mờ cực ngầu
    BoomboxPart.Material = Enum.Material.SmoothPlastic
    BoomboxPart.CanCollide = false
    BoomboxPart.Massless = true
    BoomboxPart.Parent = character
    
    -- Gắn chặt vào lưng
    local weld = Instance.new("Weld")
    weld.Part0 = torso
    weld.Part1 = BoomboxPart
    weld.C0 = CFrame.new(0, 0.2, 0.65) * CFrame.Angles(0, math.rad(0), 0)
    weld.Parent = BoomboxPart
    
    -- 2. Tạo Viền LED RGB xung quanh khối hộp (Bằng hệ thống SelectionBox cao cấp)
    local LedOutline = Instance.new("SelectionBox")
    LedOutline.Name = "RGB_Outline"
    LedOutline.Adornee = BoomboxPart
    LedOutline.LineThickness = 0.06 -- Độ dày đường viền LED
    LedOutline.SurfaceColor3 = Color3.fromRGB(0, 0, 0)
    LedOutline.SurfaceTransparency = 1
    LedOutline.Parent = BoomboxPart
    
    -- 3. Tạo Bảng Tên "Thanh Phuc" phát sáng phía sau mặt loa
    local Attachment = Instance.new("Attachment", BoomboxPart)
    Attachment.CFrame = CFrame.new(0, 0, 0.41) -- Đưa ra bề mặt phía sau lưng để người khác nhìn thấy
    
    local Billboard = Instance.new("BillboardGui")
    Billboard.Size = UDim2.new(0, 200, 0, 50)
    Billboard.AlwaysOnTop = false -- Không bị xuyên tường, nhìn như tem dán trên loa
    Billboard.ExtentsOffsetInSpace = Vector3.new(0, 0, 0)
    Billboard.Adornee = Attachment
    Billboard.Parent = BoomboxPart
    
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(1, 0, 1, 0)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = "Thanh Phuc"
    NameLabel.Font = Enum.Font.SourceSansBold
    NameLabel.TextSize = 28 -- Kích thước chữ in đậm nổi bật
    NameLabel.TextColor3 = Color3.new(1, 1, 1)
    NameLabel.Parent = Billboard

    -- VÒNG LẶP ĐỒNG BỘ HIỆU ỨNG NHÁY THEO NHỊP BASS & RAINBOW
    coroutine.wrap(function()
        local hue = 0
        local baseSize = Vector3.new(2.4, 1.3, 0.8)
        
        while BoomboxPart and BoomboxPart.Parent and BoomboxPart:IsDescendantOf(workspace) do
            -- Phân tích độ dập Bass thực tế từ bài nhạc
            local loudness = Sound1.PlaybackLoudness
            local intensity = math.clamp(loudness / 280, 0, 1.6) -- Chuẩn hóa độ mạnh nhịp nhạc
            
            -- Tốc độ chuyển màu Rainbow mượt mà phối hợp với nhịp Bass
            hue = (hue + 0.6 + (intensity * 0.4)) % 360
            local rainbowColor = Color3.fromHSV(hue / 360, 1, 0.4 + (intensity * 0.6))
            
            -- Áp dụng hiệu ứng chớp theo nhạc lên Viền LED và Chữ Tên Bạn
            LedOutline.Color3 = rainbowColor
            NameLabel.TextColor3 = rainbowColor
            
            -- Hiệu ứng dập loa (Pulse Effect): Khối hộp đập giật nhẹ to/nhỏ cực khớp theo tiếng bass
            local scaleMultiplier = 1 + (intensity * 0.07) -- Độ co giãn vừa phải không bị lố
            BoomboxPart.Size = baseSize * scaleMultiplier
            
            RunService.RenderStepped:Wait()
        end
    end)()
end

-- VÒNG LẶP KHÓA CHẶT: Giữ loa luôn dính sau lưng kể cả khi Die/Hồi sinh
RunService.Heartbeat:Connect(function()
    if IsPlayingMusic then
        local character = LocalPlayer.Character
        if character and character:IsDescendantOf(workspace) then
            -- Nếu đang bật nhạc mà trên người bị mất Part loa (do die/respawn), dán lại ngay lập tức
            if not character:FindFirstChild("ThanhPhucBoombox") then
                CreateCustomBoombox()
            end
        end
    end
end)


-- GIAO DIỆN GUI STYLE RGB ĐỒNG BỘ THEO ẢNH CỦA BẠN
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
        print("Thanh Phuc Custom Boombox kích hoạt thành công!")
    else
        InputBox.Text = ""
        InputBox.PlaceholderText = "ID không hợp lệ!"
    end
end)
