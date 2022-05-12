RegisterNetEvent("tutorial:spawn")
AddEventHandler("tutorial:spawn", function()
    DoScreenFadeOut(1000)
  	-- Here is where you set where you want to player to spawn after they complete the tutorial
    Citizen.Wait(1000)
    DoScreenFadeIn(1000)   
end)





