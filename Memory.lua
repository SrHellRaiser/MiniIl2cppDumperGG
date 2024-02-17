local mGG = gg

Memory = {}

function Memory:ReadInt64(address)
    return mGG.getValues({ { address = address, flags = gg.TYPE_QWORD } })[1].value
end

function Memory:ReadInt32(address)
    return mGG.getValues({ { address = address, flags = gg.TYPE_DWORD } })[1].value
end

function Memory:ReadInt16(address)
    return mGG.getValues({ { address = address, flags = gg.TYPE_WORD } })[1].value
end

function Memory:ReadByte(address)
    return mGG.getValues({ { address = address, flags = gg.TYPE_BYTE } })[1].value
end

function Memory:writeFloat(address, value)
    gg.setValues({{address=address, flags=gg.TYPE_FLOAT,value=value}})
end


function Memory:ReadPointer(address)
    if mGG.getTargetInfo().x64 then
        return Memory:ReadInt64(address) & 0xFFFFFFFFFFFFFFFF
    else
        return Memory:ReadInt32(address) & 0xFFFFFFFF
    end
end

function Memory:ReadPointers(address, offsets)
    local tmp_address = address;
    for _, value in ipairs(offsets) do
        tmp_address = Memory:ReadPointer(tmp_address + value);
    end
    return tmp_address;
end

function Memory:ReadCString(ptr)
    local addr = Memory:ReadPointer(ptr);
    local tableC = {
        { address = addr + 0, flags = gg.TYPE_BYTE },
        { address = addr + 1, flags = gg.TYPE_BYTE },
        { address = addr + 2, flags = gg.TYPE_BYTE },
        { address = addr + 3, flags = gg.TYPE_BYTE },
        { address = addr + 4, flags = gg.TYPE_BYTE },
        { address = addr + 5, flags = gg.TYPE_BYTE },
        { address = addr + 6, flags = gg.TYPE_BYTE },
        { address = addr + 7, flags = gg.TYPE_BYTE },
        { address = addr + 8, flags = gg.TYPE_BYTE },
        { address = addr + 9, flags = gg.TYPE_BYTE },
        { address = addr + 10, flags = gg.TYPE_BYTE },
        { address = addr + 11, flags = gg.TYPE_BYTE },
        { address = addr + 12, flags = gg.TYPE_BYTE },
        { address = addr + 13, flags = gg.TYPE_BYTE },
        { address = addr + 14, flags = gg.TYPE_BYTE },
        { address = addr + 15, flags = gg.TYPE_BYTE },
        { address = addr + 16, flags = gg.TYPE_BYTE },
        { address = addr + 17, flags = gg.TYPE_BYTE },
        { address = addr + 18, flags = gg.TYPE_BYTE },
        { address = addr + 19, flags = gg.TYPE_BYTE },
        { address = addr + 20, flags = gg.TYPE_BYTE },
        { address = addr + 21, flags = gg.TYPE_BYTE },
        { address = addr + 22, flags = gg.TYPE_BYTE },
        { address = addr + 23, flags = gg.TYPE_BYTE },
        { address = addr + 24, flags = gg.TYPE_BYTE },
        { address = addr + 25, flags = gg.TYPE_BYTE },
        { address = addr + 26, flags = gg.TYPE_BYTE },
        { address = addr + 27, flags = gg.TYPE_BYTE },
        { address = addr + 28, flags = gg.TYPE_BYTE },
        { address = addr + 29, flags = gg.TYPE_BYTE },
        { address = addr + 30, flags = gg.TYPE_BYTE },
        { address = addr + 31, flags = gg.TYPE_BYTE },
        { address = addr + 32, flags = gg.TYPE_BYTE },
        { address = addr + 33, flags = gg.TYPE_BYTE },
        { address = addr + 34, flags = gg.TYPE_BYTE },
        { address = addr + 35, flags = gg.TYPE_BYTE },
        { address = addr + 36, flags = gg.TYPE_BYTE },
        { address = addr + 37, flags = gg.TYPE_BYTE },
        { address = addr + 38, flags = gg.TYPE_BYTE },
        { address = addr + 39, flags = gg.TYPE_BYTE },
        { address = addr + 40, flags = gg.TYPE_BYTE },
        { address = addr + 41, flags = gg.TYPE_BYTE },
        { address = addr + 42, flags = gg.TYPE_BYTE },
        { address = addr + 43, flags = gg.TYPE_BYTE },
        { address = addr + 44, flags = gg.TYPE_BYTE },
        { address = addr + 45, flags = gg.TYPE_BYTE },
        { address = addr + 46, flags = gg.TYPE_BYTE },
        { address = addr + 47, flags = gg.TYPE_BYTE },
        { address = addr + 48, flags = gg.TYPE_BYTE },
        { address = addr + 49, flags = gg.TYPE_BYTE },
        { address = addr + 50, flags = gg.TYPE_BYTE },
        { address = addr + 51, flags = gg.TYPE_BYTE },
        { address = addr + 52, flags = gg.TYPE_BYTE },
        { address = addr + 53, flags = gg.TYPE_BYTE },
        { address = addr + 54, flags = gg.TYPE_BYTE },
        { address = addr + 55, flags = gg.TYPE_BYTE },
        { address = addr + 56, flags = gg.TYPE_BYTE },
        { address = addr + 57, flags = gg.TYPE_BYTE },
        { address = addr + 58, flags = gg.TYPE_BYTE },
        { address = addr + 59, flags = gg.TYPE_BYTE },
        { address = addr + 60, flags = gg.TYPE_BYTE },
        { address = addr + 61, flags = gg.TYPE_BYTE },
        { address = addr + 62, flags = gg.TYPE_BYTE },
        { address = addr + 63, flags = gg.TYPE_BYTE },
        { address = addr + 64, flags = gg.TYPE_BYTE },
        { address = addr + 65, flags = gg.TYPE_BYTE },
        { address = addr + 66, flags = gg.TYPE_BYTE },
        { address = addr + 67, flags = gg.TYPE_BYTE },
        { address = addr + 68, flags = gg.TYPE_BYTE },
        { address = addr + 69, flags = gg.TYPE_BYTE },
        { address = addr + 70, flags = gg.TYPE_BYTE },
        { address = addr + 71, flags = gg.TYPE_BYTE },
        { address = addr + 72, flags = gg.TYPE_BYTE },
        { address = addr + 73, flags = gg.TYPE_BYTE },
        { address = addr + 74, flags = gg.TYPE_BYTE },
        { address = addr + 75, flags = gg.TYPE_BYTE },
        { address = addr + 76, flags = gg.TYPE_BYTE },
        { address = addr + 77, flags = gg.TYPE_BYTE },
        { address = addr + 78, flags = gg.TYPE_BYTE },
        { address = addr + 79, flags = gg.TYPE_BYTE },
        { address = addr + 80, flags = gg.TYPE_BYTE },
        { address = addr + 81, flags = gg.TYPE_BYTE },
        { address = addr + 82, flags = gg.TYPE_BYTE },
        { address = addr + 83, flags = gg.TYPE_BYTE },
        { address = addr + 84, flags = gg.TYPE_BYTE },
        { address = addr + 85, flags = gg.TYPE_BYTE },
        { address = addr + 86, flags = gg.TYPE_BYTE },
        { address = addr + 87, flags = gg.TYPE_BYTE },
        { address = addr + 88, flags = gg.TYPE_BYTE },
        { address = addr + 89, flags = gg.TYPE_BYTE },
        { address = addr + 90, flags = gg.TYPE_BYTE },
        { address = addr + 91, flags = gg.TYPE_BYTE },
        { address = addr + 92, flags = gg.TYPE_BYTE },
        { address = addr + 93, flags = gg.TYPE_BYTE },
        { address = addr + 94, flags = gg.TYPE_BYTE },
        { address = addr + 95, flags = gg.TYPE_BYTE },
        { address = addr + 96, flags = gg.TYPE_BYTE },
        { address = addr + 97, flags = gg.TYPE_BYTE },
        { address = addr + 98, flags = gg.TYPE_BYTE },
        { address = addr + 99, flags = gg.TYPE_BYTE },
        { address = addr + 100, flags = gg.TYPE_BYTE },
        { address = addr + 101, flags = gg.TYPE_BYTE },
        { address = addr + 102, flags = gg.TYPE_BYTE },
        { address = addr + 103, flags = gg.TYPE_BYTE },
        { address = addr + 104, flags = gg.TYPE_BYTE },
        { address = addr + 105, flags = gg.TYPE_BYTE },
        { address = addr + 106, flags = gg.TYPE_BYTE },
        { address = addr + 107, flags = gg.TYPE_BYTE },
        { address = addr + 108, flags = gg.TYPE_BYTE },
        { address = addr + 109, flags = gg.TYPE_BYTE },
        { address = addr + 110, flags = gg.TYPE_BYTE },
        { address = addr + 111, flags = gg.TYPE_BYTE },
        { address = addr + 112, flags = gg.TYPE_BYTE },
        { address = addr + 113, flags = gg.TYPE_BYTE },
        { address = addr + 114, flags = gg.TYPE_BYTE },
        { address = addr + 115, flags = gg.TYPE_BYTE },
        { address = addr + 116, flags = gg.TYPE_BYTE },
        { address = addr + 117, flags = gg.TYPE_BYTE },
        { address = addr + 118, flags = gg.TYPE_BYTE },
        { address = addr + 119, flags = gg.TYPE_BYTE },
        { address = addr + 120, flags = gg.TYPE_BYTE },
    }
    local cstring ={}
    local rs =  gg.getValues(tableC)
    if type(rs) ~= "string" then
        for _, r in ipairs(rs) do
            if r.value >= 0 and r.value <= 255 then
                if r.value == 0 then
                    break
                end
                table.insert(cstring, r.value)
            end
        end
    end
    return string.char(table.unpack(cstring))
end
