ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterServerCallback('inside-farmer:checkfatigue', function(playerId, cb)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		print(result[1].fatigue)
		if result[1].fatigue >= 900 then
			cb(true)
		else
			cb(false)
		end
		end)
	
end)

RegisterServerEvent('inside-farmer:payout')
AddEventHandler('inside-farmer:payout', function(AmountPayoutC, AmountPayoutL, AmountPayoutP)	
	local xPlayer = ESX.GetPlayerFromId(source)
	local payoutC, payoutL, payoutP

---
	local paylevel

	MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		local user = result[1];
		local userexp = user.farmerexp +1
		local userLevel = user.farmerlevel

		if user.farmerlevel == 0 then
			MySQL.Sync.execute("UPDATE `users` SET `farmerlevel`=@farmerlevel WHERE identifier = @identifier", { 
				['@farmerlevel'] = 1,
				['@identifier'] = xPlayer.identifier
				
			})
			userLevel = 1
			-- print(userLevel)
		end

		for i,v in ipairs(Config.LevelUp) do --actualcode
			if i == userLevel then
				if(userexp >= v.exp) then
					MySQL.Sync.execute("UPDATE `users` SET `farmerlevel`=@farmerlevel WHERE identifier = @identifier", { 
						['@farmerlevel'] = user.farmerlevel + 1,
						['@identifier'] = xPlayer.identifier
						
					})
					MySQL.Sync.execute("UPDATE `users` SET `farmerexp`=@farmerexp WHERE identifier = @identifier", { 
						['@farmerexp'] = 0,
						['@identifier'] = xPlayer.identifier
					})
				else
					MySQL.Sync.execute("UPDATE `users` SET `farmerexp`=@farmerexp WHERE identifier = @identifier", { 
						['@farmerexp'] = user.farmerexp + 1,
						['@identifier'] = xPlayer.identifier
					})
				end
		
				MySQL.Sync.execute("UPDATE `users` SET `fatigue`=@fatigue WHERE identifier = @identifier", { 
					['@fatigue'] = user.fatigue + 80,
					['@identifier'] = xPlayer.identifier
				})
				paylevel = v.pay;
				local Payout = paylevel
				xPlayer.addMoney(Payout)
				print(Payout)
				-- print(v.pay)
				-- print(paylevel)
			end
		end

		
	end)


end)
