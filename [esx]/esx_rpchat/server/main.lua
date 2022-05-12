--[[

  ESX RP Chat

--]]

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function getIdentity(source)
    local ms = ESX.GetPlayerFromId(source)
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = ms.identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			height = identity['height'],
            job = identity['job'],
			permission_level = identity['permission_level'],
            aname = identity['adminname'],
            radioch = identity['radioch']
		}
	else
		return nil
	end
end

-- 인 게임 채팅
AddEventHandler('chatMessage', function(source, name, message)
    if string.sub(message, 1, string.len("/")) ~= "/" then
        CancelEvent()

        local iden = getIdentity(source)
        local name = ('%s %s'):format(iden.firstname, iden.lastname)
        TriggerClientEvent("sendProximityMessage", -1, source, name, message)
    end
end)

-- /외침
RegisterCommand('s', function(source, args, user)
    local iden = getIdentity(source)
    local name = ('%s %s'):format(iden.firstname, iden.lastname)
    TriggerClientEvent("sendProximityMessageShout", -1, source, name, table.concat(args, " "))
end, false)

RegisterCommand('스탯', function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(source)
    local iden = getIdentity(source)
    local name = ('%s %s'):format(iden.firstname, iden.lastname)
    local fishinglevel = MySQL.Sync.fetchAll("SELECT fishinglevel FROM users WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier})
    local mechaniclevel = MySQL.Sync.fetchAll("SELECT mechaniclevel FROM users WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier})
    local warehouselevel = MySQL.Sync.fetchAll("SELECT warehouselevel FROM users WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier})
    local craftingexp = MySQL.Sync.fetchAll("SELECT crafting_level FROM users WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier})
    local farmerexp = MySQL.Sync.fetchAll("SELECT farmerlevel FROM users WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier})
    local fruitexp = MySQL.Sync.fetchAll("SELECT fruitlevel FROM users WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier})
    local huntingexp = MySQL.Sync.fetchAll("SELECT huntinglevel FROM users WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier})
    local barexp = MySQL.Sync.fetchAll("SELECT barlevel FROM users WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier})
    local timePlay = MySQL.Sync.fetchAll("SELECT timePlay FROM users WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier})
    local job = xPlayer.job.grade_label

    timePlay = timePlay[1].timePlay
    fishinglevel = fishinglevel[1].fishinglevel + 1
    mechaniclevel = mechaniclevel[1].mechaniclevel + 1
    warehouselevel = warehouselevel[1].warehouselevel + 1
    local craftinglevel = craftingexp[1].crafting_level / 100 + 1
    local farmerlevel = farmerexp[1].farmerlevel / 100 + 1
    local fruitlevel = fruitexp[1].fruitlevel / 100 + 1
    local huntinglevel = huntingexp[1].huntinglevel / 100 + 1
    local barlevel = barexp[1].barlevel / 100 + 1
    local stats = {crafting = craftinglevel, fishing = fishinglevel, mechanic = mechaniclevel, warehouse = warehouselevel, farmer = farmerlevel, fruit = fruitlevel, hunting = huntinglevel, bar = barlevel, timePlay = timePlay, job = job}
    TriggerClientEvent('showStats',source, name, stats)
end, false)

-- /소곤거림
RegisterCommand('c', function(source, args, user)
    local iden = getIdentity(source)
    local name = ('%s %s'):format(iden.firstname, iden.lastname)
    TriggerClientEvent("sendProximityMessageClose", -1, source, name, table.concat(args, " "))
end, false)

-- /귓속말
RegisterCommand('w', function(source, args, rawCommand)
    local iden = getIdentity(source)
    local name = ('%s %s'):format(iden.firstname, iden.lastname)
    local target = tonumber(args[1])
    local tiden = getIdentity(target)
    local tname = ('%s %s'):format(tiden.firstname, tiden.lastname)
    local message = table.concat(args, " ",2)
    local tping = GetPlayerPing(target)

    if message == "" then
        TriggerClientEvent("sendWhisperError", source, source, name, table.concat(args, " ",2))
    elseif target == nil then
        TriggerClientEvent("sendWhisperError", source, source, name, table.concat(args, " ",2))
    else
        TriggerClientEvent("sendWhisper", target, source,target, name, tname,table.concat(args, " ",2))
        TriggerClientEvent("receiveWhisper", source, source,target,name, tname, table.concat(args, " ",2))
    end
end, false)



--oocpm
RegisterCommand('op', function(source, args, rawCommand)
    local iden = getIdentity(source)
    local name = ('%s %s'):format(iden.firstname, iden.lastname)
    local target = tonumber(args[1])
    local tiden = getIdentity(target)
    local tname = ('%s %s'):format(tiden.firstname, tiden.lastname)
    local message = table.concat(args, " ",2)
    local tping = GetPlayerPing(target)

    if message == "" then
        TriggerClientEvent("sendWhisperError", source, source, name, table.concat(args, " ",2))
    elseif target == nil then
        TriggerClientEvent("sendWhisperError", source, source, name, table.concat(args, " ",2))
    else
        TriggerClientEvent("sendOp", target, source, target, name, tname, table.concat(args, " ",2))
        TriggerClientEvent("receiveOp", source, source, target, name, tname, table.concat(args, " ",2))
    end
end, false)

RegisterCommand('oocpm', function(source, args, rawCommand)
    local iden = getIdentity(source)
    local name = ('%s %s'):format(iden.firstname, iden.lastname)
    local target = tonumber(args[1])
    local tiden = getIdentity(target)
    local tname = ('%s %s'):format(tiden.firstname, tiden.lastname)
    local message = table.concat(args, " ",2)
    local tping = GetPlayerPing(target)

    if message == "" then
        TriggerClientEvent("sendWhisperError", source, source, name, table.concat(args, " ",2))
    elseif target == nil then
        TriggerClientEvent("sendWhisperError", source, source, name, table.concat(args, " ",2))
    else
        TriggerClientEvent("sendOp", target, source, target, name, tname, table.concat(args, " ",2))
        TriggerClientEvent("receiveOp", source, source, target, name, tname, table.concat(args, " ",2))
    end
end, false)

RegisterCommand('공지', function(source, args, rawCommand)
    local iden = getIdentity(source)
    local name = ('%s %s'):format(iden.firstname, iden.lastname)
    local tiden = getIdentity(target)
    local tname = ('%s %s'):format(tiden.firstname, tiden.lastname)
    local message = args[1]
    local tping = GetPlayerPing(target)

    if message == "" then
       
    elseif target == nil then

    else
        TriggerClientEvent('__cfx_internal:serverPrint',source,message)
    end
end, false)

local function onMeCommand(source, args,name)
    local text = "* " .. name .. "이(가) ".. table.concat(args, " ") .. " *"
    TriggerClientEvent('3dme:shareDisplay', -1, text, source)
end

local function onDoCommand(source, args,name)
    local text = "* " .."" .. table.concat(args, " ").." (("..name.."))" .. " *"
    TriggerClientEvent('3dme:shareDisplay', -1, text, source)
end


-- 행동 명령어
RegisterCommand('me', function(source, args, user)
    local iden = getIdentity(source)
    local name = ('%s %s'):format(iden.firstname, iden.lastname)
    onMeCommand(source,args,name)
    TriggerClientEvent("sendProximityMessageMe", -1, source, name, table.concat(args, " "))
end, false)
  
--소리명령어
RegisterCommand('so', function(source, args, user)
    local iden = getIdentity(source)
    local name = ('%s %s'):format(iden.firstname, iden.lastname)
    onMeCommand(source,args,name)
    TriggerClientEvent("sendProximityMessageSo", -1, source, name, table.concat(args, " "))
end, false)

-- 상태 명령어
RegisterCommand('do', function(source, args, user)

    local iden = getIdentity(source)
    local name = ('%s %s'):format(iden.firstname, iden.lastname)
    onDoCommand(source,args,name)
    TriggerClientEvent("sendProximityMessageDo", -1, source, name, table.concat(args, " "))
end, false)
  


-- 아웃 게임 채팅
RegisterCommand('b', function(source, args, user)
    local iden = getIdentity(source)
    local name = ('%s %s'):format(iden.firstname, iden.lastname)
    TriggerClientEvent("sendProximityMessageOoc", -1, source, name, table.concat(args, " "))
end, false)


-- 무전 채팅
-- /팩션 무전
RegisterCommand('r', function(source, args, rawCommand)
    local iden = getIdentity(source)
    local name = ('%s %s'):format(iden.firstname, iden.lastname)

	local xPlayers = ESX.GetPlayers()
    local me = ESX.GetPlayerFromId(source)
    if(me.getJob().name ~= "police" and me.getJob().name ~= "ambulance") then
        TriggerClientEvent('esx:showNotification', source, '소속 팩션이 없거나, 정식 팩션이 아닙니다.')
    else
        for k, v in ipairs(xPlayers) do
            local xPlayer = ESX.GetPlayerFromId(v)
            if (xPlayer.getJob().name == me.getJob().name) then
                TriggerClientEvent("sendMessageGovRadio", xPlayer.source, xPlayer.job.grade_label, source, name, table.concat(args, " "))

            else
                -- TriggerClientEvent("sendMessageNoRadio", source, source, name, table.concat(args, " "))
                -- TriggerClientEvent("sendProximityMessageRadio", -1, source, name, table.concat(args, " "))
            end
            TriggerClientEvent("sendProximityMessageRadio", xPlayer.source, source, name, table.concat(args, " "))


        end
    end

    

end, false)

RegisterCommand('d', function(source, args, rawCommand)
    local iden = getIdentity(source)
    local name = ('%s %s'):format(iden.firstname, iden.lastname)

	local xPlayers = ESX.GetPlayers()
    local me = ESX.GetPlayerFromId(source)
    if(me.getJob().name ~= "police" and me.getJob().name ~= "ambulance") then
        TriggerClientEvent('esx:showNotification', source, '소속 팩션이 없거나, 정식 팩션이 아닙니다.')
    else
        for k, v in ipairs(xPlayers) do
            local xPlayer = ESX.GetPlayerFromId(v)
            if ((xPlayer.getJob().name == "police" or xPlayer.getJob().name == "ambulance") and (me.getJob().name == "police" or me.getJob().name == "ambulance")) then
                TriggerClientEvent("sendMessageUnifiedGovRadio", xPlayer.source, me.job.name, source, name, table.concat(args, " "))

            else
                -- TriggerClientEvent("sendMessageNoRadio", source, source, name, table.concat(args, " "))
                -- TriggerClientEvent("sendProximityMessageRadio", -1, source, name, table.concat(args, " "))
            end
            TriggerClientEvent("sendProximityMessageRadio", xPlayer.source, source, name, table.concat(args, " "))


        end
    end

    

end, false)
--질문
RegisterCommand('질문', function(source, args, rawCommand)
    local iden = getIdentity(source)
    local name = ('%s %s'):format(iden.firstname, iden.lastname)

	local xPlayers = ESX.GetPlayers()
    local me = ESX.GetPlayerFromId(source)

    for k, v in ipairs(xPlayers) do
        local xPlayer = ESX.GetPlayerFromId(v)

        TriggerClientEvent("sendQuestion", xPlayer.source, source, name, table.concat(args, " "))


    end

    

end, false)
--답변
RegisterCommand('답변', function(source, args, rawCommand)
    local iden = getIdentity(source)
    local name = ('%s %s'):format(iden.firstname, iden.lastname)

	local xPlayers = ESX.GetPlayers()
    local me = ESX.GetPlayerFromId(source)

    for k, v in ipairs(xPlayers) do
        local xPlayer = ESX.GetPlayerFromId(v)

        TriggerClientEvent("sendAnswer", xPlayer.source, source, name, table.concat(args, " "))


    end

    

end, false)

-- /사설 무전
RegisterCommand('f', function(source, args, rawCommand)
    local iden = getIdentity(source)
    local name = ('%s %s'):format(iden.firstname, iden.lastname)

	local xPlayers = ESX.GetPlayers()
    local me = ESX.GetPlayerFromId(source)

    for k, v in pairs(xPlayers) do
        local xPlayer = ESX.GetPlayerFromId(v)
        local xPlayerRadio = MySQL.Sync.fetchAll("SELECT radioch FROM users WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier})
        local meRadio =  MySQL.Sync.fetchAll("SELECT radioch FROM users WHERE identifier = @identifier", {['@identifier'] = me.identifier})
        if (xPlayerRadio[1].radioch == meRadio[1].radioch) then
            if me.getInventoryItem('transreceiver').count >= 1 then
                if me.getInventoryItem('transreceiver').count >= 1 and xPlayer.getInventoryItem('transreceiver').count >= 1 then
                    TriggerClientEvent("sendMessageRadio", xPlayer.source, source, name, table.concat(args, " "))
                    TriggerClientEvent("sendProximityMessageRadio", xPlayer.source, source, name, table.concat(args, " "))

                end
            else
                TriggerClientEvent('esx:showNotification', source, '무전기가 필요합니다.')
            end
        end


    end

end, false)

-- /주파수 설정
RegisterCommand('주파수', function(source, args)
	local me = ESX.GetPlayerFromId(source)

    if me.getInventoryItem('transreceiver').count >= 1 then
        local argString = table.concat(args, " ")
        if(type(tonumber(argString))~="number") then
            TriggerClientEvent('esx:showNotification', source, '주파수는 숫자로 입력해주십시오.')
        else
            MySQL.Async.execute("UPDATE users SET radioch = @radioch WHERE identifier = @identifier", {
                ['@radioch'] = argString,
                ['@identifier'] = me.identifier
            },
            function(result)
                TriggerClientEvent("setradioch", source, "^2"..argString.."^0")
        
            end)
        end
    else
        TriggerClientEvent('esx:showNotification', source, '주파수를 설정하기 위해서는 무전기가 필요합니다.')
    end

end)


-- 어드민 채팅
RegisterCommand('ab', function(source, args, user)
    local iden = getIdentity(source)
    local name = ('%s'):format(iden.aname)

    local xPlayers = ESX.GetPlayers()

    for k, v in pairs(xPlayers) do
        local xPlayer = ESX.GetPlayerFromId(v)
        local me = ESX.GetPlayerFromId(source)

        if (xPlayer.getGroup() == 'admin' and me.getGroup() == 'admin') then
            TriggerClientEvent("sendMessageAdmin", xPlayer.source, source, name, table.concat(args, " "))
        end
    end

end, false)


-- 펑션
function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end