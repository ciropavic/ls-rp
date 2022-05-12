-- CONFIG --
ESX = nil

-- AFK Kick Time Limit (in seconds)
secondsUntilKick = 24000

local time = secondsUntilKick

-- Warn players if 3/4 of the Time Limit ran up
kickWarning = true

-- CODE --

Citizen.CreateThread(function()
	while true do
		Wait(1000)
		while ESX == nil do
			TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
			Citizen.Wait(0)
		end
		
		playerPed = GetPlayerPed(-1)
		if playerPed then
			currentPos = GetEntityCoords(playerPed, true)
				if(GetPlayerGroup(PlayerId()) == "admin")then

				else
					if currentPos == prevPos then
						if time > 0 then
							if kickWarning and time == math.ceil(secondsUntilKick / 6) then
								TriggerEvent("chatMessage", "WARNING", {255, 0, 0}, " 장시간 움직임이 없어 " .. time .. " 킥처리 되었습니다.")
							end
							time = time - 1
						else
							TriggerServerEvent("kickForBeingAnAFKDouchebag")
						end
					else
						time = secondsUntilKick
					end
				end
			prevPos = currentPos
		end
	end
end)