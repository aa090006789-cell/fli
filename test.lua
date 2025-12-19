-- LocalScript (放在 SuperFlingButton 裡)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local flingEvent = ReplicatedStorage:WaitForChild("SuperFlingEvent")
local player = Players.LocalPlayer

script.Parent.MouseButton1Click:Connect(function()
    -- 當按鈕被點擊時，向伺服器發送事件
    flingEvent:FireServer()
end)
-- ServerScript (放在 ServerScriptService 裡)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local flingEvent = ReplicatedStorage:WaitForChild("SuperFlingEvent")
local FLING_STRENGTH = 200 -- 可依需求調整

flingEvent.OnServerEvent:Connect(function(player)
    local originChar = player.Character
    if not (originChar and originChar:FindFirstChild("HumanoidRootPart")) then return end

    local originPos = originChar.HumanoidRootPart.Position
    for _, target in ipairs(Players:GetPlayers()) do
        if target ~= player and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = target.Character.HumanoidRootPart
            -- 建立 BodyVelocity 施力拋射
            local bv = Instance.new("BodyVelocity")
            bv.Velocity = (hrp.Position - originPos).unit * FLING_STRENGTH + Vector3.new(0, FLING_STRENGTH/2, 0)
            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5) -- 適當的最大力量
            bv.P = 1250 -- 控制動力的參數，可根據需求微調:contentReference[oaicite:5]{index=5}
            bv.Parent = hrp
            Debris:AddItem(bv, 0.5) -- 0.5 秒後自動移除，避免持續施力
        end
    end
end)
