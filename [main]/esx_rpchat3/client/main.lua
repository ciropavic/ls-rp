RegisterNetEvent('esx_rpchat:sendProximityMessage')
AddEventHandler('esx_rpchat:sendProximityMessage', function(playerId, title, message, color)
	local source = PlayerId()
	local target = GetPlayerFromServerId(playerId)

	local sourcePed, targetPed = PlayerPedId(), GetPlayerPed(target)
	local sourceCoords, targetCoords = GetEntityCoords(sourcePed), GetEntityCoords(targetPed)

	if target == source then
		TriggerEvent('chat:addMessage', { args = { title, message }, color = color })
	elseif GetDistanceBetweenCoords(sourceCoords, targetCoords, true) < 8 then
		TriggerEvent('chat:addMessage', { args = { title, message }, color = color })
	end
end)

RegisterNetEvent('esx_rpchat:sendProximityMessages')
AddEventHandler('esx_rpchat:sendProximityMessages', function(playerId, title, message, color)
	local source = PlayerId()
	local target = GetPlayerFromServerId(playerId)

	local sourcePed, targetPed = PlayerPedId(), GetPlayerPed(target)
	local sourceCoords, targetCoords = GetEntityCoords(sourcePed), GetEntityCoords(targetPed)

	if target == source then
		TriggerEvent('chat:addMessage', { args = { title, message }, color = color })
	elseif GetDistanceBetweenCoords(sourceCoords, targetCoords, true) < 19.99 then
		TriggerEvent('chat:addMessage', { args = { title, message }, color = color })
	end
end)

RegisterNetEvent('esx_rpchat:sendProximityMessagec')
AddEventHandler('esx_rpchat:sendProximityMessagec', function(playerId, title, message, color)
	local source = PlayerId()
	local target = GetPlayerFromServerId(playerId)

	local sourcePed, targetPed = PlayerPedId(), GetPlayerPed(target)
	local sourceCoords, targetCoords = GetEntityCoords(sourcePed), GetEntityCoords(targetPed)

	if target == source then
		TriggerEvent('chat:addMessage', { args = { title, message }, color = color })
	elseif GetDistanceBetweenCoords(sourceCoords, targetCoords, true) < 2 then
		TriggerEvent('chat:addMessage', { args = { title, message }, color = color })
	end
end)

Citizen.CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/twt',  _U('twt_help'),  { { name = _U('generic_argument_name'), help = _U('generic_argument_help') } } )
	TriggerEvent('chat:addSuggestion', '/me',   _U('me_help'),   { { name = _U('generic_argument_name'), help = _U('generic_argument_help') } } )
	TriggerEvent('chat:addSuggestion', '/st',   _U('st_help'),   { { name = _U('generic_argument_name'), help = _U('generic_argument_help') } } )
	TriggerEvent('chat:addSuggestion', '/th',   _U('th_help'),   { { name = _U('generic_argument_name'), help = _U('generic_argument_help') } } )
	TriggerEvent('chat:addSuggestion', '/ooc',   _U('ooc_help'),   { { name = _U('generic_argument_name'), help = _U('generic_argument_help') } } )
	TriggerEvent('chat:addSuggestion', '/광고',   _U('광고_help'),   { { name = _U('generic_argument_name'), help = _U('generic_argument_help') } } )
	TriggerEvent('chat:addSuggestion', '/질문',   _U('질문_help'),   { { name = _U('generic_argument_name'), help = _U('generic_argument_help') } } )
	TriggerEvent('chat:addSuggestion', '/so',   _U('so_help'),   { { name = _U('generic_argument_name'), help = _U('generic_argument_help') } } )
	TriggerEvent('chat:addSuggestion', '/답변',   _U('답변_help'),   { { name = _U('generic_argument_name'), help = _U('generic_argument_help') } } )
	TriggerEvent('chat:addSuggestion', '/b',   _U('답변_help'),   { { name = _U('generic_argument_name'), help = _U('generic_argument_help') } } )
	TriggerEvent('chat:addSuggestion', '/b',   _U('s_help'),   { { name = _U('generic_argument_name'), help = _U('generic_argument_help') } } )
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('chat:removeSuggestion', '/twt')
		TriggerEvent('chat:removeSuggestion', '/me')
		TriggerEvent('chat:removeSuggestion', '/st')
		TriggerEvent('chat:removeSuggestion', '/th')
		TriggerEvent('chat:removeSuggestion', '/ooc')
		TriggerEvent('chat:removeSuggestion', '/질문')
		TriggerEvent('chat:removeSuggestion', '/광고')
		TriggerEvent('chat:removeSuggestion', '/so')
		TriggerEvent('chat:removeSuggestion', '/답변')
		TriggerEvent('chat:removeSuggestion', '/b')
		TriggerEvent('chat:removeSuggestion', '/s')
	end
end)
