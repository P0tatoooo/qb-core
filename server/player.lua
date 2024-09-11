QBCore.Players = {}
QBCore.Player = {}

-- On player login get their data or set defaults
-- Don't touch any of this unless you know what you are doing
-- Will cause major issues!

local resourceName = GetCurrentResourceName()
function QBCore.Player.Login(source, citizenid, newData)
    if source and source ~= '' then
        if citizenid then
            local license = QBCore.Functions.GetIdentifier(source, 'license')
            local steam = QBCore.Functions.GetIdentifier(source, 'steam')
            local PlayerData = MySQL.prepare.await('SELECT * FROM players where citizenid = ?', { citizenid })

            if PlayerData and license == PlayerData.license then
                PlayerData.steam = steam or ''
                PlayerData.money = json.decode(PlayerData.money)
                PlayerData.job = json.decode(PlayerData.job)
                PlayerData.job.grade.level = tonumber(PlayerData.job.grade.level) or 1
                if PlayerData.job.grade.level == 0 then
                    PlayerData.job.grade.level = 1
                end
                if QBCore.Shared.Jobs[PlayerData.job.name].grades[PlayerData.job.grade.level]?.name ~= PlayerData.job.grade.name then
                    for k,v in pairs(QBCore.Shared.Jobs[PlayerData.job.name].grades) do
                        if v.name == PlayerData.job.grade.name then
                            PlayerData.job.grade.level = k
                            break
                        end
                    end
                end

                PlayerData.gang = json.decode(PlayerData.gang)
                PlayerData.gang.grade.level = tonumber(PlayerData.gang.grade.level) or 1
                if PlayerData.gang.grade.level == 0 then
                    PlayerData.gang.grade.level = 1
                end
                if QBCore.Shared.Gangs[PlayerData.gang.name].grades[PlayerData.gang.grade.level]?.name ~= PlayerData.gang.grade.name then
                    for k,v in pairs(QBCore.Shared.Gangs[PlayerData.gang.name].grades) do
                        if v.name == PlayerData.gang.grade.name then
                            PlayerData.gang.grade.level = k
                            break
                        end
                    end
                end

                PlayerData.coins = 0
                local result = MySQL.query.await('SELECT coins FROM shop_coins WHERE license=@license',{
                    ['@license'] = PlayerData.license
                })
                if result[1] then
                    PlayerData.coins = result[1].coins
                end

                PlayerData.position = json.decode(PlayerData.position)
                PlayerData.metadata = json.decode(PlayerData.metadata)
                PlayerData.charinfo = json.decode(PlayerData.charinfo)
                PlayerData.bodyparts = json.decode(PlayerData.bodyparts)
                PlayerData.favemotes = json.decode(PlayerData.favemotes)
                PlayerData.tattoos = json.decode(PlayerData.tattoos)
                PlayerData.furnitures = json.decode(PlayerData.furnitures)
                PlayerData.skills = json.decode(PlayerData.skills)
                QBCore.Player.CheckPlayerData(source, PlayerData)
            else
                DropPlayer(source, Lang:t('info.exploit_dropped'))
                TriggerEvent('qb-log:server:CreateLog', 'anticheat', 'Anti-Cheat', 'white', GetPlayerName(source) .. ' Has Been Dropped For Character Joining Exploit', false)
            end
        else
            QBCore.Player.CheckPlayerData(source, newData)
        end
        return true
    else
        QBCore.ShowError(resourceName, 'ERROR QBCORE.PLAYER.LOGIN - NO SOURCE GIVEN!')
        return false
    end
end

function QBCore.Player.GetOfflinePlayer(citizenid)
    if citizenid then
        local PlayerData = MySQL.prepare.await('SELECT * FROM players where citizenid = ?', { citizenid })
        if PlayerData then
            PlayerData.coins = 0
            local result = MySQL.query.await('SELECT coins FROM shop_coins WHERE license=@license',{
                ['@license'] = PlayerData.license
            })
            if result[1] then
                PlayerData.coins = result[1].coins
            end

            PlayerData.money = json.decode(PlayerData.money)
            PlayerData.job = json.decode(PlayerData.job)
            PlayerData.gang = json.decode(PlayerData.gang)
            PlayerData.position = json.decode(PlayerData.position)
            PlayerData.metadata = json.decode(PlayerData.metadata)
            PlayerData.bodyparts = json.decode(PlayerData.bodyparts)
            PlayerData.charinfo = json.decode(PlayerData.charinfo)
            PlayerData.favemotes = json.decode(PlayerData.favemotes) or {}
            PlayerData.tattoos = json.decode(PlayerData.tattoos)
            PlayerData.furnitures = json.decode(PlayerData.furnitures)
            PlayerData.skills = json.decode(PlayerData.skills)
            return QBCore.Player.CheckPlayerData(nil, PlayerData)
        end
    end
    return nil
end

function QBCore.Player.GetPlayerByLicense(license)
    if license then
        local source = QBCore.Functions.GetSource(license)
        if source > 0 then
            return QBCore.Players[source]
        else
            return QBCore.Player.GetOfflinePlayerByLicense(license)
        end
    end
    return nil
end

function QBCore.Player.GetOfflinePlayerByLicense(license)
    if license then
        local PlayerData = MySQL.prepare.await('SELECT * FROM players where license = ?', { license })
        if PlayerData then
            PlayerData.coins = 0
            local result = MySQL.query.await('SELECT coins FROM shop_coins WHERE license=@license',{
                ['@license'] = PlayerData.license
            })
            if result[1] then
                PlayerData.coins = result[1].coins
            end

            PlayerData.money = json.decode(PlayerData.money)
            PlayerData.job = json.decode(PlayerData.job)
            PlayerData.gang = json.decode(PlayerData.gang)
            PlayerData.position = json.decode(PlayerData.position)
            PlayerData.metadata = json.decode(PlayerData.metadata)
            PlayerData.charinfo = json.decode(PlayerData.charinfo)
            PlayerData.bodyparts = json.decode(PlayerData.bodyparts)
            PlayerData.favemotes = json.decode(PlayerData.favemotes) or {}
            PlayerData.tattoos = json.decode(PlayerData.tattoos)
            PlayerData.furnitures = json.decode(PlayerData.furnitures)
            PlayerData.skills = json.decode(PlayerData.skills)
            return QBCore.Player.CheckPlayerData(nil, PlayerData)
        end
    end
    return nil
end

local function applyDefaults(playerData, defaults)
    for key, value in pairs(defaults) do
        if type(value) == 'function' then
            playerData[key] = playerData[key] or value()
        elseif type(value) == 'table' then
            playerData[key] = playerData[key] or {}
            applyDefaults(playerData[key], value)
        else
            playerData[key] = playerData[key] or value
        end
    end
end

function QBCore.Player.CheckPlayerData(source, PlayerData)
    PlayerData = PlayerData or {}
    local Offline = not source

    if source then
        PlayerData.source = source
        PlayerData.license = PlayerData.license or QBCore.Functions.GetIdentifier(source, 'license')
        PlayerData.name = GetPlayerName(source)
    end

    applyDefaults(PlayerData, QBCore.Config.Player.PlayerDefaults)

    return QBCore.Player.CreatePlayer(PlayerData, Offline)
end

-- On player logout

function QBCore.Player.Logout(source)
    TriggerClientEvent('QBCore:Client:OnPlayerUnload', source)
    TriggerEvent('QBCore:Server:OnPlayerUnload', source)
    TriggerClientEvent('QBCore:Player:UpdatePlayerData', source)
    Wait(200)
    QBCore.Players[source] = nil
end

-- Create a new character
-- Don't touch any of this unless you know what you are doing
-- Will cause major issues!

function QBCore.Player.CreatePlayer(PlayerData, Offline)
    local self = {}
    self.Functions = {}
    self.PlayerData = PlayerData
    self.Offline = Offline

    function self.Functions.UpdatePlayerData()
        if self.Offline then return end
        TriggerEvent('QBCore:Player:SetPlayerData', self.PlayerData)
        TriggerClientEvent('QBCore:Player:SetPlayerData', self.PlayerData.source, self.PlayerData)
    end

    function self.Functions.SetJob(job, grade)
        job = job:lower()
        grade = tonumber(grade) or 1
        if not QBCore.Shared.Jobs[job] then return false end
        self.PlayerData.job = {
            name = job,
            label = QBCore.Shared.Jobs[job].label,
            onduty = QBCore.Shared.Jobs[job].defaultDuty,
            type = QBCore.Shared.Jobs[job].type or 'none',
            grade = {
                name = 'No Grades',
                level = 0,
                payment = 30,
                isboss = false
            }
        }
        local gradeKey = grade
        local jobGradeInfo = QBCore.Shared.Jobs[job].grades[gradeKey]
        if jobGradeInfo then
            self.PlayerData.job.grade.name = jobGradeInfo.name
            self.PlayerData.job.grade.level = tonumber(grade)
            self.PlayerData.job.grade.payment = jobGradeInfo.payment
            self.PlayerData.job.grade.isboss = jobGradeInfo.isboss or false
            self.PlayerData.job.isboss = jobGradeInfo.isboss or false
        end

        if not self.Offline then
            self.Functions.UpdatePlayerData()
            TriggerEvent('QBCore:Server:OnJobUpdate', self.PlayerData.source, self.PlayerData.job)
            TriggerClientEvent('QBCore:Client:OnJobUpdate', self.PlayerData.source, self.PlayerData.job)
        end
        self.Functions.Save()
        return true
    end

    function self.Functions.SetGang(gang, grade)
        gang = gang:lower()
        grade = tonumber(grade) or 1
        if not QBCore.Shared.Gangs[gang] then return false end
        self.PlayerData.gang = {
            name = gang,
            label = QBCore.Shared.Gangs[gang].label,
            grade = {
                name = 'No Grades',
                level = 0,
                isboss = false
            }
        }
        local gradeKey = grade
        local gangGradeInfo = QBCore.Shared.Gangs[gang].grades[gradeKey]
        if gangGradeInfo then
            self.PlayerData.gang.grade.name = gangGradeInfo.name
            self.PlayerData.gang.grade.level = tonumber(grade)
            self.PlayerData.gang.grade.isboss = gangGradeInfo.isboss or false
            self.PlayerData.gang.isboss = gangGradeInfo.isboss or false
        end

        if not self.Offline then
            self.Functions.UpdatePlayerData()
            TriggerEvent('QBCore:Server:OnGangUpdate', self.PlayerData.source, self.PlayerData.gang)
            TriggerClientEvent('QBCore:Client:OnGangUpdate', self.PlayerData.source, self.PlayerData.gang)
        end
        self.Functions.Save()
        return true
    end

    function self.Functions.Notify(text, type, lenght)
        TriggerClientEvent('QBCore:Notify', self.PlayerData.source, text, type, lenght)
    end

    function self.Functions.HasItem(items, amount)
        return QBCore.Functions.HasItem(self.PlayerData.source, items, amount)
    end

    function self.Functions.SetJobDuty(onDuty)
        self.PlayerData.job.onduty = not not onDuty
        TriggerEvent('QBCore:Server:OnJobUpdate', self.PlayerData.source, self.PlayerData.job)
        TriggerClientEvent('QBCore:Client:OnJobUpdate', self.PlayerData.source, self.PlayerData.job)
        self.Functions.UpdatePlayerData()
        self.Functions.Save()
    end

    function self.Functions.SetPlayerData(key, val)
        if not key or type(key) ~= 'string' then return end
        self.PlayerData[key] = val
        self.Functions.UpdatePlayerData()
    end

    function self.Functions.SetMetaData(meta, val)
        if not meta or type(meta) ~= 'string' then return end
        if meta == 'hunger' or meta == 'thirst' then
            val = val > 100 and 100 or val
        end
        self.PlayerData.metadata[meta] = val
        self.Functions.UpdatePlayerData()
    end

    function self.Functions.GetMetaData(meta)
        if not meta or type(meta) ~= 'string' then return end
        return self.PlayerData.metadata[meta]
    end

    function self.Functions.GetCoords()
        local playerPed = GetPlayerPed(self.PlayerData.source)
        local playerCoords = GetEntityCoords(playerPed)
        return playerCoords or vector3(0,0,0)
    end

    function self.Functions.AddJobReputation(amount)
        if not amount then return end
        amount = tonumber(amount)
        self.PlayerData.metadata['jobrep'][self.PlayerData.job.name] = self.PlayerData.metadata['jobrep'][self.PlayerData.job.name] + amount
        self.Functions.UpdatePlayerData()
    end

    function self.Functions.AddMoney(moneytype, amount, reason)
        reason = reason or 'unknown'
        moneytype = moneytype:lower()
        amount = tonumber(amount)
        if amount < 0 then return end
        if not self.PlayerData.money[moneytype] then return false end
        self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype] + amount

        if not self.Offline then
            self.Functions.UpdatePlayerData()
            TriggerEvent('QBCore:Server:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'add', reason)
        end

        return true
    end

    function self.Functions.RemoveMoney(moneytype, amount, reason)
        reason = reason or 'unknown'
        moneytype = moneytype:lower()
        amount = tonumber(amount)
        if amount < 0 then return end
        if not self.PlayerData.money[moneytype] then return false end
        for _, mtype in pairs(QBCore.Config.Money.DontAllowMinus) do
            if mtype == moneytype then
                if (self.PlayerData.money[moneytype] - amount) < 0 then
                    return false
                end
            end
        end
        self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype] - amount

        if not self.Offline then
            self.Functions.UpdatePlayerData()
            if amount > 100000 then
                TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'RemoveMoney', 'red', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') removed, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype] .. ' reason: ' .. reason, true)
            else
                TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'RemoveMoney', 'red', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') removed, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype] .. ' reason: ' .. reason)
            end
            TriggerClientEvent('hud:client:OnMoneyChange', self.PlayerData.source, moneytype, amount, true)
            if moneytype == 'bank' then
                TriggerClientEvent('qb-phone:client:RemoveBankMoney', self.PlayerData.source, amount)
            end
            TriggerClientEvent('QBCore:Client:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'remove', reason)
            TriggerEvent('QBCore:Server:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'remove', reason)
        end

        return true
    end

    function self.Functions.SetMoney(moneytype, amount, reason)
        reason = reason or 'unknown'
        moneytype = moneytype:lower()
        amount = tonumber(amount)
        if amount < 0 then return false end
        if not self.PlayerData.money[moneytype] then return false end
        local difference = amount - self.PlayerData.money[moneytype]
        self.PlayerData.money[moneytype] = amount

        if not self.Offline then
            self.Functions.UpdatePlayerData()
            TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'SetMoney', 'green', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') set, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype] .. ' reason: ' .. reason)
            TriggerClientEvent('hud:client:OnMoneyChange', self.PlayerData.source, moneytype, math.abs(difference), difference < 0)
            TriggerClientEvent('QBCore:Client:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'set', reason)
            TriggerEvent('QBCore:Server:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'set', reason)
        end

        return true
    end

    function self.Functions.GetMoney(moneytype)
        if not moneytype then return false end
        moneytype = moneytype:lower()
        return self.PlayerData.money[moneytype]
    end

    function self.Functions.SetCreditCard(cardNumber)
        self.PlayerData.charinfo.card = cardNumber
        self.Functions.UpdatePlayerData()
    end

    function self.Functions.GetCardSlot(cardNumber, cardType)
        local item = tostring(cardType):lower()
        local slots = exports['qb-inventory']:GetSlotsByItem(self.PlayerData.items, item)
        for _, slot in pairs(slots) do
            if slot then
                if self.PlayerData.items[slot].info.cardNumber == cardNumber then
                    return slot
                end
            end
        end
        return nil
    end

    function self.Functions.Save()
        if self.Offline then
            QBCore.Player.SaveOffline(self.PlayerData)
        else
            QBCore.Player.Save(self.PlayerData.source)
        end
    end

    function self.Functions.Logout()
        if self.Offline then return end
        QBCore.Player.Logout(self.PlayerData.source)
    end

    function self.Functions.AddMethod(methodName, handler)
        self.Functions[methodName] = handler
    end

    function self.Functions.AddField(fieldName, data)
        self[fieldName] = data
    end

    function self.Functions.AddItem(item, count, metadata, slot)
        return exports.ox_inventory:AddItem(self.PlayerData.source, item, count, metadata, slot)
    end

    function self.Functions.RemoveItem(item, count, slot, metadata)
        return exports.ox_inventory:RemoveItem(self.PlayerData.source, item, count, metadata, slot)
    end

    function self.Functions.GetItemBySlot(slot)
        return exports.ox_inventory:GetSlot(self.PlayerData.source, slot)
    end

    function self.Functions.GetItemByName(name, metadata, strict)
        local result = exports.ox_inventory:GetSlotWithItem(self.PlayerData.source, name, metadata, strict)
        if result then
            return result
        else
            local items = exports.ox_inventory:Items()
            return {count = 0, label = items[name]?.label or "N/A"}
        end
    end

    function self.Functions.GetItemsByName(name, metadata, strict)
        local result = exports.ox_inventory:GetSlotsWithItem(self.PlayerData.source, name, metadata, strict)
        return result
    end

    if self.Offline then
        return self
    else
        QBCore.Players[self.PlayerData.source] = self
        QBCore.Player.Save(self.PlayerData.source)
        TriggerEvent('QBCore:Server:PlayerLoaded', self)
        self.Functions.UpdatePlayerData()
    end
end

-- Add a new function to the Functions table of the player class
-- Use-case:
--[[
    AddEventHandler('QBCore:Server:PlayerLoaded', function(Player)
        QBCore.Functions.AddPlayerMethod(Player.PlayerData.source, "functionName", function(oneArg, orMore)
            -- do something here
        end)
    end)
]]

function QBCore.Functions.AddPlayerMethod(ids, methodName, handler)
    local idType = type(ids)
    if idType == 'number' then
        if ids == -1 then
            for _, v in pairs(QBCore.Players) do
                v.Functions.AddMethod(methodName, handler)
            end
        else
            if not QBCore.Players[ids] then return end

            QBCore.Players[ids].Functions.AddMethod(methodName, handler)
        end
    elseif idType == 'table' and table.type(ids) == 'array' then
        for i = 1, #ids do
            QBCore.Functions.AddPlayerMethod(ids[i], methodName, handler)
        end
    end
end

-- Add a new field table of the player class
-- Use-case:
--[[
    AddEventHandler('QBCore:Server:PlayerLoaded', function(Player)
        QBCore.Functions.AddPlayerField(Player.PlayerData.source, "fieldName", "fieldData")
    end)
]]

function QBCore.Functions.AddPlayerField(ids, fieldName, data)
    local idType = type(ids)
    if idType == 'number' then
        if ids == -1 then
            for _, v in pairs(QBCore.Players) do
                v.Functions.AddField(fieldName, data)
            end
        else
            if not QBCore.Players[ids] then return end

            QBCore.Players[ids].Functions.AddField(fieldName, data)
        end
    elseif idType == 'table' and table.type(ids) == 'array' then
        for i = 1, #ids do
            QBCore.Functions.AddPlayerField(ids[i], fieldName, data)
        end
    end
end

-- Save player info to database (make sure citizenid is the primary key in your database)

function QBCore.Player.Save(source)
    local ped = GetPlayerPed(source)
    local pcoords = GetEntityCoords(ped)
    local PlayerData = QBCore.Players[source].PlayerData
    if PlayerData then
        MySQL.insert('INSERT INTO players (citizenid, cid, license, name, steam, rpname, money, charinfo, job, gang, position, metadata, bodyparts, tattoos, furnitures, currentproperty, mugshot, phone, skills) VALUES (:citizenid, :cid, :license, :name, :steam, :rpname, :money, :charinfo, :job, :gang, :position, :metadata, :bodyparts, :tattoos, :furnitures, :currentproperty, :mugshot, :phone, :skills) ON DUPLICATE KEY UPDATE cid = :cid, name = :name, steam = :steam, rpname = :rpname, money = :money, charinfo = :charinfo, job = :job, gang = :gang, position = :position, metadata = :metadata, bodyparts = :bodyparts, tattoos = :tattoos, furnitures = :furnitures, currentproperty = :currentproperty, mugshot = :mugshot, phone = :phone, skills = :skills', {
            citizenid = PlayerData.citizenid,
            cid = tonumber(PlayerData.cid),
            license = PlayerData.license,
            name = PlayerData.name:gsub("[^%w%s]", ""),
            steam = PlayerData.steam or '',
            rpname = PlayerData.rpname,
            money = json.encode(PlayerData.money),
            charinfo = json.encode(PlayerData.charinfo),
            job = json.encode(PlayerData.job),
            gang = json.encode(PlayerData.gang),
            position = json.encode(pcoords),
            metadata = json.encode(PlayerData.metadata),
            bodyparts = json.encode(PlayerData.bodyparts),
            tattoos = json.encode(PlayerData.tattoos),
            furnitures = json.encode(PlayerData.furnitures),
            skills = json.encode(PlayerData.skills),
            currentproperty = PlayerData.currentproperty,
            mugshot = PlayerData.mugshot,
            phone = PlayerData.phone
        })
        if GetResourceState('qb-inventory') ~= 'missing' then exports['qb-inventory']:SaveInventory(source) end
        QBCore.ShowSuccess(resourceName, PlayerData.name .. ' PLAYER SAVED!')
    else
        QBCore.ShowError(resourceName, 'ERROR QBCORE.PLAYER.SAVE - PLAYERDATA IS EMPTY!')
    end
end

function QBCore.Player.SaveOffline(PlayerData)
    if PlayerData then
        MySQL.insert('INSERT INTO players (citizenid, cid, license, name, steam, rpname, money, charinfo, job, gang, position, metadata, bodyparts, tattoos, furnitures, currentproperty, mugshot, phone, skills) VALUES (:citizenid, :cid, :license, :name, :steam, :rpname, :money, :charinfo, :job, :gang, :position, :metadata, :bodyparts, :tattoos, :furnitures, :currentproperty, :mugshot, :phone, :skills) ON DUPLICATE KEY UPDATE cid = :cid, name = :name, steam = :steam, rpname = :rpname, money = :money, charinfo = :charinfo, job = :job, gang = :gang, position = :position, metadata = :metadata, bodyparts = :bodyparts, tattoos = :tattoos, furnitures = :furnitures, currentproperty = :currentproperty, mugshot = :mugshot, phone = :phone, skills = :skills', {
            citizenid = PlayerData.citizenid,
            cid = tonumber(PlayerData.cid),
            license = PlayerData.license,
            name = PlayerData.name:gsub("[^%w%s]", ""),
            steam = PlayerData.steam or '',
            rpname = PlayerData.rpname,
            money = json.encode(PlayerData.money),
            charinfo = json.encode(PlayerData.charinfo),
            job = json.encode(PlayerData.job),
            gang = json.encode(PlayerData.gang),
            position = json.encode(PlayerData.position),
            metadata = json.encode(PlayerData.metadata),
            bodyparts = json.encode(PlayerData.bodyparts),
            tattoos = json.encode(PlayerData.tattoos),
            furnitures = json.encode(PlayerData.furnitures),
            skills = json.encode(PlayerData.skills),
            currentproperty = PlayerData.currentproperty,
            mugshot = PlayerData.mugshot,
            phone = PlayerData.phone
        })
        if GetResourceState('qb-inventory') ~= 'missing' then exports['qb-inventory']:SaveInventory(PlayerData, true) end
        QBCore.ShowSuccess(resourceName, PlayerData.name .. ' OFFLINE PLAYER SAVED!')
    else
        QBCore.ShowError(resourceName, 'ERROR QBCORE.PLAYER.SAVEOFFLINE - PLAYERDATA IS EMPTY!')
    end
end

-- Delete character

local playertables = { -- Add tables as needed
    --{ table = 'players' },
    --{ table = 'apartments' },
    --{ table = 'bank_accounts' },
    --{ table = 'crypto_transactions' },
    --{ table = 'phone_invoices' },
    --{ table = 'phone_messages' },
    --{ table = 'playerskins' },
    --{ table = 'player_contacts' },
    --{ table = 'player_houses' },
    --{ table = 'player_mails' },
    --{ table = 'player_outfits' },
    --{ table = 'player_vehicles' }
}

--[[ function QBCore.Player.DeleteCharacter(source, citizenid)
    local license = QBCore.Functions.GetIdentifier(source, 'license')
    local result = MySQL.scalar.await('SELECT license FROM players where citizenid = ?', { citizenid })
    if license == result then
        local query = 'DELETE FROM %s WHERE citizenid = ?'
        local tableCount = #playertables
        local queries = table.create(tableCount, 0)

        for i = 1, tableCount do
            local v = playertables[i]
            queries[i] = { query = query:format(v.table), values = { citizenid } }
        end

        MySQL.transaction(queries, function(result2)
            if result2 then
                TriggerEvent('qb-log:server:CreateLog', 'joinleave', 'Character Deleted', 'red', '**' .. GetPlayerName(source) .. '** ' .. license .. ' deleted **' .. citizenid .. '**..')
            end
        end)
    else
        DropPlayer(source, Lang:t('info.exploit_dropped'))
        TriggerEvent('qb-log:server:CreateLog', 'anticheat', 'Anti-Cheat', 'white', GetPlayerName(source) .. ' Has Been Dropped For Character Deletion Exploit', true)
    end
end ]]

function QBCore.Player.ForceDeleteCharacter(citizenid, sourceplayer)
    local result = MySQL.scalar.await('SELECT license FROM players where citizenid = ?', { citizenid })
    if result then
        local Player = QBCore.Functions.GetPlayerByCitizenId(citizenid)

        if Player and Player.PlayerData.source ~= sourceplayer then
            DropPlayer(Player.PlayerData.source, 'Votre personnage a été wipe par un administrateur')
        end

        local Player = QBCore.Functions.GetOfflinePlayerByCitizenId(citizenid)

        local resultPlayer = MySQL.query.await('INSERT INTO old_players SELECT * FROM players WHERE citizenid = @citizenid', {['@citizenid'] = citizenid})
        local resultPlayer = MySQL.query.await('INSERT INTO old_player_vehicles SELECT * FROM player_vehicles WHERE citizenid = @citizenid AND premium = "no"', {['@citizenid'] = citizenid})

        local result = MySQL.query.await('DELETE FROM players WHERE citizenid = @citizenid', {['@citizenid'] = citizenid})
        local result = MySQL.query.await('DELETE FROM player_vehicles WHERE citizenid = @citizenid AND premium = "no"', {
            ['@citizenid'] = citizenid
        })

        local result = MySQL.query.await('SELECT plate FROM player_vehicles WHERE citizenid = @citizenid', {
            ['@citizenid'] = citizenid
        })

        for k,v in pairs(result) do
            exports.ox_inventory:ClearInventory('glovebox' .. v.plate, false)
            exports.ox_inventory:ClearInventory('trunk' .. v.plate, false)
            local result = MySQL.query.await('UPDATE player_vehicles SET fakeplate = @fakeplate, carkeys = @carkeys, glovebox = @glovebox, trunk = @trunk, status = @status, garage = @garage WHERE plate = @plate', {
                ['@fakeplate'] = '',
                ['@carkeys'] = '{}',
                ['@glovebox'] = nil,
                ['@trunk'] = nil,
                ['@plate'] = v.plate,
                ['@status'] = 'parking',
                ['@garage'] = 'Parking Divin',
            })
        end

        --local result = MySQL.query.await('DELETE FROM properties_keys WHERE owner=@owner', { ['@owner'] = citizenid }, function() end)

        local result = MySQL.query.await('INSERT INTO old_properties SELECT * FROM properties WHERE owner = @citizenid', {['@citizenid'] = citizenid})
        local result = MySQL.query.await('DELETE FROM properties WHERE owner = @citizenid', {['@citizenid'] = citizenid})

        local propertiesText = ""
        local resultproperties = MySQL.query.await('SELECT * FROM properties WHERE owner=@owner', {
            ['owner'] = citizenid
        })
        for k,v in pairs(resultproperties) do
            propertiesText = propertiesText + '\nPropriété ' .. v.name .. ' (id : ' .. v.id .. ') sous le nom de ' ..  v.ownername
        end

        local message = 'Nom : **' .. Player.PlayerData.rpname .. '**\nJob : **' .. Player.PlayerData.gang.label .. '**\nFaction : **' .. Player.PlayerData.gang.label .. '**\nCitizenId : **' .. Player.PlayerData.citizenid .. '**\nLicense : **' .. Player.PlayerData.license .. '**'
        TriggerEvent('MyCity_Core:Wipe:Logs', "Wipe", message, sourceplayer)
    end
end

-- Inventory Backwards Compatibility

function QBCore.Player.SaveInventory(source)
    if GetResourceState('qb-inventory') == 'missing' then return end
    exports['qb-inventory']:SaveInventory(source, false)
end

function QBCore.Player.SaveOfflineInventory(PlayerData)
    if GetResourceState('qb-inventory') == 'missing' then return end
    exports['qb-inventory']:SaveInventory(PlayerData, true)
end

function QBCore.Player.GetTotalWeight(items)
    if GetResourceState('qb-inventory') == 'missing' then return end
    return exports['qb-inventory']:GetTotalWeight(items)
end

function QBCore.Player.GetSlotsByItem(items, itemName)
    if GetResourceState('qb-inventory') == 'missing' then return end
    return exports['qb-inventory']:GetSlotsByItem(items, itemName)
end

function QBCore.Player.GetFirstSlotByItem(items, itemName)
    if GetResourceState('qb-inventory') == 'missing' then return end
    return exports['qb-inventory']:GetFirstSlotByItem(items, itemName)
end

-- Util Functions

function QBCore.Player.CreateCitizenId()
    local CitizenId = tostring(QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(5)):upper()
    local result = MySQL.prepare.await('SELECT EXISTS(SELECT 1 FROM players WHERE citizenid = ?) AS uniqueCheck', { CitizenId })
    if result == 0 then return CitizenId end
    return QBCore.Player.CreateCitizenId()
end

function QBCore.Functions.CreateAccountNumber()
    local AccountNumber = 'US0' .. math.random(1, 9) .. 'QBCore' .. math.random(1111, 9999) .. math.random(1111, 9999) .. math.random(11, 99)
    local result = MySQL.prepare.await('SELECT EXISTS(SELECT 1 FROM players WHERE JSON_UNQUOTE(JSON_EXTRACT(charinfo, "$.account")) = ?) AS uniqueCheck', { AccountNumber })
    if result == 0 then return AccountNumber end
    return QBCore.Functions.CreateAccountNumber()
end

function QBCore.Functions.CreatePhoneNumber()
    local PhoneNumber ="555-" .. QBCore.Shared.RandomInt(4)
    --local result = MySQL.prepare.await('SELECT 1 FROM sim WHERE phone_number=?', { PhoneNumber })
    --if not result then return PhoneNumber end
    --return QBCore.Functions.CreatePhoneNumber()
    return PhoneNumber
end

function QBCore.Player.CreateFingerId()
    local FingerId = tostring(QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(1) .. QBCore.Shared.RandomInt(2) .. QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(4))
    local result = MySQL.prepare.await('SELECT EXISTS(SELECT 1 FROM players WHERE JSON_UNQUOTE(JSON_EXTRACT(metadata, "$.fingerprint")) = ?) AS uniqueCheck', { FingerId })
    if result == 0 then return FingerId end
    return QBCore.Player.CreateFingerId()
end

function QBCore.Player.CreateWalletId()
    local WalletId = 'QB-' .. math.random(11111111, 99999999)
    local result = MySQL.prepare.await('SELECT EXISTS(SELECT 1 FROM players WHERE JSON_UNQUOTE(JSON_EXTRACT(metadata, "$.walletid")) = ?) AS uniqueCheck', { WalletId })
    if result == 0 then return WalletId end
    return QBCore.Player.CreateWalletId()
end

function QBCore.Player.CreateSerialNumber()
    local SerialNumber = math.random(11111111, 99999999)
    local result = MySQL.prepare.await('SELECT EXISTS(SELECT 1 FROM players WHERE JSON_UNQUOTE(JSON_EXTRACT(metadata, "$.phonedata.SerialNumber")) = ?) AS uniqueCheck', { SerialNumber })
    if result == 0 then return SerialNumber end
    return QBCore.Player.CreateSerialNumber()
end

--PaycheckInterval() -- This starts the paycheck system
