--AddEventHandler('es:invalidCommandHandler', function(source, command_args, user)
	--CancelEvent()
	--TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', _U('unknown_command', command_args[1]) } })
--end)

AddEventHandler('chatMessage', function(source, name, message)
if string.sub(message, 1, string.len("/")) ~= "/" then
	local name = GetPlayerName(source)
	if Config.EnableESXIdentity then name = GetCharacterName(source) end
  TriggerClientEvent("esx_rpchat:sendProximityMessage", -1, source, name, message)
end
CancelEvent()
end)

RegisterCommand('me', function(source, args, rawCommand)
	if source == 0 then
		print('esx_rpchat: you can\'t use this command from rcon!')
		return
	end

	args = table.concat(args, ' ')
	local name = GetPlayerName(source)
	if Config.EnableESXIdentity then name = GetCharacterName(source) end

	TriggerClientEvent('esx_rpchat:sendProximityMessage', -1, source, _U('me_prefix', name)..args)
	print(('%s %s'):format(name, args))
end, false)

RegisterCommand('do', function(source, args, rawCommand)
	if source == 0 then
		print('esx_rpchat: you can\'t use this command from rcon!')
		return
	end

	args = table.concat(args, ' ')
	local name = GetPlayerName(source)
	if Config.EnableESXIdentity then name = GetCharacterName(source) end

	TriggerClientEvent('esx_rpchat:sendProximityMessage', -1, source, args.. _U('st_prefix', name))
	print(('%s %s'):format(name, args))
end, false)

--RegisterCommand('th', function(source, args, rawCommand)
	--if source == 0 then
	--	print('esx_rpchat: you can\'t use this command from rcon!')
	--	return
--	end

	--args = table.concat(args, ' ')
--	local name = GetPlayerName(source)
--	if Config.EnableESXIdentity then name = GetCharacterName(source) end

--	TriggerClientEvent('esx_rpchat:sendProximityMessage', -1, source, _U('th_prefix', name), args, { 77, 255, 77 })
--	print(('%s: %s'):format(name, args))
--end, false)

RegisterCommand('b', function(source, args, rawCommand)
	if source == 0 then
		print('esx_rpchat: you can\'t use this command from rcon!')
		return
	end

	args = table.concat(args, ' ')
	local name = GetPlayerName(source)
	if Config.EnableESXIdentity then name = GetCharacterName(source) end

	TriggerClientEvent('esx_rpchat:sendProximityMessage', -1, source, _U('b_prefix', name), args, { 204, 204, 204 })
	print(('%s %s'):format(name, args))
end, false)

--RegisterCommand('ooc', function(source, args, rawCommand)
	--if source == 0 then
	--	print('esx_rpchat: you can\'t use this command from rcon!')
	--	return
--	end

--	args = table.concat(args, ' ')
--	local name = GetPlayerName(source)
--	if Config.EnableESXIdentity then name = GetCharacterName(source) end

--	TriggerClientEvent('chat:addMessage', -1, { args = { _U('ooc_prefix', name), args }, color = { 168, 168, 168 } })
--	print(('%s: %s'):format(name, args))
--end, false) 

RegisterCommand('질문', function(source, args, rawCommand)
	if source == 0 then
		print('esx_rpchat: you can\'t use this command from rcon!')
		return
	end

	args = table.concat(args, ' ')
	local name = GetPlayerName(source)
	if Config.EnableESXIdentity then name = GetCharacterName(source) end

	TriggerClientEvent('chat:addMessage', -1, { args = { _U('질문_prefix', name), args }, color = { 255, 179, 255 } })
	print(('%s %s'):format(name, args))
end, false)

RegisterCommand('답변', function(source, args, rawCommand)
	if source == 0 then
		print('esx_rpchat: you can\'t use this command from rcon!')
		return
	end

	args = table.concat(args, ' ')
	local name = GetPlayerName(source)
	if Config.EnableESXIdentity then name = GetCharacterName(source) end

	TriggerClientEvent('chat:addMessage', -1, { args = { _U('답변_prefix', name), args }, color = { 153, 255, 51 } })
	print(('%s %s'):format(name, args))
end, false)

-- RegisterCommand('~~~', function(source, args, rawCommand)
-- 	if source == 0 then
-- 		print('esx_rpchat: you can\'t use this command from rcon!')
-- 		return
-- 	end

-- 	args = table.concat(args, ' ')
-- 	local name = GetPlayerName(source)
-- 	if Config.EnableESXIdentity then name = GetCharacterName(source) end

-- 	TriggerClientEvent('chat:addMessage', -1, { args = { _U('공지_prefix', name), args }, color = { 255, 0, 1 } })
-- 	print(('%s %s'):format(name, args))
-- end, false)


--RegisterCommand('광고', function(source, args, rawCommand)
--	if source == 0 then
	--	print('esx_rpchat: you can\'t use this command from rcon!')
--		return
--	end

	--args = table.concat(args, ' ')
--	local name = GetPlayerName(source)
--	if Config.EnableESXIdentity then name = GetCharacterName(source) end

--	TriggerClientEvent('chat:addMessage', -1, { args = { _U('광고_prefix', name), args }, color = { 153, 255, 102 } })
--	print(('%s: %s'):format(name, args))
--end, false)

RegisterCommand('so', function(source, args, rawCommand)
	if source == 0 then
		print('esx_rpchat: you can\'t use this command from rcon!')
		return
	end

	args = table.concat(args, ' ')
	local name = GetPlayerName(source)
	if Config.EnableESXIdentity then name = GetCharacterName(source) end

	TriggerClientEvent('esx_rpchat:sendProximityMessage', -1, source, _U('so_prefix', name), args, { 51, 153, 102 })
	print(('%s %s'):format(name, args))
end, false)

RegisterCommand('s', function(source, args, rawCommand)
	if source == 0 then
		print('esx_rpchat: you can\'t use this command from rcon!')
		return
	end

	args = table.concat(args, ' ')
	local name = GetPlayerName(source)
	if Config.EnableESXIdentity then name = GetCharacterName(source) end

	TriggerClientEvent('esx_rpchat:sendProximityMessages', -1, source, _U('s_prefix', name), args .. "!")
	print(('%s %s !'):format(name, args))
end, false)

RegisterCommand('c', function(source, args, rawCommand)
	if source == 0 then
		print('esx_rpchat: you can\'t use this command from rcon!')
		return
	end

	args = table.concat(args, ' ')
	local name = GetPlayerName(source)
	if Config.EnableESXIdentity then name = GetCharacterName(source) end

	TriggerClientEvent('esx_rpchat:sendProximityMessagec', -1, source, _U('c_prefix', name), args)
	print(('%s %s'):format(name, args))
end, false)

function GetCharacterName(source)
	local result = MySQL.Sync.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier', {
		['@identifier'] = GetPlayerIdentifiers(source)[1]
	})

	if result[1] and result[1].firstname and result[1].lastname then
		if Config.OnlyFirstname then
			return result[1].firstname
		else
			return ('%s %s'):format(result[1].firstname, result[1].lastname)
		end
	else
		return GetPlayerName(source)
	end
end
