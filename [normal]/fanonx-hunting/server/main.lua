ESX = nil
local baitUsable = true
local baitTime = Config.TimeBetween
local isEntityInWater = false

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.EnableBait then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            if not baitUsable then
                if baitTime == 0 then
                    baitUsable = true
                    baitTime = Config.TimeBetween
                else
                    baitTime = baitTime - 1
                end
            end
        end
    end)

    ESX.RegisterUsableItem(Config.BaitItemName, function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        TriggerClientEvent('fanonx:client:canPlaceBait', source)
        Citizen.Wait(300)
        if not isEntityInWater then
            if baitUsable then
                xPlayer.removeInventoryItem(Config.BaitItemName, 1)
                TriggerClientEvent('fanonx:client:bait', source)
                baitUsable = false
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'Error', text = Config.Text['between_bait']})
            end
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'Error', text = Config.Text['cant_place_bait']})
        end
        
    end)
end

RegisterServerEvent('fanonx-hunting:server:canPlaceBaitS')
AddEventHandler('fanonx-hunting:server:canPlaceBaitS', function(water)
    isEntityInWater = water
end)


RegisterServerEvent('fanonx-hunting:server:giveReward')
AddEventHandler('fanonx-hunting:server:giveReward', function(itemName, count)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
    xPlayer.addInventoryItem(itemName, count)
end)

RegisterServerEvent('fanonx-hunting:server:sell')
AddEventHandler('fanonx-hunting:server:sell', function(itemName, price, count, blackMoney)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local itemN = nil
	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == itemName then
			itemN = item.count
		end
	end

    local levelprice
    MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
        local user = result[1]
        local userexp = user.huntingexp + 1
        if(userexp >= user.huntinglevel * 100) then
                MySQL.Sync.execute("UPDATE `users` SET `huntinglevel`=@huntinglevel WHERE identifier = @identifier", { 
                    ['@huntinglevel'] = user.huntinglevel + 1,
                    ['@identifier'] = xPlayer.identifier
                })
            else
                MySQL.Sync.execute("UPDATE `users` SET `huntingexp`=@huntingexp WHERE identifier = @identifier", { 
                    ['@huntingexp'] = user.huntingexp + 1,
                    ['@identifier'] = xPlayer.identifier
                })
        end
        MySQL.Sync.execute("UPDATE `users` SET `fatigue`=@fatigue WHERE identifier = @identifier", { 
            ['@fatigue'] = user.fatigue + 70,
            ['@identifier'] = xPlayer.identifier
        })
        levelprice = user.huntinglevel * 50
        if itemN >= count then
            xPlayer.removeInventoryItem(itemName, count)
            if blackMoney then
                xPlayer.addAccountMoney('black_money', levelprice*count)
            else
                xPlayer.addMoney(levelprice*count)
            end
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Succesfully sold' })
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'Error', text = Config.Text['no_material'] })
        end
    end)
end)

RegisterServerEvent('fanonx-hunting:server:giveMoney')
AddEventHandler('fanonx-hunting:server:giveMoney', function(count, blackMoney)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'Success', text = Config.Text['sold'] })
end)

ESX.RegisterServerCallback('fanonx-hunting:server:cook',function(source, cb, meatName, count)
    local xPlayer = ESX.GetPlayerFromId(source)
	local itemN = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == meatName then
			itemN = item.count
		end
	end

    if itemN >= count then
        xPlayer.removeInventoryItem(meatName, count)
        cb(true)
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'Error', text = Config.Text['no_material']})
        cb(false)
    end
end)

ESX.RegisterServerCallback('fanonx-hunting:server:campfire',function(source, cb, coalName, woodName, coalCount, woodCount)
    local xPlayer = ESX.GetPlayerFromId(source)
	local coalN = 0
    local woodN = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == coalName then
			coalN = item.count
        elseif item.name == woodName then
            woodN = item.count
        end
	end
    
    if coalN >= coalCount and woodN >= woodCount then
        xPlayer.removeInventoryItem(coalName, coalCount)
        xPlayer.removeInventoryItem(woodName, woodCount)
        cb(true)
    else 
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'Error', text = Config.Text['no_material'] })
        cb(false)
    end
end)

ESX.RegisterServerCallback('fanonx-hunting:server:giveLicense', function(source, id)
	--local xPlayer = ESX.GetPlayerFromId(source)

    local xPlayer = ESX.GetPlayerFromId(id)

	if xPlayer then
		TriggerEvent('esx_license:addLicense', source, 'hunt', function()
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'Inform', text = 'Success' })
        end)
	else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'Error', text = 'No player nearby' })
	end
end)

RegisterServerEvent('fanonx-hunting:server:leatherInInventory')
AddEventHandler('fanonx-hunting:server:leatherInInventory', function(illegalMarket)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]
        for i, animal in pairs(Config.Animals) do
            if not animal.isIllegal and item.count > 0 and not illegalMarket then
                if item.name == animal.bad then
                    TriggerClientEvent('fanonx:client:addElement', source, {label = item.label, item = item.name, type = 'slider', min = 1, max = item.count, value = 1, price = animal.badCost}, false)
                elseif item.name == animal.good then
                    TriggerClientEvent('fanonx:client:addElement', source, {label = item.label, item = item.name, type = 'slider', min = 1, max = item.count, value = 1, price = animal.goodCost}, false)
                elseif item.name == animal.perfect then
                    TriggerClientEvent('fanonx:client:addElement', source, {label = item.label, item = item.name, type = 'slider', min = 1, max = item.count, value = 1, price = animal.perfectCost}, false)
                elseif item.name == animal.specialItem then
                    TriggerClientEvent('fanonx:client:addElement', source, {label = item.label, item = item.name, type = 'slider', min = 1, max = item.count, value = 1, price = animal.specialItemCost}, false)
                end
            elseif animal.isIllegal and item.count > 0 and illegalMarket then
                if item.name == animal.bad then
                    TriggerClientEvent('fanonx:client:addElement', source, {label = item.label, item = item.name, type = 'slider', min = 1, max = item.count, value = 1, price = animal.illegalBadCost}, true)
                elseif item.name == animal.good then
                    TriggerClientEvent('fanonx:client:addElement', source, {label = item.label, item = item.name, type = 'slider', min = 1, max = item.count, value = 1, price = animal.illegalGoodCost}, true)
                elseif item.name == animal.perfect then
                    TriggerClientEvent('fanonx:client:addElement', source, {label = item.label, item = item.name, type = 'slider', min = 1, max = item.count, value = 1, price = animal.illegalPerfectCost}, true)
                elseif item.name == animal.specialItem then
                    TriggerClientEvent('fanonx:client:addElement', source, {label = item.label, item = item.name, type = 'slider', min = 1, max = item.count, value = 1, price = animal.specialItemCost}, true)
                end
            end 
        end
        if item.name == Config.MeatName and item.count > 0 then
            TriggerClientEvent('fanonx:client:addElement', source, {label = item.label, item = item.name, type = 'slider', min = 1, max = item.count, value = 1, price = Config.MeatCost}, false)
        end
	end
end)
