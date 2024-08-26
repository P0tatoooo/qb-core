QBCore.Functions = {}

-- Player

function QBCore.Functions.GetPlayerData(cb)
    if not cb then return QBCore.PlayerData end
    cb(QBCore.PlayerData)
end

function QBCore.Functions.GetCoords(entity)
    local coords = GetEntityCoords(entity)
    return vector4(coords.x, coords.y, coords.z, GetEntityHeading(entity))
end

function QBCore.Functions.HasItem(item, amount)
    local count = exports.ox_inventory:GetItemCount(item, nil, false) or 0
    return count >= (amount or 1)
end

function QBCore.Functions.GetItemByName(item, amount)
    local count = exports.ox_inventory:GetItemCount(item, nil, false) or 0
    return count >= (amount or 1)
end

function QBCore.Functions.GetItemCount(item)
    local count = exports.ox_inventory:GetItemCount(item, nil, false) or 0
    return count
end

-- Utility

function QBCore.Functions.GetPedMugshot(ped, transparent)
	if DoesEntityExist(ped) then
		local mugshot

		if transparent then
			mugshot = RegisterPedheadshotTransparent(ped)
		else
			mugshot = RegisterPedheadshot(ped)
		end

		while not IsPedheadshotReady(mugshot) do
			Wait(0)
		end

		return mugshot, GetPedheadshotTxdString(mugshot)
	else
		return
	end
end

function QBCore.Functions.ShowAdvancedNotification(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
	if saveToBrief == nil then saveToBrief = true end
	AddTextEntry('esxAdvancedNotification', msg)
	BeginTextCommandThefeedPost('esxAdvancedNotification')
	if hudColorIndex then ThefeedSetNextPostBackgroundColor(hudColorIndex) end
	EndTextCommandThefeedPostMessagetext(textureDict, textureDict, false, iconType, sender, subject)
	EndTextCommandThefeedPostTicker(flash or false, saveToBrief)
end

function QBCore.Functions.ShowHelpNotification(msg, thisFrame)
	AddTextEntry('esxHelpNotification', msg)

	if thisFrame then
		DisplayHelpTextThisFrame('esxHelpNotification', false)
	else
		--if beep == nil then beep = true end
		BeginTextCommandDisplayHelp('esxHelpNotification')
		EndTextCommandDisplayHelp(0, false, false, -1)
	end
end

function QBCore.Functions.DrawText(x, y, width, height, scale, r, g, b, a, text)
    -- Use local function instead
    SetTextFont(4)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x - width / 2, y - height / 2 + 0.005)
end

function QBCore.Functions.DrawText3D(coords, text)
    -- Use local function instead
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    BeginTextCommandDisplayText('STRING')
    SetTextCentre(true)
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(coords.x, coords.y, coords.z, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    --local factor = (string.len(text)) / 370
    --DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function QBCore.Functions.RequestAnimDict(animDict)
	if HasAnimDictLoaded(animDict) then return end
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Wait(0)
	end
end

function QBCore.Functions.PlayAnim(animDict, animName, upperbodyOnly, duration)
    local flags = upperbodyOnly and 16 or 0
    local runTime = duration or -1
    QBCore.Functions.RequestAnimDict(animDict)
    TaskPlayAnim(PlayerPedId(), animDict, animName, 8.0, 1.0, runTime, flags, 0.0, false, false, true)
    RemoveAnimDict(animDict)
end

function QBCore.Functions.LoadModel(model)
    if HasModelLoaded(model) then return end
	RequestModel(model)
	while not HasModelLoaded(model) do
		Wait(0)
	end
end

function QBCore.Functions.LoadAnimSet(animSet)
    if HasAnimSetLoaded(animSet) then return end
    RequestAnimSet(animSet)
    while not HasAnimSetLoaded(animSet) do
        Wait(0)
    end
end

function QBCore.Functions.RequestControlEntity(entity)
    SetEntityAsMissionEntity(entity, true, true)

    local attempt = 0
    while not NetworkHasControlOfEntity(entity) and attempt < 100 and DoesEntityExist(entity) do
        Citizen.Wait(20)
        NetworkRequestControlOfEntity(entity)
        attempt = attempt + 1
    end

    if DoesEntityExist(entity) and NetworkHasControlOfEntity(entity) then
        return true
    end
    return false
end

function QBCore.Functions.DeleteObject(object)
    SetEntityAsMissionEntity(object, false, false)
    DeleteObject(object)

    if NetworkGetEntityIsNetworked(object) then
        local attempt = 0
        while not NetworkHasControlOfEntity(object) and attempt < 100 and DoesEntityExist(object) do
            Citizen.Wait(20)
            NetworkRequestControlOfEntity(object)
            attempt = attempt + 1
        end
    end

	if DoesEntityExist(object) and (not NetworkGetEntityIsNetworked(object) or NetworkHasControlOfEntity(object)) then
		SetEntityAsMissionEntity(object, false, false)
		DeleteObject(object)
	end

    if DoesEntityExist(entity) and NetworkGetEntityIsNetworked(entity) then
        TriggerServerEvent('qb-core:server:forcedeleteentity', NetworkGetNetworkIdFromEntity(entity))
    end
end

function QBCore.Functions.DeleteEntity(entity)
    SetEntityAsMissionEntity(entity, false, false)
    DeleteEntity(entity)

    if NetworkGetEntityIsNetworked(entity) then
        local attempt = 0
        while not NetworkHasControlOfEntity(entity) and attempt < 100 and DoesEntityExist(entity) do
            Citizen.Wait(20)
            NetworkRequestControlOfEntity(entity)
            attempt = attempt + 1
        end
    end

    if DoesEntityExist(entity) and (not NetworkGetEntityIsNetworked(entity) or NetworkHasControlOfEntity(entity)) then
        SetEntityAsMissionEntity(entity, false, false)
        DeleteEntity(entity)
    end

    if DoesEntityExist(entity) and NetworkGetEntityIsNetworked(entity) then
        TriggerServerEvent('qb-core:server:forcedeleteentity', NetworkGetNetworkIdFromEntity(entity))
    end
end

function QBCore.Functions.SpawnObject(object, coords, cb, networked)
	local model = type(object) == 'number' and object or GetHashKey(object)
	local vector = type(coords) == "vector3" and coords or vec(coords.x, coords.y, coords.z)
	networked = networked == nil and true or networked

	CreateThread(function()
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(10)
        end

		local obj = CreateObject(model, vector.xyz, networked, false, true)
        if networked then
            local timeout = GetGameTimer() + 2000
            while not NetworkGetEntityIsNetworked(obj) or GetGameTimer() > timeout do Citizen.Wait(0) end
        end
		if cb then
			cb(obj)
		end
	end)
end

function QBCore.Functions.SpawnLocalObject(object, coords, cb)
    return QBCore.Functions.SpawnObject(object, coords, cb, false)
end

function QBCore.Functions.GetPlayers(onlyOtherPlayers, returnKeyValue, returnPeds)
	local players, myPlayer = {}, PlayerId()

	for k,player in ipairs(GetActivePlayers()) do
		local ped = GetPlayerPed(player)
        if IsEntityVisible(ped) then
            if DoesEntityExist(ped) and ((onlyOtherPlayers and player ~= myPlayer) or not onlyOtherPlayers) then
                if returnKeyValue then
                    players[player] = ped
                else
                    players[#players + 1] = returnPeds and ped or player
                end
            end
        end
	end

	return players
end

RegisterNUICallback('getNotifyConfig', function(_, cb)
    cb(QBCore.Config.Notify)
end)

function QBCore.Functions.Notify(text, texttype, length)
    exports['MyCity_Notify']:notify(text, texttype, length);
end

--[[function QBCore.Functions.Notify(text, texttype, length, icon)
    local message = {
        action = 'notify',
        type = texttype or 'primary',
        length = length or 5000,
    }

    if type(text) == 'table' then
        message.text = text.text or 'Placeholder'
        message.caption = text.caption or 'Placeholder'
    else
        message.text = text
    end

    if icon then
        message.icon = icon
    end

    SendNUIMessage(message)
end]]

function QBCore.Debug(resource, obj, depth)
    TriggerServerEvent('QBCore:DebugSomething', resource, obj, depth)
end

-- Callback Functions --

-- Client Callback
function QBCore.Functions.CreateClientCallback(name, cb)
    QBCore.ClientCallbacks[name] = cb
end

function QBCore.Functions.TriggerClientCallback(name, cb, ...)
    if not QBCore.ClientCallbacks[name] then return end
    QBCore.ClientCallbacks[name](cb, ...)
end

-- Server Callback
function QBCore.Functions.TriggerCallback(name, cb, ...)
    QBCore.ServerCallbacks[name] = cb
    TriggerServerEvent('QBCore:Server:TriggerCallback', name, ...)
end

function QBCore.Functions.Progressbar(name, label, duration, useWhileDead, canCancel, disableControls, animation, prop, propTwo, onFinish, onCancel)
    if GetResourceState('progressbar') ~= 'started' then error('progressbar needs to be started in order for QBCore.Functions.Progressbar to work') end
    exports['progressbar']:Progress({
        name = name:lower(),
        duration = duration,
        label = label,
        useWhileDead = useWhileDead,
        canCancel = canCancel,
        controlDisables = disableControls,
        animation = animation,
        prop = prop,
        propTwo = propTwo,
    }, function(cancelled)
        if not cancelled then
            if onFinish then
                onFinish()
            end
        else
            if onCancel then
                onCancel()
            end
        end
    end)
end

-- Getters

function QBCore.Functions.GetVehicles(ignoreList)
    local vehPool = GetGamePool('CVehicle')
    local vehs = {}
    ignoreList = ignoreList or {}
    for i = 1, #vehPool, 1 do
        local found = false
        for j = 1, #ignoreList, 1 do
            if ignoreList[j] == vehPool[i] then
                found = true
                break
            end
        end
        if not found then
            vehs[#vehs + 1] = vehPool[i]
        end
    end
    return vehs
end

function QBCore.Functions.GetObjects()
    return GetGamePool('CObject')
end

function QBCore.Functions.GetPlayers()
    return GetActivePlayers()
end

function QBCore.Functions.GetPeds(ignoreList)
    local pedPool = GetGamePool('CPed')
    local peds = {}
    ignoreList = ignoreList or {}
    for i = 1, #pedPool, 1 do
        local found = false
        for j = 1, #ignoreList, 1 do
            if ignoreList[j] == pedPool[i] then
                found = true
            end
        end
        if not found then
            peds[#peds + 1] = pedPool[i]
        end
    end
    return peds
end

function QBCore.Functions.GetClosestPed(coords, ignoreList)
    local ped = PlayerPedId()
    if coords then
        coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
    else
        coords = GetEntityCoords(ped)
    end
    ignoreList = ignoreList or {}
    local peds = QBCore.Functions.GetPeds(ignoreList)
    local closestDistance = -1
    local closestPed = -1
    for i = 1, #peds, 1 do
        local pedCoords = GetEntityCoords(peds[i])
        local distance = #(pedCoords - coords)

        if closestDistance == -1 or closestDistance > distance then
            closestPed = peds[i]
            closestDistance = distance
        end
    end
    return closestPed, closestDistance
end

function QBCore.Functions.IsWearingGloves()
    local ped = PlayerPedId()
    local armIndex = GetPedDrawableVariation(ped, 3)
    local model = GetEntityModel(ped)
    if model == `mp_m_freemode_01` then
        if QBCore.Shared.MaleNoGloves[armIndex] then
            return false
        end
    elseif model == `mp_f_freemode_01` then
        if QBCore.Shared.FemaleNoGloves[armIndex] then
            return false
        end
    else
        return true
    end
    return true
end

function QBCore.Functions.IsWearingBag()
    local ped = PlayerPedId()
    local armIndex = GetPedDrawableVariation(ped, 5)
    local model = GetEntityModel(ped)
    if model == `mp_m_freemode_01` then
        if QBCore.Shared.MaleBags[armIndex] then
            return true
        end
    elseif model == `mp_f_freemode_01` then
        if QBCore.Shared.FemaleBags[armIndex] then
            return true
        end
    else
        return true
    end
    return false
end

function QBCore.Functions.GetClosestPlayer(coords, blacklist)
    local ped = PlayerPedId()
    if coords then
        coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
    else
        coords = GetEntityCoords(ped)
    end

    local blackListIds = {}
    if blacklist then
        for k,v in pairs(blacklist) do
            blackListIds[v] = true
        end
    end

    local closestPlayers = QBCore.Functions.GetPlayersFromCoords(coords)
    local closestDistance = -1
    local closestPlayer = -1
    for i = 1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() and closestPlayers[i] ~= -1 and not blackListIds[closestPlayers[i]] then
            local ped = GetPlayerPed(closestPlayers[i])
            if IsEntityVisible(ped) then
                local pos = GetEntityCoords(ped)
                local distance = #(pos - coords)

                if closestDistance == -1 or closestDistance > distance then
                    closestPlayer = closestPlayers[i]
                    closestDistance = distance
                end
            end
        end
    end
    return closestPlayer, closestDistance
end

function QBCore.Functions.GetPlayersFromCoords(coords, distance)
    local players = GetActivePlayers()
    local ped = PlayerPedId()
    if coords then
        coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
    else
        coords = GetEntityCoords(ped)
    end
    distance = distance or 5
    local closePlayers = {}
    for _, player in pairs(players) do
        local target = GetPlayerPed(player)
        local targetCoords = GetEntityCoords(target)
        local targetdistance = #(targetCoords - coords)
        if targetdistance <= distance then
            closePlayers[#closePlayers + 1] = player
        end
    end
    return closePlayers
end

function QBCore.Functions.GetClosestVehicle(coords, modelFilter, isWhitelist)
    local vehicles = GetGamePool('CVehicle')
    local closestDistance = -1
    local closestVehicle = -1
    local filteredEntities
    if coords then
        coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
    else
        coords = GetEntityCoords(PlayerPedId())
    end

    if modelFilter then
        local filter = {}
        if type(modelFilter) == 'string' then
            filter[GetHashKey(modelFilter)] = true
        elseif type(modelFilter) == 'table' then
            for _,model in pairs(modelFilter) do
                if type(model) == 'string' then
                    filter[GetHashKey(model)] = true
                else
                    filter[model] = true
                end
            end
        else
            filter[modelFilter] = true
        end
        modelFilter = filter

        local filteredEntities = {}
        for _,entity in pairs(vehicles) do
            if (isWhitelist and modelFilter[GetEntityModel(entity)]) or (not isWhitelist and not modelFilter[GetEntityModel(entity)]) then
                filteredEntities[#filteredEntities+1] = entity
            end
        end
        vehicles = filteredEntities
    end

    for i = 1, #vehicles, 1 do
        local vehicleCoords = GetEntityCoords(vehicles[i])
        local distance = #(vehicleCoords - coords)

        if closestDistance == -1 or closestDistance > distance then
            closestVehicle = vehicles[i]
            closestDistance = distance
        end
    end
    return closestVehicle, closestDistance
end

local function EnumerateEntitiesWithinDistance(entities, isPlayerEntities, coords, maxDistance)
	local nearbyEntities = {}

	if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		local playerPed = ESX.PlayerData.ped
		coords = GetEntityCoords(playerPed)
	end

	for k,entity in pairs(entities) do
		local distance = #(coords - GetEntityCoords(entity))

		if distance <= maxDistance then
			nearbyEntities[#nearbyEntities + 1] = isPlayerEntities and k or entity
		end
	end

	return nearbyEntities
end

function QBCore.Functions.GetVehiclesInArea(coords, maxDistance) -- Vehicle inspection in designated area
	return EnumerateEntitiesWithinDistance(GetGamePool('CVehicle'), false, coords, maxDistance)
end

function QBCore.Functions.GetPlayersInArea(coords, maxDistance)
	return EnumerateEntitiesWithinDistance(QBCore.Functions.GetPlayers(true, true), true, coords, maxDistance)
end

function QBCore.Functions.IsSpawnPointClear(coords, maxDistance) -- Check the spawn point to see if it's empty or not:
	return #QBCore.Functions.GetVehiclesInArea(coords, maxDistance) == 0
end

function QBCore.Functions.GetClosestObject(coords, modelFilter, isWhitelist, entityFilter, isEntityFilterWhitelist)
    local objects = GetGamePool('CObject')
    local closestDistance = -1
    local closestObject = -1

    if coords then
        coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
    else
        coords = GetEntityCoords(PlayerPedId())
    end

    if modelFilter then
        local filter = {}
        if type(modelFilter) == 'string' then
            filter[GetHashKey(modelFilter)] = true
        elseif type(modelFilter) == 'table' then
            for _,model in pairs(modelFilter) do
                filter[GetHashKey(model)] = true
            end
        else
            filter[modelFilter] = true
        end
        modelFilter = filter

        local filteredEntities = {}
        for _,entity in pairs(objects) do
            if (isWhitelist and modelFilter[GetEntityModel(entity)]) or (not isWhitelist and not modelFilter[GetEntityModel(entity)]) then

                filteredEntities[#filteredEntities+1] = entity
            end
        end
        objects = filteredEntities
    end

    if entityFilter then
        local filter = {}
        if type(entityFilter) == 'table' then
            for _,entity in pairs(entityFilter) do
                filter[entity] = true
            end
        else
            filter[entityFilter] = true
        end
        entityFilter = filter

        local filteredEntities = {}
        for _,entity in pairs(objects) do
            if (isEntityFilterWhitelist and entityFilter[entity]) or (not isEntityFilterWhitelist and not entityFilter[entity]) then
                filteredEntities[#filteredEntities+1] = entity
            end
        end
        objects = filteredEntities
    end

    for i = 1, #objects, 1 do
        local distance = #(GetEntityCoords(objects[i]) - coords)
        if closestDistance == -1 or closestDistance > distance then
            closestObject = objects[i]
            closestDistance = distance
        end
    end
    return closestObject, closestDistance
end

function QBCore.Functions.GetClosestBone(entity, list)
    local playerCoords, bone, coords, distance = GetEntityCoords(PlayerPedId())
    for _, element in pairs(list) do
        local boneCoords = GetWorldPositionOfEntityBone(entity, element.id or element)
        local boneDistance = #(playerCoords - boneCoords)
        if not coords then
            bone, coords, distance = element, boneCoords, boneDistance
        elseif distance > boneDistance then
            bone, coords, distance = element, boneCoords, boneDistance
        end
    end
    if not bone then
        bone = {id = GetEntityBoneIndexByName(entity, "bodyshell"), type = "remains", name = "bodyshell"}
        coords = GetWorldPositionOfEntityBone(entity, bone.id)
        distance = #(coords - playerCoords)
    end
    return bone, coords, distance
end

function QBCore.Functions.GetBoneDistance(entity, boneType, boneIndex)
    local bone
    if boneType == 1 then
        bone = GetPedBoneIndex(entity, boneIndex)
    else
        bone = GetEntityBoneIndexByName(entity, boneIndex)
    end
    local boneCoords = GetWorldPositionOfEntityBone(entity, bone)
    local playerCoords = GetEntityCoords(PlayerPedId())
    return #(boneCoords - playerCoords)
end

function QBCore.Functions.AttachProp(ped, model, boneId, x, y, z, xR, yR, zR, vertex)
    local modelHash = type(model) == 'string' and joaat(model) or model
    local bone = GetPedBoneIndex(ped, boneId)
    QBCore.Functions.LoadModel(modelHash)
    local prop = CreateObject(modelHash, 1.0, 1.0, 1.0, 1, 1, 0)
    AttachEntityToEntity(prop, ped, bone, x, y, z, xR, yR, zR, 1, 1, 0, 1, not vertex and 2 or 0, 1)
    SetModelAsNoLongerNeeded(modelHash)
    return prop
end

-- Vehicle

function QBCore.Functions.SpawnVehicle(vehicle, coords, heading, networked)
	local model = (type(vehicle) == 'number' and vehicle or GetHashKey(vehicle))
	local vector = type(coords) == "vector3" and coords or vec(coords.x, coords.y, coords.z)
	networked = networked == nil and true or networked

    QBCore.Functions.LoadModel(model)
    local vehicle = CreateVehicle(model, vector.xyz, heading, networked, false)

    while not DoesEntityExist(vehicle) do Citizen.Wait(0) end

    if networked then
        local id = NetworkGetNetworkIdFromEntity(vehicle)
        SetNetworkIdCanMigrate(id, true)
        SetEntityAsMissionEntity(vehicle, true, false)
    end

    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    SetVehicleNeedsToBeHotwired(vehicle, false)
    SetVehRadioStation(vehicle, 'OFF')
    SetVehicleRadioEnabled(vehicle, false)
    SetVehicleDoorsLocked(vehicle, 1)
    SetVehicleDoorsLockedForAllPlayers(vehicle, false)
    SetVehicleDirtLevel(vehicle, 0.0)

    RequestCollisionAtCoord(vector.xyz)
    while not HasCollisionLoadedAroundEntity(vehicle) do
        Wait(0)
    end

    if model == `forklift` or model == `trflat` or model == `graintrailer` or model == `raketrailer` then
        SetEntityInvincible(vehicle, true)
    end

    SetModelAsNoLongerNeeded(model)

    return vehicle
end

function QBCore.Functions.SpawnLocalVehicle(vehicle, coords, heading)
	return QBCore.Functions.SpawnVehicle(vehicle, coords, heading, false)
end

function QBCore.Functions.DeleteVehicle(vehicle)
    SetEntityAsMissionEntity(vehicle, true, true)
    DeleteVehicle(vehicle)

    if NetworkGetEntityIsNetworked(vehicle) then
        local attempt = 0
        while not NetworkHasControlOfEntity(vehicle) and attempt < 100 and DoesEntityExist(vehicle) do
            Citizen.Wait(20)
            NetworkRequestControlOfEntity(vehicle)
            attempt = attempt + 1
        end
    end

    if DoesEntityExist(vehicle) and (not NetworkGetEntityIsNetworked(vehicle) or NetworkHasControlOfEntity(vehicle))  then
        SetEntityAsMissionEntity(vehicle, false, false)
        DeleteEntity(vehicle)
    end

    if DoesEntityExist(vehicle) and NetworkGetEntityIsNetworked(vehicle) then
        TriggerServerEvent('qb-core:server:forcedeleteentity', NetworkGetNetworkIdFromEntity(vehicle))
    end
end

function QBCore.Functions.GetPlate(vehicle)
    if vehicle == 0 then return end
    return QBCore.Shared.Trim(GetVehicleNumberPlateText(vehicle))
end

function QBCore.Functions.IsVehicleLocked(vehicle)
    local doorsStatus = GetVehicleDoorLockStatus(vehicle)
    return doorsStatus ~= 1
end

function QBCore.Functions.GetVehicleLabel(vehicle)
    if vehicle == nil or vehicle == 0 then return end
    return GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
end

function QBCore.Functions.GetVehicleName(model)
    local displayName = GetDisplayNameFromVehicleModel(model)
    local labelText = GetLabelText(displayName)
    return (labelText ~= 'NULL' and labelText) or displayName
end

function QBCore.Functions.SpawnClear(coords, radius)
    if coords then
        coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
    else
        coords = GetEntityCoords(PlayerPedId())
    end
    local vehicles = GetGamePool('CVehicle')
    local closeVeh = {}
    for i = 1, #vehicles, 1 do
        local vehicleCoords = GetEntityCoords(vehicles[i])
        local distance = #(vehicleCoords - coords)
        if distance <= radius then
            closeVeh[#closeVeh + 1] = vehicles[i]
        end
    end
    if #closeVeh > 0 then return false end
    return true
end

function QBCore.Functions.GetVehicleProperties(vehicle)
    if DoesEntityExist(vehicle) then
        local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)

        local finishPrimary, finishSecondary
        local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
        if GetIsVehiclePrimaryColourCustom(vehicle) then
            finishPrimary = colorPrimary
            local r, g, b = GetVehicleCustomPrimaryColour(vehicle)
            colorPrimary = {r, g, b}
        end

        if GetIsVehicleSecondaryColourCustom(vehicle) then
            finishSecondary = colorSecondary
            local r, g, b = GetVehicleCustomSecondaryColour(vehicle)
            colorSecondary = {r, g, b}
        end

        local extras = {}
        for extraId = 0, 12 do
            if DoesExtraExist(vehicle, extraId) then
                local state = IsVehicleExtraTurnedOn(vehicle, extraId) == 1
                extras[tostring(extraId)] = state
            end
        end

        local modLivery = GetVehicleMod(vehicle, 48)
        if modLivery == -1 then
            modLivery = GetVehicleLivery(vehicle)
        end

        local tireHealth = {}
        for i = 0, 3 do
            tireHealth[i] = GetVehicleWheelHealth(vehicle, i)
        end

        local tireBurstState = {}
        for i = 0, 5 do
           tireBurstState[i] = IsVehicleTyreBurst(vehicle, i, false)
        end

        local tireBurstCompletely = {}
        for i = 0, 5 do
            tireBurstCompletely[i] = IsVehicleTyreBurst(vehicle, i, true)
        end

        local windowStatus = {}
        for i = 0, 7 do
            windowStatus[i] = IsVehicleWindowIntact(vehicle, i) == 1
        end

        local doorStatus = {}
        for i = 0, 5 do
            doorStatus[i] = IsVehicleDoorDamaged(vehicle, i) == 1
        end

        local xenonColor
        local hasCustom, r, g, b = GetVehicleXenonLightsCustomColor(vehicle)
        if hasCustom then
            xenonColor = table.pack(r, g, b)
        else
            xenonColor = GetVehicleXenonLightsColor(vehicle)
        end

        return {
            model = GetEntityModel(vehicle),
            plate = QBCore.Functions.GetPlate(vehicle),
            plateIndex = GetVehicleNumberPlateTextIndex(vehicle),
            bodyHealth = QBCore.Shared.Round(GetVehicleBodyHealth(vehicle), 0.1),
            engineHealth = QBCore.Shared.Round(GetVehicleEngineHealth(vehicle), 0.1),
            tankHealth = QBCore.Shared.Round(GetVehiclePetrolTankHealth(vehicle), 0.1),
            fuelLevel = QBCore.Shared.Round(GetVehicleFuelLevel(vehicle), 0.1),
            dirtLevel = QBCore.Shared.Round(GetVehicleDirtLevel(vehicle), 0.1),
            oilLevel = QBCore.Shared.Round(GetVehicleOilLevel(vehicle), 0.1),
            color1 = colorPrimary,
            color2 = colorSecondary,
            finish1 = finishPrimary,
            finish2 = finishSecondary,
            pearlescentColor = pearlescentColor,
            dashboardColor = GetVehicleDashboardColour(vehicle),
            wheelColor = wheelColor,
            wheels = GetVehicleWheelType(vehicle),
            wheelSize = GetVehicleWheelSize(vehicle),
            wheelWidth = GetVehicleWheelWidth(vehicle),
            tireHealth = tireHealth,
            tireBurstState = tireBurstState,
            tireBurstCompletely = tireBurstCompletely,
            windowTint = GetVehicleWindowTint(vehicle),
            windowStatus = windowStatus,
            doorStatus = doorStatus,
            neonEnabled = {
                IsVehicleNeonLightEnabled(vehicle, 0),
                IsVehicleNeonLightEnabled(vehicle, 1),
                IsVehicleNeonLightEnabled(vehicle, 2),
                IsVehicleNeonLightEnabled(vehicle, 3)
            },
            neonColor = table.pack(GetVehicleNeonLightsColour(vehicle)),
            interiorColor = GetVehicleInteriorColour(vehicle),
            extras = extras,
            tyreSmokeColor = table.pack(GetVehicleTyreSmokeColor(vehicle)),
            xenonColor = xenonColor,
            modSpoilers = GetVehicleMod(vehicle, 0),
            modFrontBumper = GetVehicleMod(vehicle, 1),
            modRearBumper = GetVehicleMod(vehicle, 2),
            modSideSkirt = GetVehicleMod(vehicle, 3),
            modExhaust = GetVehicleMod(vehicle, 4),
            modFrame = GetVehicleMod(vehicle, 5),
            modGrille = GetVehicleMod(vehicle, 6),
            modHood = GetVehicleMod(vehicle, 7),
            modFender = GetVehicleMod(vehicle, 8),
            modRightFender = GetVehicleMod(vehicle, 9),
            modRoof = GetVehicleMod(vehicle, 10),
            modEngine = GetVehicleMod(vehicle, 11),
            modBrakes = GetVehicleMod(vehicle, 12),
            modTransmission = GetVehicleMod(vehicle, 13),
            modHorns = GetVehicleMod(vehicle, 14),
            modSuspension = GetVehicleMod(vehicle, 15),
            modArmor = GetVehicleMod(vehicle, 16),
            modKit17 = GetVehicleMod(vehicle, 17),
            modTurbo = IsToggleModOn(vehicle, 18),
            modKit19 = GetVehicleMod(vehicle, 19),
            modSmokeEnabled = IsToggleModOn(vehicle, 20),
            modKit21 = GetVehicleMod(vehicle, 21),
            modXenon = IsToggleModOn(vehicle, 22),
            modFrontWheels = GetVehicleMod(vehicle, 23),
            modBackWheels = GetVehicleMod(vehicle, 24),
            modCustomTiresF = GetVehicleModVariation(vehicle, 23),
            modCustomTiresR = GetVehicleModVariation(vehicle, 24),
            modPlateHolder = GetVehicleMod(vehicle, 25),
            modVanityPlate = GetVehicleMod(vehicle, 26),
            modTrimA = GetVehicleMod(vehicle, 27),
            modOrnaments = GetVehicleMod(vehicle, 28),
            modDashboard = GetVehicleMod(vehicle, 29),
            modDial = GetVehicleMod(vehicle, 30),
            modDoorSpeaker = GetVehicleMod(vehicle, 31),
            modSeats = GetVehicleMod(vehicle, 32),
            modSteeringWheel = GetVehicleMod(vehicle, 33),
            modShifterLeavers = GetVehicleMod(vehicle, 34),
            modAPlate = GetVehicleMod(vehicle, 35),
            modSpeakers = GetVehicleMod(vehicle, 36),
            modTrunk = GetVehicleMod(vehicle, 37),
            modHydrolic = GetVehicleMod(vehicle, 38),
            modEngineBlock = GetVehicleMod(vehicle, 39),
            modAirFilter = GetVehicleMod(vehicle, 40),
            modStruts = GetVehicleMod(vehicle, 41),
            modArchCover = GetVehicleMod(vehicle, 42),
            modAerials = GetVehicleMod(vehicle, 43),
            modTrimB = GetVehicleMod(vehicle, 44),
            modTank = GetVehicleMod(vehicle, 45),
            modWindows = GetVehicleMod(vehicle, 46),
            modKit47 = GetVehicleMod(vehicle, 47),
            modLivery = modLivery,
            modKit49 = GetVehicleMod(vehicle, 49),
            liveryRoof = GetVehicleRoofLivery(vehicle),
            deformation = exports.MyCity_CoreV2:GetVehicleDeformation(vehicle)
        }
    else
        return {}
    end
end

function QBCore.Functions.SetVehicleProperties(vehicle, props)
    if DoesEntityExist(vehicle) and props then
        QBCore.Functions.RequestControlEntity(vehicle)

        SetVehicleModKit(vehicle, 0)

        --[[local attempt = 0
        while GetVehicleModKit(vehicle) ~= 0 and DoesEntityExist(vehicle) and attempt < 40 do
            attempt = attempt + 1
            SetVehicleModKit(vehicle, 0)
            Wait(0)
        end]]

        if props.extras then
            for id, enabled in pairs(props.extras) do
                if enabled then
                    SetVehicleExtra(vehicle, tonumber(id), 0)
                else
                    SetVehicleExtra(vehicle, tonumber(id), 1)
                end
            end
        end

        local colorPrimary, colorSecondary = GetVehicleColours(vehicle)

        if props.color1 then
            if type(props.color1) == "number" then
                colorPrimary = props.color1
            else
                if props.finish1 then
                    colorPrimary = props.finish1
                end
            end
            ClearVehicleCustomPrimaryColour(vehicle)
        end

        if props.color2 then
            if type(props.color2) == "number" then
                colorSecondary = props.color2
            else
                if props.finish2 then
                    colorSecondary = props.finish2
                end
            end
            ClearVehicleCustomSecondaryColour(vehicle)
        end

        SetVehicleColours(vehicle, colorPrimary, colorSecondary)

        if props.color1 and type(props.color1) == "table" then
            SetVehicleCustomPrimaryColour(vehicle, props.color1[1], props.color1[2], props.color1[3])
        end

        if props.color2 and type(props.color2) == "table" then
            SetVehicleCustomSecondaryColour(vehicle, props.color2[1], props.color2[2], props.color2[3])
        end

        local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)

        if props.pearlescentColor or props.wheelColor then
            SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor or wheelColor)
        end

        if props.interiorColor then
            SetVehicleInteriorColor(vehicle, props.interiorColor)
        end

        if props.dashboardColor then
            SetVehicleDashboardColour(vehicle, props.dashboardColor)
        end

        if props.plate then
            SetVehicleNumberPlateText(vehicle, props.plate)
        end
        if props.plateIndex then
            SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex)
        end
        if props.bodyHealth then
            SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0)
        end
        if props.engineHealth then
            SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0)
        end
        if props.tankHealth then
            --SetVehiclePetrolTankHealth(vehicle, props.tankHealth)
        end
        if props.fuelLevel then
            if props.fuelLevel > 100.0 then
                props.fuelLevel = 100.0
            end
            SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0)
            DecorSetFloat(vehicle, "_FUEL_LEVEL", GetVehicleFuelLevel(vehicle))
        end
        if props.dirtLevel then
            SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0)
        end
        if props.oilLevel then
            SetVehicleOilLevel(vehicle, props.oilLevel)
        end

        if props.wheels then
            SetVehicleWheelType(vehicle, props.wheels)
        end
        if props.tireHealth then
            for wheelIndex, health in pairs(props.tireHealth) do
                SetVehicleWheelHealth(vehicle, wheelIndex, health)
            end
        end
        if props.tireBurstState then
            for wheelIndex, burstState in pairs(props.tireBurstState) do
                if burstState then
                    SetVehicleTyreBurst(vehicle, tonumber(wheelIndex), false, 1000.0)
                end
            end
        end
        if props.tireBurstCompletely then
            for wheelIndex, burstState in pairs(props.tireBurstCompletely) do
                if burstState then
                    SetVehicleTyreBurst(vehicle, tonumber(wheelIndex), true, 1000.0)
                end
            end
        end
        if props.windowTint then
            SetVehicleWindowTint(vehicle, props.windowTint)
        end
        if props.windowStatus then
            for windowIndex, smashWindow in pairs(props.windowStatus) do
                if not smashWindow then SmashVehicleWindow(vehicle, windowIndex) end
            end
        end
        if props.doorStatus then
            for doorIndex, breakDoor in pairs(props.doorStatus) do
                if breakDoor then
                    SetVehicleDoorBroken(vehicle, tonumber(doorIndex), true)
                end
            end
        end
        if props.neonEnabled then
            SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
            SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
            SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
            SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
        end
        if props.neonColor then
            SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3])
        end
        if props.interiorColor then
            SetVehicleInteriorColour(vehicle, props.interiorColor)
        end
        if props.wheelSize then
            SetVehicleWheelSize(vehicle, props.wheelSize)
        end
        if props.wheelWidth then
            SetVehicleWheelWidth(vehicle, props.wheelWidth)
        end
        if props.tyreSmokeColor then
            SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3])
        end
        if props.modSpoilers then
            SetVehicleMod(vehicle, 0, props.modSpoilers, false)
        end
        if props.modFrontBumper then
            SetVehicleMod(vehicle, 1, props.modFrontBumper, false)
        end
        if props.modRearBumper then
            SetVehicleMod(vehicle, 2, props.modRearBumper, false)
        end
        if props.modSideSkirt then
            SetVehicleMod(vehicle, 3, props.modSideSkirt, false)
        end
        if props.modExhaust then
            SetVehicleMod(vehicle, 4, props.modExhaust, false)
        end
        if props.modFrame then
            SetVehicleMod(vehicle, 5, props.modFrame, false)
        end
        if props.modGrille then
            SetVehicleMod(vehicle, 6, props.modGrille, false)
        end
        if props.modHood then
            SetVehicleMod(vehicle, 7, props.modHood, false)
        end
        if props.modFender then
            SetVehicleMod(vehicle, 8, props.modFender, false)
        end
        if props.modRightFender then
            SetVehicleMod(vehicle, 9, props.modRightFender, false)
        end
        if props.modRoof then
            SetVehicleMod(vehicle, 10, props.modRoof, false)
        end
        if props.modEngine then
            SetVehicleMod(vehicle, 11, props.modEngine, false)
        end
        if props.modBrakes then
            SetVehicleMod(vehicle, 12, props.modBrakes, false)
        end
        if props.modTransmission then
            SetVehicleMod(vehicle, 13, props.modTransmission, false)
        end
        if props.modHorns then
            SetVehicleMod(vehicle, 14, props.modHorns, false)
        end
        if props.modSuspension then
            SetVehicleMod(vehicle, 15, props.modSuspension, false)
        end
        if props.modArmor then
            SetVehicleMod(vehicle, 16, props.modArmor, false)
        end
        if props.modKit17 then
            SetVehicleMod(vehicle, 17, props.modKit17, false)
        end
        if props.modTurbo then
            ToggleVehicleMod(vehicle, 18, props.modTurbo)
        end
        if props.modKit19 then
            SetVehicleMod(vehicle, 19, props.modKit19, false)
        end
        if props.modSmokeEnabled then
            ToggleVehicleMod(vehicle, 20, props.modSmokeEnabled)
        end
        if props.modKit21 then
            SetVehicleMod(vehicle, 21, props.modKit21, false)
        end
        if props.modXenon then
            ToggleVehicleMod(vehicle, 22, props.modXenon)
        end
        if props.xenonColor then
            if type(props.xenonColor) == 'table' then
                SetVehicleXenonLightsCustomColor(vehicle, props.xenonColor[1], props.xenonColor[2], props.xenonColor[3])
            else
                SetVehicleXenonLightsColor(vehicle, props.xenonColor)
            end
        end
        if props.modFrontWheels then
            SetVehicleMod(vehicle, 23, props.modFrontWheels, props.modCustomTiresF)
        end
        if props.modBackWheels then
            SetVehicleMod(vehicle, 24, props.modBackWheels, props.modCustomTiresR)
        end
        if props.modPlateHolder then
            SetVehicleMod(vehicle, 25, props.modPlateHolder, false)
        end
        if props.modVanityPlate then
            SetVehicleMod(vehicle, 26, props.modVanityPlate, false)
        end
        if props.modTrimA then
            SetVehicleMod(vehicle, 27, props.modTrimA, false)
        end
        if props.modOrnaments then
            SetVehicleMod(vehicle, 28, props.modOrnaments, false)
        end
        if props.modDashboard then
            SetVehicleMod(vehicle, 29, props.modDashboard, false)
        end
        if props.modDial then
            SetVehicleMod(vehicle, 30, props.modDial, false)
        end
        if props.modDoorSpeaker then
            SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false)
        end
        if props.modSeats then
            SetVehicleMod(vehicle, 32, props.modSeats, false)
        end
        if props.modSteeringWheel then
            SetVehicleMod(vehicle, 33, props.modSteeringWheel, false)
        end
        if props.modShifterLeavers then
            SetVehicleMod(vehicle, 34, props.modShifterLeavers, false)
        end
        if props.modAPlate then
            SetVehicleMod(vehicle, 35, props.modAPlate, false)
        end
        if props.modSpeakers then
            SetVehicleMod(vehicle, 36, props.modSpeakers, false)
        end
        if props.modTrunk then
            SetVehicleMod(vehicle, 37, props.modTrunk, false)
        end
        if props.modHydrolic then
            SetVehicleMod(vehicle, 38, props.modHydrolic, false)
        end
        if props.modEngineBlock then
            SetVehicleMod(vehicle, 39, props.modEngineBlock, false)
        end
        if props.modAirFilter then
            SetVehicleMod(vehicle, 40, props.modAirFilter, false)
        end
        if props.modStruts then
            SetVehicleMod(vehicle, 41, props.modStruts, false)
        end
        if props.modArchCover then
            SetVehicleMod(vehicle, 42, props.modArchCover, false)
        end
        if props.modAerials then
            SetVehicleMod(vehicle, 43, props.modAerials, false)
        end
        if props.modTrimB then
            SetVehicleMod(vehicle, 44, props.modTrimB, false)
        end
        if props.modTank then
            SetVehicleMod(vehicle, 45, props.modTank, false)
        end
        if props.modWindows then
            SetVehicleMod(vehicle, 46, props.modWindows, false)
        end
        if props.modKit47 then
            SetVehicleMod(vehicle, 47, props.modKit47, false)
        end
        if props.modLivery then
            SetVehicleMod(vehicle, 48, props.modLivery, false)
            SetVehicleLivery(vehicle, props.modLivery)
        end
        if props.modKit49 then
            SetVehicleMod(vehicle, 49, props.modKit49, false)
        end
        if props.liveryRoof then
            SetVehicleRoofLivery(vehicle, props.liveryRoof)
        end
        if props.deformation then
            exports.MyCity_CoreV2:SetVehicleDeformation(vehicle, props.deformation)
        end

        exports.nakres_lightbar:loadLightbarInCar(spawnedVehicle)
    end
end

function QBCore.Functions.LoadParticleDictionary(dictionary)
    if HasNamedPtfxAssetLoaded(dictionary) then return end
    RequestNamedPtfxAsset(dictionary)
    while not HasNamedPtfxAssetLoaded(dictionary) do
        Wait(0)
    end
end

function QBCore.Functions.StartParticleAtCoord(dict, ptName, looped, coords, rot, scale, alpha, color, duration)
    if coords then
        coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
    else
        coords = GetEntityCoords(PlayerPedId())
    end
    QBCore.Functions.LoadParticleDictionary(dict)
    UseParticleFxAssetNextCall(dict)
    SetPtfxAssetNextCall(dict)
    local particleHandle
    if looped then
        particleHandle = StartParticleFxLoopedAtCoord(ptName, coords.x, coords.y, coords.z, rot.x, rot.y, rot.z, scale or 1.0)
        if color then
            SetParticleFxLoopedColour(particleHandle, color.r, color.g, color.b, false)
        end
        SetParticleFxLoopedAlpha(particleHandle, alpha or 10.0)
        if duration then
            Wait(duration)
            StopParticleFxLooped(particleHandle, 0)
        end
    else
        SetParticleFxNonLoopedAlpha(alpha or 10.0)
        if color then
            SetParticleFxNonLoopedColour(color.r, color.g, color.b)
        end
        StartParticleFxNonLoopedAtCoord(ptName, coords.x, coords.y, coords.z, rot.x, rot.y, rot.z, scale or 1.0)
    end
    return particleHandle
end

function QBCore.Functions.StartParticleOnEntity(dict, ptName, looped, entity, bone, offset, rot, scale, alpha, color, evolution, duration)
    QBCore.Functions.LoadParticleDictionary(dict)
    UseParticleFxAssetNextCall(dict)
    local particleHandle, boneID
    if bone and GetEntityType(entity) == 1 then
        boneID = GetPedBoneIndex(entity, bone)
    elseif bone then
        boneID = GetEntityBoneIndexByName(entity, bone)
    end
    if looped then
        if bone then
            particleHandle = StartParticleFxLoopedOnEntityBone(ptName, entity, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, boneID, scale)
        else
            particleHandle = StartParticleFxLoopedOnEntity(ptName, entity, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, scale)
        end
        if evolution then
            SetParticleFxLoopedEvolution(particleHandle, evolution.name, evolution.amount, false)
        end
        if color then
            SetParticleFxLoopedColour(particleHandle, color.r, color.g, color.b, false)
        end
        SetParticleFxLoopedAlpha(particleHandle, alpha)
        if duration then
            Wait(duration)
            StopParticleFxLooped(particleHandle, 0)
        end
    else
        SetParticleFxNonLoopedAlpha(alpha or 10.0)
        if color then
            SetParticleFxNonLoopedColour(color.r, color.g, color.b)
        end
        if bone then
            StartParticleFxNonLoopedOnPedBone(ptName, entity, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, boneID, scale)
        else
            StartParticleFxNonLoopedOnEntity(ptName, entity, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, scale)
        end
    end
    return particleHandle
end

function QBCore.Functions.GetStreetNametAtCoords(coords)
    local streetname1, streetname2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    return { main = GetStreetNameFromHashKey(streetname1), cross = GetStreetNameFromHashKey(streetname2) }
end

function QBCore.Functions.GetZoneAtCoords(coords)
    return GetLabelText(GetNameOfZone(coords))
end

function QBCore.Functions.GetCardinalDirection(entity)
    entity = DoesEntityExist(entity) and entity or PlayerPedId()
    if DoesEntityExist(entity) then
        local heading = GetEntityHeading(entity)
        if ((heading >= 0 and heading < 45) or (heading >= 315 and heading < 360)) then
            return 'North'
        elseif (heading >= 45 and heading < 135) then
            return 'West'
        elseif (heading >= 135 and heading < 225) then
            return 'South'
        elseif (heading >= 225 and heading < 315) then
            return 'East'
        end
    else
        return 'Cardinal Direction Error'
    end
end

function QBCore.Functions.GetCurrentTime()
    local obj = {}
    obj.min = GetClockMinutes()
    obj.hour = GetClockHours()

    if obj.hour <= 12 then
        obj.ampm = 'AM'
    elseif obj.hour >= 13 then
        obj.ampm = 'PM'
        obj.formattedHour = obj.hour - 12
    end

    if obj.min <= 9 then
        obj.formattedMin = '0' .. obj.min
    end

    return obj
end

function QBCore.Functions.GetGroundZCoord(coords)
    if not coords then return end

    local retval, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z, 0)
    if retval then
        return vector3(coords.x, coords.y, groundZ)
    else
        print('Couldn\'t find Ground Z Coordinates given 3D Coordinates')
        return coords
    end
end

function QBCore.Functions.GetGroundHash(entity)
    local coords = GetEntityCoords(entity)
    local num = StartShapeTestCapsule(coords.x, coords.y, coords.z + 4, coords.x, coords.y, coords.z - 2.0, 1, 1, entity, 7)
    local retval, success, endCoords, surfaceNormal, materialHash, entityHit = GetShapeTestResultEx(num)
    return materialHash, entityHit, surfaceNormal, endCoords, success, retval
end

local hasPlayerLoaded = false

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    hasPlayerLoaded = true
end)

function QBCore.Functions.HasPlayerLoaded()
    return hasPlayerLoaded
end
