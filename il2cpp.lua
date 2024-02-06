require("Memory")
require("FieldInfo")
require("MethodInfo")

Il2CppClass = {}
function Il2CppClass:new()
    local object = {
        ptrName = nil,
        ptrNameSpace = nil,
        fieldsPtr = nil,
        methodsPtr = nil,
        fieldsCount = 0,
        methodsCount = 0,
        propertyCount = 0,
        ptrStaticFields = nil,
    }
    setmetatable(object, self);
    self.__index = self
    self._VERSION = nil
    return object
end

function Il2CppClass:GetName()
    assert(self._VERSION ~= nil, "Não disponivel")
    assert(Memory:ReadPointer(self.ptrName) ~= 0, "Não foi possível obter o nome da class; o ponteiro está nulo.")
    return Memory:ReadCString(self.ptrName);
end

function Il2CppClass:GetNameSpace()
    assert(self._VERSION ~= nil, "Não disponivel")
    assert(Memory:ReadPointer(self.ptrNameSpace) ~= 0,
        "Não foi possível obter o nome da name_space; o ponteiro está nulo.")
    return Memory:ReadCString(self.ptrNameSpace);
end

function Il2CppClass:GetFields()
    error("Método abstrato deve ser implementado na classe concreta.")
end

function Il2CppClass:GetMethods()
    error("Método abstrato deve ser implementado na classe concreta.")
end

Il2CppClassV27 = Il2CppClass:new()
function Il2CppClassV27:new(kclassPtr)
    local object = Il2CppClass:new()

    if gg.getTargetInfo().x64 then

    else
        local kclassAddr = Memory:ReadPointer(kclassPtr)
        -- names
        object.ptrName = kclassAddr + 0x8
        object.ptrNameSpace = kclassAddr + 0xC

        --fields
        object.fieldsPtr = kclassAddr + 0x40
        object.fieldsCount = Memory:ReadInt16(kclassAddr + 0xA8)

        --methods
        object.methodsPtr = kclassAddr + 0x4C
        object.methodsCount = Memory:ReadInt16(kclassAddr + 0xA4)

        --static
        object.ptrStaticFields = kclassAddr + 0x5C
    end
    setmetatable(object, self)
    self.__index = self
    self._VERSION = 27
    return object
end

function Il2CppClassV27:GetFields()
    local objects = {}
    for index = 1, self.fieldsCount do
        if gg.getTargetInfo().x64 then
        else
            local info_field = FieldInfo32:new(self, index)
            table.insert(objects, info_field)
        end
    end
    return objects
end


function Il2CppClassV27:GetMethods()
    local objects = {}
    for index = 1, self.methodsCount-1 do
        if gg.getTargetInfo().x64 then
        else
            local methods = MethodInfo32:new(self, index)
            table.insert(objects, methods)
        end
    end
    return objects
end

