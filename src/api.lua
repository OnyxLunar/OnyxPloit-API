local Library = {}
Library.__index = Library

function Library.new(name)
    local self = setmetatable({}, Library)
    self.Name = name or "OnyxPloit"
    print("[Library Loaded]:", self.Name)
    return self
end

function Library:PrintArg(...)
    local args = {...}
    for i, v in ipairs(args) do
        print(string.format("[%s] Arg %d -> %s", self.Name, i, tostring(v)))
    end
end

return function(name)
    return Library.new(name)
end
