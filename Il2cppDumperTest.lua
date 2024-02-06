require("Memory")
require("Il2CppTypes")
require("Il2Cpp")


function FindBaseAddressApp(libname)
    local list = gg.getRangesList(gg.getTargetInfo().nativeLibraryDir .. '/' .. libname)
    if list ~= nil then
        for _, value in ipairs(list) do
            if value.state == 'Xa' then
                return value.start;
            end
        end
    end
    return -1;
end

local BaseIl2Cpp = FindBaseAddressApp("libil2cpp.so")
local transform = Il2CppClassV27:new(BaseIl2Cpp + 16998936)
print(transform:GetName())
for _, method in ipairs(transform:GetMethods()) do
    print(string.format("Name:%s | Offset:0x%X",method:GetName(), method:GetOffset()))
end
