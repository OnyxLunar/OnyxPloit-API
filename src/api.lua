local Library = {}
Library.__index = Library

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local flying = false
local flySpeed = 60

local bodyVelocity
local bodyGyro

local moveKeys = {
	W = false,
	A = false,
	S = false,
	D = false,
	Space = false,
	Ctrl = false
}

local function ToggleFlyInternal(Speed)
	if flying then
		flying = false
		humanoid.PlatformStand = false
		if bodyVelocity then bodyVelocity:Destroy() end
		if bodyGyro then bodyGyro:Destroy() end
	else
		flying = true
		flySpeed = Speed or flySpeed
		humanoid.PlatformStand = true

		bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
		bodyVelocity.Parent = humanoidRootPart

		bodyGyro = Instance.new("BodyGyro")
		bodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
		bodyGyro.P = 1e4
		bodyGyro.Parent = humanoidRootPart
	end
end

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end

	if moveKeys[input.KeyCode.Name] ~= nil then
		moveKeys[input.KeyCode.Name] = true
	end

	if input.KeyCode == Enum.KeyCode.LeftControl then
		moveKeys.Ctrl = true
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if moveKeys[input.KeyCode.Name] ~= nil then
		moveKeys[input.KeyCode.Name] = false
	end

	if input.KeyCode == Enum.KeyCode.LeftControl then
		moveKeys.Ctrl = false
	end
end)

RunService.RenderStepped:Connect(function()
	if not flying then return end
	if not bodyVelocity or not bodyGyro then return end

	local camera = workspace.CurrentCamera

	local moveDir = Vector3.zero

	local look = camera.CFrame.LookVector
	local flatLook = Vector3.new(look.X, 0, look.Z)
	if flatLook.Magnitude > 0 then
		flatLook = flatLook.Unit
	end

	local right = camera.CFrame.RightVector

	if moveKeys.W then moveDir += flatLook end
	if moveKeys.S then moveDir -= flatLook end
	if moveKeys.A then moveDir -= right end
	if moveKeys.D then moveDir += right end

	if moveKeys.Space then moveDir += Vector3.new(0, 1, 0) end
	if moveKeys.Ctrl then moveDir += Vector3.new(0, -1, 0) end

	if moveDir.Magnitude > 0 then
		moveDir = moveDir.Unit
	end

	bodyVelocity.Velocity = moveDir * flySpeed
	bodyGyro.CFrame = camera.CFrame
end)

local function applySpeed(character, DESIRED_SPEED)
	local humanoid = character:WaitForChild("Humanoid")

	humanoid.WalkSpeed = DESIRED_SPEED

	humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
		if humanoid.WalkSpeed ~= DESIRED_SPEED then
			humanoid.WalkSpeed = DESIRED_SPEED
		end
	end)
end

function Library.new(name)
    local self = setmetatable({}, Library)
    self.Name = name or "OnyxPloit"
    print("[Library Loaded]:", self.Name)
    return self
end

function Library:Print(...)
    local args = {...}
    for i, v in ipairs(args) do
        print(string.format("[%s] %s", self.Name, tostring(v)))
    end
end

function Library:LoadScript(...)
    local args = {...}
    for i, v in ipairs(args) do
        print(string.format("[%s] Injecting Script: %s", self.Name, tostring(v)))
        loadstring(game:HttpGet(tostring(v), true))()
    end
end

function Library:ChangeSpeed(speed)
	if flying then
		flySpeed = speed
	else
		if player.Character then
			applySpeed(player.Character, speed)
		end
	end
end

function Library:CrashGame()
	if player.Character then
			while true do
	        	applySpeed(player.Character, 946498589898978797976737653564959765494654645464559498457547875456546266965146591465459621454857845145)
			end
    end
end

function Library:SendNotification(title, desc)
    local StarterGui = game:GetService("StarterGui")
    local success

    for i = 1, 5 do
        success = pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = string.format("[%s] %s", self.Name, tostring(title)),
                Text = tostring(desc),
                Duration = 5
            })
        end)
        if success then break end
        task.wait(0.5)
    end

    if not success then
        warn("Notification failed after retries")
    end
end

function Library:ToggleFly(speed)
	ToggleFlyInternal(speed)
end

function Library:BypassFE()
	warn("WARNING: BYPASSING FE IN 5 SEC, THIS MAY CRASH YOUR GAME OR FREEZE IT FOR A WHILE!")
	local StarterGui = game:GetService("StarterGui")
    local success

    for i = 1, 5 do
        success = pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = string.format("[%s] !!WARNING!!", self.Name),
                Text = "BYPSSING FE IN 5 SEC, THIS MAY CRASH YOUR GAME OR FREEZE IT FOR A WHILE!",
				Icon = "rbxassetid://6525485108",
                Duration = 10
            })
        end)
        if success then break end
        task.wait(0.5)
    end

    if not success then
        warn("Notification failed after retries")
    end
	wait(5)
	loadstring(game:HttpGet("https://raw.githubusercontent.com/OnyxLunar/Roblox-FE-Bypasser/refs/heads/main/febypass.lua"))()
end

return function(name)
    return Library.new(name)
end
