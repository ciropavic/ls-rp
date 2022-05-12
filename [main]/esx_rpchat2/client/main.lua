---- 효성 제작 

-- 소리 (/so)
RegisterNetEvent('esx_rpchat:sendso')
AddEventHandler('esx_rpchat:sendso', function(playerId, title, message, color)
	local source = PlayerId()
	local target = GetPlayerFromServerId(playerId)

	if target ~= -1 then
	local sourcePed, targetPed = PlayerPedId(), GetPlayerPed(target)
	local sourceCoords, targetCoords = GetEntityCoords(sourcePed), GetEntityCoords(targetPed)

	if targetPed == source or #(sourceCoords - targetCoords) < 20 then
		TriggerEvent('chatMessage', "", {255, 153, 255}, " ^* (소리) " .. title .."이(가) ".." " .. message)
	end
  end
end)

-- 질문 (/질문)
RegisterNetEvent('esx_rpchat:sendQuestion')
AddEventHandler('esx_rpchat:sendQuestion', function(playerId, title, message, color)
	local source = PlayerId()
	local target = GetPlayerFromServerId(playerId)

	if target ~= -1 then
	local sourcePed, targetPed = PlayerPedId(), GetPlayerPed(target)
	local sourceCoords, targetCoords = GetEntityCoords(sourcePed), GetEntityCoords(targetPed)

	if targetPed == source then
		TriggerEvent('chatMessage', "", {1, 190, 1}, " ^* (질문) " .. title .."이(가) ".." " .. message)
	end
  end
end)

-- 답변 (/답변)
RegisterNetEvent('esx_rpchat:sendAnswer')
AddEventHandler('esx_rpchat:sendAnswer', function(playerId, title, message, color)
	local source = PlayerId()
	local target = GetPlayerFromServerId(playerId)

	if target ~= -1 then
	local sourcePed, targetPed = PlayerPedId(), GetPlayerPed(target)
	local sourceCoords, targetCoords = GetEntityCoords(sourcePed), GetEntityCoords(targetPed)

	if targetPed == source then
		TriggerEvent('chatMessage', "", {1, 190, 1}, " ^* (답변) " .. title .."이(가) ".." " .. message)
	end
  end
end)


---- 효성

RegisterNetEvent('esx_rpchat:sendMe')
AddEventHandler('esx_rpchat:sendMe', function(playerId, title, message, color)
	local source = PlayerId()
	local target = GetPlayerFromServerId(playerId)

	if target ~= -1 then
	local sourcePed, targetPed = PlayerPedId(), GetPlayerPed(target)
	local sourceCoords, targetCoords = GetEntityCoords(sourcePed), GetEntityCoords(targetPed)

	if targetPed == source or #(sourceCoords - targetCoords) < 20 then
		TriggerEvent('chatMessage', "", {209, 185, 227}, " ^* (행동) " .. title .."이(가) ".." " .. message)
	end
  end
end)

RegisterNetEvent('esx_rpchat:sendDo')
AddEventHandler('esx_rpchat:sendDo', function(playerId, title, message, color)
	local source = PlayerId()
	local target = GetPlayerFromServerId(playerId)

	if target ~= -1 then
	local sourcePed, targetPed = PlayerPedId(), GetPlayerPed(target)
	local sourceCoords, targetCoords = GetEntityCoords(sourcePed), GetEntityCoords(targetPed)

	if targetPed == source or #(sourceCoords - targetCoords) < 20 then
		-- TriggerEvent('chat:addMessage', {args = { title, message }, color = color})
		TriggerEvent('chatMessage', "", {173, 255, 47}, " ^* (상태) " .. title .."이(가) ".." " .. message)
	end
  end
end)

RegisterNetEvent('esx_rpchat:sendShout')
AddEventHandler('esx_rpchat:sendShout', function(playerId, title, message, color)
	local source = PlayerId()
	local target = GetPlayerFromServerId(playerId)

	if target ~= -1 then
	local sourcePed, targetPed = PlayerPedId(), GetPlayerPed(target)
	local sourceCoords, targetCoords = GetEntityCoords(sourcePed), GetEntityCoords(targetPed)

	if targetPed == source or #(sourceCoords - targetCoords) < 30 then
		-- TriggerEvent('chat:addMessage', {args = { title, message }, color = color})
	  TriggerEvent('chatMessage', "" .. title .. "^*의 외침", {230, 230, 230}, "" .. message .. "!")
	end
  end
end)

RegisterNetEvent('esx_rpchat:sendLocalOOC')
AddEventHandler('esx_rpchat:sendLocalOOC', function(playerId, title, message, color)
	local source = PlayerId()
	local target = GetPlayerFromServerId(playerId)

	if target ~= -1 then
	local sourcePed, targetPed = PlayerPedId(), GetPlayerPed(target)
	local sourceCoords, targetCoords = GetEntityCoords(sourcePed), GetEntityCoords(targetPed)

	if targetPed == source or #(sourceCoords - targetCoords) < 25 then
		TriggerEvent('chatMessage', "^*" .. title .. "", {230, 230, 230}, "" .. message)
	end
  end
end)



RegisterNetEvent('esx_rpchat:sendOOC')
AddEventHandler('esx_rpchat:sendOOC', function(playerId, title, message, color)
	local source = PlayerId()
	local target = GetPlayerFromServerId(playerId)

	if target ~= -1 then
	local sourcePed, targetPed = PlayerPedId(), GetPlayerPed(target)
	local sourceCoords, targetCoords = GetEntityCoords(sourcePed), GetEntityCoords(targetPed)

	if targetPed == source or #(sourceCoords - targetCoords) < 25 then
		TriggerEvent('chatMessage', "", {128, 128, 128}, " ^* (( (".. playerId .. ") " .. title .."  ".." : " .. message.."  ))")
	end
  end
end)
RegisterNetEvent('esx_rpchat:getCoords')
AddEventHandler('esx_rpchat:getCoords', function(player)
	local ped = PlayerPedId()
    local coords = GetEntityCoords(ped, false)
    local heading = GetEntityHeading(ped)

    local message = tostring("X: " .. coords.x .. " Y: " .. coords.y .. " Z: " .. coords.z .. " HEADING: " .. heading)
    TriggerServerEvent('esx_rpchat:showCoord', player, message)

end)

Citizen.CreateThread(function()
  TriggerEvent('chat:addSuggestion', '/tweet',  _U('twt_help'),  { { name = _U('generic_argument_name'), help = _U('generic_argument_help') } } )
  TriggerEvent('chat:addSuggestion', '/twt',  _U('twt_help'),  { { name = _U('generic_argument_name'), help = _U('generic_argument_help') } } )
  TriggerEvent('chat:addSuggestion', '/anontwt',  _U('anontwt_help'),  { { name = _U('generic_argument_name'), help = _U('generic_argument_help') } } )
	TriggerEvent('chat:addSuggestion', '/me',   _U('me_help'),   { { name = _U('generic_argument_name'), help = _U('generic_argument_help') } } )
	TriggerEvent('chat:addSuggestion', '/do',   _U('do_help'),   { { name = _U('generic_argument_name'), help = _U('generic_argument_help') } } )
	TriggerEvent('chat:addSuggestion', '/ooc', _U('ooc_help'),   { { name = _U('generic_argument_name'), help = _U('generic_argument_help') } } )
	TriggerEvent('chat:addSuggestion', '/news', 'Globálna informácia z frakcie Weazel News (iba pre redaktorov)',   { { name = _U('generic_argument_name'), help = _U('generic_argument_help') } } )
	TriggerEvent('chat:addSuggestion', '/inzerat', 'odoslanie inzerátu - stojí 250$!',   { { name = _U('generic_argument_name'), help = _U('generic_argument_help') } } )
  TriggerEvent('chat:addSuggestion', '/police', 'Oznámenie polície - len pre políciu!',   { { name = _U('generic_argument_name'), help = _U('generic_argument_help') } } )
  TriggerEvent('chat:addSuggestion', '/ens', 'Oznámení Ambulance - pro ems!',   { { name = _U('generic_argument_name'), help = _U('generic_argument_help') } } )
  --TriggerEvent('chat:addSuggestion', '/sheriff', 'Oznámenie Sheriff - pro sheriffy!',   { { name = _U('generic_argument_name'), help = _U('generic_argument_help') } } )
	--TriggerEvent('chat:addSuggestion', '/gps', 'Zobrazí vám vašu aktuálnu pozíciu (súradnice XYZ a smer pohľadu)')
	TriggerEvent('chat:addSuggestion', '/doc', 'Napise za vas proces napriklad /do 1/10 (max 100)', { { name = 'pocet', help = 'pocet opakovani' } } )
  --if PlayerData.job ~= nil and PlayerData.job.name ~= 'police' then
  	--TriggerEvent('chat:addSuggestion', '/bm',   _U('bm_prefix'),   { { name = _U('generic_argument_name'), help = _U('generic_argument_help') } } )
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		--TriggerEvent('chat:removeSuggestion', '/tweet')
		--TriggerEvent('chat:removeSuggestion', '/me')
		--TriggerEvent('chat:removeSuggestion', '/do')
    -- TriggerEvent('chat:removeSuggestion', '/bm')
    -- TriggerEvent('chat:removeSuggestion', '/rk')
    -- TriggerEvent('chat:removeSuggestion', '/rukojmi')
    -- TriggerEvent('chat:removeSuggestion', '/nazada')
    -- TriggerEvent('chat:removeSuggestion', '/narameno')
    -- TriggerEvent('chat:removeSuggestion', '/givecar')
    -- TriggerEvent('chat:removeSuggestion', '/givecarplate')
	--	TriggerEvent('chat:removeSuggestion', '/news')
		--TriggerEvent('chat:removeSuggestion', '/inzerat')
		TriggerEvent('chat:removeSuggestion', '/gps')
		--*TriggerEvent('chat:removeSuggestion', '/doc')
	end
end)