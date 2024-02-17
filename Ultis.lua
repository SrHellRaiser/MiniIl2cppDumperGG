require("IL2Class")
local json = require("json")

Tokens = {}

GLOBAL_TOKENS = {}

function Tokens:new()
    local object = {
        tokens = {
        }
    }
    self.__index = self
    setmetatable(object, self)
    return object;
end

function Tokens:ReadTokens(kclassList)
    local addrKlassList = Memory:ReadPointer(kclassList);
    for i = 0, 0x56CB do
        local kclass = Memory:ReadPointer(addrKlassList + (i * 4))
        local gKlass = IL2Class32:new(29);
        gKlass:readClass(kclass)
        local pt_addr = gKlass.token - gg.getRangesList("global-metadata.dat")[1].start
        table.insert(self.tokens, { name=gKlass.name ,value=string.format("%X", pt_addr) })
    end
end

function Tokens:load()
    local f = gg.CACHE_DIR .. '/' .. 'tokens.json'
    -- Open the file for reading
    local lines = {}
    local file = io.open(f, "r")

    -- Check if the file was opened successfully
    if not file then
        print("Error: Unable to open the file.")
        return
    end

    -- Read all lines from the file
    for line in file:lines() do
        table.insert(lines,line)
    end
    self.tokens = json.decode(table.concat(lines))

end

function Tokens:findToken(token)
    for i = 1, #self.tokens do
        if tonumber(self.tokens[i].value,16) == token then
            return self.tokens[i].name
        end
    end
    return "not_found"
end

function Tokens:save()
    local f = io.open(gg.CACHE_DIR .. '/' .. 'tokens.json', "w+")
    if f ~= nil then
        local s = json.encode(self.tokens)
        f:write(s);
    end
end
