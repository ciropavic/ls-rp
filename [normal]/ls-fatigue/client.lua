
ESX          = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)



-- RegisterCommand("fatigue",'admin' ,function ()
--     TriggerServerEvent("ls-fatigue:fatigueset",5)
-- end)

-- RegisterCommand("test2",function ()
--     print("test2")
-- end)

Citizen.CreateThread(function()
	while true do
	Wait(60000)
	TriggerServerEvent("ls-fatigue:fatigueset")     
	end
	
	end)

RegisterCommand("오류해결", function ()
	TriggerServerEvent("ls-fatigue:bk")
	TriggerServerEvent('buketsys:cl')
	-- SetPlayerRoutingBucket(source, 0)
	
	print("Buket End")
end)