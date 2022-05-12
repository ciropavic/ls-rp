if not Config.EnableESXIdentityIntegration then
    ESX = nil
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

    RegisterNetEvent('esx:onPlayerJoined')
    AddEventHandler('esx:onPlayerJoined', function()
        if not ESX.Players[source] then
            local identifier

            for k,v in ipairs(GetPlayerIdentifiers(source)) do
                if string.match(v, 'license:') then
                    identifier = string.sub(v, 9)
                    break 
                end
            end

            if identifier then
                MySQL.Async.fetchScalar('SELECT 1 FROM users WHERE identifier = @identifier', {
                    ['@identifier'] = identifier
                }, function(result)
                    if not result then

                        -- first login stuff

                        
                    else
                        
                        -- subsequent login stuff
                    end
                end)
            end
        end
    end)
end


ESX.RegisterUsableItem('surgeryTicket', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
  -- local itemQuantity = xPlayer.getInventoryItem('EngineParts').count
  xPlayer.triggerEvent('cui_character:open', { 'features' })
  TriggerClientEvent('inventory:closeditem',_source)
-- exports['inventory']:CloseInventory()
	-- TriggerClientEvent('cui_character:open', {'features'})
  xPlayer.removeInventoryItem('surgeryTicket', 1)

end)

RegisterServerEvent('cui_character:kick')
AddEventHandler('cui_character:kick', function()
    local xplayer = ESX.GetPlayerFromId(source);
    Citizen.Wait(3000)
	xplayer.kick("데이터를 저장합니다. FiveM 종료 후 재접속 해주십시오.")
    print("playerkick")
end)
    

RegisterServerEvent('cui_character:save')
AddEventHandler('cui_character:save', function(data)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.execute('UPDATE users SET skin = @data WHERE identifier = @identifier', {
        ['@data'] = json.encode(data),
        ['@identifier'] = xPlayer.identifier
    })

end)

RegisterServerEvent('esx_skin:save')
AddEventHandler('esx_skin:save', function(data)
    TriggerEvent('cui_character:save', data)
end)

ESX.RegisterServerCallback('esx_skin:getPlayerSkin', function(source, cb) -- 수정 코드 원래는 없었고 그 esx_skin에 존재 
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll('SELECT skin FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(users)
        local user = users[1]
        local skin = nil

        local jobSkin = {
            skin_male   = xPlayer.job.skin_male,
            skin_female = xPlayer.job.skin_female
        }

        if user.skin ~= nil then
            skin = json.decode(user.skin)
        end

        cb(skin, jobSkin)
    end)
end)

if Config.EnableESXIdentityIntegration then
    ESX.RegisterServerCallback('cui_character:updateIdentity', function(source, cb, data)
        local xPlayer = ESX.GetPlayerFromId(source)
        
        if xPlayer then
            -- print('namecheck : ',checkDuplicatedNameFormat(data.fisrtname, data.lastname))
            if checkNameFormat(data.firstname) and checkNameFormat(data.lastname) and checkSexFormat(data.sex) and checkDOBFormat(data.dateofbirth) and checkHeightFormat(data.height) then
                local playerIdentity = {}
                playerIdentity[xPlayer.identifier] = {
                    firstName = formatName(data.firstname),
                    lastName = formatName(data.lastname),
                    dateOfBirth = data.dateofbirth,
                    sex = data.sex,
                    height = data.height,
                    nationality = data.nationality
                }

                local currentIdentity = playerIdentity[xPlayer.identifier]

                xPlayer.setName(('%s %s'):format(currentIdentity.firstName, currentIdentity.lastName))
                xPlayer.set('firstName', currentIdentity.firstName)
                xPlayer.set('lastName', currentIdentity.lastName)
                xPlayer.set('dateofbirth', currentIdentity.dateOfBirth)
                xPlayer.set('sex', currentIdentity.sex)
                xPlayer.set('height', currentIdentity.height)
                xPlayer.set('nationality', currentIdentity.nationality)

                saveIdentityToDatabase(xPlayer.identifier, currentIdentity)
                cb(true)
              
            else
                cb(false)
            end
        end
    end)

    ESX.RegisterServerCallback('cui_character:getIdentity', function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)

        MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex, height, nationality FROM users WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        }, function(users)
            if(users ~= nil) then
                local user = users[1]
            end

            local identity = {}

            if user ~= nil then
                for k, v in pairs(user) do
                    identity[k] = v
                end
            end

            cb(identity)
        end)
    
    end)
end





-- function checkDuplicatedNameFormat(fisrtname, lastname)

--     local nameResult = MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE (fisrtname = @fisrtname AND lastname = @lastname)', {
--         ['@fisrtname'] = fisrtname,
--         ['@lastname'] = lastname
--     })
--     if nameResult[1] ~= nil then
--         return false
--     else
--         return true
--     end

-- end




ESX.RegisterCommand('character', 'admin', function(xPlayer, args, showError)
	xPlayer.triggerEvent('cui_character:open', { 'identity', 'features', 'style', 'apparel' })
    end, true, {help = 'Open full character editor.', validate = true, arguments = {}
})

ESX.RegisterCommand('identity', 'admin', function(xPlayer, args, showError)
	xPlayer.triggerEvent('cui_character:open', { 'identity' })
    end, true, {help = 'Open character identity editor.', validate = true, arguments = {}
})

ESX.RegisterCommand('features', 'admin', function(xPlayer, args, showError)
	xPlayer.triggerEvent('cui_character:open', { 'features' })
    end, true, {help = 'Open character physical features editor.', validate = true, arguments = {}
})

ESX.RegisterCommand('style', 'admin', function(xPlayer, args, showError)
	xPlayer.triggerEvent('cui_character:open', { 'style' })
    end, true, {help = 'Open character style editor.', validate = true, arguments = {}
})

ESX.RegisterCommand('apparel', 'admin', function(xPlayer, args, showError)
	xPlayer.triggerEvent('cui_character:open', { 'apparel' })
    end, true, {help = 'Open character apparel editor.', validate = true, arguments = {}
})


--삭제필요

RegisterCommand("routingbucket", function(source, args, rawCommand)
    SetPlayerRoutingBucket(source,50)
end, false)