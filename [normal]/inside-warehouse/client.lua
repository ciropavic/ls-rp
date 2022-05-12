ESX = nil

local JobStart = Config.Warehouse.JobStart
local Boss = Config.Warehouse.Boss
local Garage = Config.Warehouse.Garage
local GarageSpawnPoint = Config.Warehouse.GarageSpawnPoint
local PostOP = Config.Warehouse.PostOP
local GoPostal = Config.Warehouse.GoPostal
local AlphaMail = Config.Warehouse.AlphaMail
local IKEA = Config.Warehouse.IKEA
local PackageMarker = Config.Warehouse.PackageMarker
local HasRandomBox = nil
local Type = nil
local Plate = nil
local done, AmountPayout = 0, 0

onDuty = false
hasCar = false
hasOpenDoor = false
hasBox = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(5)
	end
end)
-- RegisterCommand("startwere", function() -- Command for trigger
-- 	-- TriggerServerEvent('inside-warehouse:Payout', 1) -- you can use this for trigger the cutscene
--     TriggerServerEvent('inside-warehouse:exp')
-- end) 

-- RegisterCommand("startwere2", function() -- Command for trigger
-- 	-- TriggerServerEvent('inside-warehouse:Payout', 1) -- you can use this for trigger the cutscene
--     ESX.TriggerServerCallback('inside-warehouse:checkfatigue', function(hasMoney)
--         if hasMoney then
--             exports.pNotify:SendNotification({text = '<b>Warehouse</b></br> 성공'..hasMoney..'', timeout = 1500})
--         else 
--             exports.pNotify:SendNotification({text = '<b>Warehouse</b></br> 성공Lv', timeout = 1500})
--         end
        
--     end)
-- end) 

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

        local sleep = 500
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)

            if (GetDistanceBetweenCoords(coords, JobStart.Pos.x, JobStart.Pos.y, JobStart.Pos.z, true) < 8) then
                sleep = 7
                DrawMarker(JobStart.Type, JobStart.Pos.x, JobStart.Pos.y, JobStart.Pos.z - 0.95, 0.0, 0.0, 0.0, 0, 0.0, 0.0, JobStart.Size.x, JobStart.Size.y, JobStart.Size.z, JobStart.Color.r, JobStart.Color.g, JobStart.Color.b, 100, false, true, 2, false, false, false, false)
                if (GetDistanceBetweenCoords(coords, JobStart.Pos.x, JobStart.Pos.y, JobStart.Pos.z, true) < 1.2) then
                    if not onDuty then
                        sleep = 7
                        DrawText3Ds(JobStart.Pos.x, JobStart.Pos.y, JobStart.Pos.z + 0.4, '~g~[E]~s~ - Start Work!')
                    
                        if IsControlJustPressed(0, Keys["E"]) then
                            exports.rprogress:Custom({
                                Duration = 1500,
                                Label = "작업복으로 환복 중...",
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
                            Citizen.Wait(1500)
                            ESX.TriggerServerCallback('inside-warehouse:checkfatigue', function(hasfatigue)
                                if(hasfatigue) then
                                    exports['okokNotify']:Alert("시스템", "당신은 너무 피로합니다", 3000, 'error')
                                    onDuty = false
                                else 
                                    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                                        if skin.sex == 0 then
                                            TriggerEvent('skinchanger:loadClothes', skin, Config.Clothes.male)
                                        elseif skin.sex == 1 then
                                            TriggerEvent('skinchanger:loadClothes', skin, Config.Clothes.female)
                                        end
                                    end)
                                    exports['okokNotify']:Alert("시스템", "작업을 시작합니다! 아래층에서 일거리를 받으세요!", 3000, 'info')
                                    onDuty = true
                                    addBlips()
                                end
        
                                end)
                         
                        end
                    elseif onDuty then
                        sleep = 7
                        DrawText3Ds(JobStart.Pos.x, JobStart.Pos.y, JobStart.Pos.z + 0.4, '~r~[E]~s~ - Change into citizen clothes')
                        DrawMarker(JobStart.Type, JobStart.Pos.x, JobStart.Pos.y, JobStart.Pos.z - 0.95, 0.0, 0.0, 0.0, 0, 0.0, 0.0, JobStart.Size.x, JobStart.Size.y, JobStart.Size.z, JobStart.Color.r, JobStart.Color.g, JobStart.Color.b, 100, false, true, 2, false, false, false, false)
                        if IsControlJustPressed(0, Keys["E"]) then
                            if not HasRandomBox then
                                exports.rprogress:Custom({
                                    Duration = 2500,
                                    Label = "당신의 복장으로 환복 중...",
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
                                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                                    TriggerEvent('skinchanger:loadSkin', skin)
                                end)
                                exports['okokNotify']:Alert("시스템", "작업을 마쳤습니다!", 3000, 'info')
                                onDuty = false
                                RemoveBlip(bossBlip)
                            elseif HasRandomBox then
                                exports['okokNotify']:Alert("시스템", "먼저 당신의 일을 취소하십시오.", 3000, 'error')
                            end
                        end
                    end
                end
            end
        Citizen.Wait(sleep)
    end
end)

-- BOSS
Citizen.CreateThread(function()
    while true do
            
            local sleep = 500
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)

                if onDuty then
                    if (GetDistanceBetweenCoords(coords, Boss.Pos.x, Boss.Pos.y, Boss.Pos.z, true) < Config.DrawDistance) then
                        sleep = 7
                        DrawMarker(Boss.Type, Boss.Pos.x, Boss.Pos.y, Boss.Pos.z - 0.95, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Boss.Size.x, Boss.Size.y, Boss.Size.z, Boss.Color.r, Boss.Color.g, Boss.Color.b, 100, false, true, 2, false, false, false, false)
                        if (GetDistanceBetweenCoords(coords, Boss.Pos.x, Boss.Pos.y, Boss.Pos.z, true) < 1.5) then
                            if not HasRandomBox then
                                DrawText3Ds(Boss.Pos.x, Boss.Pos.y, Boss.Pos.z + 0.4, "~g~[E]~s~ - Ask your boss about today's job")
                                if IsControlJustPressed(0, Keys["E"]) then
                                    HasRandomBox = math.random(10, 10)
                                    Companies = Randomize(Config.Companies)
                                    CreateWork(Companies.CompanyName)
                                    addBlipsHRB()
                                    exports['okokNotify']:Alert("시스템", "창고에서"..HasRandomBox.."패키지 박스를 수집해야 합니다. 차고에서"..Companies.CompanyName.."직업 차량을 타고 출발하십시오", 3000, 'info')
                                    -- exports.pNotify:SendNotification({text = "<b>창고</b></br>창고에서 " ..HasRandomBox.. " 패키지 박스를 수집해야 합니다. 차고에서 " ..Companies.CompanyName.. " 작업 차량을 타고 출발하십시오!", timeout = 5000})
                                end
                            elseif HasRandomBox then
                                if AmountPayout == 0 then
                                    DrawText3Ds(Boss.Pos.x, Boss.Pos.y, Boss.Pos.z + 0.4, "~r~[E]~s~ - Cancel the errand")
                                    if IsControlJustPressed(0, Keys["E"]) then
                                        if not hasCar then
                                            done = 0
                                            Type = nil
                                            HasRandomBox = nil
                                            DeleteCompanyBlip()
                                            RemoveBlip(garageBlip)
                                            for i, v in ipairs(Config.WarehouseSpots) do
                                                v.taked = true
                                                RemoveBlip(v.blip)
                                            end
                                            exports['okokNotify']:Alert("시스템", "당신의 업무를 취소하였습니다.", 3000, 'info')
                                        elseif hasCar then
                                            exports['okokNotify']:Alert("시스템", "차고에 차량을 주차하십시오.", 3000, 'error')
                                        end
                                    end
                                elseif AmountPayout == HasRandomBox then
                                    DrawText3Ds(Boss.Pos.x, Boss.Pos.y, Boss.Pos.z + 0.4, "~g~[E]~s~ - Receive a salary")
                                    if IsControlJustPressed(0, Keys["E"]) then
                                        if not hasCar then
                                            exports.rprogress:Custom({
                                                Duration = 2000,
                                                Label = "당신의 급여를 계산하고 있습니다....",
                                                DisableControls = {
                                                    Mouse = false,
                                                    Player = true,
                                                    Vehicle = true
                                                }
                                            })
                                            Citizen.Wait(2000)
                                            TriggerServerEvent('inside-warehouse:Payout', AmountPayout)
                                            TriggerServerEvent('inside-warehouse:exp')
                                            exports['okokNotify']:Alert("시스템", "급여를 지급받았습니다!", 3000, 'info')
                                            RemoveBlip(garageBlip)
                                            AmountPayout = 0
                                            done = 0
                                            HasRandomBox = nil
                                        elseif hasCar then
                                            exports['okokNotify']:Alert("시스템", "차고에 차량을 주차하십시오.", 3000, 'error')
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

-- CAR DEPOSIT
Citizen.CreateThread(function()
    while true do

        local sleep = 500
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local InVehicle = IsPedInAnyVehicle(ped, false)
		local vehicle = GetVehiclePedIsIn(ped,0)
		local vplate = GetVehicleNumberPlateText(vehicle)

            if HasRandomBox then
                if (GetDistanceBetweenCoords(coords, Garage.Pos.x, Garage.Pos.y, Garage.Pos.z, true) < Config.DrawDistance) then
                    sleep = 7
                    DrawMarker(Garage.Type, Garage.Pos.x, Garage.Pos.y, Garage.Pos.z - 0.95, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Garage.Size.x, Garage.Size.y, Garage.Size.z, Garage.Color.r, Garage.Color.g, Garage.Color.b, 100, false, true, 2, false, false, false, false)
                    if (GetDistanceBetweenCoords(coords, Garage.Pos.x, Garage.Pos.y, Garage.Pos.z, true) < 2.5) then
                        if IsPedInAnyVehicle(ped, false) then
                            DrawText3Ds(Garage.Pos.x, Garage.Pos.y, Garage.Pos.z + 0.4, '~r~[E]~s~ - Return vehicle')
                            if IsControlJustReleased(0, Keys["E"]) then
                                if hasCar then
                                    if Plate == vplate then
                                    TriggerServerEvent('inside-warehouse:returnVehicle', source)
                                    ReturnVehicle()
                                    exports['okokNotify']:Alert("시스템", "당신은"..Config.DepositPrice.. '$ 차량 비용을 돌려받았습니다.', 3000, 'info')
                                    hasCar = false
                                    Plate = nil
                                    else
                                        exports['okokNotify']:Alert("시스템", "해당 차는 반납해야할 차량이 아닙니다", 3000, 'error') 
                                    end
                                end
                            end
                        elseif not IsPedInAnyVehicle(ped, false) then
                            if not hasCar then
                                DrawText3Ds(Garage.Pos.x, Garage.Pos.y, Garage.Pos.z + 0.4, '~g~[E]~s~ - Take out vehicle')
                            elseif hasCar then
                                DrawText3Ds(Garage.Pos.x, Garage.Pos.y, Garage.Pos.z + 0.4, 'You already have a pulled out vehicle')
                            end
                            if IsControlJustReleased(0, Keys["E"]) then
                                ESX.TriggerServerCallback('inside-warehouse:checkMoney', function(hasMoney)
                                if hasCar then
                                    exports['okokNotify']:Alert("시스템", "이미 차량을 대여했습니다.", 3000, 'error')
                                else
                                    if hasMoney then
                                        if Type == "Post OP" then
                                            ESX.Game.SpawnVehicle(Config.CarPostOP, vector3(GarageSpawnPoint.Pos.x, GarageSpawnPoint.Pos.y, GarageSpawnPoint.Pos.z), GarageSpawnPoint.Pos.h, function(vehicle)
                                            SetVehicleNumberPlateText(vehicle, "WRH"..tostring(math.random(1000, 9999)))
                                            SetVehicleEngineOn(vehicle, true, true)
                                            exports['okokNotify']:Alert("시스템", "차량을 대여하기 위해"..Config.DepositPrice.. '$ 금액을 지불했습니다.', 3000, 'info')
                                            hasCar = true
                                            Plate = GetVehicleNumberPlateText(vehicle)
                                            BlipsOnWorking()
                                            for i, v in ipairs(Config.WarehouseSpots) do
                                                v.taked = false
                                            end
                                            end)
                                        elseif Type == "GoPostal" then
                                            ESX.Game.SpawnVehicle(Config.CarGoPostal, vector3(GarageSpawnPoint.Pos.x, GarageSpawnPoint.Pos.y, GarageSpawnPoint.Pos.z), GarageSpawnPoint.Pos.h, function(vehicle)
                                            SetVehicleNumberPlateText(vehicle, "WRH"..tostring(math.random(1000, 9999)))
                                            SetVehicleEngineOn(vehicle, true, true)
                                           exports['okokNotify']:Alert("시스템", "차량을 대여하기 위해"..Config.DepositPrice.. '$ 금액을 지불했습니다.', 3000, 'info')
                                            hasCar = true
                                            Plate = GetVehicleNumberPlateText(vehicle)
                                            BlipsOnWorking()
                                            for i, v in ipairs(Config.WarehouseSpots) do
                                                v.taked = false
                                            end
                                            end)
                                        elseif Type == "Alpha Mail" then
                                            ESX.Game.SpawnVehicle(Config.CarAlphaMail, vector3(GarageSpawnPoint.Pos.x, GarageSpawnPoint.Pos.y, GarageSpawnPoint.Pos.z), GarageSpawnPoint.Pos.h, function(vehicle)
                                            SetVehicleNumberPlateText(vehicle, "WRH"..tostring(math.random(1000, 9999)))
                                            SetVehicleEngineOn(vehicle, true, true)
                                           exports['okokNotify']:Alert("시스템", "차량을 대여하기 위해"..Config.DepositPrice.. '$ 금액을 지불했습니다.', 3000, 'info')
                                            hasCar = true
                                            Plate = GetVehicleNumberPlateText(vehicle)
                                            BlipsOnWorking()
                                            for i, v in ipairs(Config.WarehouseSpots) do
                                                v.taked = false
                                            end
                                            end)
                                        elseif Type == "IKEA" then
                                            ESX.Game.SpawnVehicle(Config.CarDefault, vector3(GarageSpawnPoint.Pos.x, GarageSpawnPoint.Pos.y, GarageSpawnPoint.Pos.z), GarageSpawnPoint.Pos.h, function(vehicle)
                                            SetVehicleNumberPlateText(vehicle, "WRH"..tostring(math.random(1000, 9999)))
                                            SetVehicleEngineOn(vehicle, true, true)
                                           exports['okokNotify']:Alert("시스템", "차량을 대여하기 위해"..Config.DepositPrice.. '$ 금액을 지불했습니다.', 3000, 'info')
                                            hasCar = true
                                            Plate = GetVehicleNumberPlateText(vehicle)
                                            BlipsOnWorking()
                                            for i, v in ipairs(Config.WarehouseSpots) do
                                                v.taked = false
                                            end
                                            end)
                                        end
                                    end
                                end
                                
                                end)
                            end
                        end
                    end
                end
            end
        Citizen.Wait(sleep)
    end
end)

-- OPENING VAN DOORS
Citizen.CreateThread(function()
    while true do

        local sleep = 500
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)

            if hasCar then
                if not IsPedInAnyVehicle(ped, false) then
                    if Plate == GetVehicleNumberPlateText(vehicle) then
                        local trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -3.5, 0)
                        if (GetDistanceBetweenCoords(coords.x, coords.y, coords.z, trunkpos.x, trunkpos.y, trunkpos.z, true) < 2) then
                            sleep = 7
                            if not hasOpenDoor and not hasBox then
                                sleep = 7
                                DrawText3Ds(trunkpos.x, trunkpos.y, trunkpos.z + 0.4, "~g~[G]~s~ - Open Doors")
                                if IsControlJustReleased(0, Keys["G"]) then
                                    exports.rprogress:Custom({
                                        Duration = 1500,
                                        Label = "뒷문이 열려있습니다.",
                                        DisableControls = {
                                            Mouse = false,
                                            Player = true,
                                            Vehicle = true
                                        }
                                    })
                                    Citizen.Wait(1500)
                                    SetVehicleDoorOpen(vehicle, 3, false, false)
                                    SetVehicleDoorOpen(vehicle, 2, false, false)
                                    hasOpenDoor = true
                                end
                            elseif hasOpenDoor then
                                sleep = 7
                                DrawText3Ds(trunkpos.x, trunkpos.y, trunkpos.z + 0.25, "Packages: ~g~" ..done.. "/" ..HasRandomBox.. "~s~")
                                if not hasBox and done == 0 then
                                    sleep = 7
                                    DrawText3Ds(trunkpos.x, trunkpos.y, trunkpos.z + 0.4, "~r~[G]~s~ - Close Doors")
                                    if IsControlJustReleased(0, Keys["G"]) then
                                        exports.rprogress:Custom({
                                            Duration = 1500,
                                            Label = "뒷문이 닫혀있습니다.",
                                            DisableControls = {
                                                Mouse = false,
                                                Player = true,
                                                Vehicle = true
                                            }
                                        })
                                        Citizen.Wait(1500)
                                        SetVehicleDoorShut(vehicle, 3, false)
                                        SetVehicleDoorShut(vehicle, 2, false)
                                        hasOpenDoor = false
                                    end
                                elseif not hasBox then
                                    sleep = 7
                                    DrawText3Ds(trunkpos.x, trunkpos.y, trunkpos.z + 0.4, "~r~[G]~s~ - Close Doors | ~r~[E]~s~ - Take package out")
                                    if IsControlJustReleased(0, Keys["G"]) then
                                        exports.rprogress:Custom({
                                            Duration = 1500,
                                            Label = "뒷문이 닫혀있습니다.",
                                            DisableControls = {
                                                Mouse = false,
                                                Player = true,
                                                Vehicle = true
                                            }
                                        })
                                        Citizen.Wait(1500)
                                        SetVehicleDoorShut(vehicle, 3, false)
                                        SetVehicleDoorShut(vehicle, 2, false)
                                        hasOpenDoor = false
                                    elseif IsControlJustReleased(0, Keys["E"]) then
                                        exports.rprogress:Custom({
                                            Duration = 1500,
                                            Label = "패키지 박스를 선택하고 있습니다...",
                                            DisableControls = {
                                                Mouse = false,
                                                Player = true,
                                                Vehicle = true
                                            }
                                        })
                                        Citizen.Wait(1500)
                                        addPackage()
                                        hasBox = true
                                        done = done - 1
                                    end
                                elseif hasBox then
                                    sleep = 7
                                    DrawText3Ds(trunkpos.x, trunkpos.y, trunkpos.z + 0.4, "~g~[E]~s~ - Put package in")
                                    if IsControlJustReleased(0, Keys["E"]) then
                                        exports.rprogress:Custom({
                                            Duration = 1500,
                                            Label = "패키지 박스를 넣습니다...",
                                            DisableControls = {
                                                Mouse = false,
                                                Player = true,
                                                Vehicle = true
                                            }
                                        })
                                        Citizen.Wait(1500)
                                        removePackage()
                                        hasBox = false
                                        done = done + 1
                                        if done == HasRandomBox then
                                            exports['okokNotify']:Alert("시스템", "모든 패키지 박스를 수집했습니다.", 3000, 'info')
                                            if Type == "GoPostal" then
                                                SetNewWaypoint(GoPostal.Pos.x, GoPostal.Pos.y, GoPostal.Pos.z)
                                            elseif Type == "Post OP" then
                                                SetNewWaypoint(PostOP.Pos.x, PostOP.Pos.y, PostOP.Pos.z)
                                            elseif Type == "Alpha Mail" then
                                                SetNewWaypoint(AlphaMail.Pos.x, AlphaMail.Pos.y, AlphaMail.Pos.z)
                                            elseif Type == "IKEA" then
                                                SetNewWaypoint(IKEA.Pos.x, IKEA.Pos.y, IKEA.Pos.z)
                                            end
                                        end
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
        local coords = GetEntityCoords(ped)
        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
        local vheading = GetEntityHeading(vehicle)

            if hasCar then
                for i, v in ipairs(Config.WarehouseSpots) do
                    if HasRandomBox and i > HasRandomBox then break end
                    if not v.taked then
                        if (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 40) then
                            sleep = 7
                            DrawMarker(PackageMarker.Type, v.x, v.y, v.z - 0.95, 0.0, 0.0, 0.0, 0, 0.0, 0.0, PackageMarker.Size.x, PackageMarker.Size.y, PackageMarker.Size.z, PackageMarker.Color.r, PackageMarker.Color.g, PackageMarker.Color.b, 100, false, true, 2, false, false, false, false)
                            if not hasBox then
                                if (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 1.2) then
                                    sleep = 7
                                    DrawText3Ds(v.x, v.y, v.z + 0.4, "~g~[E]~s~ - Pickup package")
                                    if IsControlJustReleased(0, Keys["E"]) then
                                        if hasOpenDoor then
                                            exports.rprogress:Custom({
                                                Duration = 1500,
                                                Label = "패키지 박스를 선택합니다...",
                                                DisableControls = {
                                                    Mouse = false,
                                                    Player = true,
                                                    Vehicle = true
                                                }
                                            })
                                            Citizen.Wait(1500)
                                            addPackage()
                                            v.taked = true
                                            hasBox = true
                                            RemoveBlip(v.blip)
                                        elseif not hasOpenDoor then
                                            exports['okokNotify']:Alert("시스템", "차량의 뒷문을 열어주십시오.", 3000, 'error')
                                            exports.pNotify:SendNotification({text = "<b>창고</b></br>차량의 뒷문을 열어주십시오.", timeout = 5000})
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if Type == "GoPostal" then
                for i, v in ipairs(Config.GoPostal) do
                    if (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 15) then
                        sleep = 7
                        DrawMarker(PackageMarker.Type, v.x, v.y, v.z - 0.85, 0.0, 0.0, 0.0, 0, 0.0, 0.0, PackageMarker.Size.x, PackageMarker.Size.y, PackageMarker.Size.z, PackageMarker.Color.r, PackageMarker.Color.g, PackageMarker.Color.b, 100, false, true, 2, false, false, false, false)
                        if (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 1.2) then
                            if not hasBox then
                                DrawText3Ds(v.x, v.y, v.z + 0.4, "Take package from vehicle")
                            elseif hasBox then
                                DrawText3Ds(v.x, v.y, v.z + 0.4, "~g~[E]~s~ - Deliver package")
                                if IsControlJustReleased(0, Keys["E"]) then
                                    exports.rprogress:Custom({
                                        Duration = 1500,
                                        Label = "패키지 박스를 넣습니다...",
                                        DisableControls = {
                                            Mouse = false,
                                            Player = true,
                                            Vehicle = true
                                        }
                                    })
                                    Citizen.Wait(1500)
                                    removePackage()
                                    hasBox = false
                                    AmountPayout = AmountPayout + 1
                                    if AmountPayout == HasRandomBox then
                                        exports['okokNotify']:Alert("시스템", "모든 패키지 박스를 Gopostal에 배달한 후에 차량을 반납하고 감독관에게 가십시오!", 3000, 'info')
                                       
                                        SetNewWaypoint(Garage.Pos.x, Garage.Pos.y, Garage.Pos.z)
                                        Type = nil
                                        DeleteCompanyBlip()
                                    end
                                end
                            end
                        end
                    end
                end
            elseif Type == "Post OP" then
                for i, v in ipairs(Config.PostOP) do
                    if (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 15) then
                        sleep = 7
                        DrawMarker(PackageMarker.Type, v.x, v.y, v.z - 0.85, 0.0, 0.0, 0.0, 0, 0.0, 0.0, PackageMarker.Size.x, PackageMarker.Size.y, PackageMarker.Size.z, PackageMarker.Color.r, PackageMarker.Color.g, PackageMarker.Color.b, 100, false, true, 2, false, false, false, false)
                        if (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 1.2) then
                            if not hasBox then
                                DrawText3Ds(v.x, v.y, v.z + 0.4, "Take package from vehicle")
                            elseif hasBox then
                                DrawText3Ds(v.x, v.y, v.z + 0.4, "~g~[E]~s~ - Deliver package")
                                if IsControlJustReleased(0, Keys["E"]) then
                                    exports.rprogress:Custom({
                                        Duration = 1500,
                                        Label = "패키지 박스를 넣습니다...",
                                        DisableControls = {
                                            Mouse = false,
                                            Player = true,
                                            Vehicle = true
                                        }
                                    })
                                    Citizen.Wait(1500)
                                    removePackage()
                                    hasBox = false
                                    AmountPayout = AmountPayout + 1
                                    if AmountPayout == HasRandomBox then
                                        exports['okokNotify']:Alert("시스템", "모든 패키지 박스를 PostOP에 배달한 후에 차량을 반납하고 감독관에게 가십시오!", 3000, 'info')
                                        SetNewWaypoint(Garage.Pos.x, Garage.Pos.y, Garage.Pos.z)
                                        Type = nil
                                        DeleteCompanyBlip()
                                    end
                                end
                            end
                        end
                    end
                end
            elseif Type == "Alpha Mail" then
                for i, v in ipairs(Config.AlphaMail) do
                    if (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 15) then
                        sleep = 7
                        DrawMarker(PackageMarker.Type, v.x, v.y, v.z - 0.85, 0.0, 0.0, 0.0, 0, 0.0, 0.0, PackageMarker.Size.x, PackageMarker.Size.y, PackageMarker.Size.z, PackageMarker.Color.r, PackageMarker.Color.g, PackageMarker.Color.b, 100, false, true, 2, false, false, false, false)
                        if (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 1.2) then
                            if not hasBox then
                                DrawText3Ds(v.x, v.y, v.z + 0.4, "Take package from vehicle")
                            elseif hasBox then
                                DrawText3Ds(v.x, v.y, v.z + 0.4, "~g~[E]~s~ - Deliver package")
                                if IsControlJustReleased(0, Keys["E"]) then
                                    exports.rprogress:Custom({
                                        Duration = 1500,
                                        Label = "패키지 박스를 넣습니다...",
                                        DisableControls = {
                                            Mouse = false,
                                            Player = true,
                                            Vehicle = true
                                        }
                                    })
                                    Citizen.Wait(1500)
                                    removePackage()
                                    hasBox = false
                                    AmountPayout = AmountPayout + 1
                                    if AmountPayout == HasRandomBox then
                                        exports['okokNotify']:Alert("시스템", "모든 패키지 박스를 Alpha Mail에 배달한 후에 차량을 반납하고 감독관에게 가십시오!", 3000, 'info')
                                        SetNewWaypoint(Garage.Pos.x, Garage.Pos.y, Garage.Pos.z)
                                        Type = nil
                                        DeleteCompanyBlip()
                                    end
                                end
                            end
                        end
                    end
                end
            elseif Type == "IKEA" then
                for i, v in ipairs(Config.IKEA) do
                    if (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 15) then
                        sleep = 7
                        DrawMarker(PackageMarker.Type, v.x, v.y, v.z - 0.85, 0.0, 0.0, 0.0, 0, 0.0, 0.0, PackageMarker.Size.x, PackageMarker.Size.y, PackageMarker.Size.z, PackageMarker.Color.r, PackageMarker.Color.g, PackageMarker.Color.b, 100, false, true, 2, false, false, false, false)
                        if (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 1.2) then
                            if not hasBox then
                                DrawText3Ds(v.x, v.y, v.z + 0.4, "Take package from vehicle")
                            elseif hasBox then
                                DrawText3Ds(v.x, v.y, v.z + 0.4, "~g~[E]~s~ - Deliver package")
                                if IsControlJustReleased(0, Keys["E"]) then
                                    exports.rprogress:Custom({
                                        Duration = 1500,
                                        Label = "패키지 박스를 넣습니다...",
                                        DisableControls = {
                                            Mouse = false,
                                            Player = true,
                                            Vehicle = true
                                        }
                                    })
                                    Citizen.Wait(1500)
                                    removePackage()
                                    hasBox = false
                                    AmountPayout = AmountPayout + 1
                                    if AmountPayout == HasRandomBox then
                                        exports['okokNotify']:Alert("시스템", "모든 패키지 박스를 IKEA에 배달한 후에 차량을 반납하고 감독관에게 가십시오!", 3000, 'info')
                                        SetNewWaypoint(Garage.Pos.x, Garage.Pos.y, Garage.Pos.z)
                                        Type = nil
                                        DeleteCompanyBlip()
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

function Randomize(tb)
	local keys = {}
	for k in pairs(tb) do table.insert(keys, k) end
	return tb[keys[math.random(#keys)]]
end

function CreateWork(type)

    if type == "GoPostal" then
        for i, v in ipairs(Config.GoPostal) do
            v.blip = AddBlipForCoord(v.x, v.y, v.z)
            SetBlipSprite(v.blip, 318)
            SetBlipColour(v.blip, 24)
            SetBlipScale(v.blip, 0.6)
            SetBlipAsShortRange(v.blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString('[Warehouse] GoPostal')
            EndTextCommandSetBlipName(v.blip)
        end
    elseif type == "Post OP" then
        for i, v in ipairs(Config.PostOP) do
            v.blip = AddBlipForCoord(v.x, v.y, v.z)
            SetBlipSprite(v.blip, 318)
            SetBlipColour(v.blip, 24)
            SetBlipScale(v.blip, 0.6)
            SetBlipAsShortRange(v.blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString('[Warehouse] Post OP')
            EndTextCommandSetBlipName(v.blip)
        end
    elseif type == "Alpha Mail" then
        for i, v in ipairs(Config.AlphaMail) do
            v.blip = AddBlipForCoord(v.x, v.y, v.z)
            SetBlipSprite(v.blip, 318)
            SetBlipColour(v.blip, 24)
            SetBlipScale(v.blip, 0.6)
            SetBlipAsShortRange(v.blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString('[Warehouse] Alpha Mail')
            EndTextCommandSetBlipName(v.blip)
        end
    elseif type == "IKEA" then
        for i, v in ipairs(Config.IKEA) do
            v.blip = AddBlipForCoord(v.x, v.y, v.z)
            SetBlipSprite(v.blip, 318)
            SetBlipColour(v.blip, 24)
            SetBlipScale(v.blip, 0.6)
            SetBlipAsShortRange(v.blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString('[Warehouse] IKEA')
            EndTextCommandSetBlipName(v.blip)
        end
    end
    Type = type
end

function DeleteCompanyBlip()
    for i, v in ipairs(Config.PostOP) do
        RemoveBlip(v.blip)
    end
    for i, v in ipairs(Config.GoPostal) do
        RemoveBlip(v.blip)
    end
    for i, v in ipairs(Config.AlphaMail) do
        RemoveBlip(v.blip)
    end
    for i, v in ipairs(Config.IKEA) do
        RemoveBlip(v.blip)
    end
end

-- RETURNING VEHICLE
function ReturnVehicle()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped)

    ESX.Game.DeleteVehicle(vehicle)
end

-- MAIN BLIP
Citizen.CreateThread(function()
    mainBlip = AddBlipForCoord(JobStart.Pos.x, JobStart.Pos.y, JobStart.Pos.z)
    SetBlipSprite(mainBlip, 365)
    SetBlipDisplay(mainBlip, 4)
    SetBlipScale(mainBlip, JobStart.BlipScale)
    SetBlipAsShortRange(mainBlip, true)
    SetBlipColour(mainBlip, JobStart.BlipColor)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(JobStart.BlipLabel)
    EndTextCommandSetBlipName(mainBlip)
end)

-- ONDUTY BLIP
function addBlips()

    bossBlip = AddBlipForCoord(Boss.Pos.x, Boss.Pos.y, Boss.Pos.z)
    SetBlipSprite(bossBlip, 408)
    SetBlipDisplay(bossBlip, 4)
    SetBlipScale(bossBlip, Boss.BlipScale)
    SetBlipAsShortRange(bossBlip, true)
    SetBlipColour(bossBlip, Boss.BlipColor)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Boss.BlipLabel)
    EndTextCommandSetBlipName(bossBlip)
end

-- AFTER BOSS BLIPS
function addBlipsHRB()
    
    garageBlip = AddBlipForCoord(Garage.Pos.x, Garage.Pos.y, Garage.Pos.z)
    SetBlipSprite(garageBlip, 326)
    SetBlipDisplay(garageBlip, 4)
    SetBlipScale(garageBlip, Garage.BlipScale)
    SetBlipAsShortRange(garageBlip, true)
    SetBlipColour(garageBlip, Garage.BlipColor)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Garage.BlipLabel)
    EndTextCommandSetBlipName(garageBlip)
end

-- WORKING BLIPS
function BlipsOnWorking()
    for i, v in ipairs(Config.WarehouseSpots) do
        if HasRandomBox and i > HasRandomBox then break end
        v.blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(v.blip, 1)
        SetBlipColour(v.blip, 24)
        SetBlipScale(v.blip, 0.3)
        SetBlipAsShortRange(v.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName('[Warehouse] Packages')
        EndTextCommandSetBlipName(v.blip)
    end
end

function addPackage()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    RequestAnimDict("anim@heists@box_carry@")
    while (not HasAnimDictLoaded("anim@heists@box_carry@")) do
        Citizen.Wait(7)
    end
    TaskPlayAnim(GetPlayerPed(-1), "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
    pack = CreateObject(GetHashKey('prop_cs_cardbox_01'), coords.x, coords.y, coords.z,  true,  true, true)
    AttachEntityToEntity(pack, ped, GetPedBoneIndex(ped, 57005), 0.05, 0.1, -0.3, 300.0, 250.0, 20.0, true, true, false, true, 1, true)
end

function removePackage()
    local ped = PlayerPedId()

    ClearPedTasks(ped)
    DeleteEntity(pack)
end

function DrawText3Ds(x, y, z, text)
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
