RegisterNetEvent('gofast:reward')
AddEventHandler('gofast:reward', function(reward)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        xPlayer.addAccountMoney('money', reward)
    end
end)
