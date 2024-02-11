require("IL2Type")

IL2Parameter = {}
function IL2Parameter:new()
    local object = {
        name = nil,
        position = 0,
        token = 0,
        type = IL2Type:new()
    }
    setmetatable(object, self)
    self.__index = self
    return object
end

function IL2Parameter:getName()
    return self.name
end

function IL2Parameter:Read() end


IL2Parameter32 = IL2Parameter:new()
function IL2Parameter32:new()
    local object = IL2Parameter:new()
    object.type = IL2Type32:new()
    setmetatable(object, self)
    self.__index = self
    return object
end

function IL2Parameter32:ReadParameter(ptrParameters, index)
    local addrParam = Memory:ReadPointer(ptrParameters)
    if addrParam == nil then
        return false
    end
    local currentOffsetParam =  (index -1) * 0x10
    addrParam = addrParam + currentOffsetParam
    self.name = Memory:ReadCString(addrParam)
    self.position = Memory:ReadInt32(addrParam + 0x4)
    self.token = Memory:ReadInt32(addrParam + 0x8)   
    self.type:ReadType(addrParam + 0xC)  
end