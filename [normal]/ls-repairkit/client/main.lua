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
local CurrentAction		= nil
local isReparing 		= false
local IsMecanoOnline	= false
local PlayerData		= {}
local successRand = 0
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

-- 1. 점검, 브랜드 별 부품 갯수, 난이도, 성공확률,체력 0 ~ 1000  
--0 ~ 300 -> 엔진 교체 , 301 ~ 600 -> 엔진 수리 중 , 601 ~ 1000 -> 엔진 수리 쉬움
-- 엔진 수리 실패 시 -> 엔진 교체 단계로 넘어감 엔진 교체는 정비소에서만 가능 

-- 0 ~ 1000 외관
-- 0~ 500 외관 교체 ,500 ~ 1000 -> 외관 수리 , 
-- 외관 수리 실패시 -> 변경 사항 없음 

RegisterCommand('차량파괴',function ()
  TriggerEvent('esx_reapairkit:Voom')
end)

RegisterNetEvent('esx_reapairkit:Voom')
AddEventHandler('esx_reapairkit:Voom', function ()

    print("carvoom 41")
  local playerPed		= GetPlayerPed(-1)
	local coords		= GetEntityCoords(playerPed)
  local targetveh = '';

  if IsPedInAnyVehicle(playerPed, false) then
    targetveh = GetVehiclePedIsIn(playerPed, false)
  else
    targetveh = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
  end

    local VehModel = GetEntityModel(targetveh)
    local MinVec, MaxVec = GetModelDimensions(VehModel)
    local Size = MaxVec - MinVec

    if math.random(1,2) <= 30 then
      print("carvoom 42")
      SetVehicleDamage(targetveh, Size.x * 0.9, Size.y, 0.0, 7000.0, 1.2, true)
      Wait(20)
      SetVehicleDamage(targetveh, Size.x * 0.9, Size.y, -0.2, 7000.0, 1.2, true)
      Wait(20)
      SetVehicleDamage(targetveh, Size.x * 0.9, Size.y, -0.1, 7000.0, 1.2, true)
      Wait(20)
      SetVehicleDamage(targetveh, Size.x * 0.8, Size.y, 0.0, 7000.0, 1.2, true)
      Wait(20)
      SetVehicleDamage(targetveh, Size.x * 0.8, Size.y, -0.2, 7000.0, 1.2, true)
      Wait(20)
      SetVehicleDamage(targetveh, Size.x * 0.8, Size.y, -0.1, 7000.0, 1.2, true)
      Wait(20)
      SetVehicleDamage(targetveh, Size.x * 0.7, Size.y, 0.0, 7000.0, 1.2, true)
      Wait(20)
      SetVehicleDamage(targetveh, Size.x * 0.7, Size.y, -0.2, 7000.0, 1.2, true)
      Wait(20)
      SetVehicleDamage(targetveh, Size.x * 0.7, Size.y, -0.1, 7000.0, 1.2, true)
      Wait(20)
    end
end)

RegisterCommand('차량점검', function()
  TriggerEvent('esx_reapairkit:VehicleCheck')

end)

RegisterNetEvent('esx_reapairkit:VehicleCheck')
AddEventHandler('esx_reapairkit:VehicleCheck', function ()
  
  local playerPed		= GetPlayerPed(-1)
	local coords		= GetEntityCoords(playerPed)
	local coordsE = GetWorldPositionOfEntityBone(vehicle, engine)
  

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) and GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coordsE, true) >= 1.0 then
		
    local vehicle = nil
      if IsPedInAnyVehicle(playerPed, false) then
        vehicle = GetVehiclePedIsIn(playerPed, false)
      else
        vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
      end
    
      local plate = string.sub(GetVehicleNumberPlateText(vehicle),1,7)
      -- 엔진을 점검 중입니다.
    Citizen.CreateThread(function()
    ThreadID = GetIdOfThisThread()
    CurrentAction = 'checking'
    FreezeEntityPosition(playerPed,true)
    SetTextComponentFormat('STRING')
    AddTextComponentString(_U('abort_hint'))
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
    exports.rprogress:Custom({
      Duration = Config.CheckTime * 1000,
      Label = "차량 엔진을 점검중입니다...",
      DisableControls = {
          Mouse = false,
          Player = true,
          Vehicle = true
      }
  })
     Citizen.Wait(Config.CheckTime * 1000)

    
    local engineHealth = GetVehicleEngineHealth(vehicle)
    -- local engineHealth = 0
    -- ESX.TriggerServerCallback('esx_repairkit:checkEnginHealth',function (result)
    --   engineHealth = result
    -- end,plate)

    if engineHealth < 301 then
    exports['okokNotify']:Alert("시스템", "차량 엔진 교체 필요.", 3000, 'info')
    elseif engineHealth < 601 then
      exports['okokNotify']:Alert("시스템", "차량 엔진 정밀 수리 필요.", 3000, 'info')
    elseif engineHealth < 999 then
      exports['okokNotify']:Alert("시스템", "차량 엔진 간단 수리 필요.", 3000, 'info')
    else
      exports['okokNotify']:Alert("시스템", "차량 엔진 수리 필요 없음.", 3000, 'info')
    end
    Citizen.Wait(Config.CheckTime * 500)
    -- 외관을 점검 중입니다.
    exports.rprogress:Custom({
      Duration = Config.CheckTime * 1000,
      Label = "차량 외관을 점검중입니다...",
      DisableControls = {
          Mouse = false,
          Player = true,
          Vehicle = true
      }
  })
    Citizen.Wait(Config.CheckTime * 1000)
    local bodyHealth = GetVehicleBodyHealth(vehicle)
    if bodyHealth < 301 then
    exports['okokNotify']:Alert("시스템", "차량 외관 교체 필요.", 3000, 'info')
    elseif bodyHealth < 601 then
      exports['okokNotify']:Alert("시스템", "차량 외관 정밀 수리 필요.", 3000, 'info')
    elseif bodyHealth < 999 then
      exports['okokNotify']:Alert("시스템", "차량 외관 간단 수리 필요.", 3000, 'info')
    else
      exports['okokNotify']:Alert("시스템", "차량 외관 수리 필요 없음.", 3000, 'info')
    end
    
    FreezeEntityPosition(playerPed,false)
    CurrentAction = nil
    TerminateThisThread()
    
    end)
		elseif not IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
			exports['okokNotify']:Alert("시스템", "점검할 차량이 근처에 없습니다.", 3000, 'error')
		elseif GetVehicleEngineHealth(vehicle) == 0 then
			exports['okokNotify']:Alert("시스템", "차량이 폭발하여 점검 할 수 없습니다.", 3000, 'error')
	end

	
  

end)
RegisterNetEvent('esx_repairkit:RepairBody')
AddEventHandler('esx_repairkit:RepairBody', function ()
  local playerPed		= GetPlayerPed(-1)
	local coords		= GetEntityCoords(playerPed)
	local coordsE = GetWorldPositionOfEntityBone(vehicle, engine)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) and GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coordsE, true) >= 1.0 then
		
    local vehicle = nil
    if IsPedInAnyVehicle(playerPed, false) then
      vehicle = GetVehiclePedIsIn(playerPed, false)
    else
      vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    end
      
      Citizen.CreateThread(function()
        ThreadID = GetIdOfThisThread()
        CurrentAction = 'repairbody'
        FreezeEntityPosition(playerPed,false)
        SetTextComponentFormat('STRING')
        AddTextComponentString(_U('abort_hint'))
        DisplayHelpTextFromStringLabel(0, 0, 1, -1)

        local bodyHealth = GetVehicleBodyHealth(vehicle)
        local neadParts = 0;

    ESX.TriggerServerCallback('esx_repairkit:checkLevel',function (result)
      local level = result
      print(level)
      if bodyHealth < 301 then
        exports['okokNotify']:Alert("시스템", "차량 외관파손이 심하여, 정비소에서 수리해야합니다.", 3000, 'info')
      elseif bodyHealth < 601 then
        if level == 0 then
          neadParts = 30
        else
          neadParts = 25 / level
        end
      elseif bodyHealth < 999 then
      neadParts = 5;
      else
        exports['okokNotify']:Alert("시스템", "차량을 수리할 필요가 없습니다.", 3000, 'info') 
      end

      if neadParts > 0 then
        ESX.TriggerServerCallback('esx_repairkit:checkParts',function (result)
          if result == 1 then
            exports.rprogress:Custom({
              Duration = Config.RepairTime * 1000,
              Label = "차량 외관을 수리중 입니다...",
              DisableControls = {
                  Mouse = false,
                  Player = true,
                  Vehicle = true
              }
          })
            Citizen.Wait(Config.RepairTime * 1000)
            
            randRepiar(level)
              if successRand == 1 then
                TriggerServerEvent('esx_repairkit:SetBodyHealthSync',vehicle)
                exports['okokNotify']:Alert("시스템", "차량 수리 완료.", 3000, 'info')
              else
                exports['okokNotify']:Alert("시스템", "수리 실패", 3000, 'info')
              end


          TriggerServerEvent('esx_repairkit:removeKit',neadParts,2)
          TriggerServerEvent('esx_repairkit:expup')
        else 
            exports['okokNotify']:Alert("시스템", "부품이 부족합니다.", 3000, 'error') 
          end
          FreezeEntityPosition(playerPed,false)
        end,neadParts,2)

      else
        CurrentAction = nil
        TerminateThisThread()
      end
    end)
      
  
  end)

  elseif not IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
    exports['okokNotify']:Alert("시스템", "수리할 차량이 근처에 없습니다.", 3000, 'error')
  elseif GetVehicleEngineHealth(vehicle) == 0 then
    exports['okokNotify']:Alert("시스템", "차량이 폭발하여 고칠 수 없습니다.", 3000, 'error')
	end

  
  
end)

RegisterNetEvent('esx_repairkit:RepairEngine')
AddEventHandler('esx_repairkit:RepairEngine', function()
	local playerPed		= GetPlayerPed(-1)
	local coords		= GetEntityCoords(playerPed)
	local coordsE = GetWorldPositionOfEntityBone(vehicle, engine)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) and GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coordsE, true) >= 1.0 then
    
    local vehicle = nil

    if IsPedInAnyVehicle(playerPed, false) then
      vehicle = GetVehiclePedIsIn(playerPed, false)
    else
      vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    end

  Citizen.CreateThread(function()
    ThreadID = GetIdOfThisThread()
    CurrentAction = 'repairbody'
    FreezeEntityPosition(playerPed,true)
    local plate = string.sub(GetVehicleNumberPlateText(vehicle),1,7)

    SetTextComponentFormat('STRING')
    AddTextComponentString(_U('abort_hint'))
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
    
    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coordsE, true) <= 3.0 then  
      SetVehicleDoorOpen(vehicle, 4,0,0)
      TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true) 
    end

    local neadParts = 0
    -- local engineHealth = 0
--콜백이라 이후에 실행될 가능성 있음 그럴 경우 감싸줘야함
    -- ESX.TriggerServerCallback('esx_repairkit:checkEnginHealth',function (result)
    --   engineHealth = result
    -- end,plate)
    local engineHealth = GetVehicleEngineHealth(vehicle)
     
      ESX.TriggerServerCallback('esx_repairkit:checkLevel',function (result)
        local level = result
        if engineHealth < 301 then
          exports['okokNotify']:Alert("시스템", "차량 엔진파손이 심하여 교체하기 위해, 정비소로 가야합니다.", 3000, 'info')
        elseif engineHealth < 601 then
          if level == 0 then
            neadParts = 30
          else
            neadParts = 25 / level
          end
        elseif engineHealth < 999 then
         neadParts = 5;
        else
          exports['okokNotify']:Alert("시스템", "차량을 수리할 필요가 없습니다.", 3000, 'info') 
        end
  
        if neadParts > 0 then
          ESX.TriggerServerCallback('esx_repairkit:checkParts',function (result)
            if result == 1 then
              exports.rprogress:Custom({
                Duration = Config.RepairTime * 1000,
                Label = "차량 엔진을 수리중 입니다...",
                DisableControls = {
                    Mouse = false,
                    Player = true,
                    Vehicle = true
                }
            })


              Citizen.Wait(Config.RepairTime * 1000)

              randRepiar(level)
              if successRand == 1 then
                SetVehicleDoorShut(vehicle, 4,0,0)
                exports['okokNotify']:Alert("시스템", "차량 수리 완료.", 3000, 'info')
                TriggerServerEvent('esx_repairkit:SetEngineHealthSync',vehicle)
                
              else
                exports['okokNotify']:Alert("시스템", "수리 실패", 3000, 'info')
                exports['okokNotify']:Alert("시스템", "차량 엔진이 파손 됩니다.", 3000, 'info')
                TriggerServerEvent('esx_repairkit:SetEngineHealthSync',vehicle)
              end
              TriggerServerEvent('esx_repairkit:removeKit',neadParts,2)
              TriggerServerEvent('esx_repairkit:expup')
              -- SetVehicleEngineHealth(vehicle, 1000.0) 
              -- SetVehiclePetrolTankHealth(vehicle, 1000.0)
              -- --넷이벤트 업데이트
              -- SetVehicleDeformationFixed(vehicle)
              -- TriggerServerEvent('esx_repairkit:removeKit',neadParts,1)
            else
              exports['okokNotify']:Alert("시스템", "부품이 부족합니다.", 3000, 'error') 
            end
            FreezeEntityPosition(playerPed,false)
          end,neadParts,1)
        else 
          CurrentAction = nil
          TerminateThisThread()
        end

      end)
      
    end)
    
		elseif not IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
      exports['okokNotify']:Alert("시스템", "수리할 차량이 근처에 없습니다.", 3000, 'error')
		elseif GetVehicleEngineHealth(vehicle) == 0 then
      exports['okokNotify']:Alert("시스템", "차량이 폭발하여 고칠 수 없습니다.", 3000, 'error')
	end

 
  -- 차량에 가까이 다가간 후, 본닛을 열고 애님
  

  end)

  RegisterNetEvent('esx_repairkit:EngineSetSync')
AddEventHandler('esx_repairkit:EngineSetSync', function(veh)
  if successRand then
    SetVehicleEngineHealth(veh,1000.0)
    SetVehiclePetrolTankHealth(veh, 1000.0)
  else
    SetVehicleEngineHealth(veh,300.0)
    SetVehiclePetrolTankHealth(veh, 300.0)
  end

end)

RegisterNetEvent('esx_repairkit:BodySetSync')
AddEventHandler('esx_repairkit:BodySetSync', function (veh)

  local engineHealth = GetVehicleEngineHealth(veh)
  local petrolHealth = GetVehiclePetrolTankHealth(veh)
  print("bodysetsync")
  SetVehicleFixed(veh)
  SetVehicleEngineHealth(veh, engineHealth)
  SetVehiclePetrolTankHealth(veh, petrolHealth)

end)

function randRepiar (level)
  local initrand = 70
  local plusrand = level * 5 
  initrand = initrand + plusrand

  local rnd = math.random(0,100)

  if rnd <= initrand then
successRand = 1
  else
successRand = 0
  end
end