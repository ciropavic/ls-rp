ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('test0110:MarkerPoint')
AddEventHandler('test0110:MarkerPoint',function(x,y,z)
    print(x)
    print(y)
    print(z)
    ClearGpsCustomRoute()
    StartGpsMultiRoute(6, true, true)

    -- Add the points
    AddPointToGpsCustomRoute(x,y,z)
    AddPointToGpsCustomRoute(x+0.1,y+0.1,z+0.1)
    -- Set the route to render
    SetGpsCustomRouteRender(true, 16, 16)
end)

RegisterCommand(
    "long",
    function(source, args)

        TriggerServerEvent('test0110:test')

        -- ESX.TriggerServerCallback("test0110:testcheck", function(result)
        --   if result then
        -- print("tsss") 
        -- else
        --     print("t0000")   
        --   end
        -- end,1000)

        -- local blip = AddBlipForCoord(2030,4980 ,41)
        -- SetBlipSprite (blip, 754)
        -- SetBlipDisplay(blip, 4)
        -- SetBlipScale  (blip, 1.1)
        -- SetBlipColour (blip, 17)
        -- SetBlipAsShortRange(blip, true)
        -- BeginTextCommandSetBlipName("STRING")
        -- AddTextComponentString("test")
        -- EndTextCommandSetBlipName(blip)
    end
)
