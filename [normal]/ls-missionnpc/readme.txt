GiveWeaponToPed(
	ped --[[ Ped ]], 
	weaponHash --[[ Hash ]], 
	ammoCount --[[ integer ]], 
	isHidden --[[ boolean ]], 
	bForceInHand --[[ boolean ]]
)


웨폰 주는거 


TaskCombatPed (ped,targetPed,p2,p3)
적대 관계 만들기.

생성
CreatePed(
		pedType --[[ integer ]], 
		modelHash --[[ Hash ]], 
		x --[[ number ]], 
		y --[[ number ]], 
		z --[[ number ]], 
		heading --[[ number ]], 
		isNetwork --[[ boolean ]], 
		bScriptHostPed --[[ boolean ]]
	)


    local player = GetPlayerFromServerId(args[1]) 
    local ped = GetPlayerPed(player) 
    local pos = GetEntityCoords(ped, true)
    서버아이디로 플레이어 설정