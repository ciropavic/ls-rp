-- ESX
ESX               = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

--For nb_menuperso
RegisterNetEvent('NB:OpenKeysMenu')
AddEventHandler('NB:OpenKeysMenu', function()
    OpenKeysMenu()
end)

-- Citizen.CreateThread(function()
--     while true do
--         if(IsControlJustPressed(0, 288))then
--             OpenKeysMenu()
--             print("carkeymenu")
            
--         end
--         Citizen.Wait(5)
--     end
-- end)
    
RegisterCommand('차키', function(source, args, rawCommand)
    OpenKeysMenu()
end)

function OpenKeysMenu()
    local playerId = PlayerId()
    ESX.TriggerServerCallback('skm_carkeys:getPlayersKeys', function(keys)
        local elements = {}

        for k,key in ipairs(keys) do
            local keymodel = tonumber(key.model)
            
            if(key.copied == 0) then
                table.insert(elements, {
                    label     = '['..GetDisplayNameFromVehicleModel(keymodel)..']' .. key.plate,
                    plate     = key.plate,
                    job = key.job
                })
            else
                table.insert(elements, {
                    label     = '(복사된키)['..GetDisplayNameFromVehicleModel(keymodel)..']' .. key.plate,
                    plate     = key.plate,
                    job = key.job
                })
            end

        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'CarKeys', {
            title    = '차키',
            align    = 'right',
            elements = elements
        }, function(data, menu)
            menu.close()

            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'CarKeyOptions', {
            title    = data.current.label,
            align    = 'right',
            elements = {{label = '차키주기', value = 'giveKey'}, {label = '차키복사', value = 'copyKey'}, {label = '차키삭제', value = 'deleteKey'}}
            }, function(data2, menu2)
                menu2.close()
                    if data2.current.value == 'giveKey' then
                        if data.current.job ~= "police" and data.current.job ~= "ambulance" then
                            local reciever, distance = ESX.Game.GetClosestPlayer()
                            if player ~= -1 and distance <= 3.0 then
                                TriggerServerEvent('skm_carkeys:giveKey', data.current.plate, GetPlayerServerId(reciever))
                                ESX.ShowNotification('차 열쇠 '..data.current.plate .. ' 를 주었습니다')
                            else
                                ESX.ShowNotification('주변에 플레이어가 없습니다')
                            end
                        else
                            ESX.ShowNotification('공공기관 소속의 키는 줄 수 없습니다.')
                        end
                    elseif data2.current.value == 'copyKey' then
                        if data.current.job ~= "police" and data.current.job ~= "ambulance" then
                            ESX.TriggerServerCallback("skm_carkeys:countCopiedKeys",function(available)
                                ESX.TriggerServerCallback("skm_carkeys:checkCopiedKeys",function(istrue)
                                    if(istrue == true) then

                                        if(available == true) then
                                            local reciever, distance = ESX.Game.GetClosestPlayer()
                                            if player ~= -1 and distance <= 3.0 then
                                                ESX.TriggerServerCallback("skm_carkeys:getmodel", function(modelhash)
                                                    
                                                        TriggerServerEvent('skm_carkeys:copyKey', data.current.plate, GetPlayerServerId(reciever),modelhash)
                                                        ESX.ShowNotification('차 열쇠 '..data.current.plate .. "를 복사했습니다")
                                                end,data.current.plate)
                                            else
                                                ESX.ShowNotification('주변에 플레이어가 없습니다')
                                            end
                                        else
                                            ESX.ShowNotification("복사가능 키 수를 초과했습니다.")
                                        end
                                    else
                                        ESX.ShowNotification("복사된 키는 다시 복사가 불가능합니다.")
                                    end
                                end,data.current.plate)
                            end, data.current.plate)
                        else
                            ESX.ShowNotification('공공기관 소속의 키는 복사할 수 없습니다.')
                        end
                    elseif data2.current.value == 'deleteKey' then
                        if data.current.job ~= "police" and data.current.job ~= "ambulance" then
                            TriggerServerEvent('skm_carkeys:deleteKey', data.current.plate)
                            ESX.ShowNotification('차 열쇠 '.. data.current.plate .. "를 삭제했습니다") 
                        else
                            ESX.ShowNotification('공공기관 소속의 키는 삭제할 수 없습니다.')
                        end
                    end
            end, function(data2, menu2)
                menu2.close()
            end)

        end, function(data, menu)
            menu.close()
        end)

    end)
end

Citizen.CreateThread(function()
    local dict = "anim@mp_player_intmenu@key_fob@"
    
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end
    while true do
        Wait(0)
        if(IsControlJustPressed(1, 75))then
            local plr = GetPlayerPed(-1)
            if DoesEntityExist(GetVehiclePedIsTryingToEnter(PlayerPedId(plr))) and GetVehicleDoorLockStatus(GetVehiclePedIsTryingToEnter(PlayerPedId(plr))) == 4 then
                ClearPedTasks(plr)
            end
        end

        -- Key : L
        if(IsControlJustPressed(0, 182)) then 
            TriggerEvent("skm_carkeys:lock")
            Citizen.Wait(1000)
        end
    end
end)

RegisterCommand('차량잠금', function(source, args, rawCommand)
    TriggerEvent("skm_carkeys:lock")
            Citizen.Wait(1000)
end)

RegisterNetEvent("skm_carkeys:lock")
AddEventHandler("skm_carkeys:lock",function()
    local plr = GetPlayerPed(-1)
            local plrCoords = GetEntityCoords(plr, true)

            if(IsPedInAnyVehicle(plr, true))then
                local localVehId = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                
                local localVehPlate = string.sub(GetVehicleNumberPlateText(localVehId),1,7)
                print(localVehPlate)
                

                ESX.TriggerServerCallback('skm_carkeys:checkIfKeyExist', function(exists)
                    print(exists)
                    if exists == 1 then
                                local lockStatus = GetVehicleDoorLockStatus(localVehId)
                                print(lockStatus)
                                if lockStatus == 0 then -- unlocked
                                    SetVehicleDoorsLocked(localVehId, 4)
                                    PlayVehicleDoorCloseSound(localVehId, 1)
                                    exports['okokNotify']:Alert("시스템", "차량 잠금", 5000, 'success')
                                elseif lockStatus == 1 then -- unlocked  
                                    SetVehicleDoorsLocked(localVehId, 4)
                                    PlayVehicleDoorCloseSound(localVehId, 1)
                                    exports['okokNotify']:Alert("시스템", "차량 잠금", 5000, 'success')
                                elseif lockStatus == 4 then -- locked
                                    SetVehicleDoorsLocked(localVehId, 1)
                                    PlayVehicleDoorOpenSound(localVehId, 0)
                                    exports['okokNotify']:Alert("시스템", "차량 잠금 해제", 5000, 'success')
                                 end
                          
                    else
                        exports['okokNotify']:Alert("시스템", "차키가 없습니다.", 5000, 'error')
                        -- TriggerServerEvent('skm_carkeys:createKey', localVehPlate)
                        -- TriggerEvent('esx:showNotification', 'Vous avez pris les clés du véhicule '..localVehPlate)   
                    end
                end, localVehPlate)
            else
        
                local localVehId = GetClosestVehicle(plrCoords, 8.0, 0, 70)
                if localVehId == 0 then
                    localVehId = GetClosestVehicle(plrCoords, 8.0, 0, 127)
                end
                local localVehPlate = string.sub(GetVehicleNumberPlateText(localVehId),1,7)
                print(localVehPlate)

                ESX.TriggerServerCallback('skm_carkeys:checkIfKeyExist', function(haskey)
                    if haskey == 1 then
                        
                        local lockStatus = GetVehicleDoorLockStatus(localVehId)

                        if lockStatus == 0 then -- unlocked
                            SetVehicleDoorsLocked(localVehId, 4)
                            PlayVehicleDoorCloseSound(localVehId, 1)
                            TaskPlayAnim(GetPlayerPed(-1), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)

                            exports['okokNotify']:Alert("시스템", "차량 잠금", 5000, 'success')
                        elseif lockStatus == 1 then
                            SetVehicleDoorsLocked(localVehId, 4)
                            PlayVehicleDoorCloseSound(localVehId, 1)
                            TaskPlayAnim(GetPlayerPed(-1), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)

                            exports['okokNotify']:Alert("시스템", "차량 잠금", 5000, 'success')
                        elseif lockStatus == 4 then -- locked
                            SetVehicleDoorsLocked(localVehId, 1)
                            PlayVehicleDoorOpenSound(localVehId, 0)
                            TaskPlayAnim(GetPlayerPed(-1), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)

                            exports['okokNotify']:Alert("시스템", "차량 잠금 해제", 5000, 'success') 
                        elseif lockStatus == 2 then -- locked
                            SetVehicleDoorsLocked(localVehId, 1)
                            PlayVehicleDoorOpenSound(localVehId, 0)
                            TaskPlayAnim(GetPlayerPed(-1), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)

                            exports['okokNotify']:Alert("시스템", "차량 잠금 해체", 5000, 'success')
                        end
                    else
                        exports['okokNotify']:Alert("시스템", "차키가 없습니다.", 5000, 'error')
                    end
                end, localVehPlate)
            end

end)