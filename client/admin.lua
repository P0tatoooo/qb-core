local autohealing
RegisterNetEvent('MyCity:CoreV2:AdminMenu:AutoHeal')
AddEventHandler('MyCity:CoreV2:AdminMenu:AutoHeal', function(bool)
    autohealing = bool
    Citizen.Wait(250)
    if autohealing then
        Citizen.CreateThread(function()
            while autohealing do
                local PlayerData = QBCore.Functions.GetPlayerData()
                if GetEntityHealth(PlayerPedId()) < 200 or PlayerData.metadata.hunger < 90 or PlayerData.metadata.thirst < 90 then
                    ExecuteCommand('heal')
                end
                Citizen.Wait(60000)
            end
        end)
    end
end)