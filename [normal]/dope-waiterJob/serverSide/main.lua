ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("dope-waiterJob:giveMoney")
AddEventHandler("dope-waiterJob:giveMoney", function(FirstPedSelectedOrderPrice)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT barlevel FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
        if(result[1].barlevel <= 100) then
            xPlayer.addInventoryItem('money', 50)
        elseif(result[1].barlevel > 100) then
            xPlayer.addInventoryItem('money', 100)
        elseif(result[1].barlevel > 300) then
            xPlayer.addInventoryItem('money', 200)
        elseif(result[1].barlevel > 500) then
            xPlayer.addInventoryItem('money', 300)
        elseif(result[1].barlevel > 700) then
            xPlayer.addInventoryItem('money', 400)
        elseif(result[1].barlevel > 900) then
            xPlayer.addInventoryItem('money', 500)
        end
        MySQL.Sync.execute("UPDATE `users` SET `barlevel`=@barlevel WHERE identifier = @identifier", { 
            ['@barlevel'] = result[1].barlevel + 1,
            ['@identifier'] = xPlayer.identifier
        })
	end)
    
end)
