

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterUsableItem('turtlebait', function(source)

	local _source = source
	xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.getInventoryItem('fishingrod').count > 0 then
		TriggerClientEvent('fishing:setbait', _source, "turtle")
		
		xPlayer.removeInventoryItem('turtlebait', 1)
		TriggerClientEvent('fishing:message', _source, "~g~You attach the turtle bait onto your fishing rod")
	else
		TriggerClientEvent('fishing:message', _source, "~r~You dont have a fishing rod")
	end
	
end)

ESX.RegisterUsableItem('fishbait', function(source)

	local _source = source
	xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.getInventoryItem('fishingrod').count > 0 then
		TriggerClientEvent('fishing:setbait', _source, "fish")
		
		xPlayer.removeInventoryItem('fishbait', 1)
		TriggerClientEvent('fishing:message', _source, "~g~You attach the fish bait onto your fishing rod")
		
	else
		TriggerClientEvent('fishing:message', _source, "~r~You dont have a fishing rod")
	end
	
end)

ESX.RegisterUsableItem('turtle', function(source)

	local _source = source
	xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.getInventoryItem('fishingrod').count > 0 then
		TriggerClientEvent('fishing:setbait', _source, "shark")
		
		xPlayer.removeInventoryItem('turtle', 1)
		TriggerClientEvent('fishing:message', _source, "~g~You attach the turtle meat onto the fishing rod")
	else
		TriggerClientEvent('fishing:message', _source, "~r~You dont have a fishing rod")
	end
	
end)

ESX.RegisterUsableItem('fishingrod', function(source)

	local _source = source
	TriggerClientEvent('fishing:fishstart', _source)
	
	

end)

ESX.RegisterServerCallback("fishing:returnLevel",function(source, cb)
	local _source = source
	xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.fetchAll('SELECT fishinglevel FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        cb(result[1].fishinglevel)
    end)
end)



				
RegisterNetEvent('fishing:catch')
AddEventHandler('fishing:catch', function(bait)
	
	_source = source
	local weight = 2
	local rnd = math.random(1,100)
	xPlayer = ESX.GetPlayerFromId(_source)
	-- bait 검사 항목 넣어주자
	if xPlayer.getInventoryItem("fishbait").count > 0 then
		if rnd <= 75 then
			if  xPlayer.getInventoryItem('fish').count > 6 then
				TriggerClientEvent('okokNotify:Alert', source, "시스템", "최대 잡을 수 있는 물고기의 수가 넘었습니다", 5000, 'error')
				else
					weight = 1;
					TriggerClientEvent('okokNotify:Alert', source, "시스템", "물고기를 잡았습니다.", 5000, 'info')
					xPlayer.removeInventoryItem('fishbait', 1)
					xPlayer.addInventoryItem('fish', weight)
				end
		elseif rnd <= 90 then
			if xPlayer.getInventoryItem('turtle').count > 4 then
				TriggerClientEvent('okokNotify:Alert', source, "시스템", "최대 잡을 수 있는 거북이의 수가 넘었습니다", 5000, 'error')
			else
				TriggerClientEvent('fishing:message', _source, "~g~거북이를 잡았습니다. ~y~~h~")
				TriggerClientEvent('okokNotify:Alert', source, "시스템", "거북이를 잡았습니다.", 5000, 'info')
				xPlayer.removeInventoryItem('fishbait', 1)
				xPlayer.addInventoryItem('turtle', 1)
			end
		else
			if xPlayer.getInventoryItem('shark').count > 2 then
				TriggerClientEvent('okokNotify:Alert', source, "시스템", "최대 잡을 수 있는 상어의 수가 넘었습니다", 5000, 'error')
			else
				TriggerClientEvent('okokNotify:Alert', source, "시스템", "상어를 잡았습니다.", 5000, 'info')
				xPlayer.removeInventoryItem('fishbait', 1)
				-- TriggerClientEvent('fishing:message', _source, "~g~상어를 잡았습니다. ~y~~h~")
				xPlayer.addInventoryItem('shark', 1)
			end	
			MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
				['@identifier'] = xPlayer.identifier
			}, function(result)
				local user = result[1];
			MySQL.Sync.execute("UPDATE `users` SET `fatigue`=@fatigue WHERE identifier = @identifier", { 
				['@fatigue'] = user.fatigue + 70,
				['@identifier'] = xPlayer.identifier
			})
		end)
				
		end
	else 
		TriggerClientEvent('okokNotify:Alert', source, "시스템", "미끼가 없습니다", 5000, 'error')
	end
		-- if bait == "none" then
			
		-- end
		
end)

RegisterServerEvent('fishing:exp')
AddEventHandler('fishing:exp', function()
	local _source = source
	xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.fetchAll('SELECT fishingexp FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(resultexp)
        MySQL.Async.fetchAll('SELECT fishinglevel FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(resultlevel)
			if(resultlevel[1].fishinglevel == 1) then
				if resultexp[1].fishingexp == 100 then
					MySQL.Sync.execute("UPDATE `users` SET `fishinglevel`=@fishinglevel WHERE identifier = @identifier", { 
						['@fishinglevel'] = 2,
						['@identifier'] = xPlayer.identifier
					})
				else
					MySQL.Sync.execute("UPDATE `users` SET `fishingexp`=@fishingexp WHERE identifier = @identifier", { 
						['@fishingexp'] = resultexp[1].fishingexp + 1,
						['@identifier'] = xPlayer.identifier
					})
				end
			elseif resultlevel[1].fishinglevel == 2 then
				if resultexp[1].fishingexp == 200 then
					MySQL.Sync.execute("UPDATE `users` SET `fishinglevel`=@fishinglevel WHERE identifier = @identifier", { 
						['@fishinglevel'] = 3,
						['@identifier'] = xPlayer.identifier
					})
				else
					MySQL.Sync.execute("UPDATE `users` SET `fishingexp`=@fishingexp WHERE identifier = @identifier", { 
						['@fishingexp'] = resultexp[1].fishingexp + 1,
						['@identifier'] = xPlayer.identifier
					})
				end
			elseif resultlevel[1].fishinglevel == 3 then
				if resultexp[1].fishingexp == 300 then
					MySQL.Sync.execute("UPDATE `users` SET `fishinglevel`=@fishinglevel WHERE identifier = @identifier", { 
						['@fishinglevel'] = 4,
						['@identifier'] = xPlayer.identifier
					})
				else
					MySQL.Sync.execute("UPDATE `users` SET `fishingexp`=@fishingexp WHERE identifier = @identifier", { 
						['@fishingexp'] = resultexp[1].fishingexp + 1,
						['@identifier'] = xPlayer.identifier
					})
				end
			elseif resultlevel[1].fishinglevel == 4 then
				if resultexp[1].fishingexp == 400 then
					MySQL.Sync.execute("UPDATE `users` SET `fishinglevel`=@fishinglevel WHERE identifier = @identifier", { 
						['@fishinglevel'] = 5,
						['@identifier'] = xPlayer.identifier
					})
				else
					MySQL.Sync.execute("UPDATE `users` SET `fishingexp`=@fishingexp WHERE identifier = @identifier", { 
						['@fishingexp'] = resultexp[1].fishingexp + 1,
						['@identifier'] = xPlayer.identifier
					})
				end
			end
		end)
    end)
end)

RegisterServerEvent("fishing:lowmoney")
AddEventHandler("fishing:lowmoney", function(money)
    local _source = source	
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeMoney(money)
end)

RegisterServerEvent('fishing:returnPrice')
AddEventHandler('fishing:returnPrice', function(money)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addMoney(money)
	-- xPlayer.addAccountMoney('bank', Config.DepositPrice)
end)


ESX.RegisterServerCallback('fishing:checkMoney',function(pd,cb,price)
local xPlayer = ESX.GetPlayerFromId(pd)
	if xPlayer.getMoney() >= price then
	xPlayer.removeMoney(price)
	cb(true)
	elseif xPlayer.getAccount('bank').money >= price then
		xPlayer.removeAccountMoney('bank',price)
		cb(true)
	else
		cb(false)
	end
end)




RegisterServerEvent('fishing:startSelling')
AddEventHandler('fishing:startSelling', function(item,level)

	local _source = source
	local payment
	local xPlayer  = ESX.GetPlayerFromId(_source)
			if item == "fish" then
					local FishQuantity = xPlayer.getInventoryItem('fish').count
					-- if FishQuantity <= 4 then
					-- 	TriggerClientEvent('esx:showNotification', source, '~r~You dont have enough~s~ fish')			
					-- else   
							payment = FishQuantity * 30
							xPlayer.removeInventoryItem('fish', FishQuantity)
							xPlayer.addMoney(payment)
			end

			if item == "turtle" then
				local FishQuantity = xPlayer.getInventoryItem('turtle').count
				payment = FishQuantity * 80
				xPlayer.removeInventoryItem('turtle', FishQuantity)
				xPlayer.addMoney(payment)
			end

			if item == "shark" then
				local FishQuantity = xPlayer.getInventoryItem('shark').count
				payment = FishQuantity * 300
				xPlayer.removeInventoryItem('shark', FishQuantity)
				xPlayer.addMoney(payment)
			end
			
	
end)

