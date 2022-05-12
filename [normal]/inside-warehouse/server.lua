ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


			
		
	

ESX.RegisterServerCallback('inside-warehouse:checkMoney', function(playerId, cb)
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



ESX.RegisterServerCallback('inside-warehouse:checkfatigue', function(playerId, cb)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
		print(result[1].warehouselevel)
		print(result[1].fatigue)
		if result[1].fatigue >= 900 then
			cb(true)
		else
			cb(false)
		end
		end)
	
end)

RegisterServerEvent('inside-warehouse:returnVehicle')
AddEventHandler('inside-warehouse:returnVehicle', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local Payout = Config.DepositPrice
	
	xPlayer.addAccountMoney('bank', Config.DepositPrice)
end)

RegisterServerEvent('inside-warehouse:Payout')
AddEventHandler('inside-warehouse:Payout', function(arg)	
	local xPlayer = ESX.GetPlayerFromId(source)
	local Payout = 0;
	-- print(xPlayer)
	-- print(xPlayer.identifier)
	MySQL.Async.fetchAll('SELECT warehouselevel FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
		-- print(result[1].warehouselevel)
		-- print(arg)
		if result[1].warehouselevel == 0 then
		 Payout = 50 * arg
			print("payoutsucess")
		elseif result[1].warehouselevel == 1 then
			 Payout = 75 * arg
		elseif result[1].warehouselevel == 2 then
			 Payout = 80 * arg
		elseif result[1].warehouselevel == 3 then
			 Payout = 87.5 * arg
		elseif result[1].warehouselevel == 4 then
			 Payout = 93.8 * arg
		elseif result[1].warehouselevel == 5 then
			 Payout = 100 * arg
		end
		-- print(Payout)
		xPlayer.addMoney(Payout)
    end)
	
end)

-- ESX.RegisterServerCallback("inside-warehouse:returnLevel",function(source, cb)
-- 	local xPlayer = ESX.GetPlayerFromId(source)
-- 	MySQL.Async.fetchAll('SELECT warehouselevel FROM users WHERE identifier = @identifier', {
--         ['@identifier'] = xPlayer.identifier
--     }, function(result)
--         cb(result[1].warehouselevel)
--     end)
-- end)

RegisterServerEvent('inside-warehouse:exp')
AddEventHandler('inside-warehouse:exp', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	print(xPlayer)
	print(xPlayer.identifier)
	    MySQL.Async.fetchAll("SELECT * From users where identifier = @identifier", {
			['@identifier'] = xPlayer.identifier
		}, function(result)
			local user = result[1]
			print(result[1])
			print(result[1].warehouselevel)
			MySQL.Sync.execute("UPDATE `users` SET `fatigue`=@fatigue WHERE identifier = @identifier",{
				['@fatigue'] = user.fatigue + 230,
				['@identifier'] = xPlayer.identifier
			})

			if(user.warehouselevel == 1) then
				if user.warehouseexp == 50 then
					MySQL.Sync.execute("UPDATE `users` SET `warehouselevel`=@warehouselevel WHERE identifier = @identifier", { 
						['@warehouselevel'] = 2,
						['@identifier'] = xPlayer.identifier
					})
					
				else
					MySQL.Sync.execute("UPDATE `users` SET `warehouseexp`=@warehouseexp WHERE identifier = @identifier", { 
						['@warehouseexp'] = user.warehouseexp + 1,
						['@identifier'] = xPlayer.identifier
					})
				end
			elseif user.warehouselevel == 2 then
				if user.warehouseexp == 300 then
					MySQL.Sync.execute("UPDATE `users` SET `warehouselevel`=@warehouselevel WHERE identifier = @identifier", { 
						['@warehouselevel'] = 3,
						['@identifier'] = xPlayer.identifier
					})
				else
					MySQL.Sync.execute("UPDATE `users` SET `warehouseexp`=@warehouseexp WHERE identifier = @identifier", { 
						['@warehouseexp'] = user.warehouseexp + 1,
						['@identifier'] = xPlayer.identifier
					})
				end
			elseif user.warehouselevel == 3 then
				if user.warehouseexp == 700 then
					MySQL.Sync.execute("UPDATE `users` SET `warehouselevel`=@warehouselevel WHERE identifier = @identifier", { 
						['@warehouselevel'] = 4,
						['@identifier'] = xPlayer.identifier
					})
				else
					MySQL.Sync.execute("UPDATE `users` SET `warehouseexp`=@warehouseexp WHERE identifier = @identifier", { 
						['@warehouseexp'] = user.warehouseexp + 1,
						['@identifier'] = xPlayer.identifier
					})
				end
			elseif user.warehouselevel == 4 then
				if user.warehouseexp == 1500 then
					MySQL.Sync.execute("UPDATE `users` SET `warehouselevel`=@warehouselevel WHERE identifier = @identifier", { 
						['@warehouselevel'] = 5,
						['@identifier'] = xPlayer.identifier
					})
				else
					MySQL.Sync.execute("UPDATE `users` SET `warehouseexp`=@warehouseexp WHERE identifier = @identifier", { 
						['@warehouseexp'] = user.warehouseexp + 1,
						['@identifier'] = xPlayer.identifier
					})
				end

			elseif user.warehouselevel == 0 then
				if user.warehouseexp == 100 then
					MySQL.Sync.execute("UPDATE `users` SET `warehouselevel`=@warehouselevel WHERE identifier = @identifier", { 
						['@warehouselevel'] = 1,
						['@identifier'] = xPlayer.identifier
					})
				else
					MySQL.Sync.execute("UPDATE `users` SET `warehouseexp`=@warehouseexp WHERE identifier = @identifier", { 
						['@warehouseexp'] = user.warehouseexp + 1,
						['@identifier'] = xPlayer.identifier
					})
					print("expsuccse")
				end
			
			end
		
		end)
end)