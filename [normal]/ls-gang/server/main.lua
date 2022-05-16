ESX = nil 

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

gangs = {}
players = {}
plys = {}

RegisterCommand("팩션생성", function(source, args)
 local _src = source
 if isAllowed(_src) then
  TriggerClientEvent("ls-gang:client:openCreation", _src)
 else 
  TriggerClientEvent('esx:showNotification',_src,"권한이 없습니다.")
  end
end)