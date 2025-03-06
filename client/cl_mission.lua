local isUIOpen = false
local isPlayerReady = false
local isPlayerGetMarch = false
local isPlayerInCar = false
local isPlayerMission = false
local countdownTime = 300 
local remainingTime = 0
local isCountdownActive = false
local time = 0
local reward = 0
local pedSpawn = false
local isPedSpawn = false



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

end

function spawnPed()
    if pedSpawn then return end

    local hash = GetHashKey("a_m_o_acult_02")
    RequestModel(hash)

    while not HasModelLoaded(hash) do
        Wait(20)
    end

    ped = CreatePed(4, hash, 414.3156, 343.4885, 102.5045 - 1, 338.8057, false, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)

    exports.ox_target:addLocalEntity(ped, {
        {
            name = 'ped_interaction',
            label = 'Voir les missions',
            icon = 'fa-solid fa-user',
            distance = 4.0, 
            onSelect = function()
                openUI()
            end
        }
    })

    SetModelAsNoLongerNeeded(hash)

    pedSpawn = true
end

function spawnPed2(x, y, z, h)
    if not isPlayerMission then
        if isPedSpawn then return end
        local hash = GetHashKey("a_m_o_acult_02")
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Wait(20)
        end
        ped = CreatePed(4, hash, x, y, z, h, false, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
        exports.ox_target:addLocalEntity(ped, {
            {
                name = 'ped_interaction',
                label = 'Prendre La Marchandise',
                icon = 'fa-solid fa-user',
                distance = 4.0, 
                onSelect = function()                
                    isPlayerGetMarch = true
                end
            }
        })
        SetModelAsNoLongerNeeded(hash) 
        isPedSpawn = true
    end
end

RegisterNuiCallback('firstMission', function ()
    isPedSpawn = false
    countdownTime = 300
    remainingTime = countdownTime 
    isCountdownActive = true
    reward = 400
    isPlayerReady = true
    finalcoords = vector3(1233.0366, -3229.5491, 5.7562)
    carCoords = vector3(359.5537, 271.0142, 103.0787)
    coords = vector3(230.2068, 113.6821, 93.7016)
    SetNewWaypoint(carCoords.x, carCoords.y)
    getCar('sultan', 359.5537, 271.0142, 103.0787, 342.0844)
    openUI()
    spawnPed2(230.2068, 113.6821, 93.7016 -1, 183.8655)
end)

RegisterNUICallback('secondMission', function()
    isPedSpawn = false
    countdownTime = 500
    finalcoords = vector3(2674.1750, 1515.8195, 24.4987)
    coords = vector3(2888.2100, 4395.3896, 50.3113)
    carCoords = vector3(359.5537, 271.0142, 103.0787)
    SetNewWaypoint(carCoords.x, carCoords.y)
    getCar('sultan', 359.5537, 271.0142, 103.0787, 342.0844)
    openUI()
    spawnPed2(2888.2100, 4395.3896, 50.3113 -1, 307.8970)
    isPlayerReady = true
    remainingTime = countdownTime 
    isCountdownActive = true
    reward = 650
end)

RegisterNUICallback('thirdMission', function()
    isPedSpawn = false
    countdownTime = 650
    isPlayerReady = true
    remainingTime = countdownTime 
    isCountdownActive = true
    reward = 250
    finalcoords = vector3(1462.8651, 6548.9268, 14.3033)
    coords = vector3(1048.1499, 2653.6880, 39.5511)
    carCoords = vector4(359.5537, 271.0142, 103.0787, 342.0844)
    SetNewWaypoint(carCoords.x, carCoords.y)
    getCar('sultan', carCoords.x, carCoords.y, carCoords.z, carCoords.w)
    openUI()
    spawnPed2(1048.1499, 2653.6880, 39.5511 -1, 175.1003)
end)

Citizen.CreateThread( function ()
    while true do
        if isPlayerInCar then 
            SetNewWaypoint(coords.x, coords.y)
        end
        Citizen.Wait(0)
    end
end)



Citizen.CreateThread(function()
    spawnPed()
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
        if not isPlayerMission then
            if isCountdownActive then
                local minutes = math.floor(remainingTime / 60)
                local seconds = remainingTime % 60
                DrawTextOnScreen(("Temps restant : %02d:%02d"):format(minutes, seconds),  0.90, 0.97)
            end
        end
    end
end)


Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(time)
       
        if isPlayerGetMarch then
            isPlayerInCar = false
            SetNewWaypoint(finalcoords.x, finalcoords.y)
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
                    isPlayerGetMarch = false
                    isPlayerInCar = false
                    isPlayerMission = false
                    isCountdownActive = false
                end
            end
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(time)    
        if isPlayerReady then
            time = 0
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            local distance1 = #(coords - vector3(carCoords.x, carCoords.y, carCoords.z))
            local vehicle = GetVehiclePedIsIn(playerPed, true)
            if distance1 < 1 then
               isPlayerReady = false
               isPlayerInCar = true
                if not vehicle then
                    print('ok')
                    isPlayerMission = true
                end
            end
        end
    end
end)