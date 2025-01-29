local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

local CAMERA_DISTANCE_THRESHOLD = 30
local toggleCameraLock = false

-- Default keybind (can be overridden by setting Keybind to a string)
local Keybind = "R"

-- Create a map of string to Enum.KeyCode for compatibility
local KeyCodeMap = {
    ["A"] = Enum.KeyCode.A,
    ["B"] = Enum.KeyCode.B,
    ["C"] = Enum.KeyCode.C,
    ["D"] = Enum.KeyCode.D,
    ["E"] = Enum.KeyCode.E,
    ["F"] = Enum.KeyCode.F,
    ["G"] = Enum.KeyCode.G,
    ["H"] = Enum.KeyCode.H,
    ["I"] = Enum.KeyCode.I,
    ["J"] = Enum.KeyCode.J,
    ["K"] = Enum.KeyCode.K,
    ["L"] = Enum.KeyCode.L,
    ["M"] = Enum.KeyCode.M,
    ["N"] = Enum.KeyCode.N,
    ["O"] = Enum.KeyCode.O,
    ["P"] = Enum.KeyCode.P,
    ["Q"] = Enum.KeyCode.Q,
    ["R"] = Enum.KeyCode.R,
    ["S"] = Enum.KeyCode.S,
    ["T"] = Enum.KeyCode.T,
    ["U"] = Enum.KeyCode.U,
    ["V"] = Enum.KeyCode.V,
    ["W"] = Enum.KeyCode.W,
    ["X"] = Enum.KeyCode.X,
    ["Y"] = Enum.KeyCode.Y,
    ["Z"] = Enum.KeyCode.Z,
}

local function isEnemy(player)
    if player.Team ~= localPlayer.Team then
        return true
    end
    return false
end

local function getClosestEnemy()
    local closestPlayer = nil
    local shortestDistance = CAMERA_DISTANCE_THRESHOLD

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if isEnemy(player) then
                local playerPosition = player.Character.HumanoidRootPart.Position
                local localPosition = localPlayer.Character.HumanoidRootPart.Position
                local distance = (playerPosition - localPosition).Magnitude

                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end

    return closestPlayer
end

local function lockCamera()
    local closestEnemy = getClosestEnemy()
    if closestEnemy and closestEnemy.Character and closestEnemy.Character:FindFirstChild("HumanoidRootPart") then
        camera.CFrame = CFrame.lookAt(camera.CFrame.Position, closestEnemy.Character.HumanoidRootPart.Position)
    end
end

local function onInputBegan(input, gameProcessed)
    if input.KeyCode == KeyCodeMap[Keybind] and not gameProcessed then
        toggleCameraLock = not toggleCameraLock
        if toggleCameraLock then
            print("Camera lock enabled.")
        else
            print("Camera lock disabled.")
        end
    end
end

local function onRenderStep()
    if toggleCameraLock then
        lockCamera()
    end
end

UserInputService.InputBegan:Connect(onInputBegan)
RunService.RenderStepped:Connect(onRenderStep)
