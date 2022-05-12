local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
  }
  ESX						= nil
  
  Citizen.CreateThread(function()
	  while ESX == nil do
		  TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		  Citizen.Wait(0)
	  end
  end)
  
  
  local propModel = nil
  local propSpawned = nil
  
  function GetClosestVehicleTire(vehicle)
	  local tireBones = {"wheel_lf", "wheel_rf", "wheel_lm1", "wheel_rm1", "wheel_lm2", "wheel_rm2", "wheel_lm3", "wheel_rm3", "wheel_lr", "wheel_rr"}
	  local tireIndex = {
		  ["wheel_lf"] = 0,
		  ["wheel_rf"] = 1,
		  ["wheel_lm1"] = 2,
		  ["wheel_rm1"] = 3,
		  ["wheel_lm2"] = 45,
		  ["wheel_rm2"] = 47,
		  ["wheel_lm3"] = 46,
		  ["wheel_rm3"] = 48,
		  ["wheel_lr"] = 4,
		  ["wheel_rr"] = 5,
	  }
	  local player = PlayerId()
	  local plyPed = GetPlayerPed(player)
	  local plyPos = GetEntityCoords(plyPed, false)
	  local minDistance = 1.0
	  local closestTire = nil
	  
	  for a = 1, #tireBones do
		  local bonePos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, tireBones[a]))
		  local distance = Vdist(plyPos.x, plyPos.y, plyPos.z, bonePos.x, bonePos.y, bonePos.z)
  
		  if closestTire == nil then
			  if distance <= minDistance then
				  closestTire = {bone = tireBones[a], boneDist = distance, bonePos = bonePos, tireIndex = tireIndex[tireBones[a]]}
			  end
		  else
			  if distance < closestTire.boneDist then
				  closestTire = {bone = tireBones[a], boneDist = distance, bonePos = bonePos, tireIndex = tireIndex[tireBones[a]]}
			  end
		  end
	  end
  
	  return closestTire
  end
  
  
	RegisterNetEvent('esx_repairkit:RepairTire')
	AddEventHandler('esx_repairkit:RepairTire', function()
	  local ad = "anim@heists@box_carry@"
	  loadAnimDict( ad )
	  TaskPlayAnim( PlayerPedId(), ad, "idle", 3.0, -8, -1, 63, 0, 0, 0, 0 )
  print("repairtyre 69")
	  local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
	  propModel = 'prop_wheel_tyre'
	  propSpawned = CreateObject(GetHashKey(propModel), x, y, z + 0.2, true, true, true)
	  AttachEntityToEntity(propSpawned, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), 0.10, 0.26, 0.32, 90.0, 110.0, 0.0, true, true, false, true, 1, true)
	  Citizen.Wait(10000)
	end)
  
  Citizen.CreateThread(function()
	-- local ad = "anim@heists@box_carry@"
	-- loadAnimDict( ad )
	  while true do
		  Citizen.Wait(1)
		  if propSpawned then
			  if not IsPedInAnyVehicle(GetPlayerPed(-1)) then

				-- TaskPlayAnim( PlayerPedId(), ad, "idle", 3.0, -8, -1, 63, 0, 0, 0, 0 )
				  local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
				  Draw3DText(x, y, z, "~r~[G] ~w~Iptal")
				  local vehicle = ESX.Game.GetClosestVehicle()
				  if vehicle ~= nil then
					  local tire = GetClosestVehicleTire(vehicle)
					  if tire ~= nil then
						  Draw3DText(tire.bonePos.x, tire.bonePos.y, tire.bonePos.z, "~g~[E] ~w~Tak")
  
						  if IsControlJustPressed(1, 38) then
							  ClearPedSecondaryTask(PlayerPedId())
							  TaskStartScenarioInPlace(PlayerPedId(), 'world_human_gardener_plant', 0, false)
							  FreezeEntityPosition(PlayerPedId(), true)
  
				exports.rprogress:Custom({
				  Duration = Config.TyreKitTime * 1000,
				  Label = "차량 타이어를 교체 중입니다...",
				  DisableControls = {
					  Mouse = false,
					  Player = true,
					  Vehicle = true
				  }
			  })
			  Citizen.Wait(Config.TyreKitTime * 1000)
  
				exports['okokNotify']:Alert("시스템", "차량 바퀴 수리 완료.", 3000, 'info')
				TriggerServerEvent('esx_repairkit:SetTyreSync', vehicle, tire.tireIndex)
							  -- SetVehicleTyreFixed(vehicle, tire.tireIndex, 0, 1)
							  TriggerServerEvent('esx_repairkit:removeTyreKit')
							  deleteProp()
						  end
					  end
				  end
				  
				  if IsControlJustPressed(1, 47) then
					  deleteProp()
				  end
			  end
		  end
	  end
  end)
  
  
  function deleteProp()
	  DetachEntity(propSpawned, 1, 1)
	  DeleteObject(propSpawned)
	  ClearPedSecondaryTask(PlayerPedId())
	  ClearPedTasks(PlayerPedId())
	  FreezeEntityPosition(PlayerPedId(), false)
	  propSpawned = nil
  end
  
  function loadAnimDict(dict)
	  while (not HasAnimDictLoaded(dict)) do
		  RequestAnimDict(dict)
		  Citizen.Wait(5)
	  end
  end
  
  
	RegisterNetEvent("TyreSync")
	AddEventHandler("TyreSync", function(veh, tyre)
	  SetVehicleTyreFixed(veh, tyre)
	  SetVehicleWheelHealth(veh, tyre, 100)
	end)
  
  
	function Draw3DText(x, y, z, text)
	  local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	  local px,py,pz=table.unpack(GetGameplayCamCoords())
	  local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
   
	  local scale = (1/dist)
	  local fov = (1/GetGameplayCamFov())*100
	  local scale = scale*fov
	 
	  if onScreen then
		  SetTextScale(0.0*scale, 0.75*scale)
		  SetTextFont(4)
		  SetTextProportional(1)
		  -- SetTextScale(0.0, 0.55)
		  SetTextColour(255, 255, 255, 255)
		  SetTextDropshadow(0, 0, 0, 0, 255)
		  SetTextEdge(2, 0, 0, 0, 150)
		  SetTextDropShadow()
		  SetTextOutline()
		  SetTextEntry("STRING")
		  SetTextCentre(1)
		  AddTextComponentString(text)
		  DrawText(_x,_y)
	  end
  end
  
  
  
  