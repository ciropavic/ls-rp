
ESX          = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local vehicle = ''
local vplate = ''
local vehicleModel = ''


RegisterCommand("차량판매",function()
  if vplate then
      ESX.TriggerServerCallback('ls-carsell:checkCar', function(exists)
          print(exists)
          if exists == 1 then
              ESX.TriggerServerCallback('ls-carsell:sell', function(sellResult)
                if sellResult == 1 then
                    ESX.Game.DeleteVehicle(vehicle)
                else
                  exports['okokNotify']:Alert("시스템", "해당 차량은 판매 할 수 없습니다.", 5000, 'error')
                end
              end, vehicleModel,vplate)
          else
              exports['okokNotify']:Alert("시스템", "해당 차량의 주인이 아닙니다.", 5000, 'error')
          end
      end, vplate)
  else
    exports['okokNotify']:Alert("시스템", "판매할 차량에 탑승해주세요", 5000, 'error')
  end
-- TriggerServerEvent("ls-carsell:sell",vehicleModel)
-- print(vehicleModel)
end)

Citizen.CreateThread(function()
    while true do
      Wait(100)
      local ped = PlayerPedId()
      local pedcoords = GetEntityCoords(ped, false)
      vehicle = GetVehiclePedIsIn(ped,0)
      vplate = GetVehicleNumberPlateText(vehicle)
      -- vehicleModel = GetEntityModel(vehicle)
      vehicleModel= GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
      vehicleModel = vehicleModel:lower()
    end
	
	end)

-- RegisterCommand("오류해결", function ()
-- 	TriggerServerEvent("ls-fatigue:bk")
-- 	TriggerServerEvent('buketsys:cl')
-- 	-- SetPlayerRoutingBucket(source, 0)
	
-- 	print("Buket End")
-- end)