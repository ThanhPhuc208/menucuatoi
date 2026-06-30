-- (Creator = Thanh Phuc)
-- 💟 Thanh Phuc - Boombox Cầu Vồng Ảo Siêu Cấp V2 (Chống lỗi khi Die/Hồi sinh) 💟
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

-- HỆ THỐNG ÂM THANH KÉP (DUAL SOUND) CHỐNG RÈ & TĂNG BASS
local SoundGroup = Instance.new("SoundGroup")
SoundGroup.Name = "ThanhPhucAudioGroup"
SoundGroup.Volume = 1.5 
SoundGroup.Parent = SoundService

local EQ = Instance.new("EqualizerSoundEffect")
EQ.LowGain = 6   
EQ.MidGain = 1   
EQ.HighGain = -2 
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

-- Quản lý Boombox
local FakeBoombox = nil
local BoomboxPart = nil
local IsPlayingMusic = false -- Biến đánh dấu xem bạn có đang bật nhạc hay không

local function CreateFakeBoombox()
    -- Xóa cái cũ nếu có để tránh trùng lặp
    if FakeBoombox then pcall(function() FakeBoombox:Destroy() end) end
    if BoomboxPart then pcall(function() BoomboxPart:Destroy() end) end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    -- Chờ nhân vật tải xong hoàn toàn phần thân
    local torso = character:WaitForChild("UpperTorso", 2) or character:WaitForChild("Torso", 2)
    if not torso then return end
    
    -- Tạo Part chứa Boombox
    BoomboxPart = Instance.new("Part")
    BoomboxPart.Name = "ThanhPhucBoombox"
    BoomboxPart.Size = Vector3.new(2, 2, 2)
    BoomboxPart.CanCollide = false
    BoomboxPart.Massless = true
    BoomboxPart.Material = Enum.Material.Neon
    BoomboxPart.Parent = character
    
    FakeBoombox = Instance.new("SpecialMesh")
    FakeBoombox.MeshId = "rbxassetid://114134812"
    FakeBoombox.TextureId = "rbxassetid://114134769"
    FakeBoombox.Parent = BoomboxPart
    
    -- Gắn chặt Boombox vào lưng
    local weld = Instance.new("Weld")
    weld.Part0 = torso
    weld.Part1 = BoomboxPart
    weld.C0 = CFrame.new(0, 0, 0.7) * CFrame.Angles(0, math.rad(180), 0)
    weld.Parent = BoomboxPart
    
    -- VÒNG LẶP ĐỒNG BỘ HIỆU ỨNG THEO NHỊP NHẠC (VISUALIZER)
    coroutine.wrap(function()
        local hue = 0
        local baseSize = Vector3.new(1, 1, 1)
        
        -- Vòng lặp sẽ chạy liên tục cho đến khi Part này bị hủy (khi nhân vật chết)
        while BoomboxPart and BoomboxPart.Parent and BoomboxPart:IsDescendantOf(workspace) do
            local loudness = Sound1.PlaybackLoudness
            local intensity = math.clamp(loudness / 300, 0, 1.5)
            
            hue = (hue + 0.5 + (intensity * 0.5)) % 360
            local color = Color3.fromHSV(hue / 360, 0.9, 0.5 + (intensity * 0.5))
            
            BoomboxPart.Color = color
            FakeBoombox.VertexColor = Vector3.new(color.R, color.G, color.B)
            
            local scaleMultiplier = 1 + (intensity * 0.08)
            FakeBoombox.Scale = baseSize * scaleMultiplier
            
            RunService.RenderStepped:Wait()
        end
    end)()
end

-- VÒNG LẶP THẦN THÁNH: Kiểm tra và tự động đeo lại loa mãi mãi khi hồi sinh
RunService.Heartbeat:Connect(function()
    if IsPlayingMusic then
        local character = LocalPlayer.Character
        if character and character:IsDescendantOf(workspace) then
            -- Nếu đang bật nhạc mà trên người không thấy Part Boombox, tiến hành đeo lại ngay
            if not character:FindFirstChild("ThanhPhucBoombox") then
                CreateFakeBoombox()
            end
        end
    end
end)


-- TẠO GIAO DIỆN GUI STYLE RGB PREMIUM
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 230)
MainFrame.Position = UDim2.new(0.5, -130, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
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
HideBtn.TextSize = 20
HideBtn.TextColor3 = Color3.new(1, 1, 1)
HideBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", HideBtn).CornerRadius = UDim.new(0, 8)
HideBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 55, 0, 55)
OpenBtn.Position = UDim2.new(0, 15, 0.5, 0)
OpenBtn.Text = "TP 🎵"
OpenBtn.Font = Enum.Font.SourceSansBold
OpenBtn.TextSize = 16
OpenBtn.TextColor3 = Color3.new(1, 1, 1)
OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
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
InputBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
InputBox.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", InputBox).CornerRadius = UDim.new(0, 8)

local PlayBtn = Instance.new("TextButton", MainFrame)
PlayBtn.Size = UDim2.new(0.9, 0, 0, 45)
PlayBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
PlayBtn.Text = "PHÁT AUDIO KÉP"
PlayBtn.Font = Enum.Font.SourceSansBold
PlayBtn.TextSize = 16
PlayBtn.TextColor3 = Color3.new(1, 1, 1)
PlayBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
Instance.new("UICorner", PlayBtn).CornerRadius = UDim.new(0, 8)

PlayBtn.MouseButton1Click:Connect(function()
    local cleanID = InputBox.Text:match("%d+")
    if cleanID then
        local assetURI = "rbxassetid://" .. cleanID
        
        Sound1.SoundId = assetURI
        Sound2.SoundId = assetURI
        
        Sound1:Play()
        Sound2:Play()
        
        IsPlayingMusic = true -- Đánh dấu đang bật nhạc thành công
        CreateFakeBoombox()
        print("Thanh Phuc Music đang phát + Đã khóa Boombox vào nhân vật!")
    else
        InputBox.Text = ""
        InputBox.PlaceholderText = "ID không hợp lệ!"
    end
end)

