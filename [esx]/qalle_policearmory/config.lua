Config = {}


-- 비콘 색깔
Config.MarkerColor                = { r = 50, g = 50, b = 204 }


-- ture = 경찰만 보급 가능 // false = 모두가 보급 가능
Config.OnlyPolicemen = true


-- 화기 보급 시 같이 들어가는 탄약
Config.ReceiveAmmo = 0


-- Armory = 무기고 위치 // ArmoryPed = 무기고 NPC 위치
Config.Armory = { ["x"] = 484.16, ["y"] = -1001.99, ["z"] = 25.73, ["h"] = 177.72 }
Config.ArmoryPed = { ["x"] = 484.62, ["y"] = -1003.71, ["z"] = 25.73, ["h"] = 357.93, ["hash"] = "s_m_y_cop_01" }


-- 화기 보급 목록
Config.ArmoryWeapons = {
    { ["hash"] = "WEAPON_NIGHTSTICK", ["type"] = "pistol" , ["price"] = 500},
    { ["hash"] = "WEAPON_FLASHLIGHT", ["type"] = "pistol" , ["price"] = 300},
    { ["hash"] = "WEAPON_STUNGUN", ["type"] = "pistol" , ["price"] = 500},
    { ["hash"] = "WEAPON_GLOCK19", ["type"] = "pistol" , ["price"] = 800},
    { ["hash"] = "WEAPON_SPECIALCARBINE", ["type"] = "rifle" , ["price"] = 2000},
    { ["hash"] = "WEAPON_PUMPSHOTGUN", ["type"] = "rifle" , ["price"] = 1200}
}


-- 탄약 보급 목록
Config.ArmoryBullets = {
    { ["hash"] = "WEAPON_GLOCK19", ["type"] = "pistol" ,["price"] = 400},
    { ["hash"] = "WEAPON_SPECIALCARBINE", ["type"] = "rifle" ,["price"] = 1000},
    { ["hash"] = "WEAPON_PUMPSHOTGUN", ["type"] = "rifle" ,["price"] = 600}
} 

Config.ArmoryLocation = {
	{x = 484.16, y = -1001.99, z = 25.73, ArmoryDistance = 0.5}
}

Config.DrawDistance = 100.0