ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('test0110:test')
AddEventHandler('test0110:test',function()
-- 우선 DB로 접속을해서 그차량의 x,y,z 값을 받아와야함.

local _source = source
local plate = 'RNY 765'
local xPlayer = ESX.GetPlayerFromId(_source)
local identifier = xPlayer.identifier

MySQL.Async.fetchAll('SELECT * FROM `owned_vehicles` WHERE owner = @identifier AND plate = @plate', {
    ['@identifier'] = identifier,
    ['@plate'] = plate
}, function(result)
    if result then
 local user = result[1] 
    TriggerClientEvent('test0110:MarkerPoint', _source, user.x,user.y,user.z)
    else
   
    end
    
    end)
-- CRUD

-- Create - 만들다
-- Read - 읽다
-- Update - 편집하다.
-- Delete - 삭제하다.

-- TriggerClientEvent('test0110:MarkerPoint',source,x)
-- 서버쪽에서 x,y,z을 받아와서 클라이언트에게 x,y,z넘겨주고
-- client넘겨받은 x,y,z값으로 마커를찍어줘야함.

end)

-- ESX.RegisterServerCallback('test0110:testcheck',function(pd,cb,test)
--     local xPlayer = ESX.GetPlayerFromId(pd)
--         if xPlayer.getMoney() >= test then
--         cb(true)
--         else
--         cb(false)
--         end
--     end)
