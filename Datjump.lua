local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

-- 1. Khởi tạo GUI (Giữ phong cách Datdeptrai)
local sg = Instance.new("ScreenGui")
sg.Name = "DatDepTrai_ClassicJump"
sg.Parent = player:WaitForChild("PlayerGui")
sg.ResetOnSpawn = false 

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 140, 0, 180)
main.Position = UDim2.new(0.05, 0, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true 
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)

local credit = Instance.new("TextLabel", sg)
credit.Text = "MENU BY: DATDEPTRAI"
credit.TextColor3 = Color3.fromRGB(255, 255, 0)
credit.Font = Enum.Font.GothamBold
credit.TextSize = 13
credit.BackgroundTransparency = 1
credit.Size = UDim2.new(0, 140, 0, 20)

RunService.RenderStepped:Connect(function()
    credit.Position = UDim2.new(main.Position.X.Scale, main.Position.X.Offset, main.Position.Y.Scale, main.Position.Y.Offset - 30)
    credit.Visible = main.Visible
end)

local speedActive = false
local jumpActive = false

local function createBtn(text, pos)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0.85, 0, 0, 35)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    return btn
end

local speedBtn = createBtn("SPEED", UDim2.new(0.075, 0, 0.1, 0))
local jumpBtn = createBtn("INF JUMP", UDim2.new(0.075, 0, 0.38, 0))

local speedInput = Instance.new("TextBox", main)
speedInput.Size = UDim2.new(0.85, 0, 0, 30)
speedInput.Position = UDim2.new(0.075, 0, 0.7, 0)
speedInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
speedInput.Text = "80"
speedInput.TextColor3 = Color3.new(1, 1, 1)
speedInput.Font = Enum.Font.Gotham
Instance.new("UICorner", speedInput).CornerRadius = UDim.new(0, 5)

-- LOGIC
speedBtn.MouseButton1Click:Connect(function()
    speedActive = not speedActive
    speedBtn.BackgroundColor3 = speedActive and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(180, 0, 0)
end)

jumpBtn.MouseButton1Click:Connect(function()
    jumpActive = not jumpActive
    jumpBtn.BackgroundColor3 = jumpActive and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(180, 0, 0)
end)

-- Đảm bảo độ cao nhảy luôn chuẩn
RunService.Heartbeat:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local hum = player.Character.Humanoid
        if speedActive then
            hum.WalkSpeed = tonumber(speedInput.Text) or 16
        else
            hum.WalkSpeed = 16
        end
        
        -- Khóa JumpPower ở mức 50 (mức nhảy chuẩn của Roblox)
        hum.JumpPower = 50
        hum.UseJumpPower = true
    end
end)

-- Nhảy vô hạn khi Nhấp
UserInputService.JumpRequest:Connect(function()
    if jumpActive then
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            -- Ép trạng thái nhảy đúng chuẩn để không bị bay quá cao
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)
