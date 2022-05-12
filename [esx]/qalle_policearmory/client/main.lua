ESX = nil
local isArmoryOpened = false

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(5)

		TriggerEvent("esx:getSharedObject", function(library)
			ESX = library
		end)
    end

    if ESX.IsPlayerLoaded() then
		ESX.PlayerData = ESX.GetPlayerData()

		RefreshPed(true)
    end
end)


RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(response)
	ESX.PlayerData = response

	RefreshPed(true)
end)


RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(response)
	ESX.PlayerData["job"] = response
end)


-- 무기고 위치에 알림 뜨는 부분
function NearArmory()
    local pos = GetEntityCoords(GetPlayerPed(-1))

    for k, v in pairs(Config.ArmoryLocation) do
        local dist = GetDistanceBetweenCoords(v.x, v.y, v.z, pos.x, pos.y, pos.z, true)

        if dist <= v.ArmoryDistance then
            return true
        elseif dist <= v.ArmoryDistance + 5 then
        	return "update"
        end
    end
end

Citizen.CreateThread(function()
	local inRange = false
	local shown = false

	while true do
		local inRange = false
		Citizen.Wait(0)

		if not Config.OnlyPolicemen or (Config.OnlyPolicemen and ESX.PlayerData["job"] and ESX.PlayerData["job"]["name"] == "police") then

			if NearArmory() and not isArmoryOpened and NearArmory() ~= "update" then

				inRange = true
	
				if IsControlJustReleased(0, 38) then
					OpenPoliceArmory()
					isArmoryOpened = true
				end

			elseif NearArmory() == "update" then
				Citizen.Wait(300)
			else
				Citizen.Wait(1000)
			end
	
			if inRange and not shown then
				shown = true
				exports['okokTextUI']:Open('무기고를 이용하시려면 [E]를 누르세요.', 'darkblue', 'left')
			elseif not inRange and shown then
				shown = false
				exports['okokTextUI']:Close()
			end
			
		end
	end
end)


OpenPoliceArmory = function()

	PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)

	local elements = {
		{ ["label"] = "화기 보급 목록", ["action"] = "weapon_storage" },
		{ ["label"] = "탄약 보급 목록", ["action"] = "bullet_storage" },
		{ ["label"] = "무기 반납", ["action"] = "weapon_supp" },
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "police_armory_menu",
		{
			title    = "경찰 무기고",
			align    = "right",
			elements = elements
		},

	function(data, menu)

		local action = data.current["action"]

		if action == "weapon_storage" then
			OpenWeaponStorage()

		elseif action == "weapon_supp" then
			TriggerServerEvent("qalle_policearmory:removeweapon")
			exports['okokNotify']:Alert("시스템", "소유 장비를 모두 반납했습니다.", 5000, 'error')

		elseif action == "bullet_storage" then
			OpenBulletStorage()

		end

	end, function(data, menu)
		PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)
		menu.close()
		isArmoryOpened = false

	end, function(data, menu)
		PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)

	end)

end


OpenWeaponStorage = function()

	PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)

	local elements = {}

	local Location = Config.Armory
	local PedLocation = Config.ArmoryPed

	for i = 1, #Config.ArmoryWeapons, 1 do
		local weapon = Config.ArmoryWeapons[i]

		table.insert(elements, { ["label"] = ESX.GetWeaponLabel(weapon["hash"]) .. " 가격 : " .. weapon["price"] .. "$", ["weapon"] = weapon , ["price"] = weapon["price"]} )
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "police_armory_weapon_menu",
		{
			title    = "보급 무기 목록",
			align    = "right",
			elements = elements
		},

	function(data, menu)

		local anim = data.current["weapon"]["type"]
		local weaponHash = data.current["weapon"]["hash"]

		ESX.UI.Menu.CloseAll()
		isArmoryOpened = false

		local closestPed, closestPedDst = ESX.Game.GetClosestPed(PedLocation)

		if (DoesEntityExist(closestPed) and closestPedDst >= 5.0) or IsPedAPlayer(closestPed) then
			RefreshPed(true) -- failsafe if the ped somehow dissapear.
			exports['okokNotify']:Alert("시스템", "잠시후 다시 시도하세요.", 5000, 'error')
			return
		end

		if IsEntityPlayingAnim(closestPed, "mp_cop_armoury", "pistol_on_counter_cop", 3) or IsEntityPlayingAnim(closestPed, "mp_cop_armoury", "rifle_on_counter_cop", 3) then
			exports['okokNotify']:Alert("시스템", "잠시후 다시 시도하세요.", 5000, 'error')
			return
		end

		if not NetworkHasControlOfEntity(closestPed) then

			NetworkRequestControlOfEntity(closestPed)
			Citizen.Wait(1000)

		end

		SetEntityCoords(closestPed, PedLocation["x"], PedLocation["y"], PedLocation["z"] - 0.985)
		SetEntityHeading(closestPed, PedLocation["h"])

		SetEntityCoords(PlayerPedId(), Location["x"], Location["y"], Location["z"] - 0.985)
		SetEntityHeading(PlayerPedId(), Location["h"])
		SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), true)

		local animLib = "mp_cop_armoury"

		LoadModels({ animLib })

		if DoesEntityExist(closestPed) and closestPedDst <= 5.0 then
			ESX.TriggerServerCallback("qalle_policearmory:giveWeapon", function(accountavailable)

				if(accountavailable == true) then
					
					TaskPlayAnim(closestPed, animLib, anim .. "_on_counter_cop", 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)

					Citizen.Wait(1100)

					GiveWeaponToPed(closestPed, GetHashKey(weaponHash), 1, false, true)
					SetCurrentPedWeapon(closestPed, GetHashKey(weaponHash), true)

					TaskPlayAnim(PlayerPedId(), animLib, anim .. "_on_counter", 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)

					Citizen.Wait(3100)

					RemoveWeaponFromPed(closestPed, GetHashKey(weaponHash))

					Citizen.Wait(15)

					TriggerServerEvent("qalle_policearmory:getweapon", weaponHash, Config.ReceiveAmmo)

					ClearPedTasks(closestPed)

				else
					exports['okokNotify']:Alert("시스템", "장비를 보급할 수 있는 예산이 없습니다.", 5000, 'error')
				end

			end, weaponHash, data.current["weapon"]["price"])
		end

		UnloadModels()

	end, function(data, menu)
		PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)
		menu.close()

	end, function(data, menu)
		PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)

	end)

end


OpenBulletStorage = function()

	PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)

	local elements = {}

	local Location = Config.Armory
	local PedLocation = Config.ArmoryPed

	for i = 1, #Config.ArmoryBullets, 1 do
		local weapon = Config.ArmoryBullets[i]

		table.insert(elements, { ["label"] = ESX.GetWeaponLabel(weapon["hash"]), ["weapon"] = weapon })
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "police_armory_weapon_menu",
		{
			title    = "보급 탄약 목록",
			align    = "right",
			elements = elements
		},

	function(data, menu)

		local anim = data.current["weapon"]["type"]
		local weaponHash = data.current["weapon"]["hash"]

		ESX.UI.Menu.CloseAll()
		isArmoryOpened = false

		local closestPed, closestPedDst = ESX.Game.GetClosestPed(PedLocation)

		if (DoesEntityExist(closestPed) and closestPedDst >= 5.0) or IsPedAPlayer(closestPed) then
			RefreshPed(true) -- failsafe if the ped somehow dissapear.
			exports['okokNotify']:Alert("시스템", "잠시후 다시 시도하세요.", 5000, 'error')
			return
		end

		if IsEntityPlayingAnim(closestPed, "mp_cop_armoury", "pistol_on_counter_cop", 3) or IsEntityPlayingAnim(closestPed, "mp_cop_armoury", "rifle_on_counter_cop", 3) then
			exports['okokNotify']:Alert("시스템", "잠시후 다시 시도하세요.", 5000, 'error')
			return
		end

		if not NetworkHasControlOfEntity(closestPed) then
			NetworkRequestControlOfEntity(closestPed)
			Citizen.Wait(1000)
		end

		SetEntityCoords(closestPed, PedLocation["x"], PedLocation["y"], PedLocation["z"] - 0.985)
		SetEntityHeading(closestPed, PedLocation["h"])

		SetEntityCoords(PlayerPedId(), Location["x"], Location["y"], Location["z"] - 0.985)
		SetEntityHeading(PlayerPedId(), Location["h"])
		SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), true)

		local animLib = "mp_cop_armoury"

		LoadModels({ animLib })

		ESX.TriggerServerCallback("qalle_policearmory:giveAmmo", function(accountammoavailable)
			if accountammoavailable == true then
				if DoesEntityExist(closestPed) and closestPedDst <= 5.0 then
					TaskPlayAnim(closestPed, animLib, anim .. "_on_counter_cop", 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)

					Citizen.Wait(1100)

					TaskPlayAnim(PlayerPedId(), animLib, anim .. "_on_counter", 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)

					Citizen.Wait(3100)

					RemoveWeaponFromPed(closestPed, GetHashKey(weaponHash))

					Citizen.Wait(15)
					if(weaponHash == "WEAPON_GLOCK19") then
						TriggerServerEvent("qalle_policearmory:getammo", weaponHash, 12)
					elseif(weaponHash == "WEAPON_SPECIALCARBINE") then
						TriggerServerEvent("qalle_policearmory:getammo", weaponHash, 30)
					elseif(weaponHash == "WEAPON_PUMPSHOTGUN") then
						TriggerServerEvent("qalle_policearmory:getammo", weaponHash, 10)
					end

					ClearPedTasks(closestPed)
				end

				UnloadModels()

			else
				exports['okokNotify']:Alert("시스템", "장비를 보급할 수 있는 예산이 없습니다.", 5000, 'error')

			end
		end, weaponHash, data.current["weapon"]["price"])

	end, function(data, menu)
		PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)
		menu.close()

	end, function(data, menu)
		PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)

	end)
end


RefreshPed = function(spawn)
	local Location = Config.ArmoryPed

	ESX.TriggerServerCallback("qalle_policearmory:pedExists", function(Exists)
		if Exists and not spawn then
			return
		else
			LoadModels({ GetHashKey(Location["hash"]) })

			local pedId = CreatePed(5, Location["hash"], Location["x"], Location["y"], Location["z"] - 0.985, Location["h"], true)

			SetPedCombatAttributes(pedId, 46, true)                     
			SetPedFleeAttributes(pedId, 0, 0)                      
			SetBlockingOfNonTemporaryEvents(pedId, true)
			
			SetEntityAsMissionEntity(pedId, true, true)
			SetEntityInvincible(pedId, true)

			FreezeEntityPosition(pedId, true)
		end
	end)
end


local CachedModels = {}


LoadModels = function(models)
	for modelIndex = 1, #models do
		local model = models[modelIndex]

		table.insert(CachedModels, model)

		if IsModelValid(model) then
			while not HasModelLoaded(model) do
				RequestModel(model)
	
				Citizen.Wait(10)
			end
		else
			while not HasAnimDictLoaded(model) do
				RequestAnimDict(model)
	
				Citizen.Wait(10)
			end    
		end
	end
end


UnloadModels = function()
	for modelIndex = 1, #CachedModels do
		local model = CachedModels[modelIndex]

		if IsModelValid(model) then
			SetModelAsNoLongerNeeded(model)
		else
			RemoveAnimDict(model)   
		end

		table.remove(CachedModels, modelIndex)
	end
end