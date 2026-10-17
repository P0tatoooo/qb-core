-- The clothing lists of shared/main.lua (gloves, big bags, bulletproof vests): loaded from shared/clothinglists.json,
-- published in GlobalState.clothingLists for the clients, saved back by MyCity_AdminMenu (export SetClothingList).
local FILE = 'shared/clothinglists.json'
local MAX_DRAWABLE = 4095

local data = {}

local function load()
    local raw = LoadResourceFile(GetCurrentResourceName(), FILE)
    local ok, decoded = pcall(json.decode, raw or '')
    if not ok or type(decoded) ~= 'table' then
        print(('^1[qb-core] %s unreadable: clothing lists empty^0'):format(FILE))
        decoded = {}
    end
    for _, name in ipairs(QBShared.ClothingLists) do
        data[name] = type(decoded[name]) == 'table' and decoded[name] or {}
    end
    QBShared.ApplyClothingLists(data)
    GlobalState.clothingLists = data
end

--- One list per line, in the order of QBShared.ClothingLists: readable diffs.
local function encode()
    local lines = {}
    for _, name in ipairs(QBShared.ClothingLists) do
        local numbers = {}
        for i, drawable in ipairs(data[name]) do numbers[i] = tostring(drawable) end
        lines[#lines + 1] = ('    "%s": [%s]'):format(name, table.concat(numbers, ', '))
    end
    return '{\n' .. table.concat(lines, ',\n') .. '\n}\n'
end

--- @return table { MaleGloves = { 16, 17, ... }, ... }
local function GetClothingLists()
    return data
end

--- Replaces one list (drawable numbers) and saves the file. @return boolean, string|nil error
local function SetClothingList(name, drawables)
    local known = false
    for _, n in ipairs(QBShared.ClothingLists) do known = known or n == name end
    if not known then return false, 'list' end
    if type(drawables) ~= 'table' then return false, 'invalid' end

    local set, list = {}, {}
    for _, value in pairs(drawables) do
        local drawable = math.tointeger(tonumber(value))
        if not drawable or drawable < 0 or drawable > MAX_DRAWABLE then return false, 'invalid' end
        if not set[drawable] then set[drawable] = true; list[#list + 1] = drawable end
    end
    table.sort(list)

    local previous = data[name]
    data[name] = list
    if not SaveResourceFile(GetCurrentResourceName(), FILE, encode(), -1) then
        data[name] = previous
        print(('^1[qb-core] could not write %s^0'):format(FILE))
        return false, 'file'
    end
    QBShared.ApplyClothingLists(data)
    GlobalState.clothingLists = data
    return true
end

exports('GetClothingLists', GetClothingLists)
exports('SetClothingList', SetClothingList)

load()
