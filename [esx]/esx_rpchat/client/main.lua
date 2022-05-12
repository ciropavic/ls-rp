--[[

  ESX RP Chat

--]]

ESX								= nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(5000)
	PlayerData = ESX.GetPlayerData()
end)

local isplayercalling = false
local playertocalling = nil

RegisterNetEvent('sendQuestion')
AddEventHandler('sendQuestion', function(id, name, message)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
    TriggerEvent('chatMessage', "", {179, 218, 101}, "^*" .. "질문 " ..name .. " ("..id..") : " .. message)
  else
    TriggerEvent('chatMessage', "", {179, 218, 101}, "^*" .. "질문 " ..name .. " ("..id..") : " .. message)
  end
end)

RegisterNetEvent('startcall')
AddEventHandler('startcall', function(number)
  isplayercalling = true;
  playertocalling = number;
end)

RegisterNetEvent('terminatecall')
AddEventHandler('terminatecall', function(number)
  isplayercalling = false;
  playertocalling = nil;
end)

RegisterNetEvent('sendAnswer')
AddEventHandler('sendAnswer', function(id, name, message)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
    TriggerEvent('chatMessage', "", {104, 175, 100}, "^*" .. "답변 " ..name .. " ("..id..") : " .. message)
  else
    TriggerEvent('chatMessage', "", {104, 175, 100}, "^*" .. "답변 " ..name .. " ("..id..") : " .. message)
  end
end)

-- 인 게임 채팅 & 텍스트 통화
RegisterNetEvent('sendProximityMessage')
AddEventHandler('sendProximityMessage', function(id, name, message)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  print(id,pid,myId)
  if(isplayercalling == false) then
    if pid == myId then
      TriggerEvent('chatMessage', "^*" .. name .. "", {230, 230, 230}, "" .. message)
    elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 15.000 then
      print(GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true))
      TriggerEvent('chatMessage', "^*" .. name .. "", {230, 230, 230}, "" .. message)
    end
  else
    ESX.TriggerServerCallback('gcphone:getphonenumber',function(number)
      if pid == myId then
        TriggerEvent('chatMessage', "(통화중) ^*" .. name .. "", {230, 230, 230}, "" .. message)
      elseif number == playertocalling then
        TriggerEvent('chatMessage', "(통화중) ^*" .. name .. "", {230, 230, 230}, "" .. message)
      end
    end)
  end
end)

RegisterNetEvent("showStats")
AddEventHandler("showStats",function(name, stats)
  -- TriggerEvent("chatMessage","", {111,111,111}, " ^* " .. name.. "의 스탯")
  -- TriggerEvent("chatMessage","", {111,111,111}, " ^* ".."낚시 레벨 : ".. math.floor(stats.fishing))
  -- TriggerEvent("chatMessage","", {111,111,111}, " ^* ".."크래프팅 레벨 : ".. math.floor(stats.crafting))
  -- TriggerEvent("chatMessage","", {111,111,111}, " ^* ".."바텐더 레벨 : ".. math.floor(stats.bar))
  -- TriggerEvent("chatMessage","", {111,111,111}, " ^* " .. "사냥 레벨 : ".. math.floor(stats.hunting))
  -- TriggerEvent("chatMessage","", {111,111,111}, " ^* " .. "택배 배달 레벨 : ".. math.floor(stats.warehouse))
  -- TriggerEvent("chatMessage","", {111,111,111}, " ^* " .. "과일 채집 레벨 : ".. math.floor(stats.fruit))
  -- TriggerEvent("chatMessage","", {111,111,111}, " ^* " .. "농사 레벨 : ".. math.floor(stats.farmer))
  -- TriggerEvent("chatMessage","", {111,111,111}, " ^* " .. "차량 정비 레벨 : ".. math.floor(stats.mechanic))

  local timePlay = stats.timePlay
  local hours = math.floor(timePlay / 3600)
  local min = math.floor((timePlay - hours * 3600) / 60)
  local elements = {}
  table.insert(elements, {label = "직업 : ".. stats.job})
  table.insert(elements, {label = "플레이 시간 : ".. hours.."시간"..min.."분"})
  table.insert(elements, {label = "낚시 레벨 : ".. math.floor(stats.fishing)})
  table.insert(elements, {label = "크래프팅 레벨 : ".. math.floor(stats.crafting)})
  table.insert(elements, {label = "바텐더 레벨 : ".. math.floor(stats.bar)})
  table.insert(elements, {label = "사냥 레벨 : ".. math.floor(stats.hunting)})
  table.insert(elements, {label = "택배 배달 레벨 : ".. math.floor(stats.warehouse)})
  table.insert(elements, {label = "과일 채집 레벨 : ".. math.floor(stats.fruit)})
  table.insert(elements, {label = "농사 레벨 : ".. math.floor(stats.farmer)})
  table.insert(elements, {label = "차량 정비 레벨 : ".. math.floor(stats.mechanic)})

  ESX.UI.Menu.Open("default", GetCurrentResourceName(), "stats", {
    title = name.."의 스탯",
    align = ("bottom-right"),
    elements = elements
  }, function(data, menu)
  end, function(data, menu)
      menu.close()
  end)
end)

-- /외침
RegisterNetEvent('sendProximityMessageShout')
AddEventHandler('sendProximityMessageShout', function(id, name, message)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
    TriggerEvent('chatMessage', "" .. name .. "^*의 외침", {230, 230, 230}, "" .. message .. "!")
  elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 25.999 then
    TriggerEvent('chatMessage', "" .. name .. "^*의 외침", {230, 230, 230}, "" .. message .. "!")
  end
end)

-- /소곤거림
RegisterNetEvent('sendProximityMessageClose')
AddEventHandler('sendProximityMessageClose', function(id, name, message)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
    TriggerEvent('chatMessage', "", {103, 103, 104}, " ^* " .. name .. "의 소곤거림 : " .. message .. "..")
  elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 10.999 then
    TriggerEvent('chatMessage', "", {103, 103, 104}, " ^* " .. name .. "의 소곤거림 : " .. message .. "..")
  end
end)

-- /귓속말
RegisterNetEvent('sendWhisper')
AddEventHandler('sendWhisper', function(id, tid, name,tname, message)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)

  if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 10.999 then
    TriggerEvent('chatMessage', "",{103, 103, 104}, " ^* " .. name .. "의 귓속말".. " : " .. message .. "..")

  else
    TriggerEvent('chatMessage', "", {170, 102, 204}, " ^* " .. "상대방이 너무 멀리 있습니다.")
  end
end)

RegisterNetEvent('receiveWhisper')
AddEventHandler('receiveWhisper', function(id, tid, name, tname, message)
  if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(id)), GetEntityCoords(GetPlayerPed(tid)), true) < 10.999 then
    TriggerEvent('chatMessage', "", {103, 103, 104}, " ^* " .. name .. "의 귓속말".. " : " .. message .. "..")
  else
    TriggerEvent('chatMessage', "", {170, 102, 204}, " ^* " .. "상대방이 너무 멀리 있습니다.")
  end

end)

RegisterNetEvent('sendOp')
AddEventHandler('sendOp', function(id, tid, name, tname, message)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)

  TriggerEvent('chatMessage', "", {255,255,1}, "^*(( " .. name .."("..id .. ")".."가 ".. tname.."(" .. tid.. ")".."에게 보낸 OOCPM".. " : " .. message .. " ))")
end)

RegisterNetEvent('receiveOp')
AddEventHandler('receiveOp', function(id, tid, name, tname, message)
  TriggerEvent('chatMessage', "", {255,255,1}, "^*(( " .. name .."("..id .. ")".."가 ".. tname.."(" .. tid.. ")".."에게 보낸 OOCPM".. " : " .. message .. " ))")
end)

RegisterNetEvent('sendWhisperError')
AddEventHandler('sendWhisperError', function(id, name, message)
    TriggerEvent('chatMessage', "", {128, 128, 128}, " ^* " .. "/me 플번 할말")
end)

-- 행동 명령어
RegisterNetEvent('sendProximityMessageMe')
AddEventHandler('sendProximityMessageMe', function(id, name, message)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
    TriggerEvent('chatMessage', "", {209, 185, 227}, " ^* (행동) " .. name .."이(가) ".." " .. message)
  elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.999 then
    TriggerEvent('chatMessage', "", {209, 185, 227}, " ^* (행동) " .. name .."이(가) ".." " .. message)
  end
end)


-- 상태 명령어
RegisterNetEvent('sendProximityMessageDo')
AddEventHandler('sendProximityMessageDo', function(id, name, message)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
    TriggerEvent('chatMessage', "", {209, 185, 227}, " ^* " .. name .."의 상태 ".." " .. message)
  elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.999 then
    TriggerEvent('chatMessage', "", {209, 185, 227}, " ^* " .. name .."의 상태 ".." " .. message)
  end
end)

-- 소리명령어
RegisterNetEvent('sendProximityMessageSo')
AddEventHandler('sendProximityMessageSo', function(id, name, message)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
    TriggerEvent('chatMessage', "", {255, 204, 102}, " ^* " .. name .."의 소리 ".." " .. message)
  elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.999 then
    TriggerEvent('chatMessage', "", {255, 204, 102}, " ^* " .. name .."의 소리 ".." " .. message)
  end
end)

-- 아웃 게임 채팅
RegisterNetEvent('sendProximityMessageOoc')
AddEventHandler('sendProximityMessageOoc', function(id, name, message)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
    TriggerEvent('chatMessage', "", {128, 128, 128}, " ^* (( (".. id .. ") " .. name .."  ".." : " .. message.."  ))")
  elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.999 then
    TriggerEvent('chatMessage', "", {128, 128, 128}, " ^* (( (".. id .. ") " .. name .."  ".." : " .. message.."  ))")
  end
end)


-- 무전 채팅
RegisterNetEvent('sendProximityMessageRadio')
AddEventHandler('sendProximityMessageRadio', function(id, name, message)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
    TriggerEvent('chatMessage', "", {103, 103, 104}, " ^* (Radio) " .. name .."  ".." : " .. message)
  elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.999 then
    TriggerEvent('chatMessage', "", {103, 103, 104}, " ^* (Radio) " .. name .."  ".." : " .. message)
  end
end)

RegisterNetEvent('sendMessageGovRadio')
AddEventHandler('sendMessageGovRadio', function(grade, id, name, message)
    TriggerEvent('chatMessage', "", {65, 105, 225}, " ^* (Radio) ".. grade .. " " .. name .."  ".." : " .. message)
end)

RegisterNetEvent('sendMessageUnifiedGovRadio')
AddEventHandler('sendMessageUnifiedGovRadio', function(grade, id, name, message)
  local job
  if grade == 'police' then
    job = "LSPD"
  elseif grade == "ambulance" then
    job = "LSFD"
  end
  TriggerEvent('chatMessage', "", {225, 35, 90} ," ^* (Radio) ".. job .. " " .. name .."  ".." : " .. message)
end)

RegisterNetEvent('sendMessageRadio')
AddEventHandler('sendMessageRadio', function(id, name, message)
    TriggerEvent('chatMessage', "", {100, 149, 237}, " ^* (Radio) " .. name .."  ".." : " .. message)
end)

RegisterNetEvent('sendMessageNoRadio')
AddEventHandler('sendMessageNoRadio', function(id, name, message)
    TriggerEvent('chatMessage', "", {128, 128, 128}, " ^* " .. "무전기에 입을 대고 말해보지만 반응이 없다..")
end)

RegisterNetEvent('setradioch')
AddEventHandler('setradioch', function(argument)
  TriggerEvent('chatMessage', "", {0, 255, 0}, "^* 주파수를 " .. argument .. "으로 설정하였습니다.")
end)


-- 어드민 채팅
RegisterNetEvent('sendMessageAdmin')
AddEventHandler('sendMessageAdmin', function(id, name, message)
    TriggerEvent('chatMessage', "", {246, 70, 91}, " ^* [Admin] " .. name .."  ".." : " .. message)
end)