ESX = nil

Citizen.CreateThread(function() 
  while ESX == nil do 
      TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 
      Citizen.Wait(0) 
  end
  -- getPoints() --서버 최초 접속시 Data 받아오는 구문
end)

TriggerEvent("chat:addSuggestion", "/팩션생성", ("팩션생성"), {})
