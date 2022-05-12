local ESX = nil

local CachedPedState = false

TriggerEvent("esx:getSharedObject", function(response)
    ESX = response
end)

ESX.RegisterServerCallback("qalle_policearmory:pedExists", function(source, cb)
    if CachedPedState then
        cb(true)
    else
        CachedPedState = true

        cb(false)
    end
end)


-- 무기 주는 부분
RegisterServerEvent('qalle_policearmory:getweapon')
AddEventHandler('qalle_policearmory:getweapon', function(weapon, ammo)

    local xPlayer = ESX.GetPlayerFromId(source)
    local label = ESX.GetWeaponLabel(weapon)

    if xPlayer then
        xPlayer.addWeapon(weapon, ammo)
        TriggerClientEvent('okokNotify:Alert', source, "시스템", label.."을(를) 보급받았습니다.", 5000, 'success')
    end

end)


-- 총알 주는 부분
RegisterServerEvent('qalle_policearmory:getammo')
AddEventHandler('qalle_policearmory:getammo', function(weapon, ammo)

    local xPlayer = ESX.GetPlayerFromId(source)
    local label = ESX.GetWeaponLabel(weapon)

    if xPlayer then
        xPlayer.addWeaponAmmo(weapon, ammo)
        TriggerClientEvent('okokNotify:Alert', source, "시스템", label.." 탄약 "..ammo.."발을 보급받았습니다.", 5000, 'success')
    end

end)


-- 무기 반납 부분
RegisterServerEvent('qalle_policearmory:removeweapon')
AddEventHandler('qalle_policearmory:removeweapon', function(xPlayer, args)

    local playerId = ESX.GetPlayerFromId(source)

    for k,v in ipairs(playerId.getLoadout()) do
        playerId.removeWeapon(v.name)
    end

end)


-- 무기 보급 체크하는 부분
ESX.RegisterServerCallback("qalle_policearmory:giveWeapon", function(source,cb,weapon,price,check)

    local player = ESX.GetPlayerFromId(source)
    local iden = player.getIdentifier()

    -- 무기가 중복되는지 체크
    if player.hasWeapon(weapon) then
        check = "false"
    else
        check = "true"
    end

    if (check == "true") then
        if player then

            local label = ESX.GetWeaponLabel(weapon)

            --경찰 계좌 선택하는 부분
            MySQL.Async.fetchAll('SELECT value FROM okokbanking_societies WHERE society = @society', {
                ['@society'] = "society_police"
            }, function(result)

                if(price > result[1].value)then
                    cb(false)
                else
                    -- 경찰 계좌에서 무기 값 차감하는 부분
                    MySQL.Async.execute('UPDATE okokbanking_societies SET value = @value WHERE society = @society', {
                        ['@value'] = result[1].value - price,
                        ['@society'] = "society_police"
                    })
                    
                    -- 경찰 계좌에 거래내역 등록하는 부분
                    MySQL.Async.execute('INSERT INTO okokbanking_transactions (receiver_identifier, receiver_name, sender_identifier, sender_name, date, value, type) VALUES (@receiver_identifier, @receiver_name, @sender_identifier, @sender_name, @date, @value, @type)', {
                            ['@receiver_identifier'] = "society_police",
                            ['@receiver_name'] = player.getName().." (화기)",
                            ['@sender_identifier'] = "society_police",
                            ['@sender_name'] = player.getName().." (화기)",
                            ['@date']   = os.date("%Y-%m-%d %X"),
                            ['@value']   = price,
                            ['@type'] = "withdraw"
                    })

                    -- 경찰 무장 로그에 기록하는 부분
                    MySQL.Async.execute('INSERT INTO police_armorylog (weapon, user, time) VALUES (@weapon, @user, @time)', {
                        ['@weapon'] = weapon,
                        ['@user'] = player.getName(),
                        ['@time'] = os.date("%Y-%m-%d %X")
                    })

                    cb(true)
                end

            end)
        end
    else
        TriggerClientEvent('okokNotify:Alert', source, "시스템", "이미 해당 총기를 가지고 있습니다.", 5000, 'error')
    end

end)


-- 총알 보급 체크하는 부분
ESX.RegisterServerCallback("qalle_policearmory:giveAmmo", function(source,cb,weapon,price,check)

    local player = ESX.GetPlayerFromId(source)
    local iden = player.getIdentifier()

    -- 해당 무기가 있는지 체크
    if player.hasWeapon(weapon) then
        check = "false"
    else
        check = "true"
    end

    if check == "false" then
        if player then

            local label = ESX.GetWeaponLabel(weapon)

            --경찰 계좌 선택하는 부분
            MySQL.Async.fetchAll('SELECT value FROM okokbanking_societies WHERE society = @society', {
                ['@society'] = "society_police"
            }, function(result)

                if(price > result[1].value)then
                    cb(false)
                else
                    -- 경찰 계좌에서 총알 값 차감하는 부분
                    MySQL.Async.execute('UPDATE okokbanking_societies SET value = @value WHERE society = @society', {
                        ['@value'] = result[1].value - price,
                        ['@society'] = "society_police"
                    })

                    -- 경찰 계좌에 거래내역 등록하는 부분
                    MySQL.Async.execute('INSERT INTO okokbanking_transactions (receiver_identifier, receiver_name, sender_identifier, sender_name, date, value, type) VALUES (@receiver_identifier, @receiver_name, @sender_identifier, @sender_name, @date, @value, @type)', {
                        ['@receiver_identifier'] = "society_police",
                        ['@receiver_name'] = player.getName().." (탄약)",
                        ['@sender_identifier'] = "society_police",
                        ['@sender_name'] = player.getName().." (탄약)",
                        ['@date']   = os.date("%Y-%m-%d %X"),
                        ['@value']   = price,
                        ['@type'] = "withdraw"
                    })

                    -- 경찰 무장 로그에 기록하는 부분
                    MySQL.Async.execute('INSERT INTO police_armorylog (weapon, user, time) VALUES (@weapon, @user, @time)', {
                        ['@weapon'] = weapon.."탄약",
                        ['@user'] = player.getName(),
                        ['@time'] = os.date("%Y-%m-%d %X")
                    })

                    cb(true)
                end

            end)
        end
    else
        TriggerClientEvent('okokNotify:Alert', source, "시스템", "해당 총기가 없습니다.", 5000, 'error')
    end

end)