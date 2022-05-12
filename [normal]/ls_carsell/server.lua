ESX                = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


-- RegisterServerEvent('ls-carsell:sell')
-- AddEventHandler('ls-carsell:sell',function(model)
--   local _source = source
--   MySQL.Async.fetchAll("SELECT * FROM vehicles WHERE model = @model", {
--     ['@model'] = model
--   },function(result)
--     if result[1] then
--   local price = result[1].price
--   local xPlayer = ESX.GetPlayerFromId(_source)
-- 	local getMoney = (price/2)
--   xPlayer.addMoney(getMoney)
--   -- MySQL.Async.
--   TriggerClientEvent('okokNotify:Alert', _source, "시스템", "차량을 판매하여"..getMoney.." $ 만큼 받았습니다.", 5000, 'success')
--     else
--       TriggerClientEvent('okokNotify:Alert', _source, "시스템", "해당차량은 판매할 수 없습니다.", 5000, 'error')
--     end

--   end)

-- end)

ESX.RegisterServerCallback('ls-carsell:sell', function(source,cb,model,plate)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  local resultcb = 0
  print("sell plate"..plate)
  print("sell Model "..model)
  MySQL.Async.fetchAll("SELECT * FROM vehicles where model = @model",{
    ['@model'] = model
  }, function(result2)
          if result2[1] then
              local price = result2[1].price
              local getMoney = (price/2)
              xPlayer.addMoney(getMoney)
              TriggerEvent('ls-carsell:deleteCar',_source,plate)
              TriggerClientEvent('okokNotify:Alert', _source, "시스템", "차량을 판매하여"..getMoney.." $ 만큼 받았습니다.", 5000, 'success')
              resultcb = 1
              cb(resultcb)
          else
              cb(resultcb)
          end
      end)
end)


RegisterServerEvent('ls-carsell:deleteCar')
AddEventHandler('ls-carsell:deleteCar',function(source,plate)
print("delete PLATE" .. plate)
local _source = source
local xPlayer = ESX.GetPlayerFromId(_source)
local identifier = xPlayer.identifier

MySQL.Sync.execute("DELETE FROM `vehicle_keys` WHERE identifier = @identifier AND plate = @plate", {
    ['@identifier'] = identifier,
    ['@plate'] = plate
})

MySQL.Sync.execute("DELETE FROM `owned_vehicles` WHERE owner = @identifier AND plate = @plate", {
  ['@identifier'] = identifier,
  ['@plate'] = plate
})



end)


ESX.RegisterServerCallback('ls-carsell:checkCar', function(source,cb,plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    local resultcb = 0

    MySQL.Async.fetchAll('SELECT * FROM vehicle_keys WHERE identifier = @identifier and plate = @plate',{
      ['@identifier'] = identifier,
      ['@plate'] = plate
    },function(result)
      print(result[1])
        if result[1] then
          MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @identifier and plate = @plate",{
            ['@identifier'] = identifier,
            ['@plate'] = plate
          },function(carResult)
              if carResult[1] then
                resultcb = 1
                cb(resultcb)
              else
                cb(resultcb)
              end
            end)

        else
          cb(resultcb)
        end
    end)
end)

-- ESX.RegisterServerCallback('ls-carsell:checkCar', function(source, cb, plate)
-- print("you "..plate)
--   local xPlayer = ESX.GetPlayerFromId(source)
-- local identifier = xPlayer.identifier
-- -- print(xPlayer)
-- -- print(identifier)
-- local resultcb = 0
-- MySQL.Async.fetchAll('SELECT * FROM vehicle_keys WHERE identifier = @identifier', {
--   ['@identifier'] = identifier
-- }, function(result)
--   if result then
--     for key in pairs(result) do --actualcode
--       print(result[key].plate)
--       if result[key].plate == plate then
--         print("plate on--")
--         MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @identifier AND plate = @plate",{
--         ['@identifier'] = identifier,
--         ['@plate'] = plate 
--         }, function(resultCar)
--             if resultCar[1] then
--               resultcb = 1	
--               cb(resultcb)
--             else
--               cb(resultcb)
--             end
--         end)
      
--       end
--     end

--   else
--     cb(resultcb)
--     -- subsequent login stuff
--   end
--   cb(resultcb)
-- end)

-- end)

-- RegisterServerEvent('ls-fatigue:fatigueset')
-- AddEventHandler('ls-fatigue:fatigueset',function()
--     -- print(source)
--     local xPlayer = ESX.GetPlayerFromId(source)

--     MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
--         ['@identifier'] = xPlayer.identifier
--     },
-- 	function (result)
--         local user = result[1]
--         if user.fatigue <= 0 then

--         else
--             MySQL.Sync.execute("UPDATE `users` SET `fatigue`=@fatigue WHERE identifier = @identifier", { 
--                 ['@fatigue'] = user.fatigue - 5,
--                 ['@identifier'] = xPlayer.identifier
--             })
--         end
        
-- 	end) 
-- end)
