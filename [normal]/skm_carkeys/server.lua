ESX               = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

----
function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end

RegisterServerEvent('skm_carkeys:createKey')
AddEventHandler('skm_carkeys:createKey', function(plate,modelhash)
	local identifier = (GetPlayerIdentifiers(source))
	MySQL.Sync.execute("INSERT INTO `vehicle_keys`(`identifier`, `plate`,`model`,`copied`) VALUES (@identifier,@plate,@model,@copied)", { 
        ['@identifier'] = string.sub(identifier[2], 9,48),
        ['@plate'] = plate,
        ['@model'] = modelhash,
        ['@copied'] = 0
    })
    print("createkeys")
end)

RegisterServerEvent('skm_carkeys:deleteCopiedKey')
AddEventHandler('skm_carkeys:deleteCopiedKey', function(plate)
	MySQL.Sync.execute("DELETE FROM `vehicle_keys` WHERE plate = @plate AND copied = @copied", { 
        ['@plate'] = plate,
        ['@copied'] = 1
    })
end)

RegisterServerEvent('skm_carkeys:giveKey')
AddEventHandler('skm_carkeys:giveKey', function(plate, reciever)
    local identifier = GetPlayerIdentifiers(source)
    local xPlayer = ESX.GetPlayerFromId(reciever)
    MySQL.Sync.execute("UPDATE `vehicle_keys` SET `identifier`=@recieverid WHERE identifier = @identifier AND plate = @plate", { 
        ['@recieverid'] = xPlayer.identifier,
        ['@identifier'] = string.sub(identifier[2], 9,48),
        ['@plate'] = plate
    })
    MySQL.Async.fetchAll('SELECT log FROM vehicle_keys WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		print(json.encode(result))
		local data = {}
		if result[1].log then
			data = json.decode(result[1].log)
		end
        table.insert(data, {label = xPlayer.identifier, value = plate})
	end)
    MySQL.Sync.execute("UPDATE `vehicle_keys` SET `log`=@log WHERE plate = @plate AND identifier = @recieverid", { 
        ['@recieverid'] = xPlayer.identifier,
        ['@log'] = json.encode(data),
        ['@plate'] = plate
    })
    print("givekey")
    print(xPlayer.identifier)
    TriggerClientEvent('esx:showNotification',reciever, '차키를 받았습니다. 차량번호 ~g~' ..plate)
end)

ESX.RegisterServerCallback("skm_carkeys:countCopiedKeys",function(source,cb,plate)
    MySQL.Async.fetchAll('SELECT identifier FROM vehicle_keys WHERE plate = @plate AND copied = @copied', {
        ['@plate'] = plate,
        ['@copied'] = 1
	}, function(result)
        local count = 0
        for _, v in ipairs(result) do
            count = count + 1
        end
        if(count >= 2) then
            cb(false)
        else
            cb(true)
        end
    end)
end)
ESX.RegisterServerCallback("skm_carkeys:checkCopiedKeys",function(source,cb,plate)
    local identifier = GetPlayerIdentifiers(source)
    MySQL.Async.fetchAll('SELECT copied FROM vehicle_keys WHERE plate = @plate AND identifier = @identifier', {
        ['@plate'] = plate,
        ['@identifier'] = string.sub(identifier[2], 9,48)
	}, function(result)
        if(result[1].copied == 1)then
            cb(false)
        else
            cb(true)
        end

    end)
end)

ESX.RegisterServerCallback("skm_carkeys:getmodel",function(source,cb,plate)

    MySQL.Async.fetchAll('SELECT model FROM vehicle_keys WHERE plate = @plate', {
        ['@plate'] = plate,
	}, function(result)
        for _,v in pairs(result) do
			cb(v.model)
		end

    end)

end)

RegisterServerEvent('skm_carkeys:copyKey')
AddEventHandler('skm_carkeys:copyKey', function(plate, reciever, modelhash)
    local xPlayer = ESX.GetPlayerFromId(reciever)
    TriggerClientEvent('esx:showNotification',reciever, '차키를 받았습니다. 차량번호 ~g~' ..plate)

    MySQL.Sync.execute("INSERT INTO `vehicle_keys`(`identifier`, `plate`, `copied`,`model`) VALUES (@recieverid,@plate,@copied,@model)", { 
        ['@recieverid'] = xPlayer.identifier,
        ['@plate'] = plate,
        ['@copied'] = 1,
        ['@model'] = modelhash
    })
end)

RegisterServerEvent('skm_carkeys:deleteKey')
AddEventHandler('skm_carkeys:deleteKey', function(plate)
    local identifier = GetPlayerIdentifiers(source)
    MySQL.Sync.execute("DELETE FROM `vehicle_keys` WHERE identifier = @identifier AND plate = @plate", { 
        ['@identifier'] = string.sub(identifier[2], 9,48),
        ['@plate'] = plate
    })
end)

ESX.RegisterServerCallback('skm_carkeys:checkIfPlayerHasKey', function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	-- print(xPlayer)
	-- print(identifier)
	local resultcb = 0
	MySQL.Async.fetchAll('SELECT * FROM vehicle_keys WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result then
			for key in pairs(result) do --actualcode
				-- print(result[key].plate)
                print(plate)
				if result[key].plate == plate then
					resultcb = 1	
					cb(resultcb)
            
				end
			end

		else
			cb(resultcb)
			-- subsequent login stuff
		end
		cb(resultcb)
	end)
	
end)

ESX.RegisterServerCallback('skm_carkeys:checkIfKeyExist', function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	-- print(xPlayer)
	-- print(identifier)
	local resultcb = 0
	MySQL.Async.fetchAll('SELECT * FROM vehicle_keys WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result then
			for key in pairs(result) do --actualcode
				-- print(result[key].plate)
                print(plate)
				if result[key].plate == plate then
                    -- print(plate)
                    -- print("----")
                    -- print(result[key].plate)
					resultcb = 1	
					cb(resultcb)
				end
			end

		else
			cb(resultcb)
			-- subsequent login stuff
		end
		cb(resultcb)
	end)
	
end)

ESX.RegisterServerCallback('skm_carkeys:getPlayersKeys', function(source, cb, plate)
    local identifier = GetPlayerIdentifiers(source)
    MySQL.Async.fetchAll('SELECT plate,model,copied,job FROM vehicle_keys WHERE identifier = @identifier', {
        ['@identifier'] = string.sub(identifier[2], 9,48)
    }, function(keys)
        if keys ~= nil then
            cb(keys)
        else
            cb(nil)
        end
    end)
end)

RegisterNetEvent("playerDropped")
AddEventHandler('playerDropped', function (reason)
    local identifier = GetPlayerIdentifiers(source)
    MySQL.Sync.execute("DELETE FROM `vehicle_keys` WHERE copied = @copied AND identifier = @identifier", { 
        ['@plate'] = plate,
        ['@copied'] = 1,
        ['@identifier'] = string.sub(identifier[2], 9,48)
    })
    print("copied keys deleted when player dropped")
  end)
  
  