RegisterNetEvent("guille_gangs:client:notify")
AddEventHandler("guille_gangs:client:notify", function(txt)
    notify(txt)
end)

RegisterNetEvent("guille_gangs:client:notify")
AddEventHandler("guille_gangs:client:okoknotify", function(txt,type)
    okoknotify(txt,type)
end)