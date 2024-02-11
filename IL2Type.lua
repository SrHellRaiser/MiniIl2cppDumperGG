require("IL2Const")
gg.TYPE_PTR = gg.getTargetInfo().x64 and gg.TYPE_QWORD or gg.TYPE_DWORD

local Il2CppTypeName = {}
Il2CppTypeName[Il2CppTypeEnum.IL2CPP_TYPE_VOID] = "void"
Il2CppTypeName[Il2CppTypeEnum.IL2CPP_TYPE_STRING] = "string"
Il2CppTypeName[Il2CppTypeEnum.IL2CPP_TYPE_OBJECT] = "object"
Il2CppTypeName[Il2CppTypeEnum.IL2CPP_TYPE_BOOLEAN] = "bool"
Il2CppTypeName[Il2CppTypeEnum.IL2CPP_TYPE_CHAR] = "char"
Il2CppTypeName[Il2CppTypeEnum.IL2CPP_TYPE_I1] = "sbyte"
Il2CppTypeName[Il2CppTypeEnum.IL2CPP_TYPE_U1] = "byte"
Il2CppTypeName[Il2CppTypeEnum.IL2CPP_TYPE_I2] = "short"
Il2CppTypeName[Il2CppTypeEnum.IL2CPP_TYPE_U2] = "ushort"
Il2CppTypeName[Il2CppTypeEnum.IL2CPP_TYPE_I4] = "int"
Il2CppTypeName[Il2CppTypeEnum.IL2CPP_TYPE_U4] = "uint"
Il2CppTypeName[Il2CppTypeEnum.IL2CPP_TYPE_I8] = "long"
Il2CppTypeName[Il2CppTypeEnum.IL2CPP_TYPE_U8] = "ulong"
Il2CppTypeName[Il2CppTypeEnum.IL2CPP_TYPE_R4] = "float"
Il2CppTypeName[Il2CppTypeEnum.IL2CPP_TYPE_R8] = "double"
Il2CppTypeName[Il2CppTypeEnum.IL2CPP_TYPE_VAR] = "var"
Il2CppTypeName[Il2CppTypeEnum.IL2CPP_TYPE_SZARRAY] = "[]"
Il2CppTypeName[Il2CppTypeEnum.IL2CPP_TYPE_CLASS] = "gobject"
Il2CppTypeName[Il2CppTypeEnum.IL2CPP_TYPE_VALUETYPE] = "struct"

local Il2CppTypeGG = {}
Il2CppTypeGG[Il2CppTypeEnum.IL2CPP_TYPE_STRING] = gg.TYPE_PTR
Il2CppTypeGG[Il2CppTypeEnum.IL2CPP_TYPE_OBJECT] = gg.TYPE_PTR
Il2CppTypeGG[Il2CppTypeEnum.IL2CPP_TYPE_BOOLEAN] = gg.TYPE_BYTE
Il2CppTypeGG[Il2CppTypeEnum.IL2CPP_TYPE_CHAR] = gg.TYPE_BYTE
Il2CppTypeGG[Il2CppTypeEnum.IL2CPP_TYPE_I1] = gg.TYPE_BYTE
Il2CppTypeGG[Il2CppTypeEnum.IL2CPP_TYPE_U1] = gg.TYPE_BYTE
Il2CppTypeGG[Il2CppTypeEnum.IL2CPP_TYPE_I2] = gg.TYPE_WORD
Il2CppTypeGG[Il2CppTypeEnum.IL2CPP_TYPE_U2] = gg.TYPE_WORD
Il2CppTypeGG[Il2CppTypeEnum.IL2CPP_TYPE_I4] = gg.TYPE_DWORD
Il2CppTypeGG[Il2CppTypeEnum.IL2CPP_TYPE_U4] = gg.TYPE_DWORD
Il2CppTypeGG[Il2CppTypeEnum.IL2CPP_TYPE_I8] = gg.TYPE_QWORD
Il2CppTypeGG[Il2CppTypeEnum.IL2CPP_TYPE_U8] = gg.TYPE_QWORD
Il2CppTypeGG[Il2CppTypeEnum.IL2CPP_TYPE_R4] = gg.TYPE_FLOAT
Il2CppTypeGG[Il2CppTypeEnum.IL2CPP_TYPE_R8] = gg.TYPE_DOUBLE


IL2Type = {}
function IL2Type:new()
    local object = {
        type = 0,
        attrs = 0,
        subtype = 0
    }
    setmetatable(object, self)
    self.__index = self
    self.__typePtr = nil
    return object
end

function IL2Type:ReadType() end

function IL2Type:isStatic()
    return self.attrs & FIELD_ATTRIBUTE_STATIC == FIELD_ATTRIBUTE_STATIC
end

function IL2Type:isPublic()
    return self.attrs & FIELD_ATTRIBUTE_PUBLIC == FIELD_ATTRIBUTE_PUBLIC
end

function IL2Type:isPrivate()
    return self.attrs & FIELD_ATTRIBUTE_PRIVATE == FIELD_ATTRIBUTE_PRIVATE
end

function IL2Type:isProtect()
    return self.attribute & FIELD_ATTRIBUTE_FAMILY == FIELD_ATTRIBUTE_FAMILY
end

function IL2Type:isInternal()
    return self.attribute & FIELD_ATTRIBUTE_ASSEMBLY == FIELD_ATTRIBUTE_ASSEMBLY
end

function IL2Type:isProtectInternal()
    return self.attribute & FIELD_ATTRIBUTE_FAM_OR_ASSEM == FIELD_ATTRIBUTE_FAM_OR_ASSEM
end

function IL2Type:isReadOnline()
    return self.attribute & FIELD_ATTRIBUTE_INIT_ONLY == FIELD_ATTRIBUTE_INIT_ONLY
end

function IL2Type:isConst()
    return self.attribute & FIELD_ATTRIBUTE_LITERAL == FIELD_ATTRIBUTE_LITERAL
end

function IL2Type:getTypeName()
    if self.type == Il2CppTypeEnum.IL2CPP_TYPE_SZARRAY then
        return Il2CppTypeName[self.subtype] .. Il2CppTypeName[self.type]
    end
    return Il2CppTypeName[self.type]
end

function IL2Type:getTypeGG()
    return Il2CppTypeGG[self.type]
end

IL2Type32 = IL2Type:new()
function IL2Type32:new()
    local object = IL2Type:new()
    setmetatable(object, self)
    self.__index = self
    return object
end

--- Read the values for the type and attrs variables.
--- @return boolean --Returns true if TypePtr is not null
function IL2Type32:ReadType(typePtr)
    local addrType = Memory:ReadPointer(typePtr)
    if addrType == 0 then
        return false
    end

    self.type = Memory:ReadInt32(addrType + 0x4) >> 16
    self.type = self.type & 0xFF

    if self.type == Il2CppTypeEnum.IL2CPP_TYPE_SZARRAY then
        local addrSubType = Memory:ReadPointer(addrType) 
        self.subtype = Memory:ReadInt32(addrSubType + 0x4) >> 16
        self.subtype = self.subtype & 0xFF
    end

    self.attrs = Memory:ReadInt32(addrType + 0x4) & 0xFF
    return true
end


IL2Type64 = IL2Type:new()
function IL2Type64:new()
    local object = IL2Type:new()
    setmetatable(object, self)
    self.__index = self
    return object
end

--- Read the values for the type and attrs variables.
--- @return boolean --Returns true if TypePtr is not null
function IL2Type64:ReadType(typePtr)
    local addrType = Memory:ReadPointer(typePtr)
    if addrType == 0 then
        return false
    end
    self.type = Memory:ReadInt32(addrType + 0x8) >> 16
    self.attrs = Memory:ReadInt32(addrType + 0x8) & 0xFF
    return true
end