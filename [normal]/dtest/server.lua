ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand("get", function (source, args)
    local argString = table.concat(args, " ")


-- local _source = source
-- print(source)
-- print(_source)

    identifier = GetPlayerIdentifier(source)
    identifier = identifier:gsub("%license:","")
    -- replace(identifier,"license","")
    print(identifier)
 

  -- sql 테스트 
    MySQL.Async.fetchAll("SELECT * From users where identifier = @identifier ", {['@identifier'] = identifier},
    function (result)
        local user = result[1]
        print(user.identifier)
    end)
    

    
end)

 -- esx_addonitem test
RegisterCommand("getitem",function(source,args)
local _source = source
local xPlayer = GetPlayerIdentifier(_source)
xPlayer = xPlayer:gsub("%license:","")
-- local xPlayer = ESX.GetPlayerFromId(_source)
local xPlayerOwner = ESX.GetPlayerFromIdentifier(xPlayer)
print(_source)
print(xPlayer)
print(xPlayerOwner)

    --인벤토리 테스트
    TriggerEvent('esx_addoninventory:getInventory', 'property', xPlayerOwner.identifier, function(inventory)
        print("ㅇ");
        inventory.addItem('guns', 1)
    end)
end)

RegisterCommand('getitem2',function (source,args)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	-- local user_id = xPlayer.identifier
    print(_source)
    print(xPlayer)
    xPlayer.addInventoryItem('dtest', 1);
    
end)

-- 청구서 테스트
RegisterCommand('getbill',function (source,args)
    local amount                         = 100
-- 가장가까운 플레이어 찾는 함수 이건 테스트 인원 필요할듯
local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

if closestPlayer == -1 or closestDistance > 3.0 then
	ESX.ShowNotification('There\'s no players nearby!')
    print("청구서1")
else
    print("청구서1")
	TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_taxi', 'Taxi', amount)
end

end)

RegisterCommand('mybill',function (source)
    local amount                         = 1000000
-- 가장가까운 플레이어 찾는 함수 이건 테스트 인원 필요할듯
--local _source = source
-- local xPlayer = GetPlayerIdentifier(_source)
-- local xPlayerOwner = ESX.GetPlayerFromIdentifier(xPlayer)
-- print(source)
-- print(_source)
local xPlayer = ESX.GetPlayerFromId(source) 
print(xPlayer)
-- print(xPlayerOwner)
-- print(source)
-- print(source)
-- local _soruce = source
-- -- print(GetPlayerServerId(source))
-- local xPlayer = ESX.GetPlayerFromId(source)
-- print(xPlayer)
    print("청구서1")
    --print(GetPlayerServerId(-1))
    --GetPlayerFromServerId
    
	TriggerEvent('esx_billing:sendBill', source, 'society_taxi', 'Taxi', amount)

end)

