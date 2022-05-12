--[[
  Solar Admin Panel

  Code by Brycie, Agaarin
  
  solarscripts.store
--]]
ESX = nil
local itemList, jobList = {}, {}
SolarAdmin = {}
TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj 
end)

AddEventHandler('onResourceStart', function()
    MySQL.ready(function ()
        MySQL.Async.fetchAll('SELECT name, label FROM items',{}, function(result)
            itemList = result
        end)

        MySQL.Async.fetchAll('SELECT * FROM jobs ORDER BY name <>  "unemployed", name',{}, function(result)
            for i=1, #result, 1 do
                MySQL.Async.fetchAll('SELECT grade, label FROM job_grades WHERE job_name = @job',{["@job"] = result[i].name}, function(result2)
                    table.insert(jobList, {name = result[i].name, label = result[i].label, ranks = result2})
                end)
            end
        end)
    end)
end)

AddEventHandler("playerConnecting", function(name, setReason, deferrals)
    local player = source
    local identifier
    for k,v in ipairs(GetPlayerIdentifiers(player)) do
        if string.match(v, 'license') then
            identifier = v
            break
        end
    end

    deferrals.defer()
    deferrals.update("Checking Ban Status.")
    
    MySQL.Async.fetchAll('SELECT * FROM bans WHERE license = @license', {
        ['@license'] = identifier
    }, function(result)
        if result[1] then
            if result[1].time ~= 0 then
            	if result[1].time < os.time() then
            		SolarAdmin.Unban(result[1].license)
            		deferrals.done()
            		return
            	end

            	local time = math.floor((result[1].time - os.time()) / 60)
                deferrals.done("[SolarAdmin] You are temporarily banned for "..time.." mins Reason: "..result[1].reason)
            else
                deferrals.done("[SolarAdmin] You have been permanently banned for the reason: "..result[1].reason)
            end
        else
            deferrals.done()
        end
    end)
end)


--[Fetch User Rank CallBack]
ESX.RegisterServerCallback("esx_marker:fetchUserRank", function(source, cb)
    local player = ESX.GetPlayerFromId(source)

    if player then
        local playerGroup = player.getGroup()

        if playerGroup then 
            cb(playerGroup)
        else
            cb("user")
        end
    else
        cb("user")
    end
end)

ESX.RegisterServerCallback("SolarAdmin:getPlayers", function(source,cb)
    local data = {}
    local xPlayers = ESX.GetPlayers()

    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        data[i] = {
            identifier = xPlayer.getIdentifier(),
            playerid = xPlayers[i],
            group = xPlayer.getGroup(),
    	    rpname = xPlayer.getName(),
    	    cash = xPlayer.getMoney(), 
            bank = xPlayer.getAccount("bank").money,
    	    name = GetPlayerName(xPlayers[i])
        }
    end

    cb(data)
end)

ESX.RegisterServerCallback("SolarAdmin:getItemList", function(source,cb)
    cb(itemList)
 end)

ESX.RegisterServerCallback("SolarAdmin:getBanList", function(source,cb)
    MySQL.Async.fetchAll('SELECT * FROM bans',{}, function(result)
    	for i=1, #result, 1 do
    		result[i].time = math.floor((result[i].time - os.time()) / 60)
    	end
        	cb(result)
      end)
 end)

ESX.RegisterServerCallback("SolarAdmin:getJobs", function(source,cb)
    cb(jobList)
 end)

SolarAdmin.Kick = function(playerID, reason)
    DropPlayer(playerID, reason)
end

SolarAdmin.Ban = function(playerID, time, reason)
    local xPlayer = ESX.GetPlayerFromId(playerID)
    if time ~= 0 then
    	local timeToSeconds = time * 60
    	time = (os.time() + timeToSeconds)
    end

    MySQL.Async.execute('INSERT INTO bans (license, name, time, reason) VALUES (@license, @name, @time, @reason)',
        {   
            ['license'] = xPlayer.getIdentifier(), 
            ['name'] = GetPlayerName(playerID), 
            ['time'] = time, 
            ['reason'] = reason 
        },
        function(insertId)
            DropPlayer(playerID, "You have been banned")
    end)
end

SolarAdmin.Unban = function(license)
    MySQL.Async.execute('DELETE FROM bans WHERE license = @license',
        {   
            ['license'] = license, 
        },
        function(insertId)
            print("player unbanned")
    end)
end

SolarAdmin.AddWeapon = function(playerID, selectedWeapon, ammo)
    xPlayer = ESX.GetPlayerFromId(playerID)
    if xPlayer.hasWeapon(selectedWeapon) then
        xPlayer.addWeaponAmmo(selectedWeapon, 50)
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Added Ammo to your weapon') 
    else
        xPlayer.addWeapon(selectedWeapon, ammo)
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'You have been given a '..ESX.GetWeaponLabel(selectedWeapon)) 
    end
end

SolarAdmin.AddCash = function(playerID, amount)
    xPlayer = ESX.GetPlayerFromId(playerID)
    xPlayer.addMoney(amount)
end

SolarAdmin.AddBank = function(playerID, amount)
    xPlayer = ESX.GetPlayerFromId(playerID)
    xPlayer.addAccountMoney("bank", amount)
end

SolarAdmin.AddItem = function(playerID, selectedItem, amount)
    local xPlayer = ESX.GetPlayerFromId(playerID)
    xPlayer.addInventoryItem(selectedItem, amount)
end

SolarAdmin.Teleport = function(targetId, action)
    local xPlayer, xTarget, sourceMessage, targetMessage
    if source ~= 0 then
        if action == "bring" then
            sourceMessage = "You brought a player"
            targetMessage = "You were summoned"
            xPlayer = ESX.GetPlayerFromId(source)
            xTarget = ESX.GetPlayerFromId(targetId)
        elseif action == "goto" then
            targetMessage = "You teleported to a player"
            xPlayer = ESX.GetPlayerFromId(targetId)
            xTarget = ESX.GetPlayerFromId(source)
        end


        if xTarget then
            local targetCoords = xTarget.getCoords()
            local playerCoords = xPlayer.getCoords()
            xTarget.setCoords(playerCoords)
            if sourceMessage then
                TriggerClientEvent('esx:showNotification', xPlayer.source, sourceMessage)
            end
            TriggerClientEvent('esx:showNotification', xTarget.source, targetMessage)
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Player is not online.')        
        end
    end
end

RegisterNetEvent("SolarAdmin:GiveWeapon")
AddEventHandler("SolarAdmin:GiveWeapon", function(playerID, weapon)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerGroup = xPlayer.getGroup()
    if Config.Perms[playerGroup] and Config.Perms[playerGroup].CanGiveWeapon then
        print(weapon)
        SolarAdmin.AddWeapon(playerID, weapon, 10)
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'You gave '..GetPlayerName(playerID)..' a '..ESX.GetWeaponLabel(weapon)) 
    else
       SolarAdmin.Error(source, "noPerms")
    end
end)

RegisterNetEvent("SolarAdmin:AddItem")
AddEventHandler("SolarAdmin:AddItem", function(playerID, selectedItem, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerGroup = xPlayer.getGroup()
    if Config.Perms[playerGroup] and Config.Perms[playerGroup].CanGiveItem then
        SolarAdmin.AddItem(playerID, selectedItem, amount)
        TriggerClientEvent('esx:showNotification', source, "Gave "..selectedItem.." to "..GetPlayerName(playerID))
    else
       SolarAdmin.Error(source, "noPerms")
    end
end)


RegisterNetEvent("SolarAdmin:AddCash")
AddEventHandler("SolarAdmin:AddCash", function (playerID, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerGroup = xPlayer.getGroup()
    if Config.Perms[playerGroup] and Config.Perms[playerGroup].CanAddCash then
        SolarAdmin.AddCash(playerID, amount)
        TriggerClientEvent('esx:showNotification', source, "Gave $"..amount.." Cash to "..GetPlayerName(playerID))
    else
       SolarAdmin.Error(source, "noPerms")
    end
end)

RegisterNetEvent("SolarAdmin:AddBank")
AddEventHandler("SolarAdmin:AddBank", function (playerID, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerGroup = xPlayer.getGroup()
    if Config.Perms[playerGroup] and Config.Perms[playerGroup].CanAddBank then
        SolarAdmin.AddBank(playerID, amount)
        TriggerClientEvent('esx:showNotification', source, "Transfered $"..amount.." to "..GetPlayerName(playerID).."'s Bank Account")
    else
       SolarAdmin.Error(source, "noPerms")
    end
end)

RegisterNetEvent('SolarAdmin:Kick')
AddEventHandler('SolarAdmin:Kick', function(playerId, reason)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerGroup = xPlayer.getGroup()
    if Config.Perms[playerGroup] and Config.Perms[playerGroup].CanKick then
        SolarAdmin.Kick(playerId, reason)
        TriggerClientEvent('esx:showNotification', source, "Kicked "..GetPlayerName(playerId))
    else
       SolarAdmin.Error(source, "noPerms")
    end
end)

RegisterNetEvent('SolarAdmin:Ban')
AddEventHandler('SolarAdmin:Ban', function(playerId, time, reason)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerGroup = xPlayer.getGroup()
    if Config.Perms[playerGroup] and (Config.Perms[playerGroup].CanBanTemp and time ~= 0) or (Config.Perms[playerGroup].CanBanPerm and time == 0) then
        SolarAdmin.Ban(playerId, time, reason)
        TriggerClientEvent('esx:showNotification', source, "Banned "..GetPlayerName(playerId))
    else
       SolarAdmin.Error(source, "noPerms")
    end
end)

RegisterNetEvent("SolarAdmin:Promote")
AddEventHandler("SolarAdmin:Promote", function (playerID, group)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerGroup = xPlayer.getGroup()
    local targetPlayer = ESX.GetPlayerFromId(playerID)
    if Config.Perms[playerGroup] and Config.Perms[playerGroup].CanPromote then
        if group ~= "superadmin" or playerGroup == "superadmin" then
            targetPlayer.setGroup(group)
            TriggerClientEvent('esx:showNotification', source, "Promoted "..GetPlayerName(playerID).." to "..group)
        end
    else
       SolarAdmin.Error(source, "noPerms")
    end
end)

RegisterNetEvent("SolarAdmin:Announcement")
AddEventHandler("SolarAdmin:Announcement", function (message)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerGroup = xPlayer.getGroup()
    if Config.Perms[playerGroup] and Config.Perms[playerGroup].CanAnnounce then
        TriggerClientEvent('chat:addMessage', -1, {color = { 255, 0, 0}, args = {"서버공지 ", message}})
    else
       SolarAdmin.Error(source, "noPerms")
    end
end)

RegisterNetEvent("SolarAdmin:Notification")
AddEventHandler("SolarAdmin:Notification", function (playerID, message)
    local _source = playerID
    TriggerClientEvent('chat:addMessage', _source, {args = {"SolarAdmin ", message}})
end)

RegisterNetEvent("SolarAdmin:Teleport")
AddEventHandler("SolarAdmin:Teleport", function (targetId, action)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerGroup = xPlayer.getGroup()
    if Config.Perms[playerGroup] and Config.Perms[playerGroup].CanTeleport then
        SolarAdmin.Teleport(targetId, action)
    else
       SolarAdmin.Error(source, "noPerms")
    end
end)

RegisterNetEvent("SolarAdmin:Slay")
AddEventHandler("SolarAdmin:Slay", function (target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerGroup = xPlayer.getGroup()
    if Config.Perms[playerGroup] and Config.Perms[playerGroup].CanSlay then
        TriggerClientEvent('SolarAdmin:Slay', target)
        TriggerClientEvent('esx:showNotification', source, "You slayed "..GetPlayerName(target))
        TriggerClientEvent('esx:showNotification', target, "You were slayn by an admin.")
    else
       SolarAdmin.Error(source, "noPerms")
    end
end)

RegisterNetEvent("SolarAdmin:God")
AddEventHandler("SolarAdmin:God", function (target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerGroup = xPlayer.getGroup()
    if Config.Perms[playerGroup] and Config.Perms[playerGroup].CanGodmode then
        TriggerClientEvent('SolarAdmin:God', target)
        TriggerClientEvent('esx:showNotification', source, "You enabled/disabled Godmode for "..GetPlayerName(target))
    else
       SolarAdmin.Error(source, "noPerms")
    end
end)

RegisterNetEvent("SolarAdmin:Freeze")
AddEventHandler("SolarAdmin:Freeze", function (target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerGroup = xPlayer.getGroup()
    if Config.Perms[playerGroup] and Config.Perms[playerGroup].CanFreeze then
        TriggerClientEvent('SolarAdmin:Freeze', target)
        TriggerClientEvent('esx:showNotification', source, "You Froze/Unfroze "..GetPlayerName(target))
    else
       SolarAdmin.Error(source, "noPerms")
    end
end)

RegisterNetEvent("SolarAdmin:Unban")
AddEventHandler("SolarAdmin:Unban", function(license)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerGroup = xPlayer.getGroup()
    if Config.Perms[playerGroup] and Config.Perms[playerGroup].CanUnban then
        SolarAdmin.Unban(license)
        TriggerClientEvent('esx:showNotification', source, "Unbanned Player. ("..license..")")
    else
       SolarAdmin.Error(source, "noPerms")
    end
end)

RegisterNetEvent("SolarAdmin:setJob")
AddEventHandler("SolarAdmin:setJob", function(target, job, rank)
    local xPlayer = ESX.GetPlayerFromId(source)
    local targetPlayer = ESX.GetPlayerFromId(target)
    local playerGroup = xPlayer.getGroup()
    if Config.Perms[playerGroup] and Config.Perms[playerGroup].CanSetJob then
        targetPlayer.setJob(job, rank)
        TriggerClientEvent('esx:showNotification', source, "Changed "..GetPlayerName(target).." job to "..job)
        TriggerClientEvent('esx:showNotification', target, "Your job was changed to "..job)
    else
       SolarAdmin.Error(source, "noPerms")
    end
end)

RegisterNetEvent("SolarAdmin:revive")
AddEventHandler("SolarAdmin:revive", function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local targetPlayer = ESX.GetPlayerFromId(target)
    local playerGroup = xPlayer.getGroup()
    if Config.Perms[playerGroup] and Config.Perms[playerGroup].CanRevive then
        targetPlayer.triggerEvent('esx_ambulancejob:revive')
        TriggerClientEvent('esx:showNotification', source, "You revived "..GetPlayerName(target))
        TriggerClientEvent('esx:showNotification', target, "You have been revived by an admin")
    else
       SolarAdmin.Error(source, "noPerms")
    end
end)

SolarAdmin.Error = function(source, message)
    if message == "noPerms" then
        TriggerClientEvent('chat:addMessage', source, {args = {"SolarAdmin ", " You do not have permission for this."}})
    else
        TriggerClientEvent('chat:addMessage', source, {args = {"SolarAdmin ", message}})
    end
end

function split(s, delimiter)
    result = {}
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end