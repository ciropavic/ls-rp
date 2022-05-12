ESX.StartPayCheck = function()
	function payCheck()
		local xPlayers = ESX.GetPlayers()

		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			local job     = xPlayer.job.grade_name
			local salary  = xPlayer.job.grade_salary

			-- 추가 시작 
			local bank = xPlayer.getAccount("bank").money
			local tax = 0
			-- local taxMultiplier = Config.CarTax
			local taxMultiplier
			local CarTax = 0
			local homeTax = 0
			local carCount = 0
			local salaryTax = 0
			local homeCount = 0

			if (bank > Config.HoboClassLimit) and (bank < Config.PoorClassLimit) then --Poor Class
				local taxpercent = Config.PoorClassTax 
				tax = (bank*taxpercent) / 1000 
			elseif (bank < Config.LowerClassLimit) then --Lower Class
				local taxpercent = Config.LowerClassTax 
				tax = (bank*taxpercent) / 1000 
			elseif (bank < Config.LowerMiddleClassLimit) then --Lower Middle Class
				local taxpercent = Config.LowerMiddleClassTax 
				tax = (bank*taxpercent) / 1000 
			elseif (bank < Config.MiddleClassLimit) then --Middle Class
				local taxpercent = Config.MiddleClassTax 
				tax = (bank*taxpercent) / 1000
			elseif (bank < Config.UpperMiddleClassLimit) then --Upper Middle Class
				local taxpercent = Config.UpperMiddleClassTax 
				tax = (bank*taxpercent) / 1000
			elseif (bank < Config.LowerHigherClassLimit) then --Lower Higher Class
				local taxpercent = Config.LowerHigherClassTax 
				tax = (bank*taxpercent) / 1000
			elseif  (bank < Config.HigherClassLimit) then --Higher Class
				local taxpercent = Config.HigherClassTax 
				tax = (bank*taxpercent) / 1000
			else
				local taxpercent = Config.UpperHigherClassTax 
				tax = (bank*taxpercent) / 1000
			end
			-- print('CarTaxDebug : ',xPlayer.identifier)
			local result = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner', {
				['@owner'] = xPlayer.identifier})
			-- print('CarTaxDebug')
			-- print('result : ',result)
			for a=1 , #result,1 do
				if xPlayer.getIdentifier() == result[a].owner then
					carCount = carCount + 1
				end
			end

			local result = MySQL.Sync.fetchAll('SELECT * FROM loaf_bought_houses WHERE owner = @owner', {
				['@owner'] = xPlayer.identifier})
			for a=1 , #result,1 do
				if xPlayer.getIdentifier() == result[a].owner then
					homeCount = homeCount + 1
				end
			end
			-- print('CarTaxDebug2 : ', carCount)
			if carCount > 0 then
				if(carCount < 5)then
					taxMultiplier = 100
				elseif(carCount < 13) then
					taxMultiplier = 500
				else
					taxMultiplier = 2000
				end
				print(taxMultiplier,carCount)
				CarTax = carCount * taxMultiplier
			end
			-- print('CarTaxDebug3 : ', CarTax)


			if(homeCount == 0) then
				homeTax = 0
			elseif homeCount == 1 then
				homeTax = 1000
			elseif homeCount == 2 then
				homeTax = 2000
			elseif homeCount == 3 then
				homeTax = 5000
			elseif homeCount == 4 then
				homeTax = 10000
			elseif homeCount == 5 then
				homeTax = 20000
			end

			salaryTax = salary * 5
			salaryTax = salaryTax / 100
			salaryTax = ESX.Math.Round(salaryTax)

			-- print(xPlayer,'\'s salary : ',salary)
			-- print(xPlayer,'\'s BankIncentive : ',ESX.Math.Round(tax))
			-- print(xPlayer,'\'s CarTax : ',ESX.Math.Round(CarTax))
			-- print(xPlayer,'\'s salaryTax : ',salaryTax)

			salary = salary - salaryTax
			
			if(xPlayer ~= nil) then 
				if tax ~= 0 then 
					salary = salary + ESX.Math.Round(tax)
				end
				if CarTax ~= 0 then 
					salary = salary - CarTax
				end
			end
			
			local totalPersonalTax = CarTax + salaryTax + homeTax

			print('totalPersonalTax : ', totalPersonalTax)

			MySQL.Async.execute('UPDATE cityhall SET amount = amount + @amount WHERE department = @department',{
				['@department'] = 'cityhall',
				['@amount'] = totalPersonalTax
			})

			-- 추가 끝
			TriggerClientEvent("paybills", xPlayer.source)

			if salary > 0 then
				if job == 'unemployed' then -- unemployed
					xPlayer.addAccountMoney('bank', salary)
					TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_help', salary), 'CHAR_BANK_MAZE', 9)
					TriggerClientEvent("esx:showNotification", xPlayer.source, "자동차세 $" .. CarTax)
					TriggerClientEvent("esx:showNotification", xPlayer.source, "소득세 $" .. salaryTax)
					TriggerClientEvent("esx:showNotification", xPlayer.source, "은행 이자 $" .. ESX.Math.Round(tax))

					-- 백수
				elseif Config.EnableSocietyPayouts then -- possibly a society

					-- 취업자 
					

					TriggerEvent('esx_society:getSociety', xPlayer.job.name, function (society)
						if society ~= nil then -- verified society
							TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function (account)
								if account.money >= salary then -- does the society money to pay its employees?
									xPlayer.addAccountMoney('bank', salary)
									account.removeMoney(salary)

									TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_salary', salary), 'CHAR_BANK_MAZE', 9)
									TriggerClientEvent("esx:showNotification", xPlayer.source, "자동차세 $" .. CarTax)
									TriggerClientEvent("esx:showNotification", xPlayer.source, "소득세 $" .. salaryTax)
									TriggerClientEvent("esx:showNotification", xPlayer.source, "은행 이자 $" .. ESX.Math.Round(tax))
								else
									TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), '', _U('company_nomoney'), 'CHAR_BANK_MAZE', 1)
									TriggerClientEvent("esx:showNotification", xPlayer.source, "자동차세 $" .. CarTax)
									TriggerClientEvent("esx:showNotification", xPlayer.source, "소득세 $" .. salaryTax)
									TriggerClientEvent("esx:showNotification", xPlayer.source, "은행 이자 $" .. ESX.Math.Round(tax))
								end
							end)
						else -- not a society
							xPlayer.addAccountMoney('bank', salary)
							TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_salary', salary), 'CHAR_BANK_MAZE', 9)
							TriggerClientEvent("esx:showNotification", xPlayer.source, "자동차세 $" .. CarTax)
							TriggerClientEvent("esx:showNotification", xPlayer.source, "소득세 $" .. salaryTax)
							TriggerClientEvent("esx:showNotification", xPlayer.source, "은행 이자 $" .. ESX.Math.Round(tax))
						end
					end)
				else -- generic job
					xPlayer.addAccountMoney('bank', salary)
					TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_salary', salary), 'CHAR_BANK_MAZE', 9)
					TriggerClientEvent("esx:showNotification", xPlayer.source, "자동차세 $" .. CarTax)
					TriggerClientEvent("esx:showNotification", xPlayer.source, "소득세 $" .. salaryTax)
					TriggerClientEvent("esx:showNotification", xPlayer.source, "은행 이자 $" .. ESX.Math.Round(tax))
				end
			end

		end

		SetTimeout(Config.PaycheckInterval, payCheck)
	end

	SetTimeout(Config.PaycheckInterval, payCheck)
end