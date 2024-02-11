local bit = require("bit32")
require("IL2Type");

IL2Field = {}
function IL2Field:new(unityVersion)
    local object = {
        name = nil,
        type = IL2Type:new(),
        parent = nil,
        offset = nil,
        token = nil,
    }
    setmetatable(object, self)
    self.__index = self
    self.unityVersion = unityVersion
    return object
end

function IL2Field:getName()
    return self.name
end

function IL2Field:getType()
    return self.type.type
end

function IL2Field:isStatic()
    return self.type:isStatic();
end

function IL2Field:isPrivate()
    return self.type:isPrivate()
end

function IL2Field:isPublic()
    return self.type:isPublic()
end

function IL2Field:isProtect()
    return self.type:isProtect()
end

function IL2Field:isInternal()
    return self.type:isInternal()
end

function IL2Field:isProtectInternal()
    return self.type:isProtectInternal()
end


function IL2Field:getTypeName()
    return self.type:getTypeName()
end

IL2Field32 = IL2Field:new(0)
function IL2Field32:new(unityVersion)
    local object = IL2Field:new(unityVersion)
    object.type = IL2Type32:new();
    setmetatable(object, self)
    self.__index = self
    self.unityVersion = unityVersion
    return object
end

function IL2Field32:ReadField(fieldsPtr, index)

    local currentFieldOffset = (index -1) * 0x14;
    local addrField = Memory:ReadPointer(fieldsPtr);
    if addrField == 0 then
        return false
    end
    addrField = addrField + currentFieldOffset
    if self.unityVersion >= 18 and self.unityVersion <= 29 then
        self.name = Memory:ReadCString(addrField)
        self.type:ReadType(addrField + 0x4)
        self.parent = addrField + 0x8
        self.offset = Memory:ReadInt32(addrField + 0xC)
        self.token = Memory:ReadInt32(addrField + 0x10)
    end
    return true
end
