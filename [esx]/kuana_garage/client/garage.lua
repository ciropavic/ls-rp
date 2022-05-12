local isOut = {}
local _color1={}
local _color2={}
RegisterCommand('차량목록', function(source, args, rawCommand)
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local veh = ESX.Game.GetVehiclesInArea(pos, 20000.0)
        local elements = {}
        local debugVehicle  = GetVehiclePedIsIn(ped, false)
        -- print('debugVehicle : ', debugVehicle)
        -- print(type(debugVehicle))
        local vehiclePropsnDebug  = ESX.Game.GetVehicleProperties(debugVehicle)
        -- print('debugVehicle plate : ', vehiclePropsnDebug.plate)
        ESX.TriggerServerCallback('kuana:getVehicles', function(vehicles)
            for _,v in pairs(vehicles) do
                local hashVehicule = v.vehicle.model
                local vehicleName = GetDisplayNameFromVehicleModel(hashVehicule)
                local labelvehicle
                local plate = v.plate
                labelvehicle = vehicleName.. ' (' .. plate .. ') '	
                -- table.insert(elements, {label =labelvehicle , value = v})
                if v.state == true then		
                    table.insert(elements, {label =labelvehicle , value = v})
                end
            end
            ESX.UI.Menu.Open(
                'default', GetCurrentResourceName(), 'spawn_vehiclereload',
                {
                    title    = _U('garage'),
                    align    = 'right',
                    elements = elements,
                },
                function(data, menu)
                        local vehiclePropsn = {}
                        for i=1, #veh, 1 do
                            if veh then
                                -- print('veh[',i,'] : ',type(veh[i]))
                                vehiclePropsn  = ESX.Game.GetVehicleProperties(veh[i])
                                -- print(vehiclePropsn)
                                -- print('vehiclePropsn : ',vehiclePropsn.plate)
                            end
                            -- print('-----------------')
                            -- tdump(vehiclePropsn)
                            -- print('-----------------')
                            -- print('data.current.value.plate : ', data.current.value.plate)
                            -- print('vehiclePropsn plate : ', vehiclePropsn.plate)
                            if vehiclePropsn ~= nil and data.current.value.plate ~= nil then
                                print('podespawn1 : ', podespawn)
                                if vehiclePropsn.plate == data.current.value.plate then
                                    print('podespawn2 : ', podespawn)
                                    podespawn = false
                                    break
                                else
                                    print('podespawn3 : ', podespawn)
                                    podespawn = true
                                end
                            else
                                -- tdump(isOut)
                                local temp = data.current.value.plate
                                -- print('temp : ', temp)
                                if isOut[1] ~= nil then
                                    for i=1, #isOut, 1 do
                                        -- print('isOut ---> ',isOut[i].value)
                                        -- print('isOut ---> ',isOut[i].key)
                                        -- print('isOut ---> ',isOut[i].label)
                                        if isOut[i] == nil then
                                            podespawn = true
                                            break
                                        elseif temp == isOut[i].label and isOut[i].value ~= 'spawned' then
                                            podespawn = true
                                            break
                                        elseif temp == isOut[i].label and isOut[i].value == 'spawned' then
                                            podespawn = false
                                            break
                                        else
                                            podespawn = true
                                        end
                                    end
                                else
                                    podespawn = true
                                end
                            end
                        end
                        -- print('podespawn5 : ', podespawn)
                        if podespawn == true then
                            ESX.TriggerServerCallback('kuana:checkcoordsall', function(xx, yy, zz, hh,engineHealth,bodyHealth,color1,color2)
                                local cods = {x = xx + 0, y = yy + 0, z= zz + 1}
                                local hh    = hh + 0.0000000001
                                local x = xx + 0
                                local y = yy + 0
                                local z = zz + 1
                                local callback_engineHealth = engineHealth * 1
                                local callback_bodyHealth = bodyHealth * 1
    
                                _color1 = json.decode(color1);
                                _color2 = json.decode(color2);
    
                                -- for key, val in pairs(color2) do
                                -- _color2[1] = var.r
                                -- _color2[2] = var.g
                                -- _color2[3] = var.b
                                -- end
                            
                            
                                local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), x, y, z, 1)
                                if distanceToVeh <= 20000 then
                                    table.insert(isOut, { label = data.current.value.plate, value = 'spawned'})
                                    ESX.Game.SpawnVehicle(data.current.value.vehicle.model, cods,hh, function(callback_vehicle)
                                         SetVehicleProperties(callback_vehicle, data.current.value.vehicle)
                                         SetVehicleCustomPrimaryColour(
                                            callback_vehicle --[[ Vehicle ]], 
                                            _color2.r --[[ integer ]], 
                                            _color2.g --[[ integer ]], 
                                            _color2.b --[[ integer ]]
                                        )
                                        SetVehicleCustomSecondaryColour(
                                            callback_vehicle --[[ Vehicle ]], 
                                            _color1.r --[[ integer ]], 
                                            _color1.g --[[ integer ]], 
                                            _color1.b --[[ integer ]]
                                        )
    
                                        --  SetVehicleColours(callback_vehicle, data.current.value.vehicle.color1, data.current.value.vehicle.color2)
                                        
    
                                        SetVehicleDoorsLocked(callback_vehicle, 0)
                                        SetVehicleEngineOn(callback_vehicle, false, false, true)
    
                                        -- ESX.TriggerServerCallback('kuana:checklock', function(islock)
                                        -- 	if islock == true then
                                        -- 		SetVehicleDoorsLocked(callback_vehicle, 2)
                                        -- 	elseif islock == false then
                                        -- 		SetVehicleDoorsLocked(callback_vehicle, 1)
                                        -- 	end
                                        -- end, data.current.value.plate)
                                        SetVehRadioStation(callback_vehicle, "OFF")
                                        -- 여기서부터 체력 설정다시
                                        print(callback_engineHealth)
                                        SetVehicleEngineHealth(callback_vehicle,callback_engineHealth)
                                        SetVehiclePetrolTankHealth(callback_vehicle, callback_engineHealth)
                                        SetVehicleBodyHealth(callback_vehicle, callback_bodyHealth)
                                        -- SetVehicleDamage(callback_vehicle, 0.0, 0.0, 0.0, 900.0, 100.0, true)
    
                                        -- SetVehiclePetrolTankHealth(vehicle, callback_engineHealth)
                                        -- SetVehicleBodyHealth(callback_engineHealth,callback_engineHealth)
                                        
                                    end)
                                    TriggerServerEvent('kuana:modifystate', data.current.value.plate, true)
                                    ESX.ShowNotification("당신의 차량이 스폰되었습니다.")
                                    print("A HERE!")
    
                                else
                                    ESX.ShowNotification("차량이 떨어져있습니다.")
                                end
                            end, data.current.value.plate)
                            menu.close()
                        else
                            ESX.ShowNotification("당신의 차는 이미 스폰되었습니다.")
                        end
                end,
                function(data, menu)
                    menu.close()
                    --CurrentAction = 'open_garage_action'
                end
            )
        end)
    end)

    RegisterCommand('차량보관', function(source, args, rawCommand)
        ped = GetPlayerPed(-1)
        local car = nil
        car = GetVehiclePedIsUsing(ped)
    
        if IsPedInAnyVehicle(ped) then
                local vehicle = GetVehiclePedIsUsing(ped)
                local model = GetEntityModel(vehicle)
                local plate = string.sub(GetVehicleNumberPlateText(vehicle),1,7)
            ESX.TriggerServerCallback('kuana:checkOwnerOfCar', function(result) 
                if result == 1 then
                local x,y,z = table.unpack(GetEntityCoords(vehicle))
                local headings = GetEntityHeading(vehicle)
                local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)
                print(vehicle.."CarFac")
                local engineHealths  = GetVehicleEngineHealth(vehicle)
                TriggerServerEvent('garagem:apre', vehicleProps.plate, x, y, z, headings, engineHealths)
                exports['okokNotify']:Alert("시스템", "성공적으로 차량을 보관하였습니다.", 5000, 'error')
                ESX.Game.DeleteVehicle(car)
                else
                exports['okokNotify']:Alert("시스템", "해당차량의 소유주가 아닙니다.", 5000, 'error')
                end
            end, plate)

            
        else
            ESX.ShowNotification("You need to be inside of a vehicle to seize it.")
        end
    end)
    

    SetVehicleProperties = function(vehicle, vehicleProps)
        ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
    
        if vehicleProps["windows"] then
            for windowId = 1, 13, 1 do
                if vehicleProps["windows"][windowId] == false then
                    SmashVehicleWindow(vehicle, windowId)
                end
            end
        end
    
        if vehicleProps["tyres"] then
            for tyreId = 1, 7, 1 do
                if vehicleProps["tyres"][tyreId] ~= false then
                    SetVehicleTyreBurst(vehicle, tyreId, true, 1000)
                end
            end
        end
    
        if vehicleProps["doors"] then
            for doorId = 0, 5, 1 do
                if vehicleProps["doors"][doorId] ~= false then
                    SetVehicleDoorBroken(vehicle, doorId - 1, true)
                end
            end
        end
    end