
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

RegisterNetEvent('ls-gang:Cgettypes')
AddEventHandler('ls-gang:Cgettypes',function (type)
  return type;
end)

RegisterNetEvent('ls-gang:client:openCreation')
AddEventHandler('ls-gang:client:openCreation', function()

    if WarMenu.IsAnyMenuOpened() then
        return
    end

    WarMenu.OpenMenu('demo')
    while true do
      if WarMenu.Begin('demo') then
        WarMenu.MenuButton('팩션 정보', 'demo_menu')
        WarMenu.MenuButton('Gang style', 'demo_style')
        WarMenu.MenuButton('Gang vehicles', 'demo_vehicles')
        WarMenu.MenuButton('Add points', 'demo_points')
        WarMenu.MenuButton('Confirm creation', 'confirm')
        WarMenu.MenuButton('Exit', 'demo_exit')

        WarMenu.End() 
      elseif WarMenu.Begin('demo_menu') then
        if gangName == nil then
          local pressed, inputText = WarMenu.InputButton('Gang name:', nil, _inputText)
          if pressed then
              if inputText then
                  gangName = inputText
              end
          end
        else
          local pressed, inputText = WarMenu.InputButton('Gang name: ~r~' ..gangName, nil, _inputText)
                if pressed then
                    if inputText then
                        gangName = inputText
                    end
                end
        end

        if maxMembers == nil then
          local pressed, inputText = WarMenu.InputButton('Max members:', nil, _inputText)
          if pressed then
              if inputText then
                  local maxOnes = tonumber(inputText)
                  if maxOnes then
                      maxMembers = maxOnes
                  else
                      ESX.ShowNotification('Max members must be a number')
                  end
              end
          end
        else
            local pressed, inputText = WarMenu.InputButton('Max members: ~r~' ..maxMembers, nil, _inputText)
            if pressed then
                if inputText then
                    local maxOnes = tonumber(inputText)
                    if maxOnes then
                        maxMembers = maxOnes
                    else
                        ESX.ShowNotification('Max members must be a number')
                    end
                end
            end
        end

        if WarMenu.Button('Add rank') then
          ESX.ShowNotification(' ~r~Y~w~ 를 누르면 마지막으로 생성한 계급이 삭제 됩니다..')
          gangRankToCha = gangRankToCha + 1
          table.insert(ranks, {label = gangRankToCha, num = gangRankToCha})
        end

        if WarMenu.IsItemHovered() then
            WarMenu.ToolTip('계급을 추가할 수 있습니다. 비정식 5개, 정식 7개')
        end

        for i = 1, #ranks, 1 do
            local pressed, inputText = WarMenu.InputButton('Rank: ' ..ranks[i]['label'], nil, _inputText)
            if pressed then
                if inputText then
                    ranks[i]['label'] = inputText
                end
            end
        end

        if IsControlJustPressed(1, 246) then
            table.remove(ranks, #ranks)
            gangRankToCha = gangRankToCha - 1
        end

      WarMenu.End()
      
      else
        return
      end

      Citizen.Wait(0)
    end
  end)