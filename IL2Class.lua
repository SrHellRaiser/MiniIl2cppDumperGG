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
    }
    setmetatable(object, self);
    self.__index = self
    self.unityVersion = unityVersion
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

IL2Class32 = IL2Class:new(0)
function IL2Class32:new(version)
    local object = IL2Class:new(version)
    object.fields = {}
    setmetatable(object, self)
    self.__index = self
    return object
end

function IL2Class32:readClass(kclassAddr)
  
    if self.unityVersion >= 18 and self.unityVersion <= 29 then
        -- names
        self.name = Memory:ReadCString(kclassAddr + 0x8)
        self.nameSpace = Memory:ReadCString(kclassAddr + 0xC)
        --fields
        self.fieldsCount = Memory:ReadInt16(kclassAddr + 0xA8)

        for i = 1, self.fieldsCount do
            local tmpField = IL2Field32:new(self.unityVersion)
            tmpField:ReadField(kclassAddr + 0x40,i)
            table.insert(self.fields,tmpField)
            gg.toast(string.format("⏲ %d Read fields....⏲",(i * 100 / self.fieldsCount)),true)
        end
        --methods
        self.methodsCount = Memory:ReadInt16(kclassAddr + 0xA4)
        for i = 1, self.methodsCount do
            local tmpMethod = IL2Method32:new(self.unityVersion)
             tmpMethod:ReadMethod(kclassAddr + 0x4C,i)
             table.insert(self.methods,tmpMethod)
             gg.toast(string.format("⏲ %d Read methods....⏲",(i * 100 / self.methodsCount)),true)
        end
    end
end

