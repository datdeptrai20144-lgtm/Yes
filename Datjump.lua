local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

-- 1. Khởi tạo GUI (ResetOnSpawn = false để không mất khi reset)
local sg = Instance.new("ScreenGui")
sg.Name = "DatDepTrai_FinalMenu"
sg.Parent = player:WaitForChild("PlayerGui")
sg.ResetOnSpawn = false 

-- 2. Khung chính (Thiết kế đen, bo góc 15px chuẩn mẫu)
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 140, 0, 175)
main.Position = UDim2.new(0.05, 0, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true 

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 15)

-- 3. Dòng chữ vàng "MENU BY: DATDEPTRAI" (Y hệt trong ảnh)
local credit = Instance.new("TextLabel", sg)
credit.Text = "MENU BY: DATDEPTRAI"
credit.TextColor3 = Color3.fromRGB(255, 255, 0) -- Màu vàng rực
credit.Font = Enum.Font.GothamBold
credit.TextSize = 14
credit.BackgroundTransparency = 1
credit.Size = UDim2.new(0, 140, 0, 20)

-- Giữ dòng chữ luôn bám sát phía trên Menu khi kéo thả
RunService.RenderStepped:Connect(function()
    credit.Position = UDim2.new(main.Position.X.Scale, main.Position.X.Offset, main.Position.Y.Scale, main.Position.Y.Offset - 30)
    credit.Visible = main.Visible
end)

-- Biến lưu trạng thái bật/tắt
local speedActive = false
local jumpActive = false

local function createBtn(text, pos, color)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0.85, 0, 0, 35)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    return btn
end

-- 4. Các nút bấm (Bấm 1 lần đổi màu để nhận biết bật/tắt)
local speedBtn = createBtn("SPEED", UDim2.new(0.075, 0, 0.1, 0), Color3.fromRGB(180, 0, 0)) -- Mặc định đỏ (Tắt)
local jumpBtn = createBtn("INF JUMP", UDim2.new(0.075, 0, 0.38, 0), Color3.fromRGB(180, 0, 0))

-- Ô nhập tốc độ
local speedInput = Instance.new("TextBox", main)
speedInput.Size = UDim2.new(0.85, 0, 0, 30)
speedInput.Position = UDim2.new(0.075, 0, 0.7, 0)
speedInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
speedInput.Text = "100"
speedInput.TextColor3 = Color3.new(1, 1, 1)
speedInput.Font = Enum.Font.Gotham
speedInput.TextSize = 14
Instance.new("UICorner", speedInput).CornerRadius = UDim.new(0, 5)

-- LOGIC XỬ LÝ
-- Tốc độ chạy (Bấm 1 lần bật, lần nữa tắt)
speedBtn.MouseButton1Click:Connect(function()
    speedActive = not speedActive
    speedBtn.BackgroundColor3 = speedActive and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(180, 0, 0)
    if not speedActive and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 16
    end
end)

RunService.Heartbeat:Connect(function()
    if speedActive and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = tonumber(speedInput.Text) or 16
    end
end)

-- Nhảy vô hạn (Bấm 1 lần bật, lần nữa tắt)
jumpBtn.MouseButton1Click:Connect(function()
    jumpActive = not jumpActive
    jumpBtn.BackgroundColor3 = jumpActive and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(180, 0, 0)
end)

UserInputService.JumpRequest:Connect(function()
    if jumpActive and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- Phím L ẩn hiện menu
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.L then
        main.Visible = not main.Visible
    end
end)
