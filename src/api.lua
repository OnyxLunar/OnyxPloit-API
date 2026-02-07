local Library = {}
Library.__index = Library

local Players = game:GetService("Players")
local player = Players.LocalPlayer

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

function Library:ChangeSpeed(...)
    local args = {...}
    for i, v in ipairs(args) do
        if player.Character then
	        applySpeed(player.Character, tostring(v))
        end

        --player.CharacterAdded:Connect(applySpeed)
    end
end

function Library:CrashGame()
	if player.Character then
			while true do
	        	applySpeed(player.Character, 946498589898978797976737653564959765494654645464559498457547875456546266965146591465459621454857845145)
			end
    end
end

return function(name)
    return Library.new(name)
end
