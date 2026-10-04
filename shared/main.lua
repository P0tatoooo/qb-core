QBShared = QBShared or {}

local StringCharset = {}
local NumberCharset = {}

QBShared.StarterItems = {
    ['welcomeflyer'] = { amount = 1, item = 'welcomeflyer' },
    ['money'] = { amount = 500, item = 'money' },
}

function QBShared.IsInNorth(coords)
    return coords.y > 1310
end

for i = 48, 57 do NumberCharset[#NumberCharset + 1] = string.char(i) end
for i = 65, 90 do StringCharset[#StringCharset + 1] = string.char(i) end
for i = 97, 122 do StringCharset[#StringCharset + 1] = string.char(i) end

function QBShared.RandomStr(length)
    if length <= 0 then return '' end
    return QBShared.RandomStr(length - 1) .. StringCharset[math.random(1, #StringCharset)]
end

function QBShared.RandomInt(length)
    if length <= 0 then return '' end
    return QBShared.RandomInt(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
end

function QBShared.SplitStr(str, delimiter)
    local result = {}
    local from = 1
    local delim_from, delim_to = string.find(str, delimiter, from)
    local timeout = GetGameTimer() + 2000
    while delim_from and GetGameTimer() < timeout do
        result[#result + 1] = string.sub(str, from, delim_from - 1)
        from = delim_to + 1
        delim_from, delim_to = string.find(str, delimiter, from)
        Citizen.Wait(0)
    end
    result[#result + 1] = string.sub(str, from)
    return result
end

function QBShared.Trim(value)
    if not value then return nil end
    return (string.gsub(value, '^%s*(.-)%s*$', '%1'))
end

function QBShared.FirstToUpper(value)
    if not value then return nil end
    value = value:lower()
    return (value:gsub("^%l", string.upper))
end

function QBShared.Round(value, numDecimalPlaces)
    if not numDecimalPlaces then return math.floor(value + 0.5) end
    local power = 10 ^ numDecimalPlaces
    return math.floor((value * power) + 0.5) / (power)
end

function QBShared.GroupDigits(value)
    value = QBShared.Round(value)
    local left,num,right = string.match(value,'^([^%d]*%d)(%d*)(.-)$')

	return left..(num:reverse():gsub('(%d%d%d)','%1' .. ' '):reverse())..right
end

local function indexInTable(index, table)
    for k,v in pairs(table) do
        if v == index then
            return true
        end
    end
    return false
end

function QBShared.GetRandomIndexFromUsedTable(table, usedindexes)
    math.random(GetGameTimer())

    if #usedindexes == #table then usedindexes = {} end

    local index = -1
    local randomIndex = math.random(1, #table)
    local timeout = GetGameTimer() + 2000

    while (table[randomIndex].used or indexInTable(randomIndex, usedindexes)) and GetGameTimer() < timeout do
        Citizen.Wait(0)
        randomIndex = math.random(1, #table)
    end

    if table[randomIndex].used or indexInTable(randomIndex, usedindexes) then
        for i=1, #table do
            if not table[i].used and not indexInTable(i, usedindexes) then
                index = i
                break
            end
        end
    else
        index = randomIndex
    end

    if index and index ~= -1 then
        usedindexes[#usedindexes+1] = index
    end

    return index, usedindexes
end

function QBShared.GetRandomIndexFromUsedTableIslandParts(table, usedindexes, islandpart)
    math.random(GetGameTimer())

    if #usedindexes == #table then usedindexes = {} end

    local index = -1
    local randomIndex = math.random(1, #table)
    local timeout = GetGameTimer() + 2000
    local isNorth

    while (table[randomIndex].used or indexInTable(randomIndex, usedindexes) or ((islandpart == "south" and isNorth) or (islandpart == "north" and not isNorth))) and GetGameTimer() < timeout do
        Citizen.Wait(0)
        randomIndex = math.random(1, #table)
        local coords = table[randomIndex].coords or vec3(table[randomIndex].x, table[randomIndex].y, table[randomIndex].z)
        isNorth = QBShared.IsInNorth(coords)
    end

    if table[randomIndex].used or indexInTable(randomIndex, usedindexes) or ((islandpart == "south" and isNorth) or (islandpart == "north" and not isNorth)) then
        for i=1, #table do
            local coords = table[randomIndex].coords or vec3(table[randomIndex].x, table[randomIndex].y, table[randomIndex].z)
            isNorth = QBShared.IsInNorth(coords)
            if not table[i].used and not indexInTable(i, usedindexes) and not ((islandpart == "south" and isNorth) or (islandpart == "north" and not isNorth)) then
                index = i
                break
            end
        end
    else
        index = randomIndex
    end

    if index and index ~= -1 then
        usedindexes[#usedindexes+1] = index
    end

    return index, usedindexes
end

function QBShared.GetRectangleCenter(c1, c2, c3, c4)
    return vector3(
        (c1.x + c2.x + c3.x + c4.x) / 4,
        (c1.y + c2.y + c3.y + c4.y) / 4,
        (c1.z + c2.z + c3.z + c4.z) / 4
    )
end

function QBShared.DeepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[QBShared.DeepCopy(orig_key)] = QBShared.DeepCopy(orig_value)
        end
        setmetatable(copy, QBShared.DeepCopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function QBShared.ChangeVehicleExtra(vehicle, extra, enable)
    if DoesExtraExist(vehicle, extra) then
        if enable then
            SetVehicleExtra(vehicle, extra, false)
            if not IsVehicleExtraTurnedOn(vehicle, extra) then
                QBShared.ChangeVehicleExtra(vehicle, extra, enable)
            end
        else
            SetVehicleExtra(vehicle, extra, true)
            if IsVehicleExtraTurnedOn(vehicle, extra) then
                QBShared.ChangeVehicleExtra(vehicle, extra, enable)
            end
        end
    end
end

function QBShared.SetDefaultVehicleExtras(vehicle, config)
    -- Clear Extras
    for i = 1, 20 do
        if DoesExtraExist(vehicle, i) then
            SetVehicleExtra(vehicle, i, 1)
        end
    end

    for id, enabled in pairs(config) do
        QBShared.ChangeVehicleExtra(vehicle, tonumber(id), type(enabled) == 'boolean' and enabled or true)
    end
end

function QBShared.CheckBlPlate(plate)
    if string.match(plate, 'MCE') or string.match(plate, 'MIS') or string.match(plate, 'REN') or string.match(plate, 'LSPD') or string.match(plate, 'BCSO') then
        return true
    else
        return false
    end
end

--- Get the closest grid point to given coordinates
function QBShared.GetClosestGridPoint(x, y)
    local GRID_STEP = 100

    -- Snap the coordinates to the nearest multiple of GRID_STEP
    local closestX = math.floor((x + GRID_STEP / 2) / GRID_STEP) * GRID_STEP
    local closestY = math.floor((y + GRID_STEP / 2) / GRID_STEP) * GRID_STEP

    return vector2(closestX, closestY)
end

function QBShared.GetNearbyGridPoints(coords)
    x = coords.x
    y = coords.y

    local GRID_STEP = 100
    -- Get the closest grid point
    local closestX = math.floor((x + GRID_STEP / 2) / GRID_STEP) * GRID_STEP
    local closestY = math.floor((y + GRID_STEP / 2) / GRID_STEP) * GRID_STEP

    local points = {}

    -- Loop through a 5x5 square around the closest point
    for dx = -2 * GRID_STEP, 2 * GRID_STEP, GRID_STEP do
        for dy = -2 * GRID_STEP, 2 * GRID_STEP, GRID_STEP do
            local px = closestX + dx
            local py = closestY + dy

            table.insert(points, vector2(px, py))
        end
    end

    return points
end

QBShared.MaleGloves = {
}

QBShared.FemaleGloves = {
}

QBShared.MaleBulletproof = {
}

QBShared.FemaleBulletproof = {
}

QBShared.MaleBags = {

}

QBShared.FemaleBags = {

}

QBShared.SalaryPeriods = {
    { label = "Aucune", time = 0 },
    { label = "5 minutes", time = 5 * 60000 },
    { label = "10 minutes", time = 10 * 60000 },
    { label = "15 minutes", time = 15 * 60000 },
    { label = "20 minutes", time = 20 * 60000 },
    { label = "30 minutes", time = 30 * 60000 },
    { label = "1 heure", time = 60 * 60000 },
}

QBShared.PublicJobs = {
    ["police"] = 0,
    ["sheriff"] = 0,
    ["ambulance"] = 0, 
    ['government'] = 0,
    ['lawyer'] = 0,
    ['gruppe6'] = 0,
    ['ammunation'] = 0,
    ['weazelnews'] = 0,
}

QBShared.PublicJobsAndCivil = {
    ["civil"] = 0,
    ["police"] = 0,
    ["sheriff"] = 0,
    ["ambulance"] = 0, 
    ['government'] = 0,
    ['lawyer'] = 0,
    ['gruppe6'] = 0,
    ['ammunation'] = 0,
    ['weazelnews'] = 0,
}