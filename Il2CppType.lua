Il2CppType = {}
function Il2CppType:new(ptrType)
     local object = {
        fieldtype = 0,
        attrs = 0,
    }
    setmetatable(object, self)
    self.__index = self
    return object
end


function Il2CppType:isStatic()
    return self.attrs & 0x10 == 0x10
end

function Il2CppType:isPublic()
    return self.attrs & 0x6 == 0x6
end

function Il2CppType:isPrivate()
    return self.attrs & 0x1 == 0x1
end

Il2CppType32 = Il2CppType:new()
function Il2CppType32:new(ptrType)
    local object = Il2CppType:new();
    object.addr_cache = Memory:ReadPointer(ptrType)
    object.fieldtype = Memory:ReadInt32(object.addr_cache + 0x4) >> 16
    object.attrs = Memory:ReadInt32(object.addr_cache + 0x4) & 0xFF
    setmetatable(object, self)
    self.__index = self
    return object
end


Il2CppType64 = Il2CppType:new()

function Il2CppType64:new(ptrType)
    local object = Il2CppType:new()
    object.addr_cache = Memory:ReadPointer(ptrType)
    object.fieldtype = Memory:ReadInt32(object.addr_cache + 0x8) >> 16
    object.attrs = Memory:ReadInt32(object.addr_cache + 0x8) & 0xFF
    setmetatable(object, self)
    self.__index = self
    return object
end