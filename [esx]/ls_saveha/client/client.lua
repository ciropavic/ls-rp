
ESX = nil
local citizensave = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(500)
	end
end)



RegisterNetEvent('ls_saveha:Client:SetPlayerHealthArmour')
AddEventHandler('ls_saveha:Client:SetPlayerHealthArmour', function(health, armour)
    
    SetPedMaxHealth(PlayerPedId(), 200)
    ESX.SetTimeout(5000, function()
        print(health)
        SetEntityHealth(PlayerPedId(), tonumber(health))
        SetPedArmour(PlayerPedId(), tonumber(armour))
        citizensave = true
    end)
end)

local TimeFreshCurrentArmour = 30000
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if citizensave == true then
            TriggerServerEvent('ls_saveha:Server:RefreshCurrent', GetEntityHealth(PlayerPedId()), GetPedArmour(PlayerPedId()))
            Citizen.Wait(TimeFreshCurrentArmour)
        end
    end
end)
