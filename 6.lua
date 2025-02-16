local screenGui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local button = Instance.new("TextButton")
local textbox = Instance.new("TextBox")
local hideButton = Instance.new("TextButton")
local isDragging = false
local dragStart, startPos
local guiVisible = true

screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.Parent = screenGui

button.Size = UDim2.new(0, 100, 0, 50)
button.Position = UDim2.new(0.5, -50, 0.8, -25)
button.Text = "Upgrade"
button.Parent = frame

textbox.Size = UDim2.new(0, 200, 0, 50)
textbox.Position = UDim2.new(0.5, -100, 0.5, -25)
textbox.Text = "Tower name"
textbox.Parent = frame

hideButton.Size = UDim2.new(0, 30, 0, 30)
hideButton.Position = UDim2.new(1, -40, 0, 10)
hideButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
hideButton.Text = "X"
hideButton.Parent = frame

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

frame.InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

button.MouseButton1Click:Connect(function()
    local placeholderText = textbox.Text

    local args = {
        [1] = game:GetService("Workspace"):WaitForChild("Mapa"):WaitForChild("Ignore"):WaitForChild("Tropas"):WaitForChild(placeholderText);
    }

    game:GetService("ReplicatedStorage"):WaitForChild("levelup"):FireServer(unpack(args))
end)

hideButton.MouseButton1Click:Connect(function()
    guiVisible = not guiVisible
    frame.Visible = guiVisible
end)

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Z then
        guiVisible = not guiVisible
        frame.Visible = guiVisible
    end
end)

local tropasFolder = game.Workspace.Mapa.Ignore.Tropas

local function updateNames()
    local nameCount = {}

    for _, model in pairs(tropasFolder:GetChildren()) do
        if model:IsA("Model") then
            local baseName, number = model.Name:match("^(%D+)(%d*)")
            if number == "" then
                model.Name = baseName
            else
                nameCount[baseName] = nameCount[baseName] or {}
                nameCount[baseName][tonumber(number)] = true
            end
        end
    end

    for _, model in pairs(tropasFolder:GetChildren()) do
        if model:IsA("Model") then
            local baseName, number = model.Name:match("^(%D+)(%d*)")
            if number == "" then
                local newNumber = 1
                while nameCount[baseName] and nameCount[baseName][newNumber] do
                    newNumber = newNumber + 1
                end
                model.Name = baseName .. newNumber
                nameCount[baseName] = nameCount[baseName] or {}
                nameCount[baseName][newNumber] = true
            end
        end
    end
end

updateNames()

tropasFolder.ChildAdded:Connect(function(child)
    if child:IsA("Model") then
        updateNames()
    end
end)

tropasFolder.ChildRemoved:Connect(function(child)
    if child:IsA("Model") then
        updateNames()
    end
end)
