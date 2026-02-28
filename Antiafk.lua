-- [[ MENU BY: DATDEPTRAI ]] --

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local AntiAfkBtn = Instance.new("TextButton")

-- Cấu hình Giao diện (UI) dựa trên hình ảnh ông cung cấp
ScreenGui.Parent = game.CoreGui
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- Nền tối
MainFrame.Position = UDim2.new(0.5, -75, 0.4, 0)
MainFrame.Size = UDim2.new(0, 150, 0, 80) -- 1 mục duy nhất nên làm gọn lại
MainFrame.Active = true
MainFrame.Draggable = true -- Có thể kéo menu đi chỗ khác
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)

-- Dòng chữ thương hiệu: MENU BY: DATDEPTRAI
Title.Parent = MainFrame
Title.Text = "MENU BY: DATDEPTRAI"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, -0.4, 0)
Title.TextColor3 = Color3.fromRGB(255, 255, 0) -- Màu vàng rực
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.BackgroundTransparency = 1

-- Nút Anti-AFK duy nhất: Bấm 1 lần bật, 1 lần tắt
AntiAfkBtn.Parent = MainFrame
AntiAfkBtn.Size = UDim2.new(0.9, 0, 0, 50)
AntiAfkBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
AntiAfkBtn.Text = "ANTI AFK: OFF"
AntiAfkBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255) -- Xanh dương giống ảnh
AntiAfkBtn.TextColor3 = Color3.new(1, 1, 1)
AntiAfkBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", AntiAfkBtn).CornerRadius = UDim.new(0, 10)

-- Logic Anti-AFK (Ngăn chặn bị kick sau 20p)
local AfkEnabled = false
local VirtualUser = game:GetService("VirtualUser")

game.Players.LocalPlayer.Idled:Connect(function()
    if AfkEnabled then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new()) -- Giả lập click chuột để không bị tính là treo máy
    end
end)

-- Xử lý sự kiện bấm nút
AntiAfkBtn.MouseButton1Click:Connect(function()
    AfkEnabled = not AfkEnabled
    if AfkEnabled then
        AntiAfkBtn.Text = "ANTI AFK: ON"
        AntiAfkBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Đổi sang Đỏ khi đang bật
    else
        AntiAfkBtn.Text = "ANTI AFK: OFF"
        AntiAfkBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255) -- Quay lại Xanh dương khi tắt
    end
end)
