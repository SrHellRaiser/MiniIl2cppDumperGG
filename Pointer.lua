GGPtr = {}

function GGPtr:new(ptr)
    local object = {
        ptr = ptr
    }
    self.__index = object
    setmetatable(object,self)
    return ptr
end

function GGPtr:Read()
    return GGPtr:new(Memory:ReadPointer(self.ptr))
end

function GGPtr:add(offset)
    return self.ptr + offset
end
