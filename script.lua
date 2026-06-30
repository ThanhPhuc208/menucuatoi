-- (Creator = Thanh Phuc)
-- 💟 Thanh Phuc - Boombox Black-RGB Accessory Edition (Hiện 100% khi phát nhạc) 💟
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

-- Quản lý Boombox Độ
local CurrentAccessory = nil
local IsPlayingMusic = false

local function CreateCustomBoombox()
    -- Xóa sạch thiết bị cũ nếu có
    if CurrentAccessory then pcall(function() CurrentAccessory:Destroy() end) end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local torso = character:WaitForChild("UpperTorso", 2) or character:WaitForChild("Torso", 2)
    if not torso then return end
    
    -- 1. KHỞI TẠO DẠNG ACCESSORY (Lách luật hiển thị của Roblox)
    CurrentAccessory = Instance.new("Accessory")
    CurrentAccessory.Name = "ThanhPhucBoomboxAccessory"
    
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(2.4, 1.3, 0.8)
    handle.Color = Color3.fromRGB(15, 15, 15) -- Thân loa đen ngầu
    handle.Material = Enum.Material.SmoothPlastic
    handle.CanCollide = false
    handle.Massless = true
    handle.Parent = CurrentAccessory
    
    -- Gắn mối nối chuẩn phụ kiện vào lưng
    local attachment = Instance.new("Attachment")
    attachment.Name = "BodyBackAttachment" -- Tên attachment chuẩn của Roblox để đeo lưng
    -- Căn chỉnh tọa độ lùi ra sau lưng 0.7 block để không bị chìm vào người
    attachment.CFrame = CFrame.new(0, 0, 0.7) * CFrame.Angles(0, math.rad(180), 0)
    attachment.Parent = handle
    
    -- 2. Tạo Viền LED RGB (SelectionBox phát sáng bao quanh)
    local LedOutline = Instance.new("SelectionBox")
    LedOutline.Name = "RGB_Outline"
    LedOutline.Adornee = handle
    LedOutline.LineThickness = 0.06
    LedOutline.SurfaceColor3 = Color3.fromRGB(0, 0, 0)
    LedOutline.SurfaceTransparency = 1
    LedOutline.Parent = handle
    
    -- 3. Tạo Bảng Tên "Thanh Phuc" phía sau
    local textAttachment = Instance.new("Attachment", handle)
    textAttachment.CFrame = CFrame.new(0, 0, 0.41)
    
    local Billboard = Instance.new("BillboardGui")
    Billboard.Size = UDim2.new(0, 200, 0, 50)
    Billboard.AlwaysOnTop = false
    Billboard.Adornee = textAttachment
    Billboard.Parent = handle
    
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(1, 0, 1, 0)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = "Thanh Phuc"
    NameLabel.Font = Enum.Font.SourceSansBold
    NameLabel.TextSize = 28
    NameLabel.TextColor3 = Color3.new(1, 1, 1)
    NameLabel.Parent = Billboard

    -- Đội phụ kiện lên người nhân vật
    CurrentAccessory.Parent = character
    local human = character:FindFirstChildOfClass("Humanoid")
    if human then
        human:AddAccessory(CurrentAccessory)
    end
    
    -- VÒNG LẶP HIỆU ỨNG RAINBOW & ĐẬP THEO BASS
    coroutine.wrap(function()
        local hue = 0
        local baseSize = Vector3.new(2.4, 1.3, 0.8)
        
        while handle and handle.Parent and CurrentAccessory.Parent == character do
            local loudness = Sound1.PlaybackLoudness
            local intensity = math.clamp(loudness / 280, 0, 1.6)
            
            hue = (hue + 0.6 + (intensity * 0.4)) % 360
            local rainbowColor = Color3.fromHSV(hue / 360, 1, 0.4 + (intensity * 0.6))
            
            LedOutline.Color3 = rainbowColor
            NameLabel.TextColor3 = rainbowColor
            
            -- Loa co giãn đập nhịp nhàng theo Bass
            local scaleMultiplier = 1 + (intensity * 0.07)
            handle.Size = baseSize * scaleMultiplier
            
            RunService.RenderStepped:Wait()
        end
    end)()
end

-- VÒNG LẶP GIỮ LOA KHI DIE / HỒI SINH
RunService.Heartbeat:Connect(function()
    if IsPlayingMusic then
        local character = LocalPlayer.Character
        if character and character:IsDescendantOf(workspace) then
            -- Nếu đang bật nhạc mà nhân vật thiếu phụ kiện boombox, tạo lại ngay
            if not character:FindFirstChild("ThanhPhucBoomboxAccessory") then
                CreateCustomBoombox()
            end
        end
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
        print("Thanh Phuc Custom Boombox kích hoạt thành công!")
    else
        InputBox.Text = ""
        InputBox.PlaceholderText = "ID không hợp lệ!"
    end
end)
