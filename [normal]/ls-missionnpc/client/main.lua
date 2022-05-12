ESX						= nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

-- 모델 로딩 안하면 생성  안됨 
RequestModel( GetHashKey( "s_m_m_bouncer_01" ) )
while ( not HasModelLoaded( GetHashKey( "s_m_m_bouncer_01" ) ) ) do
    Citizen.Wait( 1 )
end

RegisterCommand('npc',function ()
  local plyPed = GetPlayerPed(-1)
  local pos = GetEntityCoords(GetPlayerPed(-1))
  local heading = GetEntityHeading(GetPlayerPed(-1))
  local createNpc = CreatePed(4, 0x9fd4292d, pos.x, pos.y, pos.z, heading, true, false)
  --네트워크연결 
  SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(createNpc), true)

  --무기 주기
  GiveWeaponToPed(createdNPC, GetHashKey('weapon_pistol'), 300, false, true)
  SetPedDropsWeaponsWhenDead(createdNPC, false)
  CreateNPCThread(plyPed,createNpc)

 
  
  -- CreatePed(4, 0x22911304, 122.702, -1308.935, 29.227, 0, false, true)
end)

function CreateNPCThread(plyPed,npc)

  local _plyPed = plyPed
  local _npc = npc
  GiveWeaponToPed(_npc, GetHashKey('weapon_pistol'), 300, false, true)
  Citizen.CreateThread(function ()

     --조준하기 위해 멈춰야하는 거리, ped가 조준을 시작해야하는 거리
     TaskGotoEntityAiming(_npc, _plyPed, 8.0, 10.0)
     -- 무기 정확도 인 듯 
     SetPedAccuracy(createdNPC, 10)
     --무기 떨어뜨리지 않기 죽어도.
     SetPedDropsWeaponsWhenDead(_npc, false)
 
     -- 그룹 설정인 듯
     SetPedRelationshipGroupHash(_npc, GetHashKey("AMBIENT_GANG_WEICHENG"))
     SetPedRelationshipGroupDefaultHash(_npc, GetHashKey("AMBIENT_GANG_WEICHENG"))
 
     -- for i, ally in pairs(squad.AlliesWith) do
     --   SetRelationshipBetweenGroups(0, GetHashKey("AMBIENT_GANG_WEICHENG"), ally)
     --   SetRelationshipBetweenGroups(0, ally, GetHashKey("AMBIENT_GANG_WEICHENG"))
     -- end
 
     --동맹설정
     SetRelationshipBetweenGroups(0, GetHashKey("AMBIENT_GANG_WEICHENG"),GetHashKey("AMBIENT_GANG_WEICHENG"))
     SetRelationshipBetweenGroups(0, GetHashKey("AMBIENT_GANG_WEICHENG"),GetHashKey("AMBIENT_GANG_WEICHENG"))
    -- while true 안하면 조준만함.
    while true do
      TaskCombatPed(_npc, _plyPed, 0, 16)
      Citizen.Wait(1)
    end

   
    
  

    --공격하게하기 

  end)
end

