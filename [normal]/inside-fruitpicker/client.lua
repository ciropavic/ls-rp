ESX = nil

onDuty = false
hasCar = false
working = false
hasWashed = false
hasBox = false
local done, AmountPayout = 0, 0
local Plate = nil
local PlayerData = {}



RegisterCommand("startfruit", function() -- Command for trigger
	-- TriggerServerEvent('inside-warehouse:Payout', 1) -- you can use this for trigger the cutscene
    TriggerServerEvent('inside-fruitpicker:Payout', 10)
end) 


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(5)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

-- STARTING JOB
Citizen.CreateThread(function()
    while true do

        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local InVehicle = IsPedInAnyVehicle(ped, false)
        local sleep = 500

        if PlayerData.job ~= nil and PlayerData.job.grade_name == 'unemployed' then
            if not onDuty then
                if (GetDistanceBetweenCoords(pos, Config.Locations["main"].coords.x, Config.Locations["main"].coords.y, Config.Locations["main"].coords.z, true) < 10) then
                    sleep = 6
                    DrawMarker(2, Config.Locations["main"].coords.x, Config.Locations["main"].coords.y, Config.Locations["main"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 233, 55, 22, 222, false, false, false, true, false, false, false)
                    if (GetDistanceBetweenCoords(pos, Config.Locations["main"].coords.x, Config.Locations["main"].coords.y, Config.Locations["main"].coords.z, true) < 1.5) then
                        sleep = 6
                        DrawText3D(Config.Locations["main"].coords.x, Config.Locations["main"].coords.y, Config.Locations["main"].coords.z + 0.4, '~g~[E]~s~ - Change into work clothes')
                        if IsControlJustPressed(0, Keys["E"]) then
                            ESX.TriggerServerCallback('inside-farmer:checkfatigue', function(hasfatigue)
                                if(hasfatigue == false) then
                                    if not InVehicle then
                              
                                        exports.rprogress:Custom({
                                        Duration = 2500,
                                        Label = "환복 중...",
                                        Animation = {
                                            scenario = "WORLD_HUMAN_COP_IDLES",
                                            animationDictionary = "idle_a",
                                        },
                                        DisableControls = {
                                            Mouse = false,
                                            Player = true,
                                            Vehicle = true
                                        }
                                    })
                                    Citizen.Wait(2500)
                                    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                                    if skin.sex == 0 then
                                        TriggerEvent('skinchanger:loadClothes', skin, Config.Clothes.male)
                                    elseif skin.sex == 1 then
                                        TriggerEvent('skinchanger:loadClothes', skin, Config.Clothes.female)
                                    end
                                    exports['okokNotify']:Alert("시스템", "과일 채집 일을 시작합니다.", 3000, 'info')
                                    onDuty = true
                                    local coordsc = Config.Locations["cardeposit"].coords
                                    StartGpsMultiRoute(6, true, true)
    
                                    -- Add the points
                                    AddPointToGpsCustomRoute(Config.Locations["main"].coords.x, Config.Locations["main"].coords.y,Config.Locations["main"].coords.z)
                                    AddPointToGpsCustomRoute(coordsc.x, coordsc.y, coordsc.z)
                                    -- Set the route to render
                                    SetGpsCustomRouteRender(true, 16, 16)
                                    blips()
                                end)
                                else
                                    exports['okokNotify']:Alert("시스템", "당신은 너무 피로합니다", 3000, 'error')
                                end
       
                               
                            else
                                exports['okokNotify']:Alert("시스템", "차량을 탑승한 상태에선 환복 할 수 없습니다.", 3000, 'error')
                            end
                        end)
                        end
                    end
                end
            elseif onDuty then
                if (GetDistanceBetweenCoords(pos, Config.Locations["main"].coords.x, Config.Locations["main"].coords.y, Config.Locations["main"].coords.z, true) < 10) then
                    sleep = 6
                    DrawMarker(2, Config.Locations["main"].coords.x, Config.Locations["main"].coords.y, Config.Locations["main"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 233, 55, 22, 222, false, false, false, true, false, false, false)
                    if (GetDistanceBetweenCoords(pos, Config.Locations["main"].coords.x, Config.Locations["main"].coords.y, Config.Locations["main"].coords.z, true) < 1.5) then
                        sleep = 6
                        DrawText3D(Config.Locations["main"].coords.x, Config.Locations["main"].coords.y, Config.Locations["main"].coords.z + 0.4, '~r~[E]~s~ - Change into citizen clothes')
                        if IsControlJustPressed(0, Keys["E"]) then
                            if not Plate then
                            if not InVehicle then
                                exports.rprogress:Custom({
                                    Duration = 2500,
                                    Label = "환복 중...",
                                    Animation = {
                                        scenario = "WORLD_HUMAN_COP_IDLES", -- https://pastebin.com/6mrYTdQv
                                        animationDictionary = "idle_a", -- https://alexguirre.github.io/animations-list/
                                    },
                                    DisableControls = {
                                        Mouse = false,
                                        Player = true,
                                        Vehicle = true
                                    }
                                })
                                Citizen.Wait(2500)
                                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                                    TriggerEvent('skinchanger:loadSkin', skin)
                                exports.pNotify:SendNotification({text = "<b>과일 채집</b></br>과일 채집이 끝났습니다!", timeout = 3000})
                                onDuty = false
                                working = false
                                hasWashed = false
                                hasBox = false
                                hasCar = false
                                done = 0
                                AmountPayout = 0
                                RemoveBlip(blip1)
                                RemoveBlip(blip2)
                                RemoveBlip(blip3)
                                for i, v in ipairs(Config.OrangeSpots) do
                                    RemoveBlip(v.blip)
                                    v.taked = true
                                end
                                for i, v in ipairs(Config.AppleSpots) do
                                    RemoveBlip(v.blip)
                                    v.taked = true
                                end
                                for i, v in ipairs(Config.StrawberrySpots) do
                                    RemoveBlip(v.blip)
                                    v.taked = true
                                end
                                end)
                            else
                                exports.pNotify:SendNotification({text = "<b>과일 채집</b></br>차량을 떠나십시오!", timeout = 1500})
                            end
                        else
                            exports['okokNotify']:Alert("시스템", "차량을 반납하고 오세요!", 3000, 'error')
                        end
                        end
                    end
                end
            end
        end
    Citizen.Wait(sleep)
    end
end)

-- CAR DEPOSIT
Citizen.CreateThread(function()
    while true do

        local sleep = 500
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local InVehicle = IsPedInAnyVehicle(ped, false)
		local vehicle = GetVehiclePedIsIn(ped,0)
		local vplate = GetVehicleNumberPlateText(vehicle)

        if PlayerData.job ~= nil and PlayerData.job.grade_name == 'unemployed' then
            if onDuty then
                if (GetDistanceBetweenCoords(pos, Config.Locations["cardeposit"].coords.x, Config.Locations["cardeposit"].coords.y, Config.Locations["cardeposit"].coords.z, true) < 10) then
                    sleep = 6
                    DrawMarker(2, Config.Locations["cardeposit"].coords.x, Config.Locations["cardeposit"].coords.y, Config.Locations["cardeposit"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 233, 55, 22, 222, false, false, false, true, false, false, false)
                    if (GetDistanceBetweenCoords(pos, Config.Locations["cardeposit"].coords.x, Config.Locations["cardeposit"].coords.y, Config.Locations["cardeposit"].coords.z, true) < 2.5) then
                        sleep = 6
                        if InVehicle then
                            sleep = 6
                            DrawText3D(Config.Locations["cardeposit"].coords.x, Config.Locations["cardeposit"].coords.y, Config.Locations["cardeposit"].coords.z + 0.4, '~r~[E]~s~ - Return vehicle')
                            if IsControlJustReleased(0, Keys["E"]) then
                                if hasCar then
                                    if Plate == vplate then
                                    DepositBack()
                                    exports['okokNotify']:Alert("시스템", "차량을 반납해서"..Config.DepositPrice.."$ 를 돌려받았습니다.", 3000, 'info')
                                    -- exports.pNotify:SendNotification({text = '<b>과일 채집</b></br>차량 반납을 위해' ..Config.DepositPrice.. '$ 를 받았습니다.', timeout = 1500})
                                    working = false
                                    hasCar = false
                                    Plate = nil
                                    TriggerServerEvent('inside-fruitpicker:depositBack', source)
                                    for i, v in ipairs(Config.OrangeSpots) do
                                        RemoveBlip(v.blip)
                                        v.taked = true
                                    end
                                    for i, v in ipairs(Config.AppleSpots) do
                                        RemoveBlip(v.blip)
                                        v.taked = true
                                    end
                                    for i, v in ipairs(Config.StrawberrySpots) do
                                        RemoveBlip(v.blip)
                                        v.taked = true
                                    end
                                else
                                    exports['okokNotify']:Alert("시스템", "해당 차는 반납해야할 차량이 아닙니다", 3000, 'error')
                                end
                                else
                                    exports['okokNotify']:Alert("시스템", "차량을 대여하지 않았습니다.", 3000, 'error')
                                end
                            end
                        elseif not InVehicle then
                            sleep = 6
                            DrawText3D(Config.Locations["cardeposit"].coords.x, Config.Locations["cardeposit"].coords.y, Config.Locations["cardeposit"].coords.z + 0.4, '~g~[E]~s~ - Take out vehicle')
                            if IsControlJustReleased(0, Keys["E"]) then
                                if hasCar == false then

                                ESX.TriggerServerCallback('inside-fruitpicker:checkMoney', function(hasMoney)
                                if hasMoney then
                                    ESX.Game.SpawnVehicle(Config.CarModelName, vector3(Config.Locations["cardeposit"].coords.x, Config.Locations["cardeposit"].coords.y, Config.Locations["cardeposit"].coords.z), Config.Locations["cardeposit"].coords.h, function(vehicle)
                                    SetVehicleNumberPlateText(vehicle, "FRT"..tostring(math.random(1000, 9999)))
                                    TaskWarpPedIntoVehicle(ped, vehicle, -1)
                                    SetVehicleEngineOn(vehicle, true, true)
                                    exports['okokNotify']:Alert("시스템", "차량을 렌트하기 위해"..Config.DepositPrice.."$ 를 지불했습니다.", 3000, 'info')
                                    Plate = GetVehicleNumberPlateText(vehicle)
                                    print(Plate)
                                    hasCar = true
                                    working = true

                                    local coordsc = Config.Locations["wolkpoint"].coords
                                    StartGpsMultiRoute(6, true, true)
    
                                    -- Add the points
                                    AddPointToGpsCustomRoute(Config.Locations["cardeposit"].coords.x, Config.Locations["cardeposit"].coords.y, Config.Locations["cardeposit"].coords.z)
                                    AddPointToGpsCustomRoute(coordsc.x, coordsc.y, coordsc.z)
                                    -- Set the route to render
                                    SetGpsCustomRouteRender(true, 16, 16)

                                    BlipsWorking()
                                    for i, v in ipairs(Config.OrangeSpots) do
                                        v.taked = false
                                    end
                                    for i, v in ipairs(Config.AppleSpots) do
                                        v.taked = false
                                    end
                                    for i, v in ipairs(Config.StrawberrySpots) do
                                        v.taked = false
                                    end
                                    end)
                                else
                                    exports['okokNotify']:Alert("시스템", "차량을 렌트하기 위해서는"..Config.DepositPrice.."$ 가 필요합니다. ", 3000, 'error')
                                  
                                end
                            end)
                            else
                                exports['okokNotify']:Alert("시스템", "이미 차량을 렌트했습니다. ", 3000, 'error')
                            end
                               
                            end
                        end
                    end
                end
            end
                    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
                    local x,y,z = table.unpack(GetEntityCoords(ped))
                    local animbasket = "anim@heists@box_carry@"
                    local object = 'prop_fruit_basket'
                if working then
                    if not InVehicle then
                        if Plate == GetVehicleNumberPlateText(vehicle) then
                            sleep = 6
                            local trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -1.5, 0)
                                if not hasBox then
                                    if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, trunkpos.x, trunkpos.y, trunkpos.z, true) < 1.5 then
                                        sleep = 6
                                        DrawText3D(trunkpos.x, trunkpos.y, trunkpos.z + 0.4, "~g~[G]~s~ - Take out basket")
                                        if IsControlJustReleased(0, Keys["G"]) then
                                            sleep = 20
                                            TaskPlayAnim(ped, animbasket, "idle", 3.0, -8, -1, 63, 0, 0, 0, 0)
                                            basket = CreateObject(GetHashKey(object), pos.x, pos.y, pos.z,  true,  true, true)
                                            AttachEntityToEntity(basket, ped, GetPedBoneIndex(ped, 28422), 0.22+0.05, -0.3+0.25, 0.0+0.16, 160.0, 90.0, 125.0, true, true, false, true, 1, true)
                                            hasBox = true
                                        end
                                    end
                                elseif hasBox then
                                    sleep = 3
                                    DisableControlAction(0,23,true) -- DISABLE EXIT/ENTER VEHICLE
                                    sleep = 6
                                    if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, trunkpos.x, trunkpos.y, trunkpos.z, true) < 1.5 then
                                        sleep = 6
                                        DrawText3D(trunkpos.x, trunkpos.y, trunkpos.z + 0.4, "~r~[G]~s~ - Put in basket")
                                        if IsControlJustReleased(0, Keys["G"]) then
                                            sleep = 20
                                            ClearPedTasks(GetPlayerPed(-1))
                                            TaskPlayAnim(ped, animbasket, "exit", 3.0, 1.0, -1, 49, 0, 0, 0, 0)
                                            DeleteEntity(basket)
                                            hasBox = false
                                        end
                                    end
                                end
                        end
                    end
                end
        end
        Citizen.Wait(sleep)
    end
end)

-- WORKING
Citizen.CreateThread(function()
    while true do

        local sleep = 500
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local InVehicle = IsPedInAnyVehicle(ped, false)
        local object = 'prop_fruit_basket'

        if PlayerData.job ~= nil and PlayerData.job.grade_name == 'unemployed' then
            if working then
                for i, v in ipairs(Config.OrangeSpots) do
                    if not v.taked then
                        if GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 3 then
                            sleep = 6
                            DrawText3D(v.x, v.y, v.z + 0.4, '~g~[E]~s~ - Pick oranges')
                            if IsControlJustPressed(0, Keys["E"]) then
                                if not InVehicle then
                                    if hasBox then
                                        ESX.Streaming.RequestAnimDict('amb@prop_human_movie_bulb@idle_a', function()
                                            TaskPlayAnim(PlayerPedId(), 'amb@prop_human_movie_bulb@idle_a', 'idle_a', 8.0, -8.0, -1, 2, 0, false, false, false)
                                        end)
                                        exports.rprogress:Custom({
                                            Duration = 5500,
                                            Label = "오렌지 채집...",
                                            DisableControls = {
                                                Mouse = false,
                                                Player = true,
                                                Vehicle = true
                                            }
                                        })
                                        Citizen.Wait(5500)
                                        ClearPedTasks(ped)
                                        done = done + 1
                                        v.taked = true
                                        RemoveBlip(v.blip)
                                        if done == 12 then
                                            exports['okokNotify']:Alert("시스템", "모든 과일을 채집하였습니다. 세척하러 가십시오. ", 3000, 'info')
                                            SetNewWaypoint(Config.Locations["transformfruit"].coords.x, Config.Locations["transformfruit"].coords.y, Config.Locations["transformfruit"].coords.z)
                                        end
                                    else
                                        exports['okokNotify']:Alert("시스템", "바구니를 들어주세요 ", 3000, 'error')
                                    end
                                else
                                    exports['okokNotify']:Alert("시스템", "차량을 탑승한 상태로 과일을 채집할 수 없습니다.", 3000, 'error')
                                end
                            end
                        end
                    end
                end
                for i, v in ipairs(Config.AppleSpots) do
                    if not v.taked then
                        if GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 3 then
                            sleep = 6
                            DrawText3D(v.x, v.y, v.z + 0.4, '~g~[E]~s~ - Pick apples')
                            if IsControlJustPressed(0, Keys["E"]) then
                                if not InVehicle then
                                    if hasBox then
                                        ESX.Streaming.RequestAnimDict('amb@prop_human_movie_bulb@idle_a', function()
                                            TaskPlayAnim(PlayerPedId(), 'amb@prop_human_movie_bulb@idle_a', 'idle_a', 8.0, -8.0, -1, 2, 0, false, false, false)
                                        end)
                                        exports.rprogress:Custom({
                                            Duration = 5500,
                                            Label = "사과 채집...",
                                            DisableControls = {
                                                Mouse = false,
                                                Player = true,
                                                Vehicle = true
                                            }
                                        })
                                        Citizen.Wait(5500)
                                        ClearPedTasks(ped)
                                        done = done + 1
                                        v.taked = true
                                        RemoveBlip(v.blip)
                                        if done == 12 then
                                            exports['okokNotify']:Alert("시스템", "모든 과일을 채집하였습니다. 세척하러 가십시오. ", 3000, 'info')
                                            SetNewWaypoint(Config.Locations["transformfruit"].coords.x, Config.Locations["transformfruit"].coords.y, Config.Locations["transformfruit"].coords.z)
                                        end
                                    else
                                        exports['okokNotify']:Alert("시스템", "바구니를 들어주세요 ", 3000, 'error')
                                    end
                                else
                                    exports['okokNotify']:Alert("시스템", "차량을 탑승한 상태로 과일을 채집할 수 없습니다.", 3000, 'error')
                                end
                            end
                        end
                    end
                end
                for i, v in ipairs(Config.StrawberrySpots) do
                    if not v.taked then
                        if GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 3 then
                            sleep = 6
                            DrawText3D(v.x, v.y, v.z + 0.4, '~g~[E]~s~ - Pick strawberries')
                            if IsControlJustPressed(0, Keys["E"]) then
                                if not InVehicle then
                                    if hasBox then
                                        DeleteEntity(basket)
                                        ESX.Streaming.RequestAnimDict('amb@world_human_gardener_plant@male@enter', function()
                                            TaskPlayAnim(PlayerPedId(), 'amb@world_human_gardener_plant@male@enter', 'enter', 8.0, -8.0, -1, 2, 0, false, false, false)
                                        end)
                                        exports.rprogress:Custom({
                                            Duration = 5500,
                                            Label = "딸기 채집...",
                                            DisableControls = {
                                                Mouse = false,
                                                Player = true,
                                                Vehicle = true
                                            }
                                        })
                                        Citizen.Wait(5500)
                                        basket = CreateObject(GetHashKey(object), pos.x, pos.y, pos.z,  true,  true, true)
                                        AttachEntityToEntity(basket, ped, GetPedBoneIndex(ped, 28422), 0.22+0.05, -0.3+0.25, 0.0+0.16, 160.0, 90.0, 125.0, true, true, false, true, 1, true)
                                        ClearPedTasks(ped)
                                        done = done + 1
                                        v.taked = true
                                        RemoveBlip(v.blip)
                                          if done == 12 then
                                            exports['okokNotify']:Alert("시스템", "모든 과일을 채집하였습니다. 세척하러 가십시오. ", 3000, 'info')
                                            SetNewWaypoint(Config.Locations["transformfruit"].coords.x, Config.Locations["transformfruit"].coords.y, Config.Locations["transformfruit"].coords.z)
                                        end
                                    else
                                        exports['okokNotify']:Alert("시스템", "바구니를 들어주세요 ", 3000, 'error')
                                    end
                                else
                                    exports['okokNotify']:Alert("시스템", "차량을 탑승한 상태로 과일을 채집할 수 없습니다.", 3000, 'error')
                                end
                            end
                        end
                    end
                end
                sleep = 6
                if (GetDistanceBetweenCoords(pos, Config.Locations["transformfruit"].coords.x, Config.Locations["transformfruit"].coords.y, Config.Locations["transformfruit"].coords.z, true) < 10) then
                    sleep = 6
                    DrawMarker(2, Config.Locations["transformfruit"].coords.x, Config.Locations["transformfruit"].coords.y, Config.Locations["transformfruit"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 233, 55, 22, 222, false, false, false, true, false, false, false)
                    if (GetDistanceBetweenCoords(pos, Config.Locations["transformfruit"].coords.x, Config.Locations["transformfruit"].coords.y, Config.Locations["transformfruit"].coords.z, true) < 2.5) then
                        sleep = 6
                        DrawText3D(Config.Locations["transformfruit"].coords.x, Config.Locations["transformfruit"].coords.y, Config.Locations["transformfruit"].coords.z + 0.4, '~g~[E]~s~ - Wash fruits')
                        if IsControlJustPressed(0, Keys["E"]) then
                            if done == 12 then
                                if not InVehicle then
                                    if hasBox then
                                        if not hasWashed then
                                            DoScreenFadeOut(800)
                                            Citizen.Wait(800)
                                            exports.rprogress:Custom({
                                                Duration = 25000,
                                                Label = "세척 중...",
                                                DisableControls = {
                                                    Mouse = false,
                                                    Player = true,
                                                    Vehicle = true
                                                }
                                            })
                                            Citizen.Wait(25000)
                                            hasWashed = true
                                            DoScreenFadeIn(800)
                                            Citizen.Wait(800)
                                            exports['okokNotify']:Alert("시스템", "과일 세척을 끝냈습니다. 가게로 가십시오.", 3000, 'info')
                                            -- exports.pNotify:SendNotification({text = '<b>과일 채집</b></br>당신이 채집한 과일을 판매할 준비가 되었습니다. 가게로 가십시오.', timeout = 5000})
                                            SetNewWaypoint(Config.Locations["sellfruit"].coords.x, Config.Locations["sellfruit"].coords.y, Config.Locations["sellfruit"].coords.z)
                                        elseif hasWashed then
                                            exports['okokNotify']:Alert("시스템", "이미 과일을 세척했습니다.", 3000, 'error')
                                            -- exports.pNotify:SendNotification({text = "<b>과일 채집</b></br>이미 씻은 과일입니다.", timeout = 3000})
                                        end
                                    else
                                        exports['okokNotify']:Alert("시스템", "바구니를 들어주세요 ", 3000, 'error')
                                        -- exports.pNotify:SendNotification({text = "<b>과일 채집</b></br>당신은 바구니가 없습니다.", timeout = 3000})
                                    end
                                else
                                    exports['okokNotify']:Alert("시스템", "차량을 탄 상태로 과일을 세척할 수 없습니다. ", 3000, 'error')
                                    -- exports.pNotify:SendNotification({text = "<b>과일 채집</b></br>차량을 떠나십시오!", timeout = 1500})
                                end
                            else
                                exports['okokNotify']:Alert("시스템", "아직 모든 과일을 채집하지 못했습니다.", 3000, 'error')
                                -- exports.pNotify:SendNotification({text = "<b>과일 채집</b></br>아직 모든 과일을 채집하지 못하였습니다!", timeout = 3000})
                            end
                        end
                    end
                end
                sleep = 6
                if (GetDistanceBetweenCoords(pos, Config.Locations["sellfruit"].coords.x, Config.Locations["sellfruit"].coords.y, Config.Locations["sellfruit"].coords.z, true) < 10) then
                    sleep = 6
                    DrawMarker(2, Config.Locations["sellfruit"].coords.x, Config.Locations["sellfruit"].coords.y, Config.Locations["sellfruit"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 233, 55, 22, 222, false, false, false, true, false, false, false)
                    if (GetDistanceBetweenCoords(pos, Config.Locations["sellfruit"].coords.x, Config.Locations["sellfruit"].coords.y, Config.Locations["sellfruit"].coords.z, true) < 2.5) then
                        sleep = 6
                        DrawText3D(Config.Locations["sellfruit"].coords.x, Config.Locations["sellfruit"].coords.y, Config.Locations["sellfruit"].coords.z + 0.4, '~g~[E]~s~ - Sell fruit')
                        if IsControlJustPressed(0, Keys["E"]) then
                            if not InVehicle then
                                if hasBox then
                                    if hasWashed then
                                        ClearPedTasks(ped)
                                        TaskPlayAnim(ped, 'anim@heists@box_carry@', "exit", 3.0, 1.0, -1, 49, 0, 0, 0, 0)
                                        DeleteEntity(basket)
                                        ESX.Streaming.RequestAnimDict('mp_common', function()
                                            TaskPlayAnim(PlayerPedId(), 'mp_common', 'givetake1_a', 8.0, -8.0, -1, 2, 0, false, false, false)
                                        end)
                                        exports.rprogress:Custom({
                                            Duration = 4000,
                                            Label = "판매 중...",
                                            DisableControls = {
                                                Mouse = false,
                                                Player = true,
                                                Vehicle = true
                                            }
                                        })
                                        Citizen.Wait(4000)
                                        ClearPedTasks(ped)
                                        AmountPayout = AmountPayout + 1
                                        TriggerServerEvent('inside-fruitpicker:Payout', AmountPayout)
                                        exports['okokNotify']:Alert("시스템", "과일을 팔고 돈을 받았습니다.", 3000, 'success')
                                        -- exports.pNotify:SendNotification({text = "<b>과일 채집</b></br>돈을 지급받았습니다.", timeout = 3000})
                                        done = 0
                                        AmountPayout = 0
                                        hasWashed = false
                                        working = false
                                        hasBox = false
                                        -- for i, v in ipairs(Config.OrangeSpots) do
                                        --     v.taked = false
                                        -- end
                                        -- for i, v in ipairs(Config.AppleSpots) do
                                        --     v.taked = false
                                        -- end
                                        -- for i, v in ipairs(Config.StrawberrySpots) do
                                        --     v.taked = false
                                        -- end
                                        -- BlipsWorking()
                                    else
                                        exports['okokNotify']:Alert("시스템", "세척되지 않은 과일을 팔 수 없습니다.", 3000, 'error')
                                        -- exports.pNotify:SendNotification({text = '<b>Fruit Picker</b></br>세척되지 않은 과일입니다!', timeout = 3000})
                                    end
                                else
                                    exports['okokNotify']:Alert("시스템", "바구니를 들어주세요", 3000, 'error')
                                    exports.pNotify:SendNotification({text = "<b>Fruit Picker</b></br>당신은 바구니가 없습니다.", timeout = 3000})
                                end
                            else
                                exports['okokNotify']:Alert("시스템", "차량을 탄 상태에서 과일을 팔 수 없습니다.", 3000, 'error')
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

-- MAIN BLIP
Citizen.CreateThread(function()
        local coordsm = Config.Locations["main"].coords
        local namem = Config.Locations["main"].label
        blip = AddBlipForCoord(coordsm.x, coordsm.y, coordsm.z)
        SetBlipSprite(blip, 285)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.6)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, 51)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(namem)
        EndTextCommandSetBlipName(blip)
end)
-- ONDUTY BLIP
function blips()
        local coordsc = Config.Locations["cardeposit"].coords
        local namec = Config.Locations["cardeposit"].label
        blip1 = AddBlipForCoord(coordsc.x, coordsc.y, coordsc.z)
        SetBlipSprite(blip1, 285)
        SetBlipDisplay(blip1, 4)
        SetBlipScale(blip1, 0.6)
        SetBlipAsShortRange(blip1, true)
        SetBlipColour(blip1, 51)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(namec)
        EndTextCommandSetBlipName(blip1)

        local coordst = Config.Locations["transformfruit"].coords
        local namet = Config.Locations["transformfruit"].label
        blip2 = AddBlipForCoord(coordst.x, coordst.y, coordst.z)
        SetBlipSprite(blip2, 285)
        SetBlipDisplay(blip2, 4)
        SetBlipScale(blip2, 0.6)
        SetBlipAsShortRange(blip2, true)
        SetBlipColour(blip2, 51)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(namet)
        EndTextCommandSetBlipName(blip2)
        
        local sell = Config.Locations["sellfruit"].coords
        local names = Config.Locations["sellfruit"].label
        blip3 = AddBlipForCoord(sell.x, sell.y, sell.z)
        SetBlipSprite(blip3, 285)
        SetBlipDisplay(blip3, 4)
        SetBlipScale(blip3, 0.6)
        SetBlipAsShortRange(blip3, true)
        SetBlipColour(blip3, 51)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(names)
        EndTextCommandSetBlipName(blip3)
end

-- WORKING BLIPS
function BlipsWorking()
    for i, v in ipairs(Config.OrangeSpots) do
        v.blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(v.blip, 285)
        SetBlipDisplay(v.blip, 4)
        SetBlipScale(v.blip, 0.4)
        SetBlipAsShortRange(v.blip, true)
        SetBlipColour(v.blip, 47)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName('Oranges Orchard')
        EndTextCommandSetBlipName(v.blip)
    end

    for i, v in ipairs(Config.AppleSpots) do
        v.blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(v.blip, 285)
        SetBlipDisplay(v.blip, 4)
        SetBlipScale(v.blip, 0.4)
        SetBlipAsShortRange(v.blip, true)
        SetBlipColour(v.blip, 69)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName('Apples Orchard')
        EndTextCommandSetBlipName(v.blip)
    end

    for i, v in ipairs(Config.StrawberrySpots) do
        v.blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(v.blip, 285)
        SetBlipDisplay(v.blip, 4)
        SetBlipScale(v.blip, 0.4)
        SetBlipAsShortRange(v.blip, true)
        SetBlipColour(v.blip, 49)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName('Strawberries Orchard')
        EndTextCommandSetBlipName(v.blip)
    end
end

function DepositBack()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped)
    ESX.Game.DeleteVehicle(vehicle)
    hasCar = false
end

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end
