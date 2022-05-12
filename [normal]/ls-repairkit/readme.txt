SetVehicleFixed 
- 
주어진 차량을 수리하십시오. 차량의 엔진이 고장나면 이 네이티브로 고칠 수 없습니다.
-
local localPlayerPed = GetPlayerPed(-1)
local localVehicle = GetVehiclePedIsIn(localPlayerPed, false)
SetVehicleFixed(localVehicle)

-> 외관 수리로 추측 

SetVehicleTyreFixed(
	vehicle --[[ Vehicle ]], 
	tyreIndex --[[ integer ]]
)
-
타이어 수리
-

SetVehicleDeformationFixed(
	vehicle --[[ Vehicle ]]
)
이것은 차량의 변형을 수정하지만 차량 건강은 개선되지 않습니다



						SetVehicleEngineHealth(vehicle, 700.0)
						SetVehiclePetrolTankHealth(vehicle, 700.0)
            -- 요게 엔진 수리 구문인듯 맥스가 1000 이고 
            미니멈이 -4000
            
GetVehicleEngineHealth (차량)
함수가 지정된 차량의 주소를 가져올 수 없거나 차량이 아닌 경우 1000.0을 반환합니다.
최소: -4000
최대: 1000
-4000: 엔진이 파손
됨 0 이하: 엔진에 불이 붙고 상태가 급격히 저하됨
300: 엔진에서 연기가 나며 기능을 잃음
1000: 엔진이 완벽함


            local retval --[[ number ]] =
	GetVehicleBodyHealth(
		vehicle --[[ Vehicle ]]
	)
 - 보디 헬스 가져오는거 

 
