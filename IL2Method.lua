require("IL2Parameter")
IL2Method = {}

function IL2Method:new(unityVersion)
    local object = {
        ptrMethod = nil,
        ptrInvokerMethod = nil,
        name = nil,
        parameters = {},
        parametersCount = 0,
        returnType = IL2Type:new(),
    }
    setmetatable(object, self)
    self.__index = self
    self.unityVersion = unityVersion
    return object
end

function IL2Method:getName()
    return self.name
end

function IL2Method:getOffset()
    return Memory:ReadPointer(self.ptrMethod) - FindBaseAddressApp("libil2cpp.so")
end

function IL2Method:getParameters()
    return self.parameters
end

IL2Method32 = IL2Method:new(0)

function IL2Method32:new(unityVersion)
    local object = IL2Method:new()
    object.parameters = {}
    object.returnType = IL2Type32:new()
    setmetatable(object, self)
    self.__index = self
    self.unityVersion = unityVersion
    return object
end

function IL2Method32:ToStringArgs(fuction)
    
end
function IL2Method32:ReadMethod(methodsPtr, index)
    local currentMethodOffset = (index - 1) * 4

    local ptrMethod = Memory:ReadPointer(methodsPtr)
    if ptrMethod == nil then
        return false
    end
    local addrMethod = Memory:ReadPointer(ptrMethod + currentMethodOffset)
    if self.unityVersion >= 18 and self.unityVersion <= 27 then
        self.ptrMethod = addrMethod
        self.ptrInvokerMethod = addrMethod + 0x4
        self.name = Memory:ReadCString(addrMethod + 0x8)
        self.returnType:ReadType(addrMethod + 0x10)
        self.parametersCount = Memory:ReadByte(addrMethod + 0x2A)
        for index = 1, self.parametersCount do
            local _parameter = IL2Parameter32:new();
            _parameter:ReadParameter(addrMethod + 0x14, index);
            table.insert(self.parameters, _parameter)
        end
    elseif self.unityVersion >= 29 then
        self.ptrMethod = addrMethod
        self.ptrInvokerMethod = addrMethod + 0x4
        self.name = Memory:ReadCString(addrMethod + 0xC)
        self.returnType:ReadType(addrMethod + 0x14)
        self.parametersCount = Memory:ReadByte(addrMethod + 0x2E)
        for i = 1, self.parametersCount do
            local _parameter = IL2Parameter32:new();
            _parameter:ReadParameter(addrMethod + 0x18, index);
            table.insert(self.parameters, _parameter)
        end
    end
end
