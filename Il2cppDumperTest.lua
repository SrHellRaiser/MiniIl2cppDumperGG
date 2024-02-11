require("Memory")
require("IL2Class")


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

function getCorLibSize(ptr) 
    local _start = Memory:ReadPointer(ptr);
    local _end = Memory:ReadPointer(ptr + 0x4);
    return ((_end - _start) >> 2) 
end

local BaseIl2Cpp = FindBaseAddressApp("libil2cpp.so")
local aGameController = Memory:ReadPointer(BaseIl2Cpp + 0x10353D4);
local KGameController = IL2Class32:new(27)
KGameController:readClass(aGameController)
for _, value in ipairs(KGameController:getFields()) do
    --print(value.parametersCount)
    print(string.format("%s %s //0x%X",value:getTypeName(),value:getName(), value.offset))

end
