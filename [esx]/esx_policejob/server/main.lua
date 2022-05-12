ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'police', Config.MaxInService)
end



RegisterServerEvent('renfort')
AddEventHandler('renfort', function(coords, raison)
	local _source = source
	local _raison = raison
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == 'police' then
			TriggerClientEvent('renfort:setBlip', xPlayers[i], coords, _raison)
		end
	end
end)

RegisterServerEvent('police:PriseEtFinservice')
AddEventHandler('police:PriseEtFinservice', function(PriseOuFin)
	local _source = source
	local _raison = PriseOuFin
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	local name = xPlayer.getName(_source)

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == 'police' then
			TriggerClientEvent('police:InfoService', xPlayers[i], _raison, name)
		end
	end
end)

ESX.RegisterServerCallback('esx_policejob:getKeys', function(source, cb, plate)
    local identifier = GetPlayerIdentifiers(source)
	local identifier = 'police'
    MySQL.Async.fetchAll('SELECT plate, state, model FROM vehicle_keys WHERE job = @job', {
        ['@job'] = 'police'
    }, function(keys)
		print(json.encode(keys))
        if keys ~= nil then
            cb(keys)
        else
            cb(nil)
        end
    end)
end)

ESX.RegisterServerCallback('esx_policejob:getOnduty', function(source, cb)
    local identifier = GetPlayerIdentifiers(source)
    MySQL.Async.fetchAll('SELECT onduty FROM users WHERE identifier = @identifier', {
        ['@identifier'] = string.sub(identifier[2], 9,48),
    }, function(onduty)
        if onduty ~= nil then
            cb(onduty[1].onduty)
        else
            cb(nil)
        end
    end)
end)

RegisterServerEvent("esx_policejob:setOnduty")
AddEventHandler("esx_policejob:setOnduty",function(onduty)
	local identifier = GetPlayerIdentifiers(source)
	MySQL.Sync.execute("UPDATE `users` SET `onduty`=@onduty WHERE identifier = @identifier", { 
        ['@identifier'] = string.sub(identifier[2], 9,48),
        ['@onduty'] = onduty
    })
end)



RegisterServerEvent('esx_policejob:giveKey')
AddEventHandler('esx_policejob:giveKey', function(plate)
    local identifier = GetPlayerIdentifiers(source)
    MySQL.Sync.execute("UPDATE `vehicle_keys` SET `identifier`=@recieverid WHERE identifier = @identifier AND plate = @plate", { 
        ['@recieverid'] = 'police',
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

RegisterNetEvent('esx_vehicleshop:setJobVehicleState')
AddEventHandler('esx_vehicleshop:setJobVehicleState', function(plate, state)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored WHERE plate = @plate AND job = @job', {
		['@stored'] = state,
		['@plate'] = plate,
		['@job'] = xPlayer.job.name
	}, function(rowsChanged)
		if rowsChanged == 0 then
			print(('[esx_vehicleshop] [^3WARNING^7] %s exploited the garage!'):format(xPlayer.identifier))
		end
	end)
end)

TriggerEvent('esx_phone:registerNumber', 'police', _U('alert_police'), true, true)
TriggerEvent('esx_society:registerSociety', 'police', 'Police', 'society_police', 'society_police', 'society_police', {type = 'public'})

RegisterServerEvent('esx_policejob:confiscatePlayerItem')
AddEventHandler('esx_policejob:confiscatePlayerItem', function(target, itemType, itemName, amount)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if sourceXPlayer.job.name ~= 'police' then
		print(('esx_policejob: %s attempted to confiscate!'):format(xPlayer.identifier))
		return
	end

	if itemType == 'item_standard' then
		local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)

		-- does the target player have enough in their inventory?
		if targetItem.count > 0 and targetItem.count <= amount then
			print(sourceItem.limit)
			print(sourceItem.count + amount)
			print(sourceItem.count)
			-- can the player carry the said amount of x item?
			-- if sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit then
			-- 	TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
			-- else
				targetXPlayer.removeInventoryItem(itemName, amount)
				sourceXPlayer.addInventoryItem   (itemName, amount)
				TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated', amount, sourceItem.label, targetXPlayer.name))
				TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated', amount, sourceItem.label, sourceXPlayer.name))
			-- end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
		end

	elseif itemType == 'item_account' then
		targetXPlayer.removeAccountMoney(itemName, amount)
		sourceXPlayer.addAccountMoney   (itemName, amount)

		TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_account', amount, itemName, targetXPlayer.name))
		TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated_account', amount, itemName, sourceXPlayer.name))

	elseif itemType == 'item_weapon' then
		if amount == nil then amount = 0 end
		targetXPlayer.removeWeapon(itemName, amount)
		sourceXPlayer.addWeapon   (itemName, amount)

		TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_weapon', ESX.GetWeaponLabel(itemName), amount, targetXPlayer.name))
		TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated_weapon', ESX.GetWeaponLabel(itemName), amount, sourceXPlayer.name))
	end
end)

RegisterServerEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' then
		TriggerClientEvent('esx_policejob:handcuff', target)
	else
		TriggerClientEvent('esx_policejob:handcuff', target)
	end
end)

RegisterServerEvent('esx_policejob:handcuff2')
AddEventHandler('esx_policejob:handcuff2', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_policejob:handcuff', target)
end)

RegisterServerEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' then
		TriggerClientEvent('esx_policejob:drag', target, source)
	else
		print(('esx_policejob: %s attempted to drag (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' then
		TriggerClientEvent('esx_policejob:putInVehicle', target)
	else
		print(('esx_policejob: %s attempted to put in vehicle (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_policejob:OutVehicle')
AddEventHandler('esx_policejob:OutVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' then
		TriggerClientEvent('esx_policejob:OutVehicle', target)
	else
		print(('esx_policejob: %s attempted to drag out from vehicle (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_policejob:getStockItem')
AddEventHandler('esx_policejob:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then

			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, _U('have_withdrawn', count, inventoryItem.label))
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
		end
	end)
end)

RegisterServerEvent('esx_policejob:putStockItems')
AddEventHandler('esx_policejob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', count, inventoryItem.label))
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
		end
	end)
end)

ESX.RegisterServerCallback('esx_policejob:getOtherPlayerData', function(source, cb, target)
	if Config.EnableESXIdentity then
		local xPlayer = ESX.GetPlayerFromId(target)
		local result = MySQL.Sync.fetchAll('SELECT firstname, lastname, sex, dateofbirth, height FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		})

		local firstname = result[1].firstname
		local lastname  = result[1].lastname
		local sex       = result[1].sex
		local dob       = result[1].dateofbirth
		local height    = result[1].height

		local data = {
			name      = GetPlayerName(target),
			job       = xPlayer.job,
			inventory = xPlayer.inventory,
			accounts  = xPlayer.accounts,
			weapons   = xPlayer.loadout,
			firstname = firstname,
			lastname  = lastname,
			sex       = sex,
			dob       = dob,
			height    = height
		}

		TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)
			if status ~= nil then
				data.drunk = math.floor(status.percent)
			end
		end)

		if Config.EnableLicenses then
			TriggerEvent('esx_license:getLicenses', target, function(licenses)
				data.licenses = licenses
				cb(data)
			end)
		else
			cb(data)
		end
	else
		local xPlayer = ESX.GetPlayerFromId(target)

		local data = {
			name       = GetPlayerName(target),
			job        = xPlayer.job,
			inventory  = xPlayer.inventory,
			accounts   = xPlayer.accounts,
			weapons    = xPlayer.loadout
		}

		TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)
			if status then
				data.drunk = math.floor(status.percent)
			end
		end)

		TriggerEvent('esx_license:getLicenses', target, function(licenses)
			data.licenses = licenses
		end)

		cb(data)
	end
end)

ESX.RegisterServerCallback('esx_policejob:getFineList', function(source, cb, category)
	MySQL.Async.fetchAll('SELECT * FROM fine_types WHERE category = @category', {
		['@category'] = category
	}, function(fines)
		cb(fines)
	end)
end)


ESX.RegisterServerCallback('esx_policejob:getVehicleInfos', function(source, cb, plate)

	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)

		local retrivedInfo = {
			plate = plate
		}

		if result[1] then
			MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)

				if Config.EnableESXIdentity then
					retrivedInfo.owner = result2[1].firstname .. ' ' .. result2[1].lastname
				end

				cb(retrivedInfo)
			end)
		else
			cb(retrivedInfo)
		end
	end)
end)

ESX.RegisterServerCallback('esx_policejob:getVehicleFromPlate', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		if result[1] ~= nil then

			MySQL.Async.fetchAll('SELECT name, firstname, lastname FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)

				if Config.EnableESXIdentity then
					cb(result2[1].firstname .. ' ' .. result2[1].lastname, true)
				else
					cb(result2[1].name, true)
				end

			end)
		else
			cb(_U('unknown'), false)
		end
	end)
end)

ESX.RegisterServerCallback('esx_policejob:getArmoryWeapons', function(source, cb)
	TriggerEvent('esx_datastore:getSharedDataStore', 'society_police', function(store)
		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		cb(weapons)
	end)
end)

ESX.RegisterServerCallback('esx_policejob:addArmoryWeapon', function(source, cb, weaponName, removeWeapon)
	local xPlayer = ESX.GetPlayerFromId(source)

	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
	end

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_police', function(store)
		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = weapons[i].count + 1
				foundWeapon = true
				break
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name  = weaponName,
				count = 1
			})
		end

		store.set('weapons', weapons)
		cb()
	end)
end)

ESX.RegisterServerCallback('esx_policejob:removeArmoryWeapon', function(source, cb, weaponName)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addWeapon(weaponName, 500)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_police', function(store)

		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
				foundWeapon = true
				break
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name  = weaponName,
				count = 0
			})
		end

		store.set('weapons', weapons)
		cb()
	end)
end)

ESX.RegisterServerCallback('esx_policejob:buyWeapon', function(source, cb, weaponName, type, componentNum)
	local xPlayer = ESX.GetPlayerFromId(source)
	local authorizedWeapons, selectedWeapon = Config.AuthorizedWeapons[xPlayer.job.grade_name]

	for k,v in ipairs(authorizedWeapons) do
		if v.weapon == weaponName then
			selectedWeapon = v
			break
		end
	end

	if not selectedWeapon then
		print(('esx_policejob: %s attempted to buy an invalid weapon.'):format(xPlayer.identifier))
		cb(false)
	else
		-- Weapon
		if type == 1 then
			if xPlayer.getMoney() >= selectedWeapon.price then
				xPlayer.removeMoney(selectedWeapon.price)
				xPlayer.addWeapon(weaponName, 100)

				cb(true)
			else
				cb(false)
			end

		-- Weapon Component
		elseif type == 2 then
			local price = selectedWeapon.components[componentNum]
			local weaponNum, weapon = ESX.GetWeapon(weaponName)

			local component = weapon.components[componentNum]

			if component then
				if xPlayer.getMoney() >= price then
					xPlayer.removeMoney(price)
					xPlayer.addWeaponComponent(weaponName, component.name)

					cb(true)
				else
					cb(false)
				end
			else
				print(('esx_policejob: %s attempted to buy an invalid weapon component.'):format(xPlayer.identifier))
				cb(false)
			end
		end
	end
end)

ESX.RegisterServerCallback('esx_policejob:retrieveJobVehicles', function(source, cb, type)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE job = @job AND type = @type AND job = @job', {
		['@job'] = 'police',
		['@type'] = type,
		['@job'] = xPlayer.job.name
	}, function(result)
		cb(result)
	end)
end)

RegisterServerEvent('esx_policejob:rentKey')
AddEventHandler('esx_policejob:rentKey', function(plate)
	local identifier = GetPlayerIdentifiers(source)
	local data = {}

    local xPlayer = ESX.GetPlayerFromId(source)
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

	MySQL.Async.fetchAll('SELECT log FROM vehicle_keys WHERE plate = @plate AND identifier = @identifier', {
		['@plate'] = plate,
		['@identifier'] = string.sub(identifier[2], 9,48)
	}, function(result)
		print(json.encode(result))
		data = json.decode(result[1].log)
		table.insert(data, {label = xPlayer.getName() .. " 시간 : " .. os.date("%Y/%m/%d %X"), value = plate})
		MySQL.Sync.execute("UPDATE `vehicle_keys` SET `log`=@log WHERE plate = @plate AND identifier = @recieverid", { 
			['@recieverid'] = string.sub(identifier[2], 9,48),
			['@log'] = json.encode(data),
			['@plate'] = plate
		})
	end)
	
end)

ESX.RegisterServerCallback('esx_policejob:returnStateOfKey',function(source,cb,plate)

	MySQL.Async.fetchAll('SELECT state FROM vehicle_keys WHERE plate = @plate', {
        ['@plate'] = plate
	}, function(result)
		print(result[1].state)
		if result[1].state == 0 then
            cb(true)
        else
            cb(false)
        end
	end)

end)

ESX.RegisterServerCallback('esx_policejob:buyJobVehicle', function(source, cb, vehicleProps, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = getPriceFromHash(vehicleProps.model, xPlayer.job.grade_name, type)
	local log = {}
	-- vehicle model not found
	if price == 0 then
		print(('esx_policejob: %s attempted to exploit the shop! (invalid vehicle model)'):format(xPlayer.identifier))
		cb(false)
	else
		MySQL.Async.fetchAll('SELECT value FROM okokbanking_societies WHERE society = @society', {
			['@society'] = 'society_police'
		}, function(result)
			
			if result[1].value >= price then

				MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier', {
					['@identifier'] = xPlayer.identifier
				}, function(name)
					print(json.encode(name))

					MySQL.Async.execute('UPDATE okokbanking_societies SET `value` = @value WHERE society = @society', {
						['@value'] = result[1].value - price,
						['@society'] = "society_police",
					}, function (rowsChanged)
					end)
		
					MySQL.Async.execute('INSERT INTO owned_vehicles (owner, state, plate, vehicle, type, job, x, y, z, h, health, nitro, lockcheck, lastid, lasthouse, stored) VALUES (@owner, @state, @plate, @vehicle, @type, @job, @x, @y, @z, @h, @health, @nitro, @lockcheck, @lastid, @lasthouse, @stored)', {
						['@owner'] = 'police',
						['@state'] = 0,
						['@plate'] = vehicleProps.plate,
						['@vehicle'] = json.encode(vehicleProps),
						['@type'] = type,
						['@job'] = xPlayer.job.name,
						['@x'] = 435.0,
						['@y'] = -1019.57,
						['@z'] = 28.83,
						['@h'] = 90.43,
						['@health'] = 1000,
						['@nitro'] = 'nao',
						['@lockcheck'] = 'nao',
						['@lasthouse'] = 0,
						['@stored'] = 1,
					}, function (rowsChanged)
						cb(true)
					end)

					MySQL.Async.execute('INSERT INTO okokbanking_transactions (receiver_identifier, receiver_name, sender_identifier, sender_name, date, value, type) VALUES (@receiver_identifier, @receiver_name, @sender_identifier, @sender_name, @date, @value, @type)', {
						['@receiver_identifier'] = "society_police",
						['@receiver_name'] = xPlayer.getName().." (차량)",
						['@sender_identifier'] = "society_police",
						['@sender_name'] = xPlayer.getName().." (차량)",
						['@date']   = os.date("%Y-%m-%d %X"),
						['@value']   = price,
						['@type'] = "withdraw"
					})
					
					table.insert(log, {label = name[1].firstname .. " " .. name[1].lastname, value = vehicleProps.plate})
					print(json.encode(log))
					MySQL.Sync.execute("INSERT INTO `vehicle_keys`(`identifier`, `plate`, `job`,`state`,`model`,`log`) VALUES (@identifier,@plate,@job,@state,@model,@log)", { 
						['@identifier'] = 'police',
						['@plate'] = vehicleProps.plate,
						['@job'] = 'police',
						['@state'] = 0,
						['@model'] = vehicleProps.model,
						['@log'] = json.encode(log)
					})
				end)

				
			else
				cb(false)
			end

		end)
		
	end
end)

ESX.RegisterServerCallback('esx_policejob:storeNearbyVehicle', function(source, cb, nearbyVehicles)
	local xPlayer = ESX.GetPlayerFromId(source)
	local foundPlate, foundNum

	for k,v in ipairs(nearbyVehicles) do
		local result = MySQL.Sync.fetchAll('SELECT plate FROM owned_vehicles WHERE owner = @owner AND plate = @plate AND job = @job', {
			['@owner'] = 'police',
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
			['@owner'] = 'police',
			['@plate'] = foundPlate,
			['@job'] = xPlayer.job.name
		}, function (rowsChanged)
			if rowsChanged == 0 then
				print(('esx_policejob: %s has exploited the garage!'):format(xPlayer.identifier))
				cb(false)
			else
				cb(true, foundNum)
			end
		end)
	end

end)

function getPriceFromHash(hashKey, jobGrade, type)
	if type == 'helicopter' then
		local vehicles = Config.AuthorizedHelicopters[jobGrade]

		for k,v in ipairs(vehicles) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end
	elseif type == 'car' then
		local vehicles = Config.AuthorizedVehicles[jobGrade]
		local shared = Config.AuthorizedVehicles['Shared']

		for k,v in ipairs(vehicles) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end

		for k,v in ipairs(shared) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end
	end

	return 0
end

ESX.RegisterServerCallback('esx_policejob:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('esx_policejob:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)

AddEventHandler('playerDropped', function()
	-- Save the source in case we lose it (which happens a lot)
	local _source = source

	-- Did the player ever join?
	if _source ~= nil then
		local xPlayer = ESX.GetPlayerFromId(_source)

		-- Is it worth telling all clients to refresh?
		if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'police' then
			Citizen.Wait(5000)
			TriggerClientEvent('esx_policejob:updateBlip', -1)
		end
	end


end)

RegisterServerEvent('esx_policejob:spawned')
AddEventHandler('esx_policejob:spawned', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'police' then
		Citizen.Wait(5000)
		TriggerClientEvent('esx_policejob:updateBlip', -1)
	end
end)

RegisterServerEvent('esx_policejob:forceBlip')
AddEventHandler('esx_policejob:forceBlip', function()
	TriggerClientEvent('esx_policejob:updateBlip', -1)
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.Wait(5000)
		TriggerClientEvent('esx_policejob:updateBlip', -1)
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_phone:removeNumber', 'police')
	end
end)

RegisterServerEvent('esx_policejob:message')
AddEventHandler('esx_policejob:message', function(target, msg)
	TriggerClientEvent('esx:showNotification', target, msg)
end)


-- ALERTE LSPD


RegisterServerEvent('TireEntenduServeur')
AddEventHandler('TireEntenduServeur', function(gx, gy, gz)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == 'police' then
			TriggerClientEvent('TireEntendu', xPlayers[i], gx, gy, gz)
		end
	end
end)


RegisterServerEvent('PriseAppelServeur')
AddEventHandler('PriseAppelServeur', function(gx, gy, gz)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local name = xPlayer.getName(source)
	local xPlayers = ESX.GetPlayers()

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == 'police' then
			TriggerClientEvent('PriseAppel', xPlayers[i], name)
		end
	end
end)



RegisterServerEvent('esx_policejob:requestarrest')
AddEventHandler('esx_policejob:requestarrest', function(targetid, playerheading, playerCoords,  playerlocation)
	_source = source
	TriggerClientEvent('esx_policejob:getarrested', targetid, playerheading, playerCoords, playerlocation)
	TriggerClientEvent('esx_policejob:doarrested', _source)
end)

RegisterServerEvent('esx_policejob:requestrelease')
AddEventHandler('esx_policejob:requestrelease', function(targetid, playerheading, playerCoords,  playerlocation)
	_source = source
	TriggerClientEvent('esx_policejob:getuncuffed', targetid, playerheading, playerCoords, playerlocation)
	TriggerClientEvent('esx_policejob:douncuffing', _source)
end)
