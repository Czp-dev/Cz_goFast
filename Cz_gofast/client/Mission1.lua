local isUIOpen = false
local isPlayerReady = false
local pedSpawn = false
local countdownTime = 300 
local remainingTime = 0
local isCountdownActive = false
local time = 0
local reward = 0

function openUI()
    if not isUIOpen then 
        isUIOpen = true
        SetNuiFocus(true, true)
        SendNuiMessage(json.encode{
            action = 'open'
        })
    else
        isUIOpen = false
        SetNuiFocus(false, false)
        SendNuiMessage(json.encode{
            action = 'close'
        })
    end
end

function DrawTextOnScreen(text, x, y)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(0.3, 0.3)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

RegisterNuiCallback('closeall', function ()
    if isUIOpen then
        openUI()
    end
end)

function getCar(carName, x, y, z, heading)
    RequestModel(carName)
    while not HasModelLoaded(carName) do 
        Citizen.Wait(10)
    end

    local playerPed = PlayerPedId()
    local car = CreateVehicle(GetHashKey(carName), x, y, z, heading, true, false)

    while not DoesEntityExist(car) do
        Citizen.Wait(10)
    end

    TaskWarpPedIntoVehicle(playerPed, car, -1)
end

function spawnPed()
    if pedSpawn then return end
    local hash = GetHashKey("a_m_o_acult_02")
        while not HasModelLoaded(hash) do
            RequestModel(hash)
            Wait(20)
        end
        ped = CreatePed("BigEnos", "a_m_o_acult_02",  414.3156, 343.4885, 102.5045-1, 338.8057, false, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
        pedSpawn = true
end

Citizen.CreateThread( function ()
    while true do
        spawnPed()
        time = 10000
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local distancePed = #(coords - vector3(414.3156, 343.4885, 102.5045))
        if distancePed < 100 then
            time = 200
            if distancePed < 10 then 
                time = 0
                ESX.ShowHelpNotification('Appuyez sur ~INPUT_CONTEXT~ pour intéragir')
                if IsControlJustReleased(1, 51) then 
                    openUI()
                end
            end
        end
        Citizen.Wait(time)
    end
end)

RegisterNuiCallback('firstMission', function ()
    finalcoords = vector3(2674.1750, 1515.8195, 24.4987)
    SetNewWaypoint(2674.1750, 1515.8195)
    getCar('sultan', 370.2192, 348.9810, 102.9179, 162.1385)
    isPlayerReady = true
    remainingTime = countdownTime 
    isCountdownActive = true
    reward = 15000
end)

RegisterNUICallback('secondMission', function()
    finalcoords = vector3(414.9604, 2996.5095, 40.5630)
    SetNewWaypoint(414.9604, 2996.5095)
    getCar('sultan', 370.2192, 348.9810, 102.9179, 162.1385)
    isPlayerReady = true
    remainingTime = countdownTime 
    isCountdownActive = true
    reward = 25000
end)

RegisterNUICallback('thrirdMission', function()
    finalcoords = vector3(51.9767, 7114.5098, 3.1057)
    SetNewWaypoint(51.9767, 7114.5098)
    getCar('sultan', 370.2192, 348.9810, 102.9179, 162.1385)
    isPlayerReady = true
    remainingTime = countdownTime 
    isCountdownActive = true
    reward = 35000
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000) 
        if isCountdownActive and remainingTime > 0 then
            remainingTime = remainingTime - 1
        elseif remainingTime <= 0 and isCountdownActive then
            ESX.ShowNotification("⏳ Temps écoulé ! Mission échouée.")
            isCountdownActive = false
            isPlayerReady = false
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if isPlayerReady then
            if isCountdownActive then
                local minutes = math.floor(remainingTime / 60)
                local seconds = remainingTime % 60
                DrawTextOnScreen(("Temps restant : %02d:%02d"):format(minutes, seconds),  0.80, 0.90)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000) 

        if isPlayerReady then
            local playerPed = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(playerPed, false)


            if vehicle == 0 then
                ESX.ShowNotification("⏳ Vous avez quitté le véhicule ! Mission échouée.")
                isPlayerReady = false  
                isCountdownActive = false

                if DoesEntityExist(vehicle) then
                    ESX.Game.DeleteVehicle(vehicle)
                end
            end
        end
    end
end)

Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(time)
       
        if isPlayerReady then
            time = 0
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            local distance1 = #(coords - vector3(finalcoords.x, finalcoords.y, finalcoords.z))
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            if distance1 < 10 then
                ESX.ShowHelpNotification('Appuyez sur ~INPUT_CONTEXT~ pour finir la course.')
                DrawMarker(25, finalcoords.x, finalcoords.y, finalcoords.z - 1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 0, 255, 0, 100, false, true, 2, false, false, false, false)

                if IsControlJustReleased(1, 51) then
                    ESX.Game.DeleteVehicle(vehicle)
                    TriggerServerEvent('gofast:reward', reward)
                    ESX.ShowNotification("Bien joué ! Vous venez de gagner ".. reward .." $")
                    isPlayerReady = false
                    isCountdownActive = false
                end
            end
        end
    end
end)