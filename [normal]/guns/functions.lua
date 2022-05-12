function alert(msg)
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
end

function notify(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(true, false)
end

function giveWeapon(hash)
    GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(hash),999, false,false)
end

function spawnCar(car)
    local car = GetHashKey(car)

    -- RequestModel. 메모리에 로드할 모델을 요청
    RequestModel(car)
    -- 해당 모델이 있는지 체크
    while not HasModelLoaded(car) do
        RequestModel(car)
        -- 잠깐 대기해줘야 부하 없음
        Citizen.Wait(0)
    end
-- 테이블 언팩을 쓰는 이유는 배열을 뭐 푸는것같음 간단하게 x y z 를 GetEntityCoords(world 좌표 가져올 대상, 대상이 살아있을 때 사용할건지 여부)
    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),false))
    local vehicle = CreateVehicle(car,x +3 , y + 3, z +1,0.0,true, false)
    SetEntityAsMissionEntity(vehicle,true, true)
end


function weaponComponent(weaponHash, component)
    if HasPedGotWeapon(GetPlayerPed(-1),GetHashKey(weaponHash),false) then
        GiveWeaponComponentToPed(GetPlayerPed(-1),GetHashKey(weaponHash),GetHashKey(component))
    end
    
end