RegisterCommand('차량위치', function(source, args, rawCommand)
	print(rawCommand)
	print(string.len(rawCommand))
	local placa = rawCommand:sub(14,19)

	print('kuanaDEbug',placa)
	local elements = {
				
	}
	if PlayerData.job ~= nil then
		if placa ~= "" then
			ESX.TriggerServerCallback('kuana:checkOwnerOfCar', function(vehicles)
				print(json.encode(vehicles))
				print(placa)
				if vehicles ~= nil then

					print('AAAAAAAAAAAAAAA')
					for _,v in pairs(vehicles) do
						local hashVehicule = v.vehicle.model
						local vehicleName = GetDisplayNameFromVehicleModel(hashVehicule)
						local labelvehicle
						carname = ""..v.target..""
						local plate = v.plate

					
						table.insert(elements, {label ="Ver Dono" , value = "carowner"})
						table.insert(elements, {label ="Modelo: "..vehicleName , value = vehicleName})
						table.insert(elements, {label ="Placa: "..placa , value = "placa"})
						if v.lock == "nao" then
							table.insert(elements, {label ="Portas: Destrancadas" , value = "unlock"})
						elseif v.lock == "sim" then
							table.insert(elements, {label ="Portas: Trancadas" , value = "lock"})
						end
						if not blipmapa then
							table.insert(elements, {label ="Colocar no GPS" , value = "gps"})
						else
							table.insert(elements, {label ="Remover do GPS" , value = "gps2"})
						end
					end
					ESX.UI.Menu.CloseAll()
					ESX.UI.Menu.Open(
						'default', GetCurrentResourceName(), 'findcar',
						{
							title    = "",
							align    = 'right',
							elements = elements,
						},
						function(data, menu)
				
							
							if data.current.value == 'gps' then
								blipmapa = true
								RemoveBlip(blipm)
								TriggerServerEvent('kuana:checkvehi', placa)
								menu.close()
							elseif data.current.value == 'gps2' then
								blipmapa = false
								RemoveBlip(blipm)
								menu.close()
							elseif data.current.value == 'carowner' then
								local elements3 = {

								}
								ESX.TriggerServerCallback('kuana:checkcarowner', function(owner)
									for _,v in pairs(owner) do
										table.insert(elements3, {label ="Nome: "..v.names , value = "name"})
										if v.sex == "M" then
											table.insert(elements3, {label ="Sexo: Homem" , value = "sex"})
										else
											table.insert(elements3, {label ="Sexo: Mulher" , value = "sex"})
										end
										table.insert(elements3, {label ="Altura: "..v.height.." cm" , value = "height"})
										table.insert(elements3, {label ="Voltar" , value = "back"})
									end

									ESX.UI.Menu.Open(
										'default', GetCurrentResourceName(), 'findcarowner',
										{
											title    = "",
											align    = 'right',
											elements = elements3,
										},
										function(data2, menu2)
											if data2.current.value == "back" then
												menu2.close()
											end
										end,
										function(data2, menu2)
											menu2.close()											
										end
									)									
								end, carname)
							end
						end,
						function(data, menu)
							menu.close()
							
						end
					)
					---
				else
					print('BBBBBBBBBBBB')
					placa = nil
				end
			end, placa)	
		else
			ESX.ShowNotification("~r~Comando errado~w~: /procarro [placa] ")
		end
	else
		ESX.ShowNotification("Precisas de ser da ~b~Policia~w~ para fazer isso.")
	end
end)