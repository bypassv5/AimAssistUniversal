local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

local CAMERA_DISTANCE_THRESHOLD = 30
local toggleCameraLock = false

_G.Keybind = _G.Keybind or "R"

local function convertKeyToEnum(key)
    local keyUpper = string.upper(key)
    local success, enum = pcall(function()
        return Enum.KeyCode[keyUpper]
    end)
    return success and enum or nil
end

local KeybindEnum = convertKeyToEnum(_G.Keybind)

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
    if input.KeyCode == KeybindEnum and not gameProcessed then
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
