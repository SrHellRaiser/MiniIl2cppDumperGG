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



gg.showUiButton()
while true do
    if gg.isClickedUiButton() then --CharacterLinker//
        local index = gg.choice({ "Get Fields GameController", "Get Fields Select", nil, "Menu" })
        local aGameController = Memory:ReadPointers(BaseIl2Cpp, {0x5427F40 , 0x5C, 0 })
        if index == 1 then
            local KGameController = IL2Class32:new(29)
            KGameController:readClass(Memory:ReadPointer(aGameController))
            KGameController:readFields()
            KGameController:readHierarchys()
            gg.clearList()
            for _, value in ipairs(KGameController:getFields()) do
                gg.addListItems({ { address = aGameController + value.offset, flags = value.type:getTypeGG(), name = value:getName() } })
            end
        end
        if index == 2 then
            local s = IL2Class32:new(29)
            local select = gg.getSelectedListItems()[1].value
            gg.clearList()
            s:readClass(Memory:ReadPointer(select))
            s:readFields()
            s:readHierarchys()
            for _, value in ipairs(s:getFields()) do
                gg.addListItems({ { address = select + value.offset, flags = value.type:getTypeGG(), name = value:getName() } })
            end
        end

    end
end
