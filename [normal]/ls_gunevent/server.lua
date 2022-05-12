ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('WEAPON_PISTOL_AMMO', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
    -- if xPlayer.hasWeapon("WEAPON_GLOCK19") then
    --     xPlayer.removeInventoryItem('WEAPON_PISTOL_AMMO', 1)
    --     xPlayer.addWeaponAmmo("WEAPON_GLOCK19", 10)
    --     xPlayer.showNotification("새 탄창을 장착합니다.")
    -- else
    --     xPlayer.showNotification("권총 무기가 없습니다.")
    -- end
  
	TriggerClientEvent('ls_gunevent:PistolAmmoadd', source, 10)
	-- TriggerClientEvent('esx_basicneeds:onEat', source)

end)

ESX.RegisterUsableItem('WEAPON_PISTOL_PACKAGE', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
    local weapon = 'WEAPON_PISTOL'
	local label = ESX.GetWeaponLabel(weapon)

    if xPlayer.hasWeapon('WEAPON_PISTOL') then
        TriggerClientEvent('okokNotify:Alert', source, "시스템", label.."을(를) 이미 가지고 있습니다.", 5000, 'error')
    else
        xPlayer.addWeapon(weapon, 0)
        TriggerClientEvent('okokNotify:Alert', source, "시스템", label.."을(를) 보급받았습니다.", 5000, 'success')
        xPlayer.removeInventoryItem('WEAPON_PISTOL_PACKAGE', 1)
    end
end)


ESX.RegisterUsableItem('WEAPON_GLOCK_PACKAGE', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
    local weapon = 'WEAPON_GLOCK19'
	local label = ESX.GetWeaponLabel(weapon)

    if xPlayer.hasWeapon('WEAPON_GLOCK19') then
        TriggerClientEvent('okokNotify:Alert', source, "시스템", label.."을(를) 이미 가지고 있습니다.", 5000, 'error')
    else
        xPlayer.addWeapon(weapon, 0)
        TriggerClientEvent('okokNotify:Alert', source, "시스템", label.."을(를) 보급받았습니다.", 5000, 'success')
        xPlayer.removeInventoryItem('WEAPON_GLOCK_PACKAGE', 1)
    end
end)
ESX.RegisterUsableItem('WEAPON_KNIFE_PACKAGE', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
    local weapon = 'WEAPON_KNIFE'
	local label = ESX.GetWeaponLabel(weapon)

    if xPlayer.hasWeapon('WEAPON_KNIFE') then
        TriggerClientEvent('okokNotify:Alert', source, "시스템", label.."을(를) 이미 가지고 있습니다.", 5000, 'error')
    else
        xPlayer.addWeapon(weapon, 0)
        TriggerClientEvent('okokNotify:Alert', source, "시스템", label.."을(를) 보급받았습니다.", 5000, 'success')
        xPlayer.removeInventoryItem('WEAPON_KNIFE_PACKAGE', 1)
    end
end)


RegisterServerEvent('ls_gunevent:ammoadd')
AddEventHandler('ls_gunevent:ammoadd',function(weapon,ammo,check)
    local xPlayer = ESX.GetPlayerFromId(source)
    if check then
        xPlayer.removeInventoryItem('WEAPON_PISTOL_AMMO', 1)
        xPlayer.addWeaponAmmo(weapon, 10)
        TriggerClientEvent('okokNotify:Alert', source, "시스템", "들고있는 무기에 새로운 탄창을 장착했습니다.", 5000, 'success')
    else
        TriggerClientEvent('okokNotify:Alert', source, "시스템", "탄창에 맞는 무기를 들어주세요. ", 5000, 'error')
    end
end)

