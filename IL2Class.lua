require("Memory")
require("IL2Method")
require("IL2Field")

IL2Class = {}
function IL2Class:new(unityVersion)
    local object = {
        name = nil,
        nameSpace = nil,
        fields = {},
        methods = {},
        fieldsCount = 0,
        methodsCount = 0,
        typeHierarchy = {}
    }
    setmetatable(object, self);
    self.__index = self
    self.unityVersion = unityVersion
    self.__cache_addr = nil
    self.__fieldPtr = nil
    self.__methodPtr = nil
    return object
end

function IL2Class:getName()
    return self.name
end

function IL2Class:getNameSpace()
    return self.nameSpace
end

function IL2Class:getFields()
    return self.fields;
end

function IL2Class:getMethods()
    return self.methods
end

function IL2Class:readFields()
    for i = 1, self.fieldsCount do
        local tmpField = IL2Field32:new(self.unityVersion)
        tmpField:ReadField(self.__fieldPtr, i)
        table.insert(self.fields, tmpField)
        gg.toast(string.format("⏲ %d Read fields....⏲", (i * 100 / self.fieldsCount)), true)
    end
end

function IL2Class:readMethods()
    self.methodsCount = Memory:ReadInt16(self.__methodPtr)
    for i = 1, self.methodsCount do
        local tmpMethod = IL2Method32:new(self.unityVersion)
        tmpMethod:ReadMethod(self.__methodPtr, i)
        table.insert(self.methods, tmpMethod)
        gg.toast(string.format("⏲ %d Read methods....⏲", (i * 100 / self.methodsCount)), true)
    end
end

IL2Class32 = IL2Class:new(0)
function IL2Class32:new(version)
    local object = IL2Class:new(version)
    object.fields = {}
    object.typeHierarchy = {}
    setmetatable(object, self)
    self.__index = self
    self.__cache_addr = nil
    return object
end


function IL2Class32:readClass(kclassAddr)
    self.__cache_addr = kclassAddr
    if self.unityVersion >= 18 and self.unityVersion <= 29 then
        -- names
        self.name = Memory:ReadCString(kclassAddr + 0x8)
        self.nameSpace = Memory:ReadCString(kclassAddr + 0xC)
        --fields
        self.fieldsCount = Memory:ReadInt16(kclassAddr + 0xA8)
        self.__fieldPtr = self.__cache_addr + 0x40
        --methods
        self.__methodPtr = self.__cache_addr + 0x4C
        self.methodsCount = Memory:ReadInt16(kclassAddr + 0xA4)
    end
end

function IL2Class32:readHierarchys()
    local typeHierarchy = Memory:ReadPointer(self.__cache_addr + 0x64)
    local count         = 2;
    repeat
        local kclassAddr = Memory:ReadPointer(typeHierarchy + count * 4)
        local kclassHierarchys  = IL2Class32:new(self.unityVersion)
        kclassHierarchys:readClass(kclassAddr)
        kclassHierarchys:readFields()
        for _, value in ipairs(kclassHierarchys:getFields()) do
            table.insert(self.fields, value)
        end
        if kclassAddr == self.__cache_addr then
            break;
        end
        count = count + 1
    until self.__cache_addr ==  kclassAddr
end
