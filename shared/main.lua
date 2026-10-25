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

--- Un rang au hasard dans `table` : ni pris en ce moment (`.used`), ni déjà tiré (`usedindexes`, la
--- rotation). Plus rien à tirer alors que des entrées sont libres (celles qui restent hors de la
--- rotation sont toutes prises, par exemple par des PNJ qui gardent leur point) : la rotation
--- repart de zéro. Avant, elle ne repartait qu'une fois pleine, et restait bloquée pour de bon
--- (MyCity_CoreV2, Go Fast : « J'ai plus besoin de toi »). → rang ou -1, rotation
function QBShared.GetRandomIndexFromUsedTable(table, usedindexes)
    usedindexes = usedindexes or {}

    local function candidates()
        local list = {}
        for i = 1, #table do
            if not table[i].used and not indexInTable(i, usedindexes) then list[#list + 1] = i end
        end
        return list
    end

    local list = candidates()
    if #list == 0 and #usedindexes > 0 then
        usedindexes = {}
        list = candidates()
    end
    if #list == 0 then return -1, usedindexes end

    local index = list[math.random(1, #list)]
    usedindexes[#usedindexes + 1] = index
    return index, usedindexes
end

--- Comme GetRandomIndexFromUsedTable, seulement dans la partie de l'île `islandpart` ('north' /
--- 'south', nil : partout). Même remise à zéro de la rotation quand plus rien n'est tirable. Avant,
--- la recherche de secours testait la position du rang tiré au hasard au lieu de chaque entrée.
function QBShared.GetRandomIndexFromUsedTableIslandParts(table, usedindexes, islandpart)
    usedindexes = usedindexes or {}

    local function inPart(entry)
        if islandpart ~= 'north' and islandpart ~= 'south' then return true end
        local coords = entry.coords or vec3(entry.x, entry.y, entry.z)
        return QBShared.IsInNorth(coords) == (islandpart == 'north')
    end

    local function candidates()
        local list = {}
        for i = 1, #table do
            if not table[i].used and not indexInTable(i, usedindexes) and inPart(table[i]) then list[#list + 1] = i end
        end
        return list
    end

    local list = candidates()
    if #list == 0 and #usedindexes > 0 then
        usedindexes = {}
        list = candidates()
    end
    if #list == 0 then return -1, usedindexes end

    local index = list[math.random(1, #list)]
    usedindexes[#usedindexes + 1] = index
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

-- Gloves that hide the fingerprints (arms, component 3), bags big enough for a long weapon (component 5), real
-- bulletproof vests (component 9), helmets that hide the face (hats, prop 0) and masks that hide it even partly
-- (component 1), as [drawable] = true. The lists live in shared/clothinglists.json, edited from
-- MyCity_AdminMenu (page Vêtements Spéciaux): the server loads them and publishes them in GlobalState.clothingLists
-- (server/clothinglists.lua), clients fill these tables from it (client/clothinglists.lua). Filled in place, so a
-- change reaches everything that reads them through qb-core (IsWearingGloves, IsWearingBag, IsABulletproofVest).
QBShared.ClothingLists = { 'MaleGloves', 'FemaleGloves', 'MaleBulletproof', 'FemaleBulletproof', 'MaleBags', 'FemaleBags',
    'MaleHelmets', 'FemaleHelmets', 'MaleMasks', 'FemaleMasks' }
for _, name in ipairs(QBShared.ClothingLists) do
    QBShared[name] = {}
end

--- Fills the clothing list tables in place from { MaleGloves = { 16, 17, ... }, ... }.
--- Into QBCore.Shared as well when it is another table (QBCore:Client:SharedUpdate replaces it on connect).
function QBShared.ApplyClothingLists(data)
    if type(data) ~= 'table' then return end
    local targets = { QBShared }
    if QBCore and QBCore.Shared and QBCore.Shared ~= QBShared then targets[2] = QBCore.Shared end
    for _, shared in ipairs(targets) do
        for _, name in ipairs(QBShared.ClothingLists) do
            local list = shared[name] or {}
            shared[name] = list
            for k in pairs(list) do list[k] = nil end
            for _, drawable in ipairs(type(data[name]) == 'table' and data[name] or {}) do
                list[drawable] = true
            end
        end
    end
end

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