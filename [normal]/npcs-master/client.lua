---------------------------------------------------------------------
                --[[SCRIPT MADE BY : ALEXMIHAI04]]--
               --[[DO NOT SELL OR COPY THIS SCRIPT]]--
                   --[[github.com/ItsAlexYTB]]--
        --[[ENJOY THE SCRIPT , DO NOT MAKE 1000 NPCS :))))) ]]
---------------------------------------------------------------------

--[[EXPLANATION [EN]: 

-1,2,3 : Coordonates
-4 : Name for the drawtext
-5 : Ped heading
-6 : Ped hash
-7: Ped model

]]--

--[[DO NOT TOUCH IF YOU DON'T KNOW WHAT YOU DO]]--

--[[EXPLANATION [RO]
-1,2,3 : sunt coordonatele de la npc
-4 : Numele care apare deasupra npc-ului
-5 : Heading (partea in care sta orientat)
-6 : Hash de la ped , se poate lua de pe net
-7 : Modelul de la ped , asemenea , il gasiti pe net

 SellZone = { x = 1225.43, y = -3246.84, z = 4.55 },
    IllegalNPC = { x = 1996.02, y = 4982.71, z = 40.63, h = 219.41}
    484.16, -1001.99, 25.73 무기고
]]--
RegisterCommand(
    "tpnpc",
    function(source, args)
        -- https://runtime.fivem.net/doc/natives/#_0x06843DA7060A026B
        -- 110.4730758667,6626.2397460938,31.78723144531 -코어비클
        -- 1996.02, 4982.71, 40.63 -- 사냥
        -- print(table.concat(args, " "))
        -- coords = {x = 416.27, y = 6520.77, z = 27.72, h = 261.93},
        -- x = 2030.0, y = 4980.35, z = 41.15
        SetEntityCoords(PlayerPedId(),2030.0, 4980.35, 41.15, true, true, true, false)
        SetEntityHeading(PlayerPedId(), 184.27)
        -- print("ㅇㅇㅇㅇ")r
        -- GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("weapon_pistol"),999, false,false)
    end
)

-- RegisterCommand("guns", function ()
--     -- giveWeapon("weapon_pistol")
--     print("ㅇㅇㅇㅇ")
--     GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("weapon_pistol"),999, false,false)
-- end)

RegisterCommand(
    "tpnpc2",
    function(source, args)
        -- 464.2, -998.4, 24.9 
        -- https://runtime.fivem.net/doc/natives/#_0x06843DA7060A026B
        SetEntityCoords(PlayerPedId(), 464.2,-998.4,24.9, true, true, true, false)
        SetEntityHeading(PlayerPedId(), 184.27)
    end
)

local coordonate = {
    --https://wiki.rage.mp/index.php?title=Peds
    --
    {28.21791015625,-2669.60791015625,11.000000000000,"감독관",184.27,0xC99F21C4,"a_m_y_business_01","Valentain_Chino"},
    {2030.0, 4980.35, 41.15,"감독관",184.27,0x4BA14CCA,"a_m_o_acult_02","George_Smith"}
    -- -- {28.21,-2670,12.689584732056,"Agent Politie",535.77,0x15F8700D,"s_f_y_cop_01"},
    -- {446.60791015625,-988.55383300781,29.689584732056,"Garda Politie",370.77,0x56C96FC6,"s_m_m_prisguard_01","Valentain_Chino"},
    -- {-1570.9993896484,-574.92303466797,107.52293395996,"Registru comertului",381.77,0xC99F21C4,"a_m_y_business_01","Valentain_Chino"}
}

-- Citizen.CreateThread(function()


--     while true do 
--         Citizen.Wait(1)
--         function giveWeapon(hash)
--             GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(hash),999, false,false)
--         end
--         end
--     end)

Citizen.CreateThread(function()

    for _,v in pairs(coordonate) do
      RequestModel(GetHashKey(v[7]))
      while not HasModelLoaded(GetHashKey(v[7])) do
        Wait(1)
      end
  
      RequestAnimDict("mini@strip_club@idles@bouncer@base")
      while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do
        Wait(1)
      end
      ped =  CreatePed(4, v[6],v[1],v[2],v[3], 3374176, false, true)
      SetEntityHeading(ped, v[5])
      FreezeEntityPosition(ped, true)
      SetEntityInvincible(ped, true)
      SetBlockingOfNonTemporaryEvents(ped, true)
      TaskPlayAnim(ped,"mini@strip_club@idles@bouncer@base","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
    end
end)

Citizen.CreateThread(function()
    while true do
        local pos = GetEntityCoords(GetPlayerPed(-1), true)
        Citizen.Wait(0)
        for _,v in pairs(coordonate) do
            x = v[1]
            y = v[2]
            z = v[3]
            if(Vdist(pos.x, pos.y, pos.z, x, y, z) < 20.0)then
                DrawText3D(x,y,z+2.10, "~g~"..v[4], 1.2, 1)
                DrawText3D(x,y,z+1.95, "~w~"..v[8], 1.0, 1)
            end
        end
    end
end)


function DrawText3D(x,y,z, text, scl, font) 

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*scl
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(font)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

--[[ENJOY]]--