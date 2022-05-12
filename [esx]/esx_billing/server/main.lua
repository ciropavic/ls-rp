ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_billing:sendBill')
AddEventHandler('esx_billing:sendBill', function(playerId, sharedAccountName, label, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(playerId)
	print("벌금테스트1")
	amount = ESX.Math.Round(amount)
	print(xPlayer)

	if amount > 0 and xTarget then
		TriggerEvent('esx_addonaccount:getSharedAccount', sharedAccountName, function(account)
			if account then
				MySQL.Async.execute('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)', {
					['@identifier'] = xTarget.identifier,
					['@sender'] = xPlayer.identifier,
					['@target_type'] = 'society',
					['@target'] = sharedAccountName,
					['@label'] = label,
					['@amount'] = amount
				}, function(rowsChanged)
					print("벌금테스트2")
					xPlayer.showNotification("벌금티켓을 발부했습니다.")
					xTarget.showNotification(_U('received_invoice'))
				end)

			else
				MySQL.Async.execute('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)', {
					['@identifier'] = xTarget.identifier,
					['@sender'] = xPlayer.identifier,
					['@target_type'] = 'player',
					['@target'] = xPlayer.identifier,
					['@label'] = label,
					['@amount'] = amount
				}, function(rowsChanged)
					xPlayer.showNotification("벌금티켓을 발부했습니다.")
					xTarget.showNotification(_U('received_invoice'))
				end)
			end
		end)
	end
end)

ESX.RegisterServerCallback('esx_billing:getBills', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT amount, id, label FROM billing WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		cb(result)
	end)
end)

ESX.RegisterServerCallback('esx_billing:getTargetBills', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	if xPlayer then
		MySQL.Async.fetchAll('SELECT amount, id, label FROM billing WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(result)
			cb(result)
		end)
	else
		cb({})
	end
end)



RegisterServerEvent('esx_billing:givebudget')
AddEventHandler('esx_billing:givebudget', function(params)


	local xPlayer = ESX.GetPlayerFromId(source)
	print('params : ',params)
	MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		print('result : ',result)
		if result[1] then
			if result[1].group == 'admin' then
				print('reached')
				local array = {}
				local i = 1
				for words in string.gmatch(params, "%S+") do
					array[i] = words
					print('array words : ',array[i])
					i = i + 1
				end
				print('array idx : ',array[1], array[2])
		
				if array[1] == 'pd' then

					TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)
						account.addMoney(tonumber(array[2]))
					end)
					-- MySQL.Async.execute('UPDATE addon_account_data SET money = money + @money WHERE account_name = @account_name',{
					-- 	['@account_name'] = 'society_police',
					-- 	['@money'] = tonumber(array[2])
					-- })
					MySQL.Async.execute('UPDATE cityhall SET amount = amount - @amount WHERE department = @department',{
						['@department'] = 'cityhall',
						['@amount'] = tonumber(array[2])
					})
				elseif array[1] == 'fd' then
					MySQL.Async.execute('UPDATE addon_account_data SET money = money + @money WHERE account_name = @account_name',{
						['@account_name'] = 'society_ambulance',
						['@money'] = tonumber(array[2])
					})
					MySQL.Async.execute('UPDATE cityhall SET amount = amount - @amount WHERE department = @department',{
						['@department'] = 'cityhall',
						['@amount'] = tonumber(array[2])
					})
				else
					print('Wrong Department')
				end
			end
		end
	

	end)
end)








ESX.RegisterServerCallback('esx_billing:payBill', function(source, cb, billId)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT sender, target_type, target, amount FROM billing WHERE id = @id', {
		['@id'] = billId
	}, function(result)
		if result[1] then
			local amount = result[1].amount
			local xTarget = ESX.GetPlayerFromIdentifier(result[1].sender)
			
			-- if result[1].target_type == 'player' then
				if xTarget then
					if xPlayer.getMoney() >= amount then
						print('taxDebug3')
						MySQL.Async.execute('UPDATE cityhall SET amount = amount + @amount WHERE department = @department',{
							['@department'] = 'cityhall',
							['@amount'] = amount
						})
						print('taxDebug')
						MySQL.Async.execute('DELETE FROM billing WHERE id = @id', {
							['@id'] = billId
						}, function(rowsChanged)
							if rowsChanged == 1 then
								xPlayer.removeMoney(amount)
								print('xTarget0218',xTarget)
								--xTarget.addMoney(amount)

								xPlayer.showNotification(_U('paid_invoice', ESX.Math.GroupDigits(amount)))
								xTarget.showNotification(_U('received_payment', ESX.Math.GroupDigits(amount)))
							end

							cb()
						end)
					elseif xPlayer.getAccount('bank').money >= amount then
						MySQL.Async.execute('DELETE FROM billing WHERE id = @id', {
							['@id'] = billId
						}, function(rowsChanged)
							if rowsChanged == 1 then
								xPlayer.removeAccountMoney('bank', amount)
								xTarget.addAccountMoney('bank', amount)

								xPlayer.showNotification(_U('paid_invoice', ESX.Math.GroupDigits(amount)))
								xTarget.showNotification(_U('received_payment', ESX.Math.GroupDigits(amount)))
							end

							cb()
						end)
					else
						xTarget.showNotification(_U('target_no_money'))
						xPlayer.showNotification(_U('no_money'))
						cb()
					end
				else
					xPlayer.showNotification(_U('player_not_online'))
					cb()
				end
			-- else
			-- 	TriggerEvent('esx_addonaccount:getSharedAccount', result[1].target, function(account)
			-- 		if xPlayer.getMoney() >= amount then
			-- 			print('taxDebug4')
			-- 			MySQL.Async.execute('UPDATE cityhall SET amount = amount + @amount WHERE department = @department',{
			-- 				['@department'] = 'cityhall',
			-- 				['@amount'] = amount
			-- 			})
			-- 			print('taxDebug5')
			-- 			MySQL.Async.execute('DELETE FROM billing WHERE id = @id', {
			-- 				['@id'] = billId
			-- 			}, function(rowsChanged)
			-- 				if rowsChanged == 1 then
			-- 					xPlayer.removeMoney(amount)
			-- 					--account.addMoney(amount)
			-- 					--print('account0218',account)
			-- 					xPlayer.showNotification(_U('paid_invoice', ESX.Math.GroupDigits(amount)))
			-- 					if xTarget then
			-- 						xTarget.showNotification(_U('received_payment', ESX.Math.GroupDigits(amount)))
			-- 					end
			-- 				end

			-- 				cb()
			-- 			end)
			-- 		elseif xPlayer.getAccount('bank').money >= amount then
			-- 			MySQL.Async.execute('DELETE FROM billing WHERE id = @id', {
			-- 				['@id'] = billId
			-- 			}, function(rowsChanged)
			-- 				if rowsChanged == 1 then
			-- 					xPlayer.removeAccountMoney('bank', amount)
			-- 					account.addMoney(amount)
			-- 					xPlayer.showNotification(_U('paid_invoice', ESX.Math.GroupDigits(amount)))

			-- 					if xTarget then
			-- 						xTarget.showNotification(_U('received_payment', ESX.Math.GroupDigits(amount)))
			-- 					end
			-- 				end

			-- 				cb()
			-- 			end)
			-- 		else
			-- 			if xTarget then
			-- 				xTarget.showNotification(_U('target_no_money'))
			-- 			end

			-- 			xPlayer.showNotification(_U('no_money'))
			-- 			cb()
			-- 		end
			-- 	end)
			-- end
		end
	end)
end)
