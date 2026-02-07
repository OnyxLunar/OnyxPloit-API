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

	local camera = workspace.CurrentCamera
	local direction = Vector3.zero

	local look = camera.CFrame.LookVector
	local flatLook = Vector3.new(look.X, 0, look.Z).Unit
	local right = camera.CFrame.RightVector

	if moveKeys.W then direction += flatLook end
	if moveKeys.S then direction -= flatLook end
	if moveKeys.A then direction -= right end
	if moveKeys.D then direction += right end

	if direction.Magnitude > 0 then
		direction = direction.Unit
	end

	bodyVelocity.Velocity = direction * flySpeed
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
       if player.Character then
	        applySpeed(player.Character, speed)
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
    local success, err = pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "[%s] %s", self.Name, tostring(title),
            Text = tostring(desc),
            Duration = 5
        })
    end)

    if not success then
        warn("Notification failed:", err)
    end
end

function Library:ToggleFly(speed)
	ToggleFlyInternal(speed)
end

return function(name)
    return Library.new(name)
end
