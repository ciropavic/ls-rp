local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum
local isBusy, deadPlayers, deadPlayerBlips, isOnDuty = false, {}, {}, false
isInShopMenu = false
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function OpenAmbulanceActionsMenu()
	local elements = {{label = _U('cloakroom'), value = 'cloakroom'}}

	if Config.EnablePlayerManagement and ESX.PlayerData.job.grade_name == 'lieutenant' or 
	ESX.PlayerData.job.grade_name == 'captain' or
	ESX.PlayerData.job.grade_name == 'deputy_fire_chief' or
	ESX.PlayerData.job.grade_name == 'chief_of_fire' then
		table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
		print("enable bossactions")
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ambulance_actions', {
		title    = _U('ambulance'),
		align    = 'right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'cloakroom' then
			OpenCloakroomMenu()
		elseif data.current.value == 'boss_actions' then
			TriggerEvent('esx_society:openBossMenu', 'ambulance', function(data, menu)
				menu.close()
			end, {wash = false})
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenMobileAmbulanceActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_ambulance_actions', {
		title    = _U('ambulance'),
		align    = 'right',
		elements = {
			{label = _U('ems_menu'), value = 'citizen_interaction'}
	}}, function(data, menu)
		if data.current.value == 'citizen_interaction' then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				title    = _U('ems_menu_title'),
				align    = 'right',
				elements = {
					{label = _U('ems_menu_revive'), value = 'revive'},
					{label = _U('ems_menu_small'), value = 'small'},
					{label = _U('ems_menu_big'), value = 'big'},
					{label = _U('ems_menu_putincar'), value = 'put_in_vehicle'},
					{label = _U('ems_menu_search'), value = 'search'}
			}}, function(data, menu)
				if isBusy then return end

				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

				if data.current.value == 'search' then
					TriggerServerEvent('esx_ambulancejob:svsearch')
				elseif closestPlayer == -1 or closestDistance > 3.0 then
					ESX.ShowNotification(_U('no_players'))
				else
					if data.current.value == 'revive' then
								ESX.UI.Menu.Open(
										'dialog', GetCurrentResourceName(), 'reviveplayer',
										{
										title = "소생할 플레이어 지정"
										},
									function(data4, menu4)
										menu.close()
										print(data4.value)
										local Player = tonumber(data4.value)
							if(data4.value == nil)then
								ESX.ShowNotification("잘못된 플레이어 번호입니다.")
								menu4.close()
							else
								menu4.close()
										local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

										if closestPlayer == -1 or closestDistance > 3.0 then
											ESX.ShowNotification("No players nearby!")
										else
													local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
													
													if closestPlayer == -1 or closestDistance > 3.0 then
														ESX.ShowNotification("No players nearby!")
													else
														if(GetPlayerServerId(closestPlayer) == Player) then
															revivePlayer(closestPlayer)
														else
															ESX.ShowNotification("소생할 대상에게 더 가까이 가서 시도하십시오.")
														end
													end
										end
							end

						end, function(data4, menu4)
							menu4.close()
						end)
					elseif data.current.value == 'small' then
						ESX.UI.Menu.Open(
										'dialog', GetCurrentResourceName(), 'reviveplayer',
										{
										title = "치료할 플레이어 지정"
										},
									function(data4, menu4)
										menu.close()
										print(data4.value)
										local Player = tonumber(data4.value)
							if(data4.value == nil)then
								ESX.ShowNotification("잘못된 플레이어 번호입니다.")
								menu4.close()
							else
								menu4.close()
										local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

										if closestPlayer == -1 or closestDistance > 3.0 then
											ESX.ShowNotification("No players nearby!")
										else
													local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
													
													if closestPlayer == -1 or closestDistance > 3.0 then
														ESX.ShowNotification("No players nearby!")
													else
														if(GetPlayerServerId(closestPlayer) == Player) then
															ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
																if quantity > 0 then
																	local closestPlayerPed = GetPlayerPed(closestPlayer)
																	local health = GetEntityHealth(closestPlayerPed)
									
																	if health > 110 then
																		local playerPed = PlayerPedId()
									
																		isBusy = true
																		ESX.ShowNotification(_U('heal_inprogress'))
																		TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
																		exports['rprogress']:Start('치료중', 10000)
																		ClearPedTasks(playerPed)
									
																		TriggerServerEvent('esx_ambulancejob:removeItem', 'bandage')
																		TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'small')
																		isBusy = false
																	else
																		ESX.ShowNotification(_U('player_not_conscious'))
																	end
																else
																	ESX.ShowNotification(_U('not_enough_bandage'))
																end
															end, 'bandage')
														else
															ESX.ShowNotification("소생할 대상에게 더 가까이 가서 시도하십시오.")
														end
													end
										end
							end

						end, function(data4, menu4)
							menu4.close()
						end)
					elseif data.current.value == 'big' then
						ESX.UI.Menu.Open(
										'dialog', GetCurrentResourceName(), 'reviveplayer',
										{
										title = "치료할 플레이어 지정"
										},
									function(data4, menu4)
										menu.close()
										print(data4.value)
										local Player = tonumber(data4.value)
							if(data4.value == nil)then
								ESX.ShowNotification("잘못된 플레이어 번호입니다.")
								menu4.close()
							else
								menu4.close()
										local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

										if closestPlayer == -1 or closestDistance > 3.0 then
											ESX.ShowNotification("No players nearby!")
										else
													local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
													
													if closestPlayer == -1 or closestDistance > 3.0 then
														ESX.ShowNotification("No players nearby!")
													else
														if(GetPlayerServerId(closestPlayer) == Player) then
															ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
																if quantity > 0 then
																	local closestPlayerPed = GetPlayerPed(closestPlayer)
																	local health = GetEntityHealth(closestPlayerPed)
									
																	if health > 110 then
																		local playerPed = PlayerPedId()
									
																		isBusy = true
																		ESX.ShowNotification(_U('heal_inprogress'))
																		TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
																		exports['rprogress']:Start('치료중', 10000)
																		ClearPedTasks(playerPed)
									
																		TriggerServerEvent('esx_ambulancejob:removeItem', 'bandage')
																		TriggerServerEvent('esx_ambulancejob:removeItem', 'bandage')
																		TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'big')
																		isBusy = false
																	else
																		ESX.ShowNotification(_U('player_not_conscious'))
																	end
																else
																	ESX.ShowNotification(_U('not_enough_medikit'))
																end
															end, 'bandage')
														else
															ESX.ShowNotification("소생할 대상에게 더 가까이 가서 시도하십시오.")
														end
													end
										end
							end

							end, function(data4, menu4)
							menu4.close()
						end)
						ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
							if quantity > 0 then
								local closestPlayerPed = GetPlayerPed(closestPlayer)
								local health = GetEntityHealth(closestPlayerPed)

								if health > 110 then
									local playerPed = PlayerPedId()

									isBusy = true
									ESX.ShowNotification(_U('heal_inprogress'))
									TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
									exports['rprogress']:Start('치료중', 10000)
									ClearPedTasks(playerPed)

									TriggerServerEvent('esx_ambulancejob:removeItem', 'bandage')
									TriggerServerEvent('esx_ambulancejob:removeItem', 'bandage')
									TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'big')
									isBusy = false
								else
									ESX.ShowNotification(_U('player_not_conscious'))
								end
							else
								ESX.ShowNotification(_U('not_enough_medikit'))
							end
						end, 'bandage')

					elseif data.current.value == 'put_in_vehicle' then
						TriggerServerEvent('esx_ambulancejob:putInVehicle', GetPlayerServerId(closestPlayer))
					end
				end
			end, function(data, menu)
				menu.close()
			end)
		end

	end, function(data, menu)
		menu.close()
	end)
end

function revivePlayer(closestPlayer)
	isBusy = true

	ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
		if quantity > 0 then
			local closestPlayerPed = GetPlayerPed(closestPlayer)
			if GetEntityHealth(GetPlayerPed(closestPlayer)) > 0 and GetEntityHealth(GetPlayerPed(closestPlayer)) < 110 then
				local playerPed = PlayerPedId()
				local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01'
				ESX.ShowNotification(_U('revive_inprogress'))

				
				ESX.Streaming.RequestAnimDict(lib, function()
					TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, 15000, 0, 0, false, false, false)
					exports['rprogress']:Start('소생중', 15000)
					ClearPedTasksImmediately(GetPlayerPed(-1))
				end)
				TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
				TriggerServerEvent('esx_ambulancejob:revive', GetPlayerServerId(closestPlayer))
			else
				ESX.ShowNotification(_U('player_not_unconscious'))
			end
		else
			ESX.ShowNotification(_U('not_enough_medikit'))
		end
		isBusy = false
	end, 'medikit')
end

function FastTravel(coords, heading)
	local playerPed = PlayerPedId()

	DoScreenFadeOut(800)

	while not IsScreenFadedOut() do
		Citizen.Wait(500)
	end

	ESX.Game.Teleport(playerPed, coords, function()
		DoScreenFadeIn(800)

		if heading then
			SetEntityHeading(playerPed, heading)
		end
	end)
end

-- Draw markers & Marker logic
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
			local playerCoords = GetEntityCoords(PlayerPedId())
			local letSleep, isInMarker, hasExited = true, false, false
			local currentHospital, currentPart, currentPartNum

			for hospitalNum,hospital in pairs(Config.Hospitals) do
				-- Ambulance Actions
				for k,v in ipairs(hospital.AmbulanceActions) do
					local distance = #(playerCoords - v)

					if distance < Config.DrawDistance then
						DrawMarker(20, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 50, 50, 204, Config.Marker.a, true, false, 2, Config.Marker.rotate, nil, nil, false)
						letSleep = false

						if distance < Config.Marker.x then
							isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'AmbulanceActions', k
						end
					end
				end

				-- Pharmacies
				for k,v in ipairs(hospital.Pharmacies) do
					local distance = #(playerCoords - v)

					if distance < Config.DrawDistance then
						DrawMarker(20, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 50, 05, 204, Config.Marker.a, true, false, 2, Config.Marker.rotate, nil, nil, false)
						letSleep = false

						if distance < Config.Marker.x then
							isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'Pharmacy', k
						end
					end
				end

				-- Vehicle Spawners
				for k,v in ipairs(hospital.Vehicles) do
					local distance = #(playerCoords - v.Spawner)

					if distance < Config.DrawDistance then
						DrawMarker(v.Marker.type, v.Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil, nil, false)
						letSleep = false

						if distance < v.Marker.x then
							isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'Vehicles', k
						end
					end
				end

				-- Helicopter Spawners
				for k,v in ipairs(hospital.Helicopters) do
					local distance = #(playerCoords - v.Spawner)

					if distance < Config.DrawDistance then
						DrawMarker(v.Marker.type, v.Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil, nil, false)
						letSleep = false

						if distance < v.Marker.x then
							isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'Helicopters', k
						end
					end
				end

				-- Fast Travels (Prompt)
				for k,v in ipairs(hospital.FastTravelsPrompt) do
					local distance = #(playerCoords - v.From)

					if distance < Config.DrawDistance then
						DrawMarker(v.Marker.type, v.From, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil, nil, false)
						letSleep = false

						if distance < v.Marker.x then
							isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'FastTravelsPrompt', k
						end
					end
				end
			end

			-- Logic for exiting & entering markers
			if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastHospital ~= currentHospital or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
				if
					(LastHospital ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
					(LastHospital ~= currentHospital or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
				then
					TriggerEvent('esx_ambulancejob:hasExitedMarker', LastHospital, LastPart, LastPartNum)
					hasExited = true
				end

				HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum = true, currentHospital, currentPart, currentPartNum

				TriggerEvent('esx_ambulancejob:hasEnteredMarker', currentHospital, currentPart, currentPartNum)
			end

			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_ambulancejob:hasExitedMarker', LastHospital, LastPart, LastPartNum)
			end

			if letSleep then
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

-- Fast travels
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords, letSleep = GetEntityCoords(PlayerPedId()), true

		for hospitalNum,hospital in pairs(Config.Hospitals) do
			-- Fast Travels
			for k,v in ipairs(hospital.FastTravels) do
				local distance = #(playerCoords - v.From)

				if distance < Config.DrawDistance then
					DrawMarker(v.Marker.type, v.From, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil, nil, false)
					letSleep = false

					if distance < v.Marker.x then
						FastTravel(v.To.coords, v.To.heading)
					end
				end
			end
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

AddEventHandler('esx_ambulancejob:hasEnteredMarker', function(hospital, part, partNum)
	if part == 'AmbulanceActions' then
		CurrentAction = part
		CurrentActionMsg = _U('actions_prompt')
		CurrentActionData = {}
	elseif part == 'Pharmacy' then
		
		CurrentAction = part
		CurrentActionMsg = _U('open_pharmacy')
		CurrentActionData = {}
	elseif part == 'Vehicles' then
		CurrentAction = part
		CurrentActionMsg = _U('garage_prompt')
		CurrentActionData = {hospital = hospital, partNum = partNum}
	elseif part == 'Helicopters' then
		CurrentAction = part
		CurrentActionMsg = _U('helicopter_prompt')
		CurrentActionData = {hospital = hospital, partNum = partNum}
	elseif part == 'FastTravelsPrompt' then
		local travelItem = Config.Hospitals[hospital][part][partNum]

		CurrentAction = part
		CurrentActionMsg = travelItem.Prompt
		CurrentActionData = {to = travelItem.To.coords, heading = travelItem.To.heading}
	end
end)

AddEventHandler('esx_ambulancejob:hasExitedMarker', function(hospital, part, partNum)
	if not isInShopMenu then
		ESX.UI.Menu.CloseAll()
	end

	CurrentAction = nil
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'AmbulanceActions' then
					OpenAmbulanceActionsMenu()
				elseif CurrentAction == 'Pharmacy' then
					if(ESX.PlayerData.job.grade_name ~= "probationary_fire_fighter") then
						OpenPharmacyMenu()
					else
						ESX.ShowNotification("Probationary Fire Fighter 계급은 의약품 구매가 불가능합니다.")
					end
				elseif CurrentAction == 'Vehicles' then
					OpenVehicleSpawnerMenu('car', CurrentActionData.hospital, CurrentAction, CurrentActionData.partNum)
				elseif CurrentAction == 'Helicopters' then
					OpenVehicleSpawnerMenu('helicopter', CurrentActionData.hospital, CurrentAction, CurrentActionData.partNum)
				elseif CurrentAction == 'FastTravelsPrompt' then
					FastTravel(CurrentActionData.to, CurrentActionData.heading)
				end

				CurrentAction = nil
			end

		elseif ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' and not isDead then
			if IsControlJustReleased(0, 167) then
				OpenMobileAmbulanceActionsMenu()
			end
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('esx_ambulancejob:putInVehicle')
AddEventHandler('esx_ambulancejob:putInVehicle', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords, 5.0) then
		local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)

		if DoesEntityExist(vehicle) then
			local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

			for i=maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end

			if freeSeat then
				TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
			end
		end
	end
end)

function OpenCloakroomMenu()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {
		title    = _U('cloakroom'),
		align    = 'right',
		elements = {
			{label = _U('ems_clothes_civil'), value = 'citizen_wear'},
			{label = _U('ems_clothes_ems'), value = 'ambulance_wear'},
			{label = "구급차량 열쇠 관리", value = "keys"},
			{label = "무기고", value = "armory"},
			{label = "진압복 착용", value = "fire_wear"}
	}}, function(data, menu)
		if data.current.value == 'fire_wear' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				-- print(json.encode(jobSkin.skin_male))
				
				if skin.sex == 0 then
					SetPedPropIndex(GetPlayerPed(-1), 0, 137, 0, 2)
					SetPedComponentVariation	(GetPlayerPed(-1), 4,		120,			0, 2)
					SetPedComponentVariation	(GetPlayerPed(-1), 11,		315,			0, 2)
					SetPedComponentVariation	(GetPlayerPed(-1), 6,		12,			0, 2)
					SetPedComponentVariation	(GetPlayerPed(-1), 3,		16,			0, 2)

				else
					SetPedPropIndex(GetPlayerPed(-1), 0, 137, 0, 2)
					SetPedComponentVariation	(GetPlayerPed(-1), 4,		126,			0, 2)
					SetPedComponentVariation	(GetPlayerPed(-1), 11,		326,			0, 2)
					SetPedComponentVariation	(GetPlayerPed(-1), 6,		21,			0, 2)
					SetPedComponentVariation	(GetPlayerPed(-1), 3,		17,			0, 2)

				end

				isOnDuty = true
				TriggerEvent('esx_ambulancejob:setDeadPlayers', deadPlayers)
			end)
		end


		if data.current.value == 'citizen_wear' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				TriggerEvent('skinchanger:loadSkin', skin)
				isOnDuty = false

				for playerId,v in pairs(deadPlayerBlips) do
					RemoveBlip(v)
					deadPlayerBlips[playerId] = nil
				end
			end)
		elseif data.current.value == 'ambulance_wear' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				-- print(json.encode(jobSkin.skin_male))
				
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
					SetPedPropIndex(GetPlayerPed(-1), 1, 0, 0, 2)
					SetPedComponentVariation	(GetPlayerPed(-1), 6,		8,			0, 2)
				else
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
					SetPedPropIndex(GetPlayerPed(-1), 1, 5, 0, 2)
					SetPedComponentVariation	(GetPlayerPed(-1), 6,		52,			0, 2)
				end

				isOnDuty = true
				TriggerEvent('esx_ambulancejob:setDeadPlayers', deadPlayers)
			end)
		elseif data.current.value == "armory" then

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory', {
				title    = '무기고',
				align    = 'right',
				elements = {{label = '소화기 가격: 300$', value = 'fire_extinguisher'}}
				}, function(data4, menu4)
					menu.close()
					if data4.current.value == 'fire_extinguisher' then
						TriggerServerEvent("esx_ambulancejob:giveweapon", "WEAPON_FIREEXTINGUISHER", 300)
					end

				end, function(data4, menu4)
					menu4.close()
				end)

		elseif data.current.value == "keys" then
			ESX.TriggerServerCallback('esx_ambulancejob:getKeys', function(keys)
				elements = {}
				for k,key in ipairs(keys) do
					-- print(key.state)
						if(key.state == 1) then
							table.insert(elements, {
								label     = '(사용중)['.. GetDisplayNameFromVehicleModel(tonumber(key.model)) ..']'.. key.plate,
								plate     = key.plate,
								state     = key.state
							})
						else
							table.insert(elements, {
								label     = '['.. GetDisplayNameFromVehicleModel(tonumber(key.model)) ..']'.. key.plate,
								plate     = key.plate,
								state     = key.state
							})
						end
					-- print(json.encode(elements))
				end
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'CarKeys', {
					title    = '차키',
					align    = 'right',
					elements = elements
				}, function(data2, menu2)
					menu.close()
					

							ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'CarKeyOptions', {
							title    = '차키',
							align    = 'right',
							elements = {{label = '차키대여', value = 'getKey'}, {label = '차키반납', value = 'givekey'}}
							}, function(data3, menu3)
								menu2.close()
									if data3.current.value == 'getKey' then
										ESX.TriggerServerCallback('esx_ambulancejob:returnStateOfKey',function(available)
											-- print(available)
											if(available == true) then
												
												TriggerServerEvent('esx_ambulancejob:rentKey', data2.current.plate)
												ESX.ShowNotification('차 열쇠 '..data2.current.plate .. ' 를 대여했습니다.')
												menu3.close()
											else
												ESX.ShowNotification('해당 차키는 다른 사람이 대여중입니다.')
												menu3.close()
											end
										end,data2.current.plate)
									end
									
									if data3.current.value == 'givekey' then
										ESX.TriggerServerCallback('esx_ambulancejob:returnStateOfKey',function(available)
											if(available == false) then
												TriggerServerEvent('esx_ambulancejob:giveKey', data2.current.plate)
												ESX.ShowNotification('차 열쇠 '..data2.current.plate .. ' 를 반납했습니다.')
												menu3.close()
											else
												ESX.ShowNotification('해당 차키를 빌린적이 없습니다.')
												menu3.close()
											end
										end,data2.current.plate)
									end

							end, function(data3, menu3)
								menu3.close()
							end)
				end, function(data2, menu2)
					menu2.close()
				end)
			end)
		end


		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

function OpenPharmacyMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pharmacy', {
		title    = _U('pharmacy_menu_title'),
		align    = 'right',
		elements = {
			{label = _U('medikit'), item = 'medikit', value = 1, min = 1, max = 100, price = 500},
			{label = _U('bandage'), item = 'bandage', value = 1, min = 1, max = 100, price = 250}
	}}, function(data, menu)
		TriggerServerEvent('esx_ambulancejob:giveItem', data.current.item, data.current.value, data.current.price)
		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(healType, quiet)
	local playerPed = PlayerPedId()
	local maxHealth = GetEntityMaxHealth(playerPed)
	local currentHealth = GetEntityHealth(playerPed)

	if healType == 'small' then
		local health = GetEntityHealth(playerPed)
		local newHealth = currentHealth + 25
		SetEntityHealth(playerPed, newHealth)
	elseif healType == 'big' then
		SetEntityHealth(playerPed, currentHealth + 50)
	end

	-- if not quiet then
	-- 	ESX.ShowNotification(_U('healed'))
	-- end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	if isOnDuty and job ~= 'ambulance' then
		for playerId,v in pairs(deadPlayerBlips) do
			RemoveBlip(v)
			deadPlayerBlips[playerId] = nil
		end

		isOnDuty = false
	end
end)

RegisterNetEvent('esx_ambulancejob:setDeadPlayers')
AddEventHandler('esx_ambulancejob:setDeadPlayers', function(_deadPlayers)
	deadPlayers = _deadPlayers

	if isOnDuty then
		for playerId,v in pairs(deadPlayerBlips) do
			RemoveBlip(v)
			deadPlayerBlips[playerId] = nil
		end

		for playerId,status in pairs(deadPlayers) do
			if status == 'distress' then
				local player = GetPlayerFromServerId(playerId)
				local playerPed = GetPlayerPed(player)
				local blip = AddBlipForEntity(playerPed)

				SetBlipSprite(blip, 303)
				SetBlipColour(blip, 1)
				SetBlipFlashes(blip, true)
				SetBlipCategory(blip, 7)

				BeginTextCommandSetBlipName('STRING')
				AddTextComponentSubstringPlayerName(_U('blip_dead'))
				EndTextCommandSetBlipName(blip)

				deadPlayerBlips[playerId] = blip
			end
		end
	end
end)
