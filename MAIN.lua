queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
wait(5)
queueteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/MISSINGACID/AutoDupe/refs/heads/main/MAIN.lua'))()")
local selectedtp = game.Players.McFlurry0k.Character.HumanoidRootPart

local function getGroundPosition(position)
    local direction = Vector3.new(0, -300, 0) -- Raycast direction
    local origin = position + Vector3.new(0, 200, 0) -- Start raycast above the position

    -- Ignore character parts during raycast
    local ignoreList = {}
    for _, part in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(ignoreList, part)
        end
    end

    -- Perform raycast
    local hitPart, hitPosition = workspace:FindPartOnRayWithIgnoreList(Ray.new(origin, direction), ignoreList)

    -- Return ground position if hit; otherwise, fallback to original position
    if hitPart then
        return Vector3.new(position.X, hitPosition.Y, position.Z)
    else
        return position
    end
end

local function interpolateToTarget()
    local startTime = tick()
    local character = game.Players.LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        warn("Player character or HumanoidRootPart not found.")
        return
    end

    local rootPart = character.HumanoidRootPart
    local startPosition = rootPart.Position
    local endPosition = selectedtp.Position

    -- Ensure the target position is adjusted to the ground
    local adjustedEndPosition = getGroundPosition(endPosition)

    -- Calculate distance and duration
    local distance = (startPosition - adjustedEndPosition).Magnitude
    local baseMoveSpeed = 150 -- Adjust the speed as needed
    local moveDuration = distance / baseMoveSpeed

    while tick() - startTime < moveDuration do
        local alpha = (tick() - startTime) / moveDuration
        local interpolatedPosition = startPosition:Lerp(adjustedEndPosition, alpha)

        -- Update position with ground adjustment
        local groundPosition = getGroundPosition(interpolatedPosition)
        rootPart.CFrame = CFrame.new(groundPosition)

        task.wait(0.03) -- Update every frame
    end

    -- Ensure final position is adjusted to the ground
    local finalGroundPosition = getGroundPosition(adjustedEndPosition)
    rootPart.CFrame = CFrame.new(finalGroundPosition)
end

-- Code to run after teleport

local args = {
    [1] = "RedRocks",
    [2] = true,
    [3] = false
}

game:GetService("ReplicatedStorage"):WaitForChild("GeneralEvents"):WaitForChild("Spawn"):FireServer(unpack(args))

    wait(0.5)  -- Wait for spawn to complete

    -- Wait for the player character to load
    repeat wait() until game.Players.LocalPlayer.Character
    game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")

    -- Interpolate to the target position smoothly
    interpolateToTarget()
    wait(3)
    -- Fire the ChangeKeybind event
    local args2 = {
        [1] = 3,
        [2] = "\255"
    }
    game:GetService("ReplicatedStorage"):WaitForChild("GeneralEvents"):WaitForChild("ChangeKeybind"):FireServer(unpack(args2))
    wait(3)  -- Wait for keybind change to complete

    -- Fire the Inventory event
    local args3 = {
        [1] = "DropAll",
        [2] = "asd"
    }
    game:GetService("ReplicatedStorage"):WaitForChild("GeneralEvents"):WaitForChild("Inventory"):InvokeServer(unpack(args3))
    wait(0.5)  -- Wait for inventory action to complete
game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)

-- Queue the code to run after teleportation

-- Start teleportation
