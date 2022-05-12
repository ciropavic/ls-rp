local ESX = nil

local CachedPedState = false


TriggerEvent("esx:getSharedObject", function(response)
    ESX = response
end)

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


-- RegisterCommand("getgun3",function()
--     print("ㅇㅇㅇ")
--     GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_GLOCK19"), 1, false, true)
--     SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_GLOCK19"), true)
--     local xPlayer = ESX.GetPlayerFromId(source)
--     print(xPlayer) 못받아옴 Client에서 해줘야함 
--     local label = ESX.GetWeaponLabel("WEAPON_GLOCK19")

--     print(label)
--     if xPlayer then
--         xPlayer.addWeapon("WEAPON_GLOCK19", 10)
--         print("df")
--         TriggerClientEvent('okokNotify:Alert', source, "시스템", label.."을(를) 보급받았습니다.", 5000, 'success')
--     end
-- end)

RegisterCommand('testid',function(source, args)
-- local iden = getIdentity(source)
-- print("iden")
-- print(iden)
-- local giden = GetPlayerFromServerId(iden)
-- print(giden)
-- print("giden")
local siden = GetPlayerFromServerId(source)
print(siden)
print("sden")
end)
    


RegisterCommand('tell', function(source, args, rawCommand)
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
        TriggerClientEvent("sendtell", target, source, target, name, tname, table.concat(args, " ",2))
        TriggerClientEvent("receivetell", source, source, target, name, tname, table.concat(args, " ",2))
    end
end, false)

RegisterServerEvent('guns:getweapon')
AddEventHandler('guns:getweapon', function(weapon, ammo)

    local xPlayer = ESX.GetPlayerFromId(source)
    local label = ESX.GetWeaponLabel(weapon)

    if xPlayer then
        xPlayer.addWeapon(weapon, ammo)
        TriggerClientEvent('okokNotify:Alert', source, "시스템", label.."을(를) 보급받았습니다.", 5000, 'success')
    end

end)