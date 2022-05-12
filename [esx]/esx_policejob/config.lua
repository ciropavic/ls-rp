Config                            = {}

Config.DrawDistance               = 100.0
Config.MarkerType                 = 1
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 0.5 }
Config.MarkerColor                = { r = 50, g = 50, b = 204 }

Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = false
Config.EnableESXIdentity          = true -- enable if you're using esx_identity
Config.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.EnableLicenses             = true -- enable if you're using esx_license

Config.EnableHandcuffTimer        = true -- enable handcuff timer? will unrestrain player after the time ends
Config.HandcuffTimer              = 10 * 60000 -- 10 mins

Config.EnableJobBlip              = true -- enable blips for colleagues, requires esx_society

Config.MaxInService               = -1
Config.Locale                     = 'en'

Config.WhitelistedCops = {
	'police'
}

Config.PoliceStations = {

	LSPD = {

		Blip = {
			Coords  = vector3(425.1, -979.5, 30.7),
			Sprite  = 60,
			Display = 4,
			Scale   = 0.9,
			Colour  = 29
		},

		Cloakrooms = {
			vector3(471.11, -986.81, 25.73)
		},

		Armories = {
			vector3(484.16, -1001.99, 25.73)
		},

		Vehicles = {
			{
				Spawner = vector3(466.22, -990.7, 25.73),
				InsideShop = vector3(228.5, -993.5, -99.5),
				SpawnPoints = {
					{ coords = vector3(438.4, -1018.3, 27.7), heading = 90.0, radius = 6.0 },
					{ coords = vector3(441.0, -1024.2, 28.3), heading = 90.0, radius = 6.0 },
					{ coords = vector3(453.5, -1022.2, 28.0), heading = 90.0, radius = 6.0 },
					{ coords = vector3(450.9, -1016.5, 28.1), heading = 90.0, radius = 6.0 }
				}
			},

			
		},

		Helicopters = {
			{
				Spawner = vector3(460.18, -982.8, 43.69),
				InsideShop = vector3(477.0, -1106.4, 43.0),
				SpawnPoints = {
					{ coords = vector3(449.5, -981.2, 43.6), heading = 92.6, radius = 10.0 }
				}
			}
		},

		BossActions = {
			vector3(471.68, -1005.67, 30.69)
		}

	}

}

Config.AuthorizedWeapons = {
	recruit = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 1000, 4000, nil }, price = 1 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 1500 },
		{ weapon = 'WEAPON_FLASHBANG', price = 1500 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 80 }
	},

	officer = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 1000, 4000, nil }, price = 1 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 6000, 1000, 4000, 8000, nil }, price = 1 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 500 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	},

	sergeant = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 1000, 4000, nil }, price = 10000 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 6000, 1000, 4000, 8000, nil }, price = 50000 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', components = { 2000, 6000, nil }, price = 70000 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 500 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	},

	intendent = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 1000, 4000, nil }, price = 10000 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 6000, 1000, 4000, 8000, nil }, price = 50000 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', components = { 2000, 6000, nil }, price = 70000 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 500 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	},

	lieutenant = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 1000, 4000, nil }, price = 10000 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 6000, 1000, 4000, 8000, nil }, price = 50000 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', components = { 2000, 6000, nil }, price = 70000 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 500 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	},

	chef = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 1000, 4000, nil }, price = 10000 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 6000, 1000, 4000, 8000, nil }, price = 50000 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', components = { 2000, 6000, nil }, price = 70000 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 500 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	},

	boss = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 1000, 4000, nil }, price = 10000 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 6000, 1000, 4000, 8000, nil }, price = 50000 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', components = { 2000, 6000, nil }, price = 70000 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 500 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	}
}

Config.AuthorizedVehicles = {
	
		-- shared = {
		-- 	{ model = 'police', label = '일반 순찰차', price = 32000 },
		-- --{ model = 'hwaycar1', label = '고속도로 순찰차', price = 1 }
		-- },

		lieutenant_1 = {
			{ model = 'police', label = 'police', price = 32000 },
			{ model = 'police2', label = 'police2', price = 35000 },
			{ model = 'police3', label = 'police3', price = 35000 },
			{ model = 'police4', label = 'police4', price = 40000 },
			{ model = 'policeb', label = 'policeb', price = 25000 },
			{ model = 'pbus', label = 'pbus', price = 150000 },
			{ model = 'policeold1', label = 'policeold1', price = 80000 },
			{ model = 'policeold2', label = 'policeold2', price = 75000 },
			{ model = 'policet', label = 'policet', price = 100000 },
		},

		lieutenant_2 = {
			{ model = 'police', label = 'police', price = 32000 },
			{ model = 'police2', label = 'police2', price = 35000 },
			{ model = 'police3', label = 'police3', price = 35000 },
			{ model = 'police4', label = 'police4', price = 40000 },
			{ model = 'policeb', label = 'policeb', price = 25000 },
			{ model = 'pbus', label = 'pbus', price = 150000 },
			{ model = 'policeold1', label = 'policeold1', price = 80000 },
			{ model = 'policeold2', label = 'policeold2', price = 75000 },
			{ model = 'policet', label = 'policet', price = 100000 },
		},

		captain_1 = {
			{ model = 'police', label = 'police', price = 32000 },
			{ model = 'police2', label = 'police2', price = 35000 },
			{ model = 'police3', label = 'police3', price = 35000 },
			{ model = 'police4', label = 'police4', price = 40000 },
			{ model = 'policeb', label = 'policeb', price = 25000 },
			{ model = 'pbus', label = 'pbus', price = 150000 },
			{ model = 'policeold1', label = 'policeold1', price = 80000 },
			{ model = 'policeold2', label = 'policeold2', price = 75000 },
			{ model = 'policet', label = 'policet', price = 100000 },
		},

		captain_2 = {
			{ model = 'police', label = 'police', price = 32000 },
			{ model = 'police2', label = 'police2', price = 35000 },
			{ model = 'police3', label = 'police3', price = 35000 },
			{ model = 'police4', label = 'police4', price = 40000 },
			{ model = 'policeb', label = 'policeb', price = 25000 },
			{ model = 'pbus', label = 'pbus', price = 150000 },
			{ model = 'policeold1', label = 'policeold1', price = 80000 },
			{ model = 'policeold2', label = 'policeold2', price = 75000 },
			{ model = 'policet', label = 'policet', price = 100000 },
		},

		captain_3 = {
			{ model = 'police', label = 'police', price = 32000 },
			{ model = 'police2', label = 'police2', price = 35000 },
			{ model = 'police3', label = 'police3', price = 35000 },
			{ model = 'police4', label = 'police4', price = 40000 },
			{ model = 'policeb', label = 'policeb', price = 25000 },
			{ model = 'pbus', label = 'pbus', price = 150000 },
			{ model = 'policeold1', label = 'policeold1', price = 80000 },
			{ model = 'policeold2', label = 'policeold2', price = 75000 },
			{ model = 'policet', label = 'policet', price = 100000 },
		},

		commander = {
			{ model = 'police', label = 'police', price = 32000 },
			{ model = 'police2', label = 'police2', price = 35000 },
			{ model = 'police3', label = 'police3', price = 35000 },
			{ model = 'police4', label = 'police4', price = 40000 },
			{ model = 'policeb', label = 'policeb', price = 25000 },
			{ model = 'pbus', label = 'pbus', price = 150000 },
			{ model = 'policeold1', label = 'policeold1', price = 80000 },
			{ model = 'policeold2', label = 'policeold2', price = 75000 },
			{ model = 'policet', label = 'policet', price = 100000 },
		},

		deputy_chief = {
			{ model = 'police', label = 'police', price = 32000 },
			{ model = 'police2', label = 'police2', price = 35000 },
			{ model = 'police3', label = 'police3', price = 35000 },
			{ model = 'police4', label = 'police4', price = 40000 },
			{ model = 'policeb', label = 'policeb', price = 25000 },
			{ model = 'pbus', label = 'pbus', price = 150000 },
			{ model = 'policeold1', label = 'policeold1', price = 80000 },
			{ model = 'policeold2', label = 'policeold2', price = 75000 },
			{ model = 'policet', label = 'policet', price = 100000 },

		},

		assistant_chief = {
			{ model = 'police', label = 'police', price = 32000 },
			{ model = 'police2', label = 'police2', price = 35000 },
			{ model = 'police3', label = 'police3', price = 35000 },
			{ model = 'police4', label = 'police4', price = 40000 },
			{ model = 'policeb', label = 'policeb', price = 25000 },
			{ model = 'pbus', label = 'pbus', price = 150000 },
			{ model = 'policeold1', label = 'policeold1', price = 80000 },
			{ model = 'policeold2', label = 'policeold2', price = 75000 },
			{ model = 'policet', label = 'policet', price = 100000 },
		},

		chief_of_police = {
			{ model = 'police', label = 'police', price = 32000 },
			{ model = 'police2', label = 'police2', price = 35000 },
			{ model = 'police3', label = 'police3', price = 35000 },
			{ model = 'police4', label = 'police4', price = 40000 },
			{ model = 'policeb', label = 'policeb', price = 25000 },
			{ model = 'pbus', label = 'pbus', price = 150000 },
			{ model = 'policeold1', label = 'policeold1', price = 80000 },
			{ model = 'policeold2', label = 'policeold2', price = 75000 },
			{ model = 'policet', label = 'policet', price = 100000 },
		}
	
}

Config.AuthorizedHelicopters = {
	recruit = {},

	officer = {},

	sergeant = {},

	intendent = {},

	lieutenant = {
		{ model = 'polmav', label = 'Police Maverick', livery = 0, price = 720000 }
	},

	chef = {
		{ model = 'polmav', label = 'Police Maverick', livery = 0, price = 720000 }
	},

	chief_of_police = {
		{ model = 'polmav', label = 'Police Maverick', livery = 0, price = 720000 }
	}
}

-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements

Config.Uniforms = {

	police1 = {
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['mask_1'] = -1,  ['mask_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 189,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['mask_1'] = -1,  ['mask_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},

	police2 = {
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['mask_1'] = -1,  ['mask_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 189,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['mask_1'] = -1,  ['mask_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	
	police3 = {
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['mask_1'] = -1,  ['mask_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 189,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['mask_1'] = -1,  ['mask_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	police4 = {
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['mask_1'] = -1,  ['mask_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 189,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['mask_1'] = 0,  ['mask_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},

	swat_wear = {
		male = {
			['tshirt_1'] = 107,  ['tshirt_2'] = 1,
			['torso_1'] = 53,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 17,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = 124,  ['helmet_2'] = 0,
			['chain_1'] = -1,    ['chain_2'] = -1,
			['mask_1'] = 52,  ['mask_2'] = 0,
			['bproof_1'] = 16,  ['bproof_2'] = 2,
			['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 0,  ['tshirt_2'] = 1,
			['torso_1'] = 343,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 239,
			['pants_1'] = 127,   ['pants_2'] = 0,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = 123,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = -1,
			['mask_1'] = 122,  ['mask_2'] = 0,
			['bproof_1'] = 18,  ['bproof_2'] = 2,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},


	bullet_wear = {
		male = {
			['bproof_1'] = 11,  ['bproof_2'] = 1
		},
		female = {
			['bproof_1'] = 13,  ['bproof_2'] = 1
		}
	},

	helmet = {
		male = {
			['helmet_1'] = 46,  ['helmet_2'] = 0
		},
		female = {
			['helmet_1'] = 45,  ['helmet_2'] = 0
		}
	},

}