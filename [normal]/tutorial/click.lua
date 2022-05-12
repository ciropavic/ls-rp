
-- Change this to your server name
local servername = "LSRP"; 

local menuEnabled = false 

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(0)
-- 		if menuenabled == true then
-- 			SetNuiFocus(true,true)
-- 		else
-- 			SetNuiFocus(false,false)
-- 		end
-- 	end
-- end)

AddEventHandler("playerSpawned", function(spawn)
	print("playerspawn")
   	TriggerServerEvent('tutorial:firstspawn')
	-- TriggerEvent('cui_character:open', { 'identity', 'features', 'style', 'apparel' }, false)

end)

RegisterNetEvent("ToggleActionmenu")
AddEventHandler("ToggleActionmenu", function()
	ToggleActionMenu()
end)

RegisterNetEvent("KillTutorialMenu")
AddEventHandler("KillTutorialMenu", function()
	killTutorialMenu() 
end)

function ToggleActionMenu()
	Citizen.Trace("tutorial launch")
	menuEnabled = not menuEnabled
	if ( menuEnabled ) then 
		SetNuiFocus( true, true ) 
        TriggerServerEvent("bucketsys:create")

		SendNUIMessage({
			showPlayerMenu = true 
		})
	else 
		SetNuiFocus( false,false )
		SendNUIMessage({
			showPlayerMenu = false
		})
	end 
end 

function killTutorialMenu() 
SetNuiFocus( false,false )
		SendNUIMessage({
			showPlayerMenu = false
		})
		menuEnabled = false

end


RegisterNUICallback('close', function(data, cb)  
  ToggleActionMenu()
  cb('ok')
end)


RegisterNUICallback('spawnButton', function(data, cb) 

	TriggerEvent("tutorial:spawn", source)
	SetNotificationTextEntry("STRING")
  	AddTextComponentString("~g~Tutorial completed. ~w~Welcome to ~b~".. servername .."~w~!")
  	DrawNotification(true, false)
	TriggerEvent('cui_character:open', { 'identity', 'features', 'style', 'apparel' }, false)
	-- SetPedCoordsKeepVehicle(GetPlayerPed(-1), -1037.41, -2737.29, 20.2)
	-- TriggerServerEvent('cui_character:kick')
	menuEnabled = false

	SendNUIMessage({
		showPlayerMenu = false
	})
	print("focus false")
	SetNuiFocus(false,false)
  	cb('ok')

end)




