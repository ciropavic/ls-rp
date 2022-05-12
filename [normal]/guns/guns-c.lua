
RegisterCommand("getgun", function ()
    -- RemoveAllPedWeapons(GetPlayerPed(-1), true)
    print("ㅇㅇㅇ")
    notify("~r~ start")
    ESX.TriggerServerCallback("guns:giveWeapon", function(accountavailable)

        GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_GLOCK19"), 1, false, true)
        SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_GLOCK19"), true)
        -- TaskPlayAnim(PlayerPedId(), animLib, anim .. "_on_counter", 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)
        RemoveWeaponFromPed(GetPlayerPed(-1), GetHashKey("WEAPON_GLOCK19"))
        TriggerServerEvent("guns:getweapon", "WEAPON_GLOCK19", 10)


end)
    notify("~r~ Clear All Weapons")
end)

RegisterCommand("getgun2", function ()
    print("하이루")
end)
-- RegisterCommand("clear", function ()
--     RemoveAllPedWeapons(GetPlayerPed(-1), true)
--     notify("~r~ Clear All Weapons")
-- end)


local cars = {"adder", "comat", "cheetah", "faggio"}
RegisterCommand("car",function ()
    local car = (cars[math.random(#cars)])
    spawnCar(car)
    print("차랑루")
    notify("~p~Spawned car : ~h~~g~" .. car)
    
end)

RegisterCommand("die",function ()
    SetEntityHealth(PlayerPedId(), 150)
    print("다이")
    alert("다이2")
    notify("~r~ You died.")
end)

RegisterCommand("die2",function ()
    SetEntityHealth(PlayerPedId(), 120)
    print("다이")
    alert("다이2")
    notify("~r~ You died.")
end)

-- RegisterCommand("gun2", function ()
--     xPlayer.addWeapon('WEAPON_PISTOL', 10)
--     notify("~r~ You gun.")
--     -- giveweapon(GetPlayerPed(-1),"weapon_pistol", 100)
-- end)

-- Citizen.CreateThread(function()

--     local h_key = 74
--     local x_key = 73

--     while true do 
--         Citizen.Wait(1)
--         if IsControlJustReleased(1,h_key) then
--             print("The Key " .. h_key .. "was pressed")
--             giveWeapon("weapon_pistol")
--             giveWeapon("weapon_pumpshotgun")
--             weaponComponent('weapon_pumpshotgun',"COMPONENT_AT_AR_FLSH")
--              weaponComponent('weapon_pumpshotgun',"COMPONENT_AT_SR_SUPP")
--             alert("~b~ Given Weapons With ~INPUT_VEH_HEADLIGHT~")
--         end
--     end

-- end)