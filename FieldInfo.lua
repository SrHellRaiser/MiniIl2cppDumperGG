local bit = require("bit32")
require("Il2CppType");

FieldInfo = {}
function FieldInfo:new()
    local object = {
        ptr_name = nil,
        fieldType = nil,
        parentPtr = nil,
        offset = -1,
        token = -1,
    }
    setmetatable(object, self)
    self.__index = self
    return object
end

function FieldInfo:GetName()
    assert(Memory:ReadPointer(self.ptr_name) ~= 0, "Ponteiro invalido!")
    return Memory:ReadCString(self.ptr_name)
end

function FieldInfo:GetType()
    return self.fieldType.type
end

function FieldInfo:isStatic()
    return self.fieldType:isStatic();
end

function FieldInfo:isPrivate()
    return self.fieldType:isPrivate()
end

function FieldInfo:isPublic()
    return self.fieldType:isPublic()
end

FieldInfo32 = FieldInfo:new()
function FieldInfo32:new(kclass, index)
    local object = FieldInfo:new()
    local tmp_addr = Memory:ReadPointer(kclass.fieldsPtr) + (index - 1) * 0x14;
    object.ptr_name = tmp_addr
    object.fieldType = Il2CppType32:new(tmp_addr + 0x4)
    object.parentPtr = tmp_addr + 0x8
    object.offset = Memory:ReadInt32(tmp_addr + 0xC)
    object.token = Memory:ReadInt32(tmp_addr + 0x10)
    setmetatable(object, self)
    self.__index = self
    return object
end

FieldInfo64 = FieldInfo:new()
function FieldInfo64:new(kclass, index)
    local object = FieldInfo:new()
    setmetatable(object, self)
    self.__index = self
    return object
end