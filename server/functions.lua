QBCore.Functions = {}
QBCore.Player_Buckets = {}
QBCore.Entity_Buckets = {}
QBCore.UsableItems = {}

-- Getters
-- Get your player first and then trigger a function on them
-- ex: local player = QBCore.Functions.GetPlayer(source)
-- ex: local example = player.Functions.functionname(parameter)

---Gets the coordinates of an entity
---@param entity number
---@return vector4
function QBCore.Functions.GetCoords(entity)
    local coords = GetEntityCoords(entity, false)
    local heading = GetEntityHeading(entity)
    return vector4(coords.x, coords.y, coords.z, heading)
end

---Gets player identifier of the given type
---@param source any
---@param idtype string
---@return string?
function QBCore.Functions.GetIdentifier(source, idtype)
    if GetConvarInt('sv_fxdkMode', 0) == 1 then return 'license:fxdk' end
    return GetPlayerIdentifierByType(source, idtype or 'license')
end

---Gets a players server id (source). Returns 0 if no player is found.
---@param identifier string
---@return number
function QBCore.Functions.GetSource(identifier)
    for src, _ in pairs(QBCore.Players) do
        local idens = GetPlayerIdentifiers(src)
        for _, id in pairs(idens) do
            if identifier == id then
                return src
            end
        end
    end
    return 0
end

---Get player name with given server id (source)
---@param source any
---@return table
function QBCore.Functions.GetPlayerName(source)
    if type(source) == 'number' then
        return ((QBCore.Players[source].PlayerData.charinfo.firstname or ' ') .. ' ' .. (QBCore.Players[source].PlayerData.charinfo.lastname or ' '))
    else
        return 'source error'
    end
end

---Get player with given server id (source)
---@param source any
---@return table
function QBCore.Functions.GetPlayer(source)
    if type(source) == 'number' then
        return QBCore.Players[source]
    else
        return QBCore.Players[QBCore.Functions.GetSource(source)]
    end
end

---Get player by citizen id
---@param citizenid string
---@return table?
function QBCore.Functions.GetPlayerByCitizenId(citizenid)
    for src in pairs(QBCore.Players) do
        if QBCore.Players[src].PlayerData.citizenid == citizenid then
            return QBCore.Players[src]
        end
    end
    return nil
end

---Get offline player by citizen id
---@param citizenid string
---@return table?
function QBCore.Functions.GetOfflinePlayerByCitizenId(citizenid)
    local xPlayer = QBCore.Functions.GetPlayerByCitizenId(citizenid)
    if xPlayer then return xPlayer end
    return QBCore.Player.GetOfflinePlayer(citizenid)
end

---Get player by discord id
function QBCore.Functions.GetPlayerByDiscordId(discordid)
    for src in pairs(QBCore.Players) do
        if QBCore.Players[src].PlayerData.discord == discordid then
            return QBCore.Players[src]
        end
    end
    return nil
end

---Get offline player by discord id
function QBCore.Functions.GetOfflinePlayerByDiscordId(discordid)
    local xPlayer = QBCore.Functions.GetPlayerByDiscordId(discordid)
    if xPlayer then return xPlayer end
    return QBCore.Player.GetOfflinePlayer(nil, discordid)
end

---Get player by license
---@param license string
---@return table?
function QBCore.Functions.GetPlayerByLicense(license)
    return QBCore.Player.GetPlayerByLicense(license)
end

---Get player by phone number
---@param number number
---@return table?
function QBCore.Functions.GetPlayerByPhone(number)
    for src in pairs(QBCore.Players) do
        if QBCore.Players[src].PlayerData.phone == number then
            return QBCore.Players[src]
        end
    end
    return nil
end

---Get player by account id
---@param account string
---@return table?
function QBCore.Functions.GetPlayerByAccount(account)
    for src in pairs(QBCore.Players) do
        if QBCore.Players[src].PlayerData.charinfo.account == account then
            return QBCore.Players[src]
        end
    end
    return nil
end

---Get player passing property and value to check exists
---@param property string
---@param value string
---@return table?
function QBCore.Functions.GetPlayerByCharInfo(property, value)
    for src in pairs(QBCore.Players) do
        local charinfo = QBCore.Players[src].PlayerData.charinfo
        if charinfo[property] ~= nil and charinfo[property] == value then
            return QBCore.Players[src]
        end
    end
    return nil
end

---Get all players. Returns the server ids of all players.
---@return table
function QBCore.Functions.GetPlayers()
    local sources = {}
    for k in pairs(QBCore.Players) do
        sources[#sources + 1] = k
    end
    return sources
end

---Will return an array of QB Player class instances
---unlike the GetPlayers() wrapper which only returns IDs
---@return table
function QBCore.Functions.GetQBPlayers()
    return QBCore.Players
end

--- Gets a list of all online players of a specified job or job type and the number
--- @param job string
--- @param checkOnDuty boolean If true, only players on duty will be returned
function QBCore.Functions.GetPlayersByJob(job, checkOnDuty)
    local players = {}
    local count = 0
    for src, Player in pairs(QBCore.Players) do
        local playerData = Player.PlayerData
        if playerData.job.name == job or playerData.job.type == job then
            if checkOnDuty then
                if playerData.job.onduty then
                    players[#players + 1] = src
                    count += 1
                end
            else
                players[#players + 1] = src
                count += 1
            end
        end
    end
    return players, count
end

---Gets a list of all on duty players of a specified job and the number
---@param job string
---@return table, number
function QBCore.Functions.GetPlayersOnDuty(job)
    local players, count = QBCore.Functions.GetPlayersByJob(job, true)
    return players, count
end

---Returns only the amount of players on duty for the specified job
---@param job string
---@return number
function QBCore.Functions.GetDutyCount(job)
    local _, count = QBCore.Functions.GetPlayersByJob(job, true)
    return count
end

-- Routing buckets (Only touch if you know what you are doing)

---Returns the objects related to buckets, first returned value is the player buckets, second one is entity buckets
---@return table, table
function QBCore.Functions.GetBucketObjects()
    return QBCore.Player_Buckets, QBCore.Entity_Buckets
end

---Will set the provided player id / source into the provided bucket id
---@param source any
---@param bucket any
---@return boolean
function QBCore.Functions.SetPlayerBucket(source, bucket)
    if source and bucket then
        local plicense = QBCore.Functions.GetIdentifier(source, 'license')
        Player(source).state:set('instance', bucket, true)
        SetPlayerRoutingBucket(source, bucket)
        QBCore.Player_Buckets[plicense] = { id = source, bucket = bucket }
        return true
    else
        return false
    end
end

---Will set any entity into the provided bucket, for example peds / vehicles / props / etc.
---@param entity number
---@param bucket number
---@return boolean
function QBCore.Functions.SetEntityBucket(entity, bucket)
    if entity and bucket then
        SetEntityRoutingBucket(entity, bucket)
        QBCore.Entity_Buckets[entity] = { id = entity, bucket = bucket }
        return true
    else
        return false
    end
end

---Will return an array of all the player ids inside the current bucket
---@param bucket number
---@return table|boolean
function QBCore.Functions.GetPlayersInBucket(bucket)
    local curr_bucket_pool = {}
    if QBCore.Player_Buckets and next(QBCore.Player_Buckets) then
        for _, v in pairs(QBCore.Player_Buckets) do
            if v.bucket == bucket then
                curr_bucket_pool[#curr_bucket_pool + 1] = v.id
            end
        end
        return curr_bucket_pool
    else
        return false
    end
end

---Will return an array of all the entities inside the current bucket
---(not for player entities, use GetPlayersInBucket for that)
---@param bucket number
---@return table|boolean
function QBCore.Functions.GetEntitiesInBucket(bucket)
    local curr_bucket_pool = {}
    if QBCore.Entity_Buckets and next(QBCore.Entity_Buckets) then
        for _, v in pairs(QBCore.Entity_Buckets) do
            if v.bucket == bucket then
                curr_bucket_pool[#curr_bucket_pool + 1] = v.id
            end
        end
        return curr_bucket_pool
    else
        return false
    end
end

---Server side vehicle creation with optional callback
---the CreateVehicle RPC still uses the client for creation so players must be near
---@param source any
---@param model any
---@param coords vector
---@param warp boolean
---@return number
function QBCore.Functions.SpawnVehicle(source, model, coords, warp)
    local ped = GetPlayerPed(source)
    model = type(model) == 'string' and joaat(model) or model
    if not coords then coords = GetEntityCoords(ped) end
    local heading = coords.w and coords.w or 0.0
    local veh = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, true)
    while not DoesEntityExist(veh) do Wait(0) end
    if warp then
        while GetVehiclePedIsIn(ped) ~= veh do
            Wait(0)
            TaskWarpPedIntoVehicle(ped, veh, -1)
        end
    end
    while NetworkGetEntityOwner(veh) ~= source do Wait(0) end
    return veh
end

---Server side vehicle creation with optional callback
---the CreateAutomobile native is still experimental but doesn't use client for creation
---doesn't work for all vehicles!
---comment
---@param source any
---@param model any
---@param coords vector
---@param warp boolean
---@return number
function QBCore.Functions.CreateAutomobile(source, model, coords, warp)
    model = type(model) == 'string' and joaat(model) or model
    if not coords then coords = GetEntityCoords(GetPlayerPed(source)) end
    local heading = coords.w and coords.w or 0.0
    local CreateAutomobile = `CREATE_AUTOMOBILE`
    local veh = Citizen.InvokeNative(CreateAutomobile, model, coords, heading, true, true)
    while not DoesEntityExist(veh) do Wait(0) end
    if warp then TaskWarpPedIntoVehicle(GetPlayerPed(source), veh, -1) end
    return veh
end

--- New & more reliable server side native for creating vehicles
---comment
---@param source any
---@param model any
---@param vehtype any
-- The appropriate vehicle type for the model info.
-- Can be one of automobile, bike, boat, heli, plane, submarine, trailer, and (potentially), train.
-- This should be the same type as the type field in vehicles.meta.
---@param coords vector
---@param warp boolean
---@return number
function QBCore.Functions.CreateVehicle(source, model, vehtype, coords, warp)
    model = type(model) == 'string' and joaat(model) or model
    vehtype = type(vehtype) == 'string' and tostring(vehtype) or vehtype
    if not coords then coords = GetEntityCoords(GetPlayerPed(source)) end
    local heading = coords.w and coords.w or 0.0
    local veh = CreateVehicleServerSetter(model, vehtype, coords, heading)
    while not DoesEntityExist(veh) do Wait(0) end
    if warp then TaskWarpPedIntoVehicle(GetPlayerPed(source), veh, -1) end
    return veh
end

-- Callback Functions --

---Trigger Client Callback
---@param name string
---@param source any
---@param cb function
---@param ... any
function QBCore.Functions.TriggerClientCallback(name, source, cb, ...)
    QBCore.ClientCallbacks[name] = cb
    TriggerClientEvent('QBCore:Client:TriggerClientCallback', source, name, ...)
end

---Create Server Callback
---@param name string
---@param cb function
function QBCore.Functions.CreateCallback(name, cb)
    QBCore.ServerCallbacks[name] = cb
end

---Trigger Serv er Callback
---@param name string
---@param source any
---@param cb function
---@param ... any
function QBCore.Functions.TriggerCallback(name, source, cb, ...)
    if not QBCore.ServerCallbacks[name] then return end
    QBCore.ServerCallbacks[name](source, cb, ...)
end

-- Items

---Create a usable item
---@param item string
---@param data function
function QBCore.Functions.CreateUseableItem(item, data)
    QBCore.UsableItems[item] = data
end

---Checks if the given item is usable
---@param item string
---@return any
function QBCore.Functions.CanUseItem(item)
    return QBCore.UsableItems[item]
end

---Use item
---@param source any
---@param item string
function QBCore.Functions.UseItem(source, item)
    if GetResourceState('qb-inventory') == 'missing' then return end
    exports['qb-inventory']:UseItem(source, item)
end

---Kick Player
---@param source any
---@param reason string
---@param setKickReason boolean
---@param deferrals boolean
function QBCore.Functions.Kick(source, reason, setKickReason, deferrals)
    reason = '\n' .. reason .. '\n🔸 Check our Discord for further information: ' .. QBCore.Config.Server.Discord
    if setKickReason then
        setKickReason(reason)
    end
    CreateThread(function()
        if deferrals then
            deferrals.update(reason)
            Wait(2500)
        end
        if source then
            DropPlayer(source, reason)
        end
        for _ = 0, 4 do
            while true do
                if source then
                    if GetPlayerPing(source) >= 0 then
                        break
                    end
                    Wait(100)
                    CreateThread(function()
                        DropPlayer(source, reason)
                    end)
                end
                Wait(100)
            end
            Wait(5000)
        end
    end)
end

---Check if player is whitelisted, kept like this for backwards compatibility or future plans
---@param source any
---@return boolean
function QBCore.Functions.IsWhitelisted(source)
    if not QBCore.Config.Server.Whitelist then return true end
    if QBCore.Functions.HasPermission(source, QBCore.Config.Server.WhitelistPermission) then return true end
    return false
end

-- Setting & Removing Permissions

---Add permission for player
---@param source any
---@param permission string
function QBCore.Functions.AddPermission(source, permission)
    if not IsPlayerAceAllowed(source, permission) then
        ExecuteCommand(('add_principal player.%s qbcore.%s'):format(source, permission))
        QBCore.Commands.Refresh(source)
    end
end

---Remove permission from player
---@param source any
---@param permission string
function QBCore.Functions.RemovePermission(source, permission)
    if permission then
        if IsPlayerAceAllowed(source, permission) then
            ExecuteCommand(('remove_principal player.%s qbcore.%s'):format(source, permission))
            QBCore.Commands.Refresh(source)
        end
    else
        for _, v in pairs(QBCore.Config.Server.Permissions) do
            if IsPlayerAceAllowed(source, v) then
                ExecuteCommand(('remove_principal player.%s qbcore.%s'):format(source, v))
                QBCore.Commands.Refresh(source)
            end
        end
    end
end

-- Checking for Permission Level

---Check if player has permission
---@param source any
---@param permission string
---@return boolean
function QBCore.Functions.HasPermission(source, permission)
    if type(permission) == 'string' then
        if IsPlayerAceAllowed(source, permission) then return true end
    elseif type(permission) == 'table' then
        for _, permLevel in pairs(permission) do
            if IsPlayerAceAllowed(source, permLevel) then return true end
        end
    end

    return false
end

---Get the players permissions
---@param source any
---@return table
function QBCore.Functions.GetPermission(source)
    local src = source
    local perms = {}
    for _, v in pairs(QBCore.Config.Server.Permissions) do
        if IsPlayerAceAllowed(src, v) then
            perms[v] = true
        end
    end
    return perms
end

---Get admin messages opt-in state for player
---@param source any
---@return boolean
function QBCore.Functions.IsOptin(source)
    local license = QBCore.Functions.GetIdentifier(source, 'license')
    if not license or not QBCore.Functions.HasPermission(source, 'admin') then return false end
    local Player = QBCore.Functions.GetPlayer(source)
    return Player.PlayerData.optin
end

---Toggle opt-in to admin messages
---@param source any
function QBCore.Functions.ToggleOptin(source)
    local license = QBCore.Functions.GetIdentifier(source, 'license')
    if not license or not QBCore.Functions.HasPermission(source, 'admin') then return end
    local Player = QBCore.Functions.GetPlayer(source)
    Player.PlayerData.optin = not Player.PlayerData.optin
    Player.Functions.SetPlayerData('optin', Player.PlayerData.optin)
end

---Check if player is banned (el_bwh / bwh_bans)
---@param source any
---@return boolean, string?
function QBCore.Functions.IsPlayerBanned(source)
    -- el_bwh does its own ban check on playerConnecting, don't do it twice
    if GetResourceState('el_bwh') == 'started' then return false end

    local identifiers = GetPlayerIdentifiers(source)
    if not identifiers or #identifiers == 0 then return false end

    -- Pre-filter on the identifiers, the exact match is done below (receiver is a json array)
    local conditions, params = {}, {}
    for i = 1, #identifiers do
        conditions[#conditions + 1] = 'receiver LIKE ?'
        params[#params + 1] = '%' .. identifiers[i] .. '%'
    end

    local result = MySQL.query.await([[
        SELECT id, receiver, reason, sender_name, UNIX_TIMESTAMP(length) AS expire
        FROM bwh_bans
        WHERE (unbanned = 0 OR unbanned IS NULL)
        AND (length IS NULL OR length > NOW())
        AND (]] .. table.concat(conditions, ' OR ') .. ')', params)
    if not result or #result == 0 then return false end

    for i = 1, #result do
        local ban = result[i]
        local receivers = ban.receiver and json.decode(ban.receiver)
        if receivers then
            for j = 1, #receivers do
                for k = 1, #identifiers do
                    if receivers[j] == identifiers[k] then
                        local expire = ban.expire and ('Expire le ' .. os.date('%d/%m/%Y', ban.expire) .. ' a ' .. os.date('%H:%M', ban.expire)) or 'PERMANENT'
                        return true, ('BANNI !\nRaison: %s\nExpiration: %s\nBanni par: %s (Ban ID: #%s)'):format(ban.reason or 'Aucune raison', expire, ban.sender_name or 'N/A', ban.id)
                    end
                end
            end
        end
    end

    return false
end

---Check for duplicate license
---@param license any
---@return boolean
function QBCore.Functions.IsLicenseInUse(license)
    local players = GetPlayers()
    for _, player in pairs(players) do
        local playerLicense = QBCore.Functions.GetIdentifier(player, 'license')
        if playerLicense == license then return true end
    end
    return false
end

-- Utility functions

---Check if a player has an item [deprecated]
---@param source any
---@param items table|string
---@param amount number
---@return boolean
function QBCore.Functions.HasItem(source, item, amount)
    local itemCount = exports.ox_inventory:Search(source, 'count', type)
    if itemCount then
        return itemCount >= (amount or 1)
    else
        return false
    end
end

---Notify
---@param source any
---@param text string
---@param type string
---@param length number
function QBCore.Functions.Notify(source, text, type, length)
    TriggerClientEvent('QBCore:Notify', source, text, type, length)
end

---???? ... ok
---@param source any
---@param data any
---@param pattern any
---@return boolean
function QBCore.Functions.PrepForSQL(source, data, pattern)
    data = tostring(data)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    local result = string.match(data, pattern)
    if not result or string.len(result) ~= string.len(data) then
        TriggerEvent('qb-log:server:CreateLog', 'anticheat', 'SQL Exploit Attempted', 'red', string.format('%s attempted to exploit SQL!', player.PlayerData.license))
        return false
    end
    return true
end

-- Colonnes communes à deux tables, résolues une fois puis mises en cache.
local sharedColumnsCache = {}

---Liste (échappée) des colonnes présentes à la fois dans `sourceTable` et dans
---`targetTable`, dans l'ordre de la table source.
---Les colonnes générées de la cible (`job_name`, `gang_name`...) sont exclues :
---MySQL refuse qu'on leur fournisse une valeur, elles se recalculent seules à
---partir des colonnes copiées.
---@param sourceTable string
---@param targetTable string
---@return string? columns
local function getSharedColumns(sourceTable, targetTable)
    local cacheKey = sourceTable .. '>' .. targetTable
    if sharedColumnsCache[cacheKey] then return sharedColumnsCache[cacheKey] end

    local columns = MySQL.query.await([[
        SELECT src.COLUMN_NAME AS name
        FROM information_schema.COLUMNS AS src
        INNER JOIN information_schema.COLUMNS AS dst
            ON dst.TABLE_SCHEMA = src.TABLE_SCHEMA
            AND dst.TABLE_NAME = ?
            AND dst.COLUMN_NAME = src.COLUMN_NAME
        WHERE src.TABLE_SCHEMA = DATABASE() AND src.TABLE_NAME = ?
            AND COALESCE(dst.GENERATION_EXPRESSION, '') = ''
        ORDER BY src.ORDINAL_POSITION
    ]], { targetTable, sourceTable })

    if not columns or #columns == 0 then return nil end

    local escaped = {}
    for i = 1, #columns do
        escaped[i] = ('`%s`'):format(columns[i].name)
    end

    sharedColumnsCache[cacheKey] = table.concat(escaped, ', ')
    return sharedColumnsCache[cacheKey]
end

---Vérifie qu'une copie `sourceTable` -> `targetTable` est possible, sans rien
---écrire. À appeler avant la moindre suppression.
---@param sourceTable string
---@param targetTable string
---@return boolean
function QBCore.Functions.CanCopyRows(sourceTable, targetTable)
    if getSharedColumns(sourceTable, targetTable) then return true end
    print(('^1[qb-core] Copie %s -> %s impossible : aucune colonne commune^7'):format(sourceTable, targetTable))
    return false
end

---Recopie des lignes d'une table vers une autre en listant explicitement les
---colonnes communes aux deux tables.
---`INSERT INTO target SELECT * FROM source` casse dès qu'une colonne est
---ajoutée d'un seul côté (ou que l'ordre diffère) : les archives (`old_players`
---& co) finissent toujours par diverger du schéma vivant.
---Les copies passent par une transaction : soit tout est écrit, soit rien, ce
---qui évite l'archive à moitié faite dont on ne peut plus se dépêtrer. Ne lève
---pas d'erreur : renvoie false pour que l'appelant annule la suppression qui
---suit plutôt que de perdre les données.
---@param copies { source: string, target: string, where: string, params: table }[] `where` utilise des placeholders `?`
---@return boolean
function QBCore.Functions.CopyRows(copies)
    local queries = {}

    for i = 1, #copies do
        local copy = copies[i]
        local columns = getSharedColumns(copy.source, copy.target)

        if not columns then
            print(('^1[qb-core] Copie %s -> %s impossible : aucune colonne commune^7'):format(copy.source, copy.target))
            return false
        end

        queries[i] = {
            query = ('INSERT INTO `%s` (%s) SELECT %s FROM `%s` WHERE %s'):format(copy.target, columns, columns, copy.source, copy.where),
            values = copy.params
        }
    end

    if MySQL.transaction.await(queries) then return true end

    for i = 1, #copies do
        print(('^1[qb-core] Copie %s -> %s échouée^7'):format(copies[i].source, copies[i].target))
    end

    return false
end

function QBCore.Functions.DoesJobExist(job, grade)
    if not job then return false end
    job = job:lower() or ''
    grade = tonumber(grade) or 1

    if not QBCore.Shared.Jobs[job] then
        return false
    end

    while grade > 1 and not QBCore.Shared.Jobs[job].grades[grade] do
        grade = grade - 1
    end

    if QBCore.Shared.Jobs[job].grades[grade] then
        return true, grade
    else
        return false
    end
end

function QBCore.Functions.DoesGangExist(gang, grade)
    if not gang then return false end
    gang = gang:lower() or ''
    grade = tonumber(grade) or 1

    if not QBCore.Shared.Gangs[gang] then
        return false
    end

    while grade > 1 and not QBCore.Shared.Gangs[gang].grades[grade] do
        grade = grade - 1
    end

    if QBCore.Shared.Gangs[gang].grades[grade] then
        return true, grade
    else
        return false
    end
end