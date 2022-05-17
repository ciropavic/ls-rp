ESX = nil 

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

gangs = {}
players = {}
plys = {}

RegisterServerEvent('ls-gang:Sgettypes')
AddEventHandler('ls-gang:Sgettypes',function(gang)
local rank = 0;
  MySQL.Async.fetchAll("SELECT * FROM guille_gangsv2 Where gang =@gang",{
    ['@gang'] = gang
  }, function (result)
    TriggerClientEvent('ls-gang:Cgettypes',result.type)
  end)

end)

RegisterCommand("팩션생성", function(source, args)
 local _src = source
 if isAllowed(_src) then
  TriggerClientEvent("ls-gang:client:openCreation", _src)
 else 
  TriggerClientEvent('esx:showNotification',_src,"권한이 없습니다.")
  end
end)