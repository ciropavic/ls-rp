ESX = nil
local playersHealing, deadPlayers = {}, {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'ambulance', _U('alert_ambulance'), true, true)

TriggerEvent('esx_society:registerSociety', 'ambulance', 'Ambulance', 'society_ambulance', 'society_ambulance', 'society_ambulance', {type = 'public'})

RegisterNetEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function(playerId)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer and xPlayer.job.name == 'ambulance' then
		local xTarget = ESX.GetPlayerFromId(playerId)

		if xTarget then
			if Config.ReviveReward > 0 then
				xPlayer.showNotification(_U('revive_complete_award', xTarget.name, Config.ReviveReward))
				-- xPlayer.addMoney(Config.ReviveReward)
				xTarget.removeMoney(800)
				MySQL.Async.fetchAll('SELECT amount FROM cityhall WHERE department = @department', {
					['@department'] = "cityhall"
				}, function(result)
					for _,v in ipairs(result) do
						MySQL.Sync.execute("UPDATE `cityhall` SET `amount`=@amount WHERE department = @department", { 
							['@department'] = "cityhall",
							['@amount'] = 800 + v.amount
						})
					end
					
	
				end)
				
				xTarget.triggerEvent('esx_ambulancejob:revive')
				xTarget.triggerEvent("esx_ambulancejob:stopbleeding")
				xTarget.showNotification("소생을 받아 $800 이 예금에서 차감됩니다.")
			else
				xPlayer.showNotification(_U('revive_complete', xTarget.name))
				xTarget.triggerEvent('esx_ambulancejob:revive')
				
			end
		else
			xPlayer.showNotification(_U('revive_fail_offline'))
		end
	end
end)



RegisterNetEvent("esx_ambulancejob:giveweapon")
AddEventHandler("esx_ambulancejob:giveweapon",function(weaponhash, price)

	local player = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT money FROM addon_account_data WHERE account_name = @account_name', {
        ['@account_name'] = "society_ambulance"
	}, function(result)
		print(result[1].money)
		if(price > result[1].money)then
			TriggerClientEvent("esx:showNotification", player.source, "병원금고 잔액이 모자랍니다.")
		else
			player.addWeapon(weaponhash, 50)
			TriggerClientEvent("esx:showNotification", player.source, "장비를 지급받았습니다.")
			MySQL.Sync.execute("UPDATE `addon_account_data` SET `money`=@money WHERE account_name = @account_name", { 
				['@account_name'] = "society_ambulance",
				['@money'] = result[1].money - price
			})
		end
	end)

	MySQL.Async.execute('INSERT INTO ambulance_armorylog (weapon, user) VALUES (@weapon, @user)', {
		['@weapon'] = weaponhash,
		['@user'] = player.getName(),
	}, function (rowsChanged)
	end)

end)

RegisterNetEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	deadPlayers[source] = 'dead'
	TriggerClientEvent('esx_ambulancejob:setDeadPlayers', -1, deadPlayers)
end)

RegisterServerEvent('esx_ambulancejob:svsearch')
AddEventHandler('esx_ambulancejob:svsearch', function()
  TriggerClientEvent('esx_ambulancejob:clsearch', -1, source)
end)

RegisterNetEvent('esx_ambulancejob:onPlayerDistress')
AddEventHandler('esx_ambulancejob:onPlayerDistress', function()
	if deadPlayers[source] then
		deadPlayers[source] = 'distress'
		TriggerClientEvent('esx_ambulancejob:setDeadPlayers', -1, deadPlayers)
	end
end)

RegisterNetEvent('esx:onPlayerSpawn')
AddEventHandler('esx:onPlayerSpawn', function()
	if deadPlayers[source] then
		deadPlayers[source] = nil
		TriggerClientEvent('esx_ambulancejob:setDeadPlayers', -1, deadPlayers)
	end
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
	MySQL.Sync.execute("UPDATE `users` SET `health`=@health WHERE identifier = @identifier", { 
        ['@health'] = "200",
        ['@identifier'] = GetPlayerFromIndex(playerId)
    })
	print(GetPlayerFromIndex(playerId))
	if deadPlayers[playerId] then
		deadPlayers[playerId] = nil
		TriggerClientEvent('esx_ambulancejob:setDeadPlayers', -1, deadPlayers)
	end
	
	
end)

RegisterNetEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(target, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)
	if xPlayer.job.name == 'ambulance' then
		TriggerClientEvent('esx_ambulancejob:heal', target, type)

		if(type == "big") then
			xTarget.removeMoney(800)
				MySQL.Async.fetchAll('SELECT amount FROM cityhall WHERE department = @department', {
					['@department'] = "cityhall"
				}, function(result)
					for _,v in ipairs(result) do
						MySQL.Sync.execute("UPDATE `cityhall` SET `amount`=@amount WHERE department = @department", { 
							['@department'] = "cityhall",
							['@amount'] = 800 + v.amount
						})
					end
					
	
				end)
				xPlayer.showNotification(_U('heal_complete', xTarget.name))
				xTarget.showNotification("중상 치료를 받아 $400 이 예금에서 차감됩니다.")
		elseif type == "small" then
			xTarget.removeMoney(400)
				MySQL.Async.fetchAll('SELECT amount FROM cityhall WHERE department = @department', {
					['@department'] = "cityhall"
				}, function(result)
					for _,v in ipairs(result) do
						MySQL.Sync.execute("UPDATE `cityhall` SET `amount`=@amount WHERE department = @department", { 
							['@department'] = "cityhall",
							['@amount'] = 400 + v.amount
						})
					end
					
	
				end)
				xTarget.showNotification("부상 치료를 받아 $400 이 예금에서 차감됩니다.")
				xPlayer.showNotification(_U('heal_complete', xTarget.name))
		end
	end
end)

RegisterNetEvent('esx_ambulancejob:putInVehicle')
AddEventHandler('esx_ambulancejob:putInVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' then
		TriggerClientEvent('esx_ambulancejob:putInVehicle', target)
	end
end)

ESX.RegisterServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if Config.RemoveCashAfterRPDeath then
		if xPlayer.getMoney() > 0 then
			xPlayer.removeMoney(xPlayer.getMoney())
		end

		if xPlayer.getAccount('black_money').money > 0 then
			xPlayer.setAccountMoney('black_money', 0)
		end
	end

	if Config.RemoveItemsAfterRPDeath then
		for i=1, #xPlayer.inventory, 1 do
			if xPlayer.inventory[i].count > 0 then
				xPlayer.setInventoryItem(xPlayer.inventory[i].name, 0)
			end
		end
	end

	local playerLoadout = {}
	if Config.RemoveWeaponsAfterRPDeath then
		for i=1, #xPlayer.loadout, 1 do
			xPlayer.removeWeapon(xPlayer.loadout[i].name)
		end
	else -- save weapons & restore em' since spawnmanager removes them
		for i=1, #xPlayer.loadout, 1 do
			table.insert(playerLoadout, xPlayer.loadout[i])
		end

		-- give back wepaons after a couple of seconds
		Citizen.CreateThread(function()
			Citizen.Wait(5000)
			for i=1, #playerLoadout, 1 do
				if playerLoadout[i].label ~= nil then
					xPlayer.addWeapon(playerLoadout[i].name, playerLoadout[i].ammo)
				end
			end
		end)
	end

	cb()
end)

RegisterNetEvent("bleeding")
RegisterServerEvent("bleeding",function()
	local identifier = GetPlayerIdentifiers(source)
	MySQL.Sync.execute("UPDATE `users` SET `isbleeding`=@isbleeding WHERE identifier = @identifier", { 
        ['@isbleeding'] = 1,
        ['@identifier'] = string.sub(identifier[2], 9,48)
    })
end)

RegisterNetEvent("bleedstop")
RegisterServerEvent("bleedstop",function()
	local identifier = GetPlayerIdentifiers(source)
	MySQL.Sync.execute("UPDATE `users` SET `isbleeding`=@isbleeding WHERE identifier = @identifier", { 
        ['@isbleeding'] = 0,
        ['@identifier'] = string.sub(identifier[2], 9,48)
    })
end)

ESX.RegisterServerCallback('esx_ambulancejob:isbleeding',function(source,cb)
	local identifier = GetPlayerIdentifiers(source)
	MySQL.Async.fetchAll('SELECT isbleeding FROM users WHERE identifier = @identifier', {
        ['@identifier'] = string.sub(identifier[2], 9,48)
	}, function(result)
		-- print(result[1].isbleeding)
		if result[1].isbleeding == 1 then
            cb(true)
        else
            cb(false)
        end
	end)

end)

if Config.EarlyRespawnFine then
	ESX.RegisterServerCallback('esx_ambulancejob:checkBalance', function(source, cb)
		local xPlayer = ESX.GetPlayerFromId(source)
		local bankBalance = xPlayer.getAccount('bank').money

		cb(bankBalance >= Config.EarlyRespawnFineAmount)
	end)

	RegisterNetEvent('esx_ambulancejob:payFine')
	AddEventHandler('esx_ambulancejob:payFine', function()
		local xPlayer = ESX.GetPlayerFromId(source)
		local fineAmount = Config.EarlyRespawnFineAmount

		xPlayer.showNotification(_U('respawn_bleedout_fine_msg', ESX.Math.GroupDigits(fineAmount)))
		xPlayer.removeAccountMoney('bank', fineAmount)
	end)
end

ESX.RegisterServerCallback('esx_ambulancejob:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local quantity = xPlayer.getInventoryItem(item).count

	cb(quantity)
end)

ESX.RegisterServerCallback('esx_ambulancejob:buyJobVehicle', function(source, cb, vehicleProps, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = getPriceFromHash(vehicleProps.model, xPlayer.job.grade_name, type)

	-- vehicle model not found
	if price == 0 then
		cb(false)
	else
		if xPlayer.getMoney() >= price then
			xPlayer.removeMoney(price)

			MySQL.Async.execute('INSERT INTO owned_vehicles (owner, state, plate, vehicle, type, job, x, y, z ,h, health, nitro, lockcheck, lastid, lasthouse, stored) VALUES (@owner, @state, @plate, @vehicle, @type, @job, @x, @y, @z ,@h, @health, @nitro, @lockcheck, @lastid, @lasthouse, @stored)', {
				['@owner'] = "ambulance",
				['@state'] = 0,
				['@plate'] = vehicleProps.plate,
				['@vehicle'] = json.encode(vehicleProps),
				['@type'] = type,
				['@job'] = xPlayer.job.name,
				['@x'] = 300.4,
				['@y'] = -1439,
				['@z'] = 29.8,
				['@h'] = 47.43,
				['@health'] = 1000,
				['@nitro'] = "nao",
				['@lockcheck'] = "nao",
				['@lastid'] = 0,
				['@lasthouse'] = 0,
				['@stored'] = true
			}, function (rowsChanged)
			end)
			MySQL.Async.execute('INSERT INTO vehicle_keys (identifier, plate, job, state, copied, model) VALUES (@identifier, @plate, @job, @state, @copied, @model)', {
				['@identifier'] = "ambulance",
				['@plate'] = vehicleProps.plate,
				['@job'] = "ambulance",
				['@state'] = 0,
				['@copied'] = 0,
				['@model'] = vehicleProps.model
			}, function (rowsChanged)
				cb(true)
			end)
		else
			cb(false)
		end
		
	end
end)

ESX.RegisterServerCallback('esx_ambulancejob:returnStateOfKey',function(source,cb,plate)

	MySQL.Async.fetchAll('SELECT state FROM vehicle_keys WHERE plate = @plate', {
        ['@plate'] = plate
	}, function(result)
		-- print(result[1].state)
		if result[1].state == 0 then
            cb(true)
        else
            cb(false)
        end
	end)

end)

RegisterServerEvent('esx_ambulancejob:giveKey')
AddEventHandler('esx_ambulancejob:giveKey', function(plate)
    local identifier = GetPlayerIdentifiers(source)
    MySQL.Sync.execute("UPDATE `vehicle_keys` SET `identifier`=@recieverid WHERE identifier = @identifier AND plate = @plate", { 
        ['@recieverid'] = 'ambulance',
        ['@identifier'] = string.sub(identifier[2], 9,48),
        ['@plate'] = plate
    })
	print(json.encode(identifier))
	MySQL.Sync.execute("UPDATE `vehicle_keys` SET `state`=@state WHERE plate = @plate", { 
        ['@state'] = 0,
        ['@plate'] = plate
    })
	MySQL.Sync.execute("UPDATE `owned_vehicles` SET `owner`=@owner WHERE plate = @plate", { 
        ['@owner'] = "police",
        ['@plate'] = plate
    })
end)

RegisterServerEvent('esx_ambulancejob:rentKey')
AddEventHandler('esx_ambulancejob:rentKey', function(plate)
	local identifier = GetPlayerIdentifiers(source)
    -- local xPlayer = ESX.GetPlayerFromId(source)
	print(string.sub(identifier[2], 9,48))

    MySQL.Sync.execute("UPDATE `vehicle_keys` SET `identifier`=@recieverid WHERE plate = @plate", { 
        ['@recieverid'] = string.sub(identifier[2], 9,48),
        ['@plate'] = plate
    })
	MySQL.Sync.execute("UPDATE `vehicle_keys` SET `state`=@state WHERE plate = @plate", { 
        ['@state'] = 1,
        ['@plate'] = plate
    })
	MySQL.Sync.execute("UPDATE `owned_vehicles` SET `owner`=@owner WHERE plate = @plate", { 
        ['@owner'] = string.sub(identifier[2], 9,48),
        ['@plate'] = plate
    })
    print("rentkey")
    TriggerClientEvent('esx:showNotification',identifier, '차키를 받았습니다. 차량번호 ~g~' ..plate)
end)

ESX.RegisterServerCallback('esx_ambulancejob:getKeys', function(source, cb, plate)
    local identifier = GetPlayerIdentifiers(source)
    MySQL.Async.fetchAll('SELECT plate, state, model FROM vehicle_keys WHERE job = @job', {
        ['@job'] = 'ambulance'
    }, function(keys)
		print(json.encode(keys))
        if keys ~= nil then
            cb(keys)
        else
            cb(nil)
        end
    end)
end)

ESX.RegisterServerCallback('esx_ambulancejob:retrieveJobVehicles', function(source, cb, type)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND type = @type AND job = @job', {
		['@owner'] = 'ambulance',
		['@type'] = type,
		['@job'] = xPlayer.job.name
	}, function(result)
		cb(result)
	end)
end)

ESX.RegisterServerCallback('esx_ambulancejob:storeNearbyVehicle', function(source, cb, nearbyVehicles)
	local xPlayer = ESX.GetPlayerFromId(source)
	local foundPlate, foundNum

	for k,v in ipairs(nearbyVehicles) do
		local result = MySQL.Sync.fetchAll('SELECT plate FROM owned_vehicles WHERE owner = @owner AND plate = @plate AND job = @job', {
			['@owner'] = "ambulance",
			['@plate'] = v.plate,
			['@job'] = xPlayer.job.name
		})

		if result[1] then
			foundPlate, foundNum = result[1].plate, k
			break
		end
	end

	if not foundPlate then
		cb(false)
	else
		MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = true WHERE owner = @owner AND plate = @plate AND job = @job', {
			['@owner'] = "ambulance",
			['@plate'] = foundPlate,
			['@job'] = xPlayer.job.name
		}, function (rowsChanged)
			if rowsChanged == 0 then
				cb(false)
			else
				cb(true, foundNum)
			end
		end)
	end
end)

function getPriceFromHash(vehicleHash, jobGrade, type)
	local vehicles = Config.AuthorizedVehicles[type][jobGrade]

	for k,v in ipairs(vehicles) do
		if GetHashKey(v.model) == vehicleHash then
			return v.price
		end
	end

	return 0
end

RegisterNetEvent('esx_ambulancejob:removeItem')
AddEventHandler('esx_ambulancejob:removeItem', function(item)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem(item, 1)

	if item == 'bandage' then
		xPlayer.showNotification(_U('used_bandage'))
	elseif item == 'medikit' then
		xPlayer.showNotification(_U('used_medikit'))
	end
end)

RegisterNetEvent('esx_ambulancejob:giveItem')
AddEventHandler('esx_ambulancejob:giveItem', function(itemName, amount, price)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name ~= 'ambulance' then
		print(('[esx_ambulancejob] [^2INFO^7] "%s" attempted to spawn in an item!'):format(xPlayer.identifier))
		return
	elseif (itemName ~= 'medikit' and itemName ~= 'bandage') then
		print(('[esx_ambulancejob] [^2INFO^7] "%s" attempted to spawn in an item!'):format(xPlayer.identifier))
		return
	end

	MySQL.Async.fetchAll('SELECT money FROM addon_account_data WHERE account_name = @account_name', {
        ['@account_name'] = "society_ambulance"
	}, function(result)
		print(result[1].money)
		if(price > result[1].money)then
			TriggerClientEvent("esx:showNotification", xPlayer.source, "병원금고 잔액이 모자랍니다.")
		else
			if xPlayer.canCarryItem(itemName, amount) then
				TriggerClientEvent("esx:showNotification", xPlayer.source, "장비를 지급받았습니다.")
				MySQL.Sync.execute("UPDATE `addon_account_data` SET `money`=@money WHERE account_name = @account_name", { 
					['@account_name'] = "society_ambulance",
					['@money'] = result[1].money - price
				})
				xPlayer.addInventoryItem(itemName, amount)
				
			else
				xPlayer.showNotification(_U('max_item'))
			end
			
		end
	end)
	
end)

ESX.RegisterCommand('revive', 'admin', function(xPlayer, args, showError)
	args.playerId.triggerEvent('esx_ambulancejob:revive')
end, true, {help = _U('revive_help'), validate = true, arguments = {
	{name = 'playerId', help = 'The player id', type = 'player'}
}})

ESX.RegisterUsableItem('medikit', function(source)
	if not playersHealing[source] then
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('medikit', 1)

		playersHealing[source] = true
		TriggerClientEvent('esx_ambulancejob:useItem', source, 'medikit')

		Citizen.Wait(10000)
		playersHealing[source] = nil
	end
end)

ESX.RegisterUsableItem('bandage', function(source)
	if not playersHealing[source] then
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('bandage', 1)

		playersHealing[source] = true
		TriggerClientEvent('esx_ambulancejob:useItem', source, 'bandage')

		Citizen.Wait(10000)
		playersHealing[source] = nil
	end
end)

ESX.RegisterServerCallback('esx_ambulancejob:getDeathStatus', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchScalar('SELECT is_dead FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(isDead)
				
		if isDead then
			print(('[esx_ambulancejob] [^2INFO^7] "%s" attempted combat logging'):format(xPlayer.identifier))
		end

		cb(isDead)
	end)
end)

RegisterNetEvent('esx_ambulancejob:setDeathStatus')
AddEventHandler('esx_ambulancejob:setDeathStatus', function(isDead)
	local xPlayer = ESX.GetPlayerFromId(source)

	if type(isDead) == 'boolean' then
		MySQL.Sync.execute('UPDATE users SET is_dead = @isDead WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier,
			['@isDead'] = isDead
		})
	end
end)
