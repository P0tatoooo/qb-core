local autohealing
RegisterNetEvent('MyCity:CoreV2:AdminMenu:AutoHeal')
AddEventHandler('MyCity:CoreV2:AdminMenu:AutoHeal', function(bool)
    autohealing = bool
    Citizen.Wait(250)
    if autohealing then
        Citizen.CreateThread(function()
            while autohealing do
                ExecuteCommand('heal')
                Citizen.Wait(60000)
            end
        end)
    end
end)