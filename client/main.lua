QBCore = {}
QBCore.PlayerData = {}
QBCore.Config = QBConfig
QBCore.Shared = QBShared
QBCore.ClientCallbacks = {}
QBCore.ServerCallbacks = {}

exports('GetCoreObject', function()
    return QBCore
end)

Citizen.CreateThread(function()
    Citizen.Wait(5000)
    QBCore.Functions.TriggerCallback('QBCore:GetServerGangs', function(gangs, jobs)
        QBCore.Shared.Gangs = gangs
        QBCore.Shared.Jobs = jobs
        TriggerEvent("QBCore:Client:UpdateObject")
    end)
end)

-- To use this export in a script instead of manifest method
-- Just put this line of code below at the very top of the script
-- local QBCore = exports['qb-core']:GetCoreObject()
