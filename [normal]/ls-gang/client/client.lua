ESX = nil

Citizen.CreateThread(function() 
  while ESX == nil do 
      TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 
      Citizen.Wait(0) 
  end
  getPoints()
end)

TriggerEvent("chat:addSuggestion", "/팩션생성", ("팩션생성"), {})
