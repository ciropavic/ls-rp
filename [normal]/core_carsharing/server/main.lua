ESX = nil
local outtime = 0

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

RegisterServerEvent("core_carsharing:unlockVehicle")
AddEventHandler(
    "core_carsharing:unlockVehicle",
    function(veh)
        TriggerClientEvent("core_carsharing:unlockVehicle", -1, veh)
    end
)

AddEventHandler('playerDropped', function (reason)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll(
        'SELECT hash FROM `rentcar` WHERE `identifier` = @identifier',
        {
            ['@identifier'] = xPlayer.identifier
        },
        function(result)
            DeleteEntity(result[1].hash)
        end)
    
end)


RegisterServerEvent("core_carsharing:deletevehicle")
AddEventHandler("core_carsharing:deletevehicle",function()
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.execute('DELETE FROM `rentcar` WHERE `identifier` = @identifier', {
        ['@identifier'] = xPlayer.identifier
    })
end)

RegisterServerEvent("core_carsharing:createvehicle")
AddEventHandler("core_carsharing:createvehicle",function(hash)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.execute('INSERT INTO rentcar (`identifier`, `time`, `hash`) VALUES (@identifier, @time, @hash);',
	{
		['@identifier'] = xPlayer.identifier,
        ['@time'] = 0,
        ['@hash'] = hash,
	}, function()
	end)
end)


ESX.RegisterServerCallback("core_carsharing:check_license"
, function(source,cb)
    TriggerEvent("esx_license:checkLicense",
    source,
    Config.licenseRequired,function(hasIt)
        if(hasIt)then
        cb(true)    
        else 
        cb(false)
        end
        
    end)
 end)
  
ESX.RegisterServerCallback(
    "core_carsharing:unlockFee",
    function(source, cb, unlockFee,modal)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.getMoney() >= unlockFee then
            if Config.licenseRequired ~= "" and modal ~= -431692672 then
                TriggerEvent(
                    "esx_license:checkLicense",
                    source,
                    Config.licenseRequired,
                    function(hasIt)
                        if hasIt then
                            print("has")
                            xPlayer.removeMoney(unlockFee)
                            cb(true)
                        else
                            cb(false)
                        end
                    end
                )
            else
                xPlayer.removeMoney(unlockFee)
                cb(true)
            end
        else
            cb(false)
        end
    end
)

RegisterServerEvent("core_carsharing:pay")
AddEventHandler(
    "core_carsharing:pay",
    function(amount)
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)

        xPlayer.removeMoney(amount)
    end
)
