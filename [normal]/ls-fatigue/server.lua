ESX                = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent('ls-fatigue:bk')
AddEventHandler('ls-fatigue:bk',function()
	SetPlayerRoutingBucket(source, 0)
    local hostRBID = GetPlayerRoutingBucket(source)
    print("this wo--")
    print(hostRBID)
end)

RegisterServerEvent('ls-fatigue:fatigueset')
AddEventHandler('ls-fatigue:fatigueset',function()
    -- print(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    },
	function (result)
        local user = result[1]
        if user.fatigue <= 0 then

        else
            MySQL.Sync.execute("UPDATE `users` SET `fatigue`=@fatigue WHERE identifier = @identifier", { 
                ['@fatigue'] = user.fatigue - 5,
                ['@identifier'] = xPlayer.identifier
            })
        end
        
	end) 
end)
