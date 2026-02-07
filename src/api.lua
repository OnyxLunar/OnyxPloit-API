local Library = {}
Library.__index = Library

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
        print(string.format("[%s] Injecting Script: \"%s\"", self.Name, tostring(v)))
        local script = string.format("%s", tosring(v))
        loadstring(game:HttpGet(script, true))()
    end
end

return function(name)
    return Library.new(name)
end
