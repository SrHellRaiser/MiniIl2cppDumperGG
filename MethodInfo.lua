require("ParameterInfo")
MethodInfo = {}

function MethodInfo:new()
    local object = {
        ptrMethod = nil,
        ptrInvokerMethod = nil,
        ptrName = nil,
        ptrParameters = nil,
        parametersCount = 0,
        returnType = nil
    }
    setmetatable(object, self)
    self.__index = self
    return object
end

function MethodInfo:GetName()
    assert(Memory:ReadPointer(self.ptrName) ~= 0, "Ponteiro invalido!")
    return Memory:ReadCString(self.ptrName)
end

function MethodInfo:GetOffset()
   return Memory:ReadPointer(self.ptrMethod) - FindBaseAddressApp("libil2cpp.so")
end

function MethodInfo:GetParameters()
    local object = {}
    for index = 1, self.parametersCount do
        local param = ParameterInfo32:new(self.ptrParameters, index)
        table.insert(object,param)
    end
    return object
end


MethodInfo32 = MethodInfo:new()

function MethodInfo32:new(methodsInfo,index)
    local object = MethodInfo:new()
    local ptrMethod = Memory:ReadPointer(methodsInfo.methodsPtr) + (index) * 4
    local addrMethod = Memory:ReadPointer(ptrMethod)
    object.ptrMethod = addrMethod
    object.ptrInvokerMethod = addrMethod + 0x4
    object.ptrName = addrMethod + 0x8
    object.returnType = Il2CppType32:new(addrMethod + 0x10)
    object.ptrParameters = addrMethod + 0x14
    object.parametersCount = Memory:ReadByte(addrMethod + 0x2A)
    setmetatable(object, self)
    self.__index = self
    return object
end
