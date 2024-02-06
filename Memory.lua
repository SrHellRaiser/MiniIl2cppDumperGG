Memory = {}

function Memory:ReadInt64(address)
    return gg.getValues({ { address = address, flags = gg.TYPE_QWORD } })[1].value
end

function Memory:ReadInt32(address)
    return gg.getValues({ { address = address, flags = gg.TYPE_DWORD } })[1].value
end

function Memory:ReadInt16(address)
    return gg.getValues({ { address = address, flags = gg.TYPE_WORD } })[1].value
end

function Memory:ReadByte(address)
    return gg.getValues({ { address = address, flags = gg.TYPE_BYTE } })[1].value
end

function Memory:ReadPointer(address)
    if gg.getTargetInfo().x64 then
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
    local value, offset, cstring = 0, 0, {}
    local address = Memory:ReadPointer(ptr);
    while true do
        value = Memory:ReadByte(address + offset)
        if value >= 0 and value <= 0xFF then
            if value == 0 then
                break
            end
            table.insert(cstring, string.char(value))
        end
        offset = offset + 1;
    end
    return table.concat(cstring)
end
