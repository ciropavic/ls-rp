ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent("bence_hud:getServerValue")
AddEventHandler("bence_hud:getServerValue", function(id)
    local xPlayer = ESX.GetPlayerFromId(id)
    local data = {}
    data.bank = xPlayer.getAccount("bank").money
    data.black_money = xPlayer.getAccount("black_money").money
    data.money = xPlayer.getMoney()
    TriggerClientEvent("bence_hud:recrieveInfo", id, data)
end)