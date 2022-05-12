--------------------------------------------------------------------
-------------------------Converted by Eotix#1337--------------------
--------------------------------------------------------------------
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('eotix-vehicleshop:requestInfo')
AddEventHandler('eotix-vehicleshop:requestInfo', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local rows    

    TriggerClientEvent('eotix-vehicleshop:receiveInfo', src, xPlayer.getMoney())
    TriggerClientEvent("eotix-vehicleshop:notify", src, 'error', 'Use A and D To Rotate')
end)

ESX.RegisterServerCallback('eotix-vehicleshop:isPlateTaken', function (source, cb, plate)
	MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function (result)
		cb(result[1] ~= nil)
	end)
end)




RegisterServerEvent('eotix-vehicleshop:CheckMoneyForVeh')
AddEventHandler('eotix-vehicleshop:CheckMoneyForVeh', function(veh, price, name, vehicleProps,red,green,blue,red2,green2,blue2)
local _source = source
local src = source
local xPlayer = ESX.GetPlayerFromId(_source)
print(red)
print(red2)
print(json.encode({r = red, g = green, b = blue}))
if xPlayer.getMoney() >= tonumber(price) or xPlayer.getAccount('bank').money >= tonumber(price) then
	xPlayer.removeMoney(tonumber(price))
	if Config.SpawnVehicle then
		stateVehicle = 0
	else
		stateVehicle = 1
	end



	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle,color1,color2,enginehealth) VALUES (@owner, @plate, @vehicle,@color1,@color2,@enginehealth)',
	{
		['@owner']   = xPlayer.identifier,
		['@plate']   = vehicleProps.plate,
		['@vehicle'] = json.encode(vehicleProps),
		['@color1'] = json.encode({r = red, g = green, b = blue}),
		['@color2'] = json.encode({r = red2, g = green2, b = blue2}),
		['@enginehealth'] = 1000.0 
	}, function (rowsChanged)
		
		MySQL.Async.execute("INSERT INTO `vehicle_keys`(`identifier`, `plate`,`model`,`copied`) VALUES (@identifier,@plate,@model,@copied)", { 
			['@identifier'] = xPlayer.identifier,
			['@plate'] = vehicleProps.plate,
			['@model'] = GetHashKey(veh),
			['@copied'] = 0
		},function(success)
			print("car buy");
		end)

		TriggerClientEvent("eotix-vehicleshop:successfulbuy", _source, name, vehicleProps.plate, price)
		TriggerClientEvent('eotix-vehicleshop:receiveInfo', _source, xPlayer.getMoney())   
		TriggerClientEvent('eotix-vehicleshop:spawnVehicle', _source, veh, vehicleProps.plate)
	end)
	else
        TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Not Enough Money'})
	end
end)
-- // I AM SORRY FOR EVERYONE WHO DOWNLOADED THAT SCRIPT AND IT DON WORKED \\ --
-- // ITS NOW THE FIXED VERSION  \\ -- -- // Eotix#1337 \\ -- -- // Eotix#1337 \\ --
-- // REMOVES MONEY AND IF YOU DONT HAVE ENOUGH IT DONT GIVE YOU THE VEHICLE\\ --
-- // Eotix#1337 \\ -- -- // Eotix#1337 \\ -- -- // Eotix#1337 \\ -- -- // Eotix#1337 \\ --
-- // Eotix#1337 \\ -- -- // Eotix#1337 \\ -- -- // Eotix#1337 \\ -- -- // Eotix#1337 \\ --
-- // Eotix#1337 \\ -- -- // Eotix#1337 \\ -- -- // Eotix#1337 \\ -- -- // Eotix#1337 \\ --
-- // Eotix#1337 \\ -- -- // Eotix#1337 \\ -- -- // Eotix#1337 \\ -- -- // Eotix#1337 \\ --
