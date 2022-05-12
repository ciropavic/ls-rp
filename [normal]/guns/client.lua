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

    end
end)


RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(response)
	ESX.PlayerData = response

end)


RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(response)
	ESX.PlayerData["job"] = response
end)

RegisterCommand("getgun2", function ()
    TriggerServerEvent('guns:getweapon',"WEAPON_GLOCK19",10)
end)

-- RegisterCommand("통화",function ()
    
-- end)

RegisterNetEvent('sendtell')
AddEventHandler('sendtell', function(id, tid, name, tname, message)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  

  TriggerEvent('chatMessage', "", {255,255,1}, "^*(( " .. name .."("..id .. ")".."가 ".. tname.."(" .. tid.. ")".."에게 보낸 OOCPM".. " : " .. message .. " ))")
end)

RegisterNetEvent('receivetell')
AddEventHandler('receivetell', function(id, tid, name, tname, message)
  TriggerEvent('chatMessage', "", {255,255,1}, "^*(( " .. name .."("..id .. ")".."가 ".. tname.."(" .. tid.. ")".."에게 보낸 OOCPM".. " : " .. message .. " ))")
end)

-- RegisterCommand("getgun", function ()
--     -- RemoveAllPedWeapons(GetPlayerPed(-1), true)
--     print("TestGun")
--     -- notify("~r~ start")
--     ESX.TriggerServerCallback("guns:giveWeapon", function(accountavailable)

--         GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_GLOCK19"), 1, false, true)
--         SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_GLOCK19"), true)
--         -- TaskPlayAnim(PlayerPedId(), animLib, anim .. "_on_counter", 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)
--         RemoveWeaponFromPed(GetPlayerPed(-1), GetHashKey("WEAPON_GLOCK19"))
--         TriggerServerEvent("guns:getweapon", "WEAPON_GLOCK19", 10)


-- end)
--     -- notify("~r~ Clear All Weapons")
-- end)
-- weapon_knife

-- RegisterCommand("clear", function ()
--     RemoveAllPedWeapons(GetPlayerPed(-1), true)
--     notify("~r~ Clear All Weapons")
-- end)

-- local cars = {"adder", "comat", "cheetah", "faggio"}
-- RegisterCommand("car",function ()
--     local car = (cars[math.random(#cars)])
--     spawnCar(car)
--     print("차랑루")
--     notify("~p~Spawned car : ~h~~g~" .. car)
    
-- end)

-- RegisterCommand("die",function ()
--     SetEntityHealth(PlayerPedId(), 150)
--     print("다이")
--     alert("다이2")
--     notify("~r~ You died.")
-- end)

-- RegisterCommand("die2",function ()
--     SetEntityHealth(PlayerPedId(), 120)
--     print("다이")
--     alert("다이2")
--     notify("~r~ You died.")
-- end)

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