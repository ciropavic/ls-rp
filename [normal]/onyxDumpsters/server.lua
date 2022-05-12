ESX = nil

local dumpsterItems = {
    [1] = {chance = 2, id = 'glassbottle', name = '유리 병', quantity = math.random(1,3), limit = 10},
    [2] = {chance = 4, id = 'wallet', name = '지갑', quantity = 1, limit = 4},
    [3] = {chance = 2, id = 'oldshoe', name = '낡은 신발', quantity = 1, limit = 10},
    [4] = {chance = 2, id = 'mouldybread', name = '곰팡이 핀 빵', quantity = 1, limit = 10},
    [5] = {chance = 3, id = 'plastic', name = '깨진 플라스틱 조각', quantity = math.random(1,8), limit = 0},
    [6] = {chance = 4, id = 'WEAPON_BAT', name = '야구 망방이', quantity = 1, limit = 2},
    [7] = {chance = 8, id = 'electronics', name = '전자제품', quantity = math.random(1,2), limit = 0},
    [8] = {chance = 5, id = 'lowgradefemaleseed', name = '시들어 빠진 대마초 씨앗', quantity = 1, limit = 0},
    [9] = {chance = 5, id = 'lowgrademaleseed', name = '썩어버린 대마초 씨앗', quantity = 1, limit = 0},
    [10] = {chance = 2, id = 'deadbatteries', name = '방전된 배터리', quantity = 1, limit = 10},
    [11] = {chance = 4, id = 'cellphone', name = '파손된 휴대폰', quantity = 1, limit = 0},
    [12] = {chance = 3, id = 'rubber', name = '고무조각', quantity = math.random(1,3), limit = 0},
    [13] = {chance = 2, id = 'brokenfishingrod', name = '부러진 낚시대', quantity = 1, limit = 10},
    [14] = {chance = 7, id = 'cartire', name = '파손된 타이어', quantity = 1, limit = 4},
    [15] = {chance = 8, id = 'oldring', name = '낡은 반지', quantity = 1, limit = 10},
    [16] = {chance = 7, id = 'advancedlockpick', name = '파손된 고급 자물쇠', quantity = 1, limit = 15},
    [17] = {chance = 2, id = 'expiredburger', name = '썩은 햄버거', quantity = 1, limit = 10}
   }

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('wallet', function(source) --Hammer high time to unlock but 100% call cops
    local source = tonumber(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local cash = math.random(20, 120)
    local chance = math.random(1,2)

    if chance == 2 then
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = '지갑에서 $' .. cash .. ' 를 찾았습니다.'})
        xPlayer.addMoney(cash)
        local cardChance = math.random(1, 40)
        if cardChance == 20 then
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You find a Green Keycard inside the wallet'})
            xPlayer.addInventoryItem('green-keycard', 1)
        end
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = '비어있는 지갑 입니다.'})
    end

    xPlayer.removeInventoryItem('wallet', 1)
end)

RegisterServerEvent('onyx:startDumpsterTimer')
AddEventHandler('onyx:startDumpsterTimer', function(dumpster)
    startTimer(source, dumpster)
end)

RegisterServerEvent('onyx:giveDumpsterReward')
AddEventHandler('onyx:giveDumpsterReward', function()
    local source = tonumber(source)
    local item = {}
    local xPlayer = ESX.GetPlayerFromId(source)
    local gotID = {}
    local rolls = math.random(1, 2)
    local foundItem = false

    for i = 1, rolls do
        item = dumpsterItems[math.random(1, #dumpsterItems)]
        if math.random(1, 10) >= item.chance then
            if item.isWeapon and not gotID[item.id] then
                if item.limit > 0 then
                    local count = xPlayer.getInventoryItem(item.id).count
                    if count >= item.limit then
                        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You find a ' .. item.name .. ' but cannot carry any more of this item'})
                    else
                        gotID[item.id] = true
                        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You find a ' .. item.name})
                        foundItem = true
                        xPlayer.addWeapon(item.id, 50)
                    end
                else
                    gotID[item.id] = true
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You find a ' .. item.name})
                    foundItem = true
                    xPlayer.addWeapon(item.id, 50)
                end
            elseif not gotID[item.id] then
                if item.limit > 0 then
                    local count = xPlayer.getInventoryItem(item.id).count
                    if count >= item.limit then
                        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = '' .. item.name ..'x '.. item.quantity .. ' 을 찾았지만 소유 한도가 부족합니다.'})
                    else
                        gotID[item.id] = true
                        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = ''  .. item.name ..'x '.. item.quantity .. '을 얻었습니다.'})
                        xPlayer.addInventoryItem(item.id, item.quantity)
                        foundItem = true
                    end
                else
                    gotID[item.id] = true
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = '' .. item.name ..'x '.. item.quantity ..'을 얻었습니다. ' })
                    xPlayer.addInventoryItem(item.id, item.quantity)
                    foundItem = true
                end
            end
        end
        if i == rolls and not gotID[item.id] and not foundItem then
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = '아무것도 찾지 못했습니다.'})
        end
    end
end)

function startTimer(id, object)
    local timer = 10 * 60000

    while timer > 0 do
        Wait(1000)
        timer = timer - 1000
        if timer == 0 then
            TriggerClientEvent('onyx:removeDumpster', id, object)
        end
    end
end