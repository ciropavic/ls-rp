TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("kickForBeingAnAFKDouchebag")
AddEventHandler("kickForBeingAnAFKDouchebag", function()
	local xplayer = ESX.GetPlayerFromId(source);
	xplayer.kick("장기간 미활동으로 킥처리 되었습니다. FiveM을 종료 후 재접속 해주십시오.")
end)

ESX.RegisterServerCallback("ifAdmin",function(source,cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	local group = xPlayer.getGroup()
	if(group == "admin") then
		cb(true)
	else
		cb(false)
	end
	
end)