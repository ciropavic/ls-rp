ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("ls_saveha:loadingscreenoff")
AddEventHandler("ls_saveha:loadingscreenoff", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.getIdentifier()
    }, function(data)
        if data[1] then
            TriggerClientEvent('ls_saveha:Client:SetPlayerHealthArmour',xPlayer.source, data[1].health, data[1].armour)
        end
    end)
end)


-- ESX.RegisterServerCallback("ls_saveha:loadhealth",function(cb)
--     local xPlayer = ESX.GetPlayerFromId(playerId)
--     MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
-- 		['@identifier'] = xPlayer.getIdentifier()
--     }, function(data)
--         if data[1] then
--             TriggerClientEvent('ls_saveha:Client:SetPlayerHealthArmour', playerId, data[1].health, data[1].armour)
--         end
--     end)
-- end)

RegisterServerEvent('ls_saveha:Server:RefreshCurrent')
AddEventHandler('ls_saveha:Server:RefreshCurrent', function(updateHealth, updateArmour)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    MySQL.Async.execute("UPDATE users SET armour = @armour, health = @health WHERE identifier = @identifier", { 
        ['@identifier'] = xPlayer.getIdentifier(),
        ['@armour'] = tonumber(updateArmour),
        ['@health'] = tonumber(updateHealth)
    })
end)
