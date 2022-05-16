
local gangName, maxMembers, ranks, gangStyle, red, green, blue, vehicles, points = nil, nil, {}, 1, 1, 1, 1, {}, {}

local gangRankToCha = 0

local _altX = false
local _altY = false
local _altWidth = false
local _altTitle = false
local _altSubTitle = false
local _altMaxOption = false

-- Controls


local _altSprite = false

local posibleOnes = { "Gang", "Mafia" }

local rank = 0

local typePoints = {
    "Save Vehicles",
    "Get Vehicles",
    "Armory",
    "Boss",
    --"Things to do",
    "Shop"
}

local _checked = false

local _altTitleColor = false
local _altSubTitleColor = false
local _altTitleBackgroundColor = false
local _altTitleBackgroundSprite = false
local _altBackgroundColor = false
local _altTextColor = false
local _altSubTextColor = false
local _altFocusColor = false
local _altFocusTextColor = false
local _altButtonSound = false

WarMenu.CreateMenu('demo', _U('gang_creation'), _U('gang_info'))

WarMenu.CreateSubMenu('demo_menu', 'demo', _U('menu'))
WarMenu.CreateSubMenu('demo_style', 'demo', _U('style'))
WarMenu.CreateSubMenu('demo_vehicles', 'demo', _U('vehs'))
WarMenu.CreateSubMenu('demo_points', 'demo', _U('points'))
WarMenu.CreateSubMenu('confirm', 'demo', _U('conf'))
WarMenu.CreateSubMenu('demo_exit', 'demo', _U('sure'))

RegisterNetEvent('guille_gangs:client:openCreation')
AddEventHandler('guille_gangs:client:openCreation', function()

    if WarMenu.IsAnyMenuOpened() then
        return
    end

    WarMenu.OpenMenu('demo')
    while true do
      if WarMenu.Begin('demo') then
        WarMenu.MenuButton('Gang Info', 'demo_menu')
        WarMenu.MenuButton('Gang style', 'demo_style')
        WarMenu.MenuButton('Gang vehicles', 'demo_vehicles')
        WarMenu.MenuButton('Add points', 'demo_points')
        WarMenu.MenuButton('Confirm creation', 'confirm')
        WarMenu.MenuButton('Exit', 'demo_exit')

        WarMenu.End() end
    end
  end)