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
    QBCore.Functions.TriggerLatentCallback('QBCore:GetServerGangs', function(gangs, jobs)
        QBCore.Shared.Gangs = gangs
        QBCore.Shared.Jobs = jobs
        for k,v in pairs(QBCore.Shared.Gangs) do
            TriggerEvent("QBCore:Client:UpdateSpecificObject", "Gangs", k, v)
            Citizen.Wait(100)
        end
        for k,v in pairs(QBCore.Shared.Jobs) do
            TriggerEvent("QBCore:Client:UpdateSpecificObject", "Jobs", k, v)
            Citizen.Wait(100)
        end
    end)
end)

-- To use this export in a script instead of manifest method
-- Just put this line of code below at the very top of the script
-- local QBCore = exports['qb-core']:GetCoreObject()
