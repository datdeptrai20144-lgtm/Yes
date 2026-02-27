local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer

-- Khởi tạo GUI (Không mất khi Reset)
local sg = Instance.new("ScreenGui")
sg.Name = "DatDepTraiMenu_Pro"
sg.Parent = player:WaitForChild("PlayerGui")
sg.ResetOnSpawn = false 

-- Khung chính (Đen, bo góc dày)
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 130, 0, 195) -- Tăng chiều cao để thêm nút Stop
main.Position = UDim2.new(0.05, 0, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 15)

-- Dòng chữ MENU BY: DATDEPTRAI (Màu vàng)
local credit = Instance.new("TextLabel", sg)
credit.Text = "MENU BY: DATDEPTRAI"
credit.TextColor3 = Color3.fromRGB(255, 255, 0)
credit.Font = Enum.Font.GothamBold
credit.TextSize = 14
credit.BackgroundTransparency = 1
credit.Size = UDim2.new(0, 150, 0, 20)

RunService.RenderStepped:Connect(function()
    credit.Position = UDim2.new(main.Position.X.Scale, main.Position.X.Offset, main.Position.Y.Scale, main.Position.Y.Offset - 25)
end)

local function createBtn(text, pos, color)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0.85, 0, 0, 32)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    return btn
end

-- 4 MỤC CHÍNH
local saveBtn = createBtn("SAVE", UDim2.new(0.075, 0, 0.08, 0), Color3.fromRGB(0, 100, 200))
local backBtn = createBtn("RETURN", UDim2.new(0.075, 0, 0.28, 0), Color3.fromRGB(0, 150, 70))
local stopBtn = createBtn("STOP", UDim2.new(0.075, 0, 0.48, 0), Color3.fromRGB(200, 0, 0)) -- Nút Stop màu đỏ

local speedInput = Instance.new("TextBox", main)
speedInput.Size = UDim2.new(0.85, 0, 0, 28)
speedInput.Position = UDim2.new(0.075, 0, 0.75, 0)
speedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
speedInput.Text = "300"
speedInput.TextColor3 = Color3.new(1, 1, 1)
speedInput.Font = Enum.Font.Gotham
speedInput.TextSize = 14
Instance.new("UICorner", speedInput).CornerRadius = UDim.new(0, 5)

-- Logic
local savedCF = nil
local isTweening = false
local currentTween = nil

local function setNoclip(status)
    isTweening = status
    if status then
        _G.Noclip = RunService.Stepped:Connect(function()
            if isTweening and player.Character then
                for _, p in pairs(player.Character:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end)
    else
        if _G.Noclip then _G.Noclip:Disconnect() end
        if player.Character then
            for _, p in pairs(player.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = true end
            end
        end
    end
end

saveBtn.MouseButton1Click:Connect(function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        savedCF = hrp.CFrame
        saveBtn.Text = "DONE!"
        task.wait(0.5)
        saveBtn.Text = "SAVE"
    end
end)

backBtn.MouseButton1Click:Connect(function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp and savedCF and not isTweening then
        local dist = (hrp.Position - savedCF.Position).Magnitude
        local spd = tonumber(speedInput.Text) or 300
        local dur = dist / spd
        
        hrp.Anchored = true
        setNoclip(true)
        
        currentTween = TweenService:Create(hrp, TweenInfo.new(dur, Enum.EasingStyle.Linear), {CFrame = savedCF})
        currentTween:Play()
        
        currentTween.Completed:Connect(function()
            hrp.Anchored = false
            setNoclip(false)
            currentTween = nil
        end)
    end
end)

-- Nút STOP giúp dừng Tween ngay lập tức
stopBtn.MouseButton1Click:Connect(function()
    if currentTween then
        currentTween:Cancel()
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Anchored = false
        end
        setNoclip(false)
        currentTween = nil
        stopBtn.Text = "STOPPED!"
        task.wait(0.5)
        stopBtn.Text = "STOP"
    end
end)
