-- 創建GUI
local main = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local flingButton = Instance.new("TextButton")
local flingRangeLabel = Instance.new("TextLabel")
local increaseRange = Instance.new("TextButton")
local decreaseRange = Instance.new("TextButton")
local rangeValue = Instance.new("TextLabel")
local closebutton = Instance.new("TextButton")
local mini = Instance.new("TextButton")
local mini2 = Instance.new("TextButton")

main.Name = "SuperFlingGUI"
main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false

Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderColor3 = Color3.fromRGB(0, 255, 255)
Frame.Position = UDim2.new(0.1, 0, 0.3, 0)
Frame.Size = UDim2.new(0, 200, 0, 150)
Frame.Active = true
Frame.Draggable = true

-- 主要拋射按鈕
flingButton.Name = "flingButton"
flingButton.Parent = Frame
flingButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
flingButton.Position = UDim2.new(0.1, 0, 0.1, 0)
flingButton.Size = UDim2.new(0, 160, 0, 60)
flingButton.Font = Enum.Font.SourceSansBold
flingButton.Text = "🔥 超級拋射 🔥"
flingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flingButton.TextScaled = true
flingButton.TextSize = 20

-- 拋射範圍標題
flingRangeLabel.Name = "flingRangeLabel"
flingRangeLabel.Parent = Frame
flingRangeLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
flingRangeLabel.Position = UDim2.new(0.1, 0, 0.55, 0)
flingRangeLabel.Size = UDim2.new(0, 100, 0, 25)
flingRangeLabel.Font = Enum.Font.SourceSans
flingRangeLabel.Text = "拋射範圍:"
flingRangeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
flingRangeLabel.TextSize = 14

-- 增加範圍按鈕
increaseRange.Name = "increaseRange"
increaseRange.Parent = Frame
increaseRange.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
increaseRange.Position = UDim2.new(0.1, 0, 0.75, 0)
increaseRange.Size = UDim2.new(0, 30, 0, 25)
increaseRange.Font = Enum.Font.SourceSansBold
increaseRange.Text = "+"
increaseRange.TextColor3 = Color3.fromRGB(255, 255, 255)
increaseRange.TextSize = 18

-- 減少範圍按鈕
decreaseRange.Name = "decreaseRange"
decreaseRange.Parent = Frame
decreaseRange.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
decreaseRange.Position = UDim2.new(0.3, 0, 0.75, 0)
decreaseRange.Size = UDim2.new(0, 30, 0, 25)
decreaseRange.Font = Enum.Font.SourceSansBold
decreaseRange.Text = "-"
decreaseRange.TextColor3 = Color3.fromRGB(255, 255, 255)
decreaseRange.TextSize = 18

-- 範圍數值顯示
rangeValue.Name = "rangeValue"
rangeValue.Parent = Frame
rangeValue.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
rangeValue.Position = UDim2.new(0.5, 0, 0.75, 0)
rangeValue.Size = UDim2.new(0, 80, 0, 25)
rangeValue.Font = Enum.Font.SourceSansBold
rangeValue.Text = "50 米"
rangeValue.TextColor3 = Color3.fromRGB(255, 255, 255)
rangeValue.TextSize = 14

-- 關閉按鈕
closebutton.Name = "Close"
closebutton.Parent = Frame
closebutton.BackgroundColor3 = Color3.fromRGB(225, 25, 0)
closebutton.Font = Enum.Font.SourceSansBold
closebutton.Size = UDim2.new(0, 30, 0, 25)
closebutton.Text = "X"
closebutton.TextColor3 = Color3.fromRGB(255, 255, 255)
closebutton.TextSize = 18
closebutton.Position = UDim2.new(0.8, 0, 0.02, 0)

-- 最小化按鈕
mini.Name = "minimize"
mini.Parent = Frame
mini.BackgroundColor3 = Color3.fromRGB(50, 50, 150)
mini.Font = Enum.Font.SourceSansBold
mini.Size = UDim2.new(0, 30, 0, 25)
mini.Text = "_"
mini.TextColor3 = Color3.fromRGB(255, 255, 255)
mini.TextSize = 18
mini.Position = UDim2.new(0.65, 0, 0.02, 0)

-- 最大化按鈕（最小化後顯示）
mini2.Name = "maximize"
mini2.Parent = Frame
mini2.BackgroundColor3 = Color3.fromRGB(50, 50, 150)
mini2.Font = Enum.Font.SourceSansBold
mini2.Size = UDim2.new(0, 30, 0, 25)
mini2.Text = "□"
mini2.TextColor3 = Color3.fromRGB(255, 255, 255)
mini2.TextSize = 18
mini2.Position = UDim2.new(0.65, 0, 0.02, 0)
mini2.Visible = false

-- 拋射系統變數
local FLING_STRENGTH = 500  -- 拋射力量
local FLING_UPWARD_FORCE = 250  -- 向上力量
local currentRange = 50  -- 默認範圍（米）

-- 發送通知
game:GetService("StarterGui"):SetCore("SendNotification", { 
    Title = "超級拋射系統 V1.0",
    Text = "按下按鈕拋射全服玩家！",
    Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150",
    Duration = 5
})

-- 更新範圍顯示
local function updateRangeDisplay()
    rangeValue.Text = tostring(currentRange) .. " 米"
end

-- 拋射功能
local function superFling()
    local player = game.Players.LocalPlayer
    local character = player.Character
    
    if not character then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local originPos = humanoidRootPart.Position
    
    -- 視覺效果：創建爆炸特效
    local explosion = Instance.new("Explosion")
    explosion.Position = originPos
    explosion.BlastPressure = 0
    explosion.BlastRadius = currentRange
    explosion.DestroyJointRadiusPercent = 0
    explosion.Visible = true
    explosion.Parent = workspace
    
    -- 音效
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://9117826331"  -- 爆炸音效
    sound.Volume = 1
    sound.Parent = originPos
    sound:Play()
    game:GetService("Debris"):AddItem(sound, 3)
    
    -- 拋射所有玩家
    local playersFlinged = 0
    for _, target in ipairs(game.Players:GetPlayers()) do
        if target ~= player and target.Character then
            local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP then
                local distance = (targetHRP.Position - originPos).Magnitude
                
                -- 檢查是否在範圍內
                if distance <= currentRange then
                    -- 計算拋射方向
                    local direction = (targetHRP.Position - originPos).Unit
                    
                    -- 創建 BodyVelocity
                    local bodyVelocity = Instance.new("BodyVelocity")
                    bodyVelocity.Velocity = direction * FLING_STRENGTH + Vector3.new(0, FLING_UPWARD_FORCE, 0)
                    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    bodyVelocity.P = 1250
                    bodyVelocity.Parent = targetHRP
                    
                    -- 5秒後移除
                    game:GetService("Debris"):AddItem(bodyVelocity, 5)
                    
                    playersFlinged = playersFlinged + 1
                    
                    -- 對目標添加視覺效果
                    local sparkles = Instance.new("Sparkles")
                    sparkles.Parent = targetHRP
                    game:GetService("Debris"):AddItem(sparkles, 3)
                end
            end
        end
    end
    
    -- 顯示拋射結果
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "拋射完成！",
        Text = "已拋射 " .. playersFlinged .. " 名玩家",
        Duration = 3
    })
    
    -- 按鈕冷卻效果
    flingButton.Text = "冷卻中..."
    flingButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    flingButton.Active = false
    
    wait(3)  -- 3秒冷卻
    
    flingButton.Text = "🔥 超級拋射 🔥"
    flingButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    flingButton.Active = true
end

-- 按鈕點擊事件
flingButton.MouseButton1Click:Connect(function()
    -- 按鈕動畫
    local originalSize = flingButton.Size
    flingButton.Size = originalSize * 0.95
    
    -- 播放音效
    local clickSound = Instance.new("Sound")
    clickSound.SoundId = "rbxassetid://5416730210"  -- 點擊音效
    clickSound.Volume = 0.5
    clickSound.Parent = flingButton
    clickSound:Play()
    game:GetService("Debris"):AddItem(clickSound, 1)
    
    -- 執行拋射
    superFling()
    
    -- 恢復按鈕大小
    wait(0.1)
    flingButton.Size = originalSize
end)

-- 增加範圍按鈕
increaseRange.MouseButton1Click:Connect(function()
    if currentRange < 200 then
        currentRange = currentRange + 10
        updateRangeDisplay()
        
        -- 反饋效果
        increaseRange.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        wait(0.1)
        increaseRange.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    end
end)

-- 減少範圍按鈕
decreaseRange.MouseButton1Click:Connect(function()
    if currentRange > 10 then
        currentRange = currentRange - 10
        updateRangeDisplay()
        
        -- 反饋效果
        decreaseRange.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        wait(0.1)
        decreaseRange.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    end
end)

-- 關閉按鈕
closebutton.MouseButton1Click:Connect(function()
    main:Destroy()
end)

-- 最小化按鈕
mini.MouseButton1Click:Connect(function()
    -- 隱藏所有內容
    flingButton.Visible = false
    flingRangeLabel.Visible = false
    increaseRange.Visible = false
    decreaseRange.Visible = false
    rangeValue.Visible = false
    mini.Visible = false
    
    -- 顯示最大化按鈕
    mini2.Visible = true
    
    -- 縮小框架
    Frame.Size = UDim2.new(0, 100, 0, 30)
    
    -- 調整按鈕位置
    closebutton.Position = UDim2.new(0.7, 0, 0, 0)
    mini2.Position = UDim2.new(0.35, 0, 0, 0)
end)

-- 最大化按鈕
mini2.MouseButton1Click:Connect(function()
    -- 顯示所有內容
    flingButton.Visible = true
    flingRangeLabel.Visible = true
    increaseRange.Visible = true
    decreaseRange.Visible = true
    rangeValue.Visible = true
    mini.Visible = true
    
    -- 隱藏最大化按鈕
    mini2.Visible = false
    
    -- 恢復框架大小
    Frame.Size = UDim2.new(0, 200, 0, 150)
    
    -- 恢復按鈕位置
    closebutton.Position = UDim2.new(0.8, 0, 0.02, 0)
    mini.Position = UDim2.new(0.65, 0, 0.02, 0)
end)

-- 滑鼠懸停效果
flingButton.MouseEnter:Connect(function()
    flingButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
end)

flingButton.MouseLeave:Connect(function()
    flingButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
end)

-- 初始顯示
updateRangeDisplay()
print("✅ 超級拋射系統已載入！")
print("🎯 默認範圍: " .. currentRange .. "米")
print("💥 按紅色按鈕拋射全服玩家！")
