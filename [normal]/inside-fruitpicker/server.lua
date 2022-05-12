ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent('inside-fruitpicker:test')
AddEventHandler('inside-fruitpicker:test', function()
	print("sososo")
	for i,v in ipairs(Config.LevelUp) do --actualcode
		print(v.exp)
		print(i)
	end
end)

ESX.RegisterServerCallback('inside-fruitpicker:checkMoney', function(playerId, cb)
	local xPlayer = ESX.GetPlayerFromId(playerId)
    local name = ESX.GetPlayerFromId(playerId)

	if xPlayer.getMoney() >= Config.DepositPrice then
        xPlayer.removeMoney(Config.DepositPrice)
		cb(true)
    elseif xPlayer.getAccount('bank').money >= Config.DepositPrice then
        xPlayer.removeAccountMoney('bank', Config.DepositPrice)
        cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent('inside-fruitpicker:depositBack')
AddEventHandler('inside-fruitpicker:depositBack', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local Payout = Config.DepositPrice
	xPlayer.addMoney(Payout)
	-- xPlayer.addAccountMoney('bank', Config.DepositPrice)
end)

RegisterServerEvent('inside-fruitpicker:Payout')
AddEventHandler('inside-fruitpicker:Payout', function(arg)	
	local xPlayer = ESX.GetPlayerFromId(source)
	local paylevel

	MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		local user = result[1];
		local userexp = user.fruitexp +1

		local userLevel = user.fruitlevel

		if user.fruitlevel == 0 then
			MySQL.Sync.execute("UPDATE `users` SET `fruitlevel`=@fruitlevel WHERE identifier = @identifier", { 
				['@fruitlevel'] = 1,
				['@identifier'] = xPlayer.identifier
				
			})
			userLevel = 1
		end


		for i,v in ipairs(Config.LevelUp) do --actualcode
			if i == userLevel then
				if(userexp >= v.exp) then
					MySQL.Sync.execute("UPDATE `users` SET `fruitlevel`=@fruitlevel WHERE identifier = @identifier", { 
						['@fruitlevel'] = user.fruitlevel + 1,
						['@identifier'] = xPlayer.identifier
						
					})
					MySQL.Sync.execute("UPDATE `users` SET `fruitexp`=@fruitexp WHERE identifier = @identifier", { 
						['@fruitexp'] = 0,
						['@identifier'] = xPlayer.identifier
					})
				else
					MySQL.Sync.execute("UPDATE `users` SET `fruitexp`=@fruitexp WHERE identifier = @identifier", { 
						['@fruitexp'] = user.fruitexp + 1,
						['@identifier'] = xPlayer.identifier
					})
				end
		
				MySQL.Sync.execute("UPDATE `users` SET `fatigue`=@fatigue WHERE identifier = @identifier", { 
					['@fatigue'] = user.fatigue + 230,
					['@identifier'] = xPlayer.identifier
				})
				paylevel = v.pay
				local Payout = paylevel
				xPlayer.addMoney(Payout)
				-- print(v.pay)
				-- print(paylevel)
			end
		end

		
	end)
	
	-- MySQL.Async.fetchAll('SELECT fruitlevel FROM users WHERE identifier = @identifier', {
	-- 	['@identifier'] = xPlayer.identifier
	-- }, function(result)
	-- 	print(json.encode(result))
	-- 	local Payout = paylevel * arg
	-- 	xPlayer.addMoney(Payout)
	-- end)
	
end)