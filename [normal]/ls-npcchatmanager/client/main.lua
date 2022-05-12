local display = false

RegisterCommand("di", function(source, args)
    TriggerEvent('ls_npcdialogue:Alert','vehicle_rent_Greetings01')
    SetDisplay(not display)
end)

--very important cb 
RegisterNUICallback("exit", function(data)
    SendNUIMessage({
        type ="ui",
        display=false
    })
    SetNuiFocus(false,false)
end)

-- this cb is used as the main route to transfer data back 
-- and also where we hanld the data sent from js
RegisterNUICallback("main", function(data)
    chat(data.text, {0,255,0})
    SetDisplay(false)
end)

RegisterNUICallback("error", function(data)
    chat(data.error, {255,0,0})
    SetDisplay(false)
end)

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end

Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)
        -- https://runtime.fivem.net/doc/natives/#_0xFE99B66D079CF6BC
        --[[ 
            inputGroup -- integer , 
	        control --integer , 
            disable -- boolean 
        ]]
        DisableControlAction(0, 1, display) -- LookLeftRight
        DisableControlAction(0, 2, display) -- LookUpDown
        DisableControlAction(0, 142, display) -- MeleeAttackAlternate
        DisableControlAction(0, 18, display) -- Enter
        DisableControlAction(0, 322, display) -- ESC
        DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
    end
end)

function chat(str, color)
    TriggerEvent(
        'chat:addMessage',
        {
            color = color,
            multiline = true,
            args = {str}
        }
    )
end


function Alert(name,content,nextscid,btn)
    SendNUIMessage({
      action = 'scription',
      name = name,
      content = content,
      nextscid = nextscid,
    })
    local nums= 0
    for _, value in pairs(Config.SelectButton) do
      if btn == value[1] then
        -- print("btn.."..value[2].._)
        nums = nums+1
        SendNUIMessage({
          action = 'buttonAdd',
          --여기선 int로 보내줄 가능성이 있음.
          btnnumber = nums,
          btncontent = value[2],
          btnnextscid = value[3],
          btnopenNui = value[4]
        })
      end
    end
  end
  
  -- text. 
  RegisterNetEvent('ls_npcdialogue:Alert')
  AddEventHandler('ls_npcdialogue:Alert',function (scid)
    print("Alreat Inst")
    for _, value in pairs(Config.Scription) do
      if scid == value[1] then
        Alert(value[2],value[3],value[4],value[5])
      end
    end
  end)
  
  RegisterNUICallback(
    "NextAlert",
    function (data,cb)
      TriggerEvent('ls_npcdialogue:Alert',data.scid);
    end
  
  )