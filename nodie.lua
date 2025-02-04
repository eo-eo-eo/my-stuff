local player = game:GetService("Players").LocalPlayer
local position, lookVector

if player.Character and player.Character.PrimaryPart then
    position = player.Character.PrimaryPart.Position
    lookVector = workspace.CurrentCamera.CFrame.LookVector
end

local function onCharacterAdded(character)
    task.wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    if position and lookVector then
        rootPart.CFrame = CFrame.new(position, position + lookVector)
        task.wait()
        workspace.CurrentCamera.CFrame = CFrame.new(rootPart.Position, rootPart.Position + lookVector)
    end
end

player.CharacterAdded:Connect(onCharacterAdded)
