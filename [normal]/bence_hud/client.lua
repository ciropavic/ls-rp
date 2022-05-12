ESX = nil
loaded = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
    loaded = true
    ESX.PlayerData = ESX.GetPlayerData()
end)

local hunger = 1.00
local thirst = 1.00
local stamina = 1.00
local money = 0
local bank = 0
local socBal = 0
local moneyout = false
local b_m = 0

local showhud = true

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
    ESX.PlayerData = playerData
end)

function drawRct(x, y, width, height, r, g, b, a)
    DrawRect(x + width/2, y + height/2, width, height, r, g, b, a)
end

function Draw2dText(text, x, y)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(0.33, 0.33)
	SetTextColour(255, 255, 255, 255 )
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
	SetTextOutline( true )
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

function Draw2dText2(text, x, y)
    SetTextFont(8)
    SetTextProportional(0)
    SetTextScale(0.25, 0.25)
	SetTextColour(255, 255, 255, 255 )
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
	SetTextOutline( true )
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

function GetMinimapAnchor()
    -- Safezone goes from 1.0 (no gap) to 0.9 (5% gap (1/20))
    -- 0.05 * ((safezone - 0.9) * 10)
    local safezone = GetSafeZoneSize()
    local safezone_x = 1.0 / 20.0
    local safezone_y = 1.0 / 20.0
    local aspect_ratio = GetAspectRatio(false)
    local res_x, res_y = GetActiveScreenResolution()
    local xscale = 1.0 / res_x
    local yscale = 1.0 / res_y
    local Minimap = {}
    if aspect_ratio > 2 then
        Minimap.width = xscale * (res_x / (4 * aspect_ratio))
        Minimap.height = yscale * (res_y / 5.674)
        Minimap.left_x = xscale * (res_x * (safezone_x * ((math.abs(safezone - 1.0)) * 10)))
        Minimap.bottom_y = 1.0 - yscale * (res_y * (safezone_y * ((math.abs(safezone - 1.0)) * 10)))
        Minimap.right_x = Minimap.left_x + Minimap.width + Minimap.width + 51 * xscale
        Minimap.top_y = Minimap.bottom_y - Minimap.height
        Minimap.x = Minimap.left_x + Minimap.width + 51 * xscale 
        Minimap.y = Minimap.top_y
        Minimap.xunit = xscale
        Minimap.yunit = yscale
        return Minimap
    else
        Minimap.width = xscale * (res_x / (4 * aspect_ratio))
        Minimap.height = yscale * (res_y / 5.674)
        Minimap.left_x = xscale * (res_x * (safezone_x * ((math.abs(safezone - 1.0)) * 10)))
        Minimap.bottom_y = 1.0 - yscale * (res_y * (safezone_y * ((math.abs(safezone - 1.0)) * 10)))
        Minimap.right_x = Minimap.left_x + Minimap.width
        Minimap.top_y = Minimap.bottom_y - Minimap.height
        Minimap.x = Minimap.left_x
        Minimap.y = Minimap.top_y
        Minimap.xunit = xscale
        Minimap.yunit = yscale
        return Minimap
    end
end

RegisterCommand("tesres", function()
    print("AR (true): " .. tostring(GetAspectRatio(true)))
    print("AR (false): " .. tostring(GetAspectRatio(false)))
    local res_x, res_y = GetActiveScreenResolution()
    print("Res: " .. tostring(res_x), tostring(res_y))
    print("SZ: " .. tostring(GetSafeZoneSize()))
end)

function MoneyBox()
    if showhud then
        Citizen.CreateThread(function()
            if not moneyout then
                moneyout = true
                local endpos_x, pos_y = 0.87, 0.02
                local money_endpos_x = endpos_x + 0.01
                local startpos_x = 0.99
                local currentpos_x, current_moneypos_x = startpos_x, startpos_x + 0.01
                for i = 1, 30, 1 do
                    currentpos_x = currentpos_x - 0.004
                    current_moneypos_x = current_moneypos_x - 0.004
                    drawRct(currentpos_x, pos_y, 0.12, 0.2, 0, 0, 0, 175)
                    local pos = 0
                    if money > 0 then
                        Draw2dText2("💶    $" .. tostring(money), current_moneypos_x, pos_y + 0.01)
                        pos = 1
                    end
                    if bank > 0 then
                        if pos < 1 then
                            Draw2dText2("💳    $" .. tostring(bank), current_moneypos_x, pos_y + 0.01)
                            pos = 1
                        else
                            Draw2dText2("💳    $" .. tostring(bank), current_moneypos_x, pos_y + 0.035)
                            pos = 2
                        end
                    end
                    if b_m > 0 then
                        if pos < 1 then
                            Draw2dText2("💰    $" .. tostring(math.ceil(b_m)), current_moneypos_x, pos_y + 0.01)
                            pos = 1
                        elseif pos == 1 then
                            Draw2dText2("💰    $" .. tostring(math.ceil(b_m)), current_moneypos_x, pos_y + 0.035)
                            pos = 2
                        else
                            Draw2dText2("💰    $" .. tostring(math.ceil(b_m)), current_moneypos_x, pos_y + 0.06)
                            pos = 3
                        end
                    end
                    if ESX.PlayerData.job.grade_name == "boss" then
                        if socBal > 0 then
                            if pos < 1 then
                                Draw2dText2("💸    $" .. tostring(math.ceil(socBal)), current_moneypos_x, pos_y + 0.01)
                                pos = 1
                            elseif pos == 1 then
                                Draw2dText2("💸    $" .. tostring(math.ceil(socBal)), current_moneypos_x, pos_y + 0.035)
                                pos = 2
                            elseif pos == 2 then
                                Draw2dText2("💸    $" .. tostring(math.ceil(socBal)), current_moneypos_x, pos_y + 0.06)
                                pos = 3
                            else
                                Draw2dText2("💸    $" .. tostring(math.ceil(socBal)), current_moneypos_x, pos_y + 0.085)
                                pos = 4
                            end
                        end
                    end
                    if pos < 1 then
                        Draw2dText2(ESX.PlayerData.job.label .. " - " .. ESX.PlayerData.job.grade_label, current_moneypos_x, pos_y + 0.01)
                        pos = 1
                    elseif pos == 1 then
                        Draw2dText2(ESX.PlayerData.job.label .. " - " .. ESX.PlayerData.job.grade_label, current_moneypos_x, pos_y + 0.035)
                        pos = 2
                    elseif pos == 2 then
                        Draw2dText2(ESX.PlayerData.job.label .. " - " .. ESX.PlayerData.job.grade_label, current_moneypos_x, pos_y + 0.06)
                        pos = 3
                    elseif pos == 3 then
                    Draw2dText2(ESX.PlayerData.job.label .. " - " .. ESX.PlayerData.job.grade_label, current_moneypos_x, pos_y + 0.085)
                        pos = 4
                    else
                        Draw2dText2(ESX.PlayerData.job.label .. " - " .. ESX.PlayerData.job.grade_label, current_moneypos_x, pos_y + 0.11)
                        pos = 5
                    end
                    Citizen.Wait(0)
                end
                local done = false
                Citizen.CreateThread(function()
                    for i = 1, 2, 1 do
                        Citizen.Wait(1000)
                    end
                    done = true
                end)
                while not done do
                    local pos = 0
                    drawRct(currentpos_x, pos_y, 0.12, 0.2, 0, 0, 0, 175)
                    if money > 0 then
                        Draw2dText2("💶    $" .. tostring(money), current_moneypos_x, pos_y + 0.01)
                        pos = 1
                    end
                    if bank > 0 then
                        if pos < 1 then
                            Draw2dText2("💳    $" .. tostring(bank), current_moneypos_x, pos_y + 0.01)
                            pos = 1
                        else
                            Draw2dText2("💳    $" .. tostring(bank), current_moneypos_x, pos_y + 0.035)
                            pos = 2
                        end
                    end
                    if b_m > 0 then
                        if pos < 1 then
                            Draw2dText2("💰    $" .. tostring(math.ceil(b_m)), current_moneypos_x, pos_y + 0.01)
                            pos = 1
                        elseif pos == 1 then
                            Draw2dText2("💰    $" .. tostring(math.ceil(b_m)), current_moneypos_x, pos_y + 0.035)
                            pos = 2
                        else
                            Draw2dText2("💰    $" .. tostring(math.ceil(b_m)), current_moneypos_x, pos_y + 0.06)
                            pos = 3
                        end
                    end
                    if ESX.PlayerData.job.grade_name == "boss" then
                        if socBal > 0 then
                            if pos < 1 then
                                Draw2dText2("💸    $" .. tostring(math.ceil(socBal)), current_moneypos_x, pos_y + 0.01)
                                pos = 1
                            elseif pos == 1 then
                                Draw2dText2("💸    $" .. tostring(math.ceil(socBal)), current_moneypos_x, pos_y + 0.035)
                                pos = 2
                            elseif pos == 2 then
                                Draw2dText2("💸    $" .. tostring(math.ceil(socBal)), current_moneypos_x, pos_y + 0.06)
                                pos = 3
                            else
                                Draw2dText2("💸    $" .. tostring(math.ceil(socBal)), current_moneypos_x, pos_y + 0.085)
                                pos = 4
                            end
                        end
                    end
                    if pos < 1 then
                        Draw2dText2(ESX.PlayerData.job.label .. " - " .. ESX.PlayerData.job.grade_label, current_moneypos_x, pos_y + 0.01)
                        pos = 1
                    elseif pos == 1 then
                        Draw2dText2(ESX.PlayerData.job.label .. " - " .. ESX.PlayerData.job.grade_label, current_moneypos_x, pos_y + 0.035)
                        pos = 2
                    elseif pos == 2 then
                        Draw2dText2(ESX.PlayerData.job.label .. " - " .. ESX.PlayerData.job.grade_label, current_moneypos_x, pos_y + 0.06)
                        pos = 3
                    elseif pos == 3 then
                    Draw2dText2(ESX.PlayerData.job.label .. " - " .. ESX.PlayerData.job.grade_label, current_moneypos_x, pos_y + 0.085)
                        pos = 4
                    else
                        Draw2dText2(ESX.PlayerData.job.label .. " - " .. ESX.PlayerData.job.grade_label, current_moneypos_x, pos_y + 0.11)
                        pos = 5
                    end
                    Citizen.Wait(0)
                end
                for i = 1, 30, 1 do
                    currentpos_x = currentpos_x + 0.004
                    current_moneypos_x = current_moneypos_x + 0.004
                    local pos = 0
                    drawRct(currentpos_x, pos_y, 0.12, 0.2, 0, 0, 0, 175)
                    if money > 0 then
                        Draw2dText2("💶    $" .. tostring(money), current_moneypos_x, pos_y + 0.01)
                        pos = 1
                    end
                    if bank > 0 then
                        if pos < 1 then
                            Draw2dText2("💳    $" .. tostring(bank), current_moneypos_x, pos_y + 0.01)
                            pos = 1
                        else
                            Draw2dText2("💳    $" .. tostring(bank), current_moneypos_x, pos_y + 0.035)
                            pos = 2
                        end
                    end
                    if b_m > 0 then
                        if pos < 1 then
                            Draw2dText2("💰    $" .. tostring(math.ceil(b_m)), current_moneypos_x, pos_y + 0.01)
                            pos = 1
                        elseif pos == 1 then
                            Draw2dText2("💰    $" .. tostring(math.ceil(b_m)), current_moneypos_x, pos_y + 0.035)
                            pos = 2
                        else
                            Draw2dText2("💰    $" .. tostring(math.ceil(b_m)), current_moneypos_x, pos_y + 0.06)
                            pos = 3
                        end
                    end
                    if ESX.PlayerData.job.grade_name == "boss" then
                        if socBal > 0 then
                            if pos < 1 then
                                Draw2dText2("💸    $" .. tostring(math.ceil(socBal)), current_moneypos_x, pos_y + 0.01)
                                pos = 1
                            elseif pos == 1 then
                                Draw2dText2("💸    $" .. tostring(math.ceil(socBal)), current_moneypos_x, pos_y + 0.035)
                                pos = 2
                            elseif pos == 2 then
                                Draw2dText2("💸    $" .. tostring(math.ceil(socBal)), current_moneypos_x, pos_y + 0.06)
                                pos = 3
                            else
                                Draw2dText2("💸    $" .. tostring(math.ceil(socBal)), current_moneypos_x, pos_y + 0.085)
                                pos = 4
                            end
                        end
                    end
                    if pos < 1 then
                        Draw2dText2(ESX.PlayerData.job.label .. " - " .. ESX.PlayerData.job.grade_label, money_x, pos_y + 0.01)
                        pos = 1
                    elseif pos == 1 then
                        Draw2dText2(ESX.PlayerData.job.label .. " - " .. ESX.PlayerData.job.grade_label, money_x, pos_y + 0.035)
                        pos = 2
                    elseif pos == 2 then
                        Draw2dText2(ESX.PlayerData.job.label .. " - " .. ESX.PlayerData.job.grade_label, money_x, pos_y + 0.06)
                        pos = 3
                    elseif pos == 3 then
                    Draw2dText2(ESX.PlayerData.job.label .. " - " .. ESX.PlayerData.job.grade_label, money_x, pos_y + 0.085)
                        pos = 4
                    else
                        Draw2dText2(ESX.PlayerData.job.label .. " - " .. ESX.PlayerData.job.grade_label, money_x, pos_y + 0.11)
                        pos = 5
                    end
                    Citizen.Wait(0)
                end
                moneyout = false
            end
        end)
    end
end

RegisterCommand("moneyboard", function()
    MoneyBox()
end)
RegisterKeyMapping("moneyboard", "Pénz megtekintése", "keyboard", "f9")
TriggerEvent('chat:removeSuggestion', '/moneyboard')

RegisterCommand("toghud", function()
    if showhud then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.5vw; background-color: rgba(158, 18, 0, 0.6); border-radius: 10px; font-size: 14px;"><i class="fas fa-times-circle"></i> Hud láthatósága kikapcsolva! </div>', -- Turned off
            args = { }
        })
    else
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.5vw; background-color: rgba(26, 140, 20, 0.6); border-radius: 10px; font-size: 14px;"><i class="fas fa-check-square"></i> Hud láthatósága bekapcsolva! </div>', -- Turned on
            args = { }
        })
    end
    showhud = not showhud
end)

Citizen.CreateThread(function()
    while not loaded do
        Citizen.Wait(500)
    end
    while true do
        if showhud then
            local ui = GetMinimapAnchor()
            local yoffset = 1.2
            local pos = 0
            -- Draw2dText("[" .. GetPlayerServerId(PlayerId()) ..  "]", ui.x - 27.5 * ui.xunit, ui.y)
            drawRct(ui.x, ui.y + ui.height - yoffset * ui.yunit, ui.width, 15 * ui.yunit, 0, 0, 0, 125)
            drawRct(ui.x, ui.y + ui.height - yoffset * ui.yunit + 3 * ui.yunit, (ui.width/2 - ui.xunit) * hunger, 8 * ui.yunit, 255, 155, 48, 125 )
            drawRct(ui.x, ui.y + ui.height - yoffset * ui.yunit + 3 * ui.yunit, ui.width/2 - ui.xunit, 8 * ui.yunit, 145, 89, 29, 125 )
            local thirst_width = -(ui.width/2 - 2 * ui.xunit) * thirst + ((ui.width/2 - 2 * ui.xunit) * thirst) * 2 - 0.001
            drawRct(ui.x + ui.width/2 + 0.001, ui.y + ui.height - yoffset * ui.yunit + 3 * ui.yunit, thirst_width, 8 * ui.yunit, 99, 190, 255, 125 )
            drawRct(ui.x + ui.width, ui.y + ui.height - yoffset * ui.yunit + 3 * ui.yunit, (ui.width/2 - 2 * ui.xunit) - (((ui.width/2 - 2 * ui.xunit) * 2) - 0.002) , 8 * ui.yunit, 71, 135, 181, 125 )
            if stamina <= 0.90 then
                -- drawRct(ui.x - ui.xunit * 5, ui.y + ui.height - (yoffset - 15) * ui.yunit, (5 * ui.yunit) - (5 * ui.yunit) * 2, (ui.height - ui.height*2) * stamina, 252, 186, 3, 125)
            end
        end
        Citizen.Wait(0)
    end
end)


Citizen.CreateThread(function()
    while not loaded do
        Citizen.Wait(500)
    end
    while true do
        TriggerEvent('esx_status:getStatus', 'hunger', function(h)
            TriggerEvent('esx_status:getStatus', 'thirst', function(t)
                hunger = h.getPercent() / 100
                thirst = t.getPercent() / 100
                stamina = math.ceil(100 - GetPlayerSprintStaminaRemaining(PlayerId())) / 100
            end)
        end)
        Citizen.Wait(200)
    end
end)


RegisterNetEvent("bence_hud:recrieveInfo")
AddEventHandler("bence_hud:recrieveInfo", function(data)
    bank = data.bank
    b_m = data.black_money
    money = data.money
end)

Citizen.CreateThread(function()
    while not loaded do
        Citizen.Wait(500)
    end
    while true do
        --[[if ESX.PlayerData.job.grade_name == "boss" then
            ESX.TriggerServerCallback("esx_society:getSocietyMoney", function(moneyy)
                socBal = moneyy   
            end, ESX.PlayerData.job.name)
        end--]]
        TriggerServerEvent("bence_hud:getServerValue", GetPlayerServerId(PlayerId()))
        Citizen.Wait(1500)
    end
end)

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(0)
    --   HideHudComponentThisFrame(1)  -- Wanted Stars
    --   HideHudComponentThisFrame(2)  -- Weapon Icon
      HideHudComponentThisFrame(3)  -- Cash
      HideHudComponentThisFrame(4)  -- MP Cash
    --   HideHudComponentThisFrame(6)  -- Vehicle Name
    --   HideHudComponentThisFrame(7)  -- Area Name
    --   HideHudComponentThisFrame(8)  -- Vehicle Class
    --   HideHudComponentThisFrame(9)  -- Street Name
    HideHudComponentThisFrame(13) -- Cash Change
    --   HideHudComponentThisFrame(17) -- Save Game
    --   HideHudComponentThisFrame(20) -- Weapon Stats
    end
end)