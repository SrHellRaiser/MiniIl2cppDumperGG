ParameterInfo = {}
function ParameterInfo:new()
    local object = {
        ptrName = nil,
        position = 0,
        token = 0,
        methodType = nil
    }
    setmetatable(object, self)
    self.__index = self
    return object
end

function ParameterInfo:GetName()
    assert(Memory:ReadPointer(self.ptrName) ~= 0, "Ponteiro invalido!")
    return Memory:ReadCString(self.ptrName)
end


ParameterInfo32 = ParameterInfo:new()
function ParameterInfo32:new(ptrParameters, index)
    local object = ParameterInfo:new()
    local addParam = Memory:ReadPointer(ptrParameters) + (index -1) * 0x10
    object.ptrName = addParam + 0x0
    object.position = Memory:ReadInt32(addParam + 0x4)
    object.token = Memory:ReadInt32(addParam + 0x8)   
    object.methodType = Il2CppType32:new(addParam + 0xC) 
    setmetatable(object, self)
    self.__index = self
    return object
end

ParameterInfo64 = ParameterInfo:new()
function ParameterInfo64:new(ptrParameters, index)
    local object = ParameterInfo:new()
    local addParam = Memory:ReadPointer(ptrParameters) + (index-1) * 0x14
    object.ptrName = addParam + 0x0
    object.position = Memory:ReadInt32(addParam + 0x8)
    object.token = Memory:ReadInt32(addParam + 0xC)    
    object.methodType = Il2CppType64:new(addParam + 0x10) 
    setmetatable(object, self)
    self.__index = self
    return object
end