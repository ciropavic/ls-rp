Config = {

BlipSprite = 237,
BlipColor = 26,
BlipText = 'Workbench',

UseLimitSystem = false, -- Enable if your esx uses limit system

CraftingStopWithDistance = false, -- Crafting will stop when not near workbench

ExperiancePerCraft = 5, -- The amount of experiance added per craft (100 Experiance is 1 level)

HideWhenCantCraft = false, -- Instead of lowering the opacity it hides the item that is not craftable due to low level or wrong job

Categories = {

['misc'] = {
	Label = 'MISC',
	Image = 'fishingrod',
	Jobs = {}
},
['weapons'] = {
	Label = 'WEAPONS',
	Image = 'WEAPON_APPISTOL',
	Jobs = {}
},
['medical'] = {
	Label = 'MEDICAL',
	Image = 'bandage',
	Jobs = {}
}


},

PermanentItems = { -- Items that dont get removed when crafting
	['wrench'] = true
},

Recipes = { -- Enter Item name and then the speed value! The higher the value the more torque

['bandage'] = {
	Level = 0, -- From what level this item will be craftable
	Category = 'medical', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {'ambulance'}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 2, -- The amount that will be crafted
	SuccessRate = 100, -- 100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 10, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['clothe'] = 2, -- item name and count, adding items that dont exist in database will crash the script
		['wood'] = 1
	}
}, 

['WEAPON_APPISTOL'] = {
	Level = 2, -- From what level this item will be craftable
	Category = 'weapons', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 100, --  100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['copper'] = 5, -- item name and count, adding items that dont exist in database will crash the script
		['wood'] = 3,
		['iron'] = 5
	}
}, 

['fishingrod'] = {
	Level = 0, -- From what level this item will be craftable
	Category = 'misc', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 3, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['wood'] = 3 -- item name and count, adding items that dont exist in database will crash the script
		
	}
}

},

Workbenches = { -- Every workbench location, leave {} for jobs if you want everybody to access

		{coords = vector3(101.26113891602,6615.810546875,33.58126831054), jobs = {}, blip = true, recipes = {}, radius = 3.0 }

},
 

Text = {

    ['not_enough_ingredients'] = '재료가 충분하지 않습니다.',
    ['you_cant_hold_item'] = '아이템을 잡을 수 없습니다.',
    ['item_crafted'] = '크래프팅 아이템!',
    ['wrong_job'] = '이 작업대를 열 수 없습니다.',
    ['workbench_hologram'] = '[~b~E~w~] 작업대',
    ['wrong_usage'] = '잘못된 명령어입니다.',
    ['inv_limit_exceed'] = '소지품 갯수를 초과하였습니다.',
    ['crafting_failed'] = '제작에 실패하였습니다!'

}

}



function SendTextMessage(msg)

        SetNotificationTextEntry('STRING')
        AddTextComponentString(msg)
        DrawNotification(0,1)

        --EXAMPLE USED IN VIDEO
        --exports['mythic_notify']:SendAlert('inform', msg)

end
