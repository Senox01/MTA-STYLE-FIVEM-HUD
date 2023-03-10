ESX = nil
loaded = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(100)
    end
    loaded = true
    ESX.PlayerData = ESX.GetPlayerData()
end)

function open()
    SendNUIMessage({
        type = "ui",
        status = true,
    })
end

function close()
    SendNUIMessage({
        type = "ui",
        status = false,
    })
end

function setSocBal(money)
    socBal = money
end

local id = 0
local health = 0
local armor = 0
local food = 0
local water = 0
local stamina = 0
local oxygen = 0
local job = ""
local jobgrade = ""
local socBal = 0
local cash = 0
local bank = 0
local black = 0
local isPause = false

Citizen.CreateThread(function()
    while loaded == false do
        Citizen.Wait(200)
    end

    while true do 
        Citizen.Wait(300)
        local ped =  GetPlayerPed(-1)
        local playerId = PlayerId()
        SetPlayerHealthRechargeMultiplier(playerId, 0)
        health = GetEntityHealth(ped)/2
        armor = GetPedArmour(ped)
        stamina = 100 - GetPlayerSprintStaminaRemaining(playerId)
        stamina = math.ceil(stamina)
        oxygen = GetPlayerUnderwaterTimeRemaining(playerId)*10
        oxygen = math.ceil(oxygen)
        SendNUIMessage({
            type = "update",
            id = id,
            health = health,
            armor = armor,
            food = food,
            water = water,
            stamina = stamina,
            oxygen = oxygen,
            job = job,
            jobgrade = jobgrade,
            socBal = socBal,
            cash = cash,
            bank = bank,
            black = black,
        })
    end
end)

Citizen.CreateThread(function()
    while loaded == false do
        Citizen.Wait(1000)
    end

    while true do
        Citizen.Wait(1000)
        TriggerEvent('esx_status:getStatus', 'hunger', function(hunger)
            TriggerEvent('esx_status:getStatus', 'thirst', function(thirst)
              food = hunger.getPercent()
              water = thirst.getPercent()
            end)
        end)
    end
end)

Citizen.CreateThread(function()
    while loaded == false do
        Citizen.Wait(100)
    end
    local isPause = false
    while true do
        Citizen.Wait(1000)
        
        if IsPauseMenuActive() then 
            isPause = true
            SendNUIMessage({
                type = "ui",
                status = false,
            })
        
        elseif not IsPauseMenuActive() and isPause then
            isPause = false
            SendNUIMessage({
                type = "ui",
                status = true,
            })
        end
    end
end)

Citizen.CreateThread(function()
    while loaded == false do
        Citizen.Wait(500)
    end

    while true do
        Citizen.Wait(3000)
        ESX.PlayerData = ESX.GetPlayerData()
        
        job =  ESX.PlayerData.job.label 
        jobgrade = ESX.PlayerData.job.grade_label

        if ESX.PlayerData.job.grade_name == 'boss' then

            ESX.TriggerServerCallback("esx_society:getSocietyMoney", function(money)
                socBal = money               
            end, ESX.PlayerData.job.name)
            SendNUIMessage({
                type = "isBoss",
                isBoss = true
            })
            
            
        elseif ESX.PlayerData.job.grade_name ~= 'boss' then
            SendNUIMessage({
                type = "isBoss",
                isBoss = false,
            })
        end

        TriggerServerEvent('hud:getServerInfo')
    end
end)


Citizen.CreateThread(function()
    while loaded == false do
        Citizen.Wait(100)
    end

    while true do
        Citizen.Wait(1000)

       alcohol = 80 --A megszerzett alkohol szint (0-100)
       drug = 25-- A megszerzett drog szint (0-100)
       stress = 55--A megszerzett stress szint (0-100)

    end
end)




Citizen.CreateThread(function()
    while true do
      Citizen.Wait(1000)
      HideHudComponentThisFrame(1)  -- Wanted Stars
    --   HideHudComponentThisFrame(2)  -- Weapon Icon
      HideHudComponentThisFrame(3)  -- Cash
      HideHudComponentThisFrame(4)  -- MP Cash
      HideHudComponentThisFrame(6)  -- Vehicle Name
      HideHudComponentThisFrame(7)  -- Area Name
      HideHudComponentThisFrame(8)  -- Vehicle Class
      HideHudComponentThisFrame(9)  -- Street Name
      HideHudComponentThisFrame(13) -- Cash Change
      HideHudComponentThisFrame(17) -- Save Game
    --   HideHudComponentThisFrame(20) -- Weapon Stats
    end
  end)
  

RegisterNetEvent('hud:setInfo')
AddEventHandler('hud:setInfo', function(info)
	cash = info['money']
	bank = info['bankMoney']
    black = info['blackMoney']
    id = info['id']
end)


relevantInteriors = {
    {
        id = 1,
        groupName = "Cypress Flats tunnel",
        interiors = {{id = 248577, details = "Segment 1 (South exit)"}, {id = 248833, details = "Segment 2"}, {id = 249089, details = "Segment 3 (Incl. northern maintenance tunnel)"}, {id = 249601, details = "Segment 4"}, {id = 249857, details = "Segment 5 (Incl. southern maintenance tunnel)"}, {id = 250113, details = "Segment 6"}, {id = 250369, details = "Segment 7 (North exit)"}}
    },
    {
        id = 2,
        groupName = "Rancho tunnel",
        interiors = {
            {id = 194817, details = "Tunnel, segment 1 (West exit)"},
            {id = 196353, details = "Tunnel, segment 2 (Southern fork segment 1)"},
            {id = 195329, details = "Tunnel, segment 3 (Southern fork segment 2)"},
            {id = 195841, details = "Tunnel, segment 4 (Southern fork segment 3) (East exit)"},
            {id = 196097, details = "Tunnel, segment 5 (Northern fork segment 1)"},
            {id = 195073, details = "Tunnel, segment 6 (Northern fork segment 2)"},
            {id = 195585, details = "Tunnel, segment 7 (Northern fork segment 3) (East exit)"}
        }
    },
    {
        id = 3,
        groupName = "Southern Subway System",
        interiors = {
            {id = 54018, details = "Segment 1 (North exit)"},
            {id = 33538, details = "Segment 2"},
            {id = 27394, details = "Segment 3"},
            {id = 29186, details = "Segment 4"},
            {id = 49666, details = "Segment 5"},
            {id = 87042, details = "Segment 6"},
            {id = 83714, details = "Segment 8"},
            {id = 89858, details = "Segment 9"},
            {id = 77570, details = "Segment 0"},
            {id = 79618, details = "Segment 10"},
            {id = 48642, details = "Segment 11"},
            {id = 109570, details = "Segment 12"},
            {id = 84226, details = "Segment 13"},
            {id = 34050, details = "Segment 14"},
            {id = 4354, details = "Segment 15"},
            {id = 45058, details = "Segment 16"},
            {id = 12546, details = "Segment 17"},
            {id = 16642, details = "Segment 18"},
            {id = 56578, details = "Segment 19"},
            {id = 8450, details = "Segment 20"},
            {id = 102658, details = "Segment 21"},
            {id = 26626, details = "Segment 22"},
            {id = 6658, details = "Segment 23"},
            {id = 69378, details = "Segment 24"},
            {id = 39170, details = "Segment 25"},
            {id = 61698, details = "Platform area of LSIA parking station"},
            {id = 65538, details = "Upper area of LSIA parking station"},
            {id = 164097, details = "Entrance area of LSIA parking station"},
            {id = 51970, details = "Segment 27"},
            {id = 63746, details = "Segment 28"},
            {id = 62210, details = "Segment 29"},
            {id = 78082, details = "Segment 30"},
            {id = 25858, details = "Segment 31"},
            {id = 53506, details = "Segment 32"},
            {id = 81922, details = "Segment 33"},
            {id = 77058, details = "Segment 34"},
            {id = 73218, details = "Segment 35"},
            {id = 11778, details = "Segment 36"},
            {id = 93698, details = "Segment 37"},
            {id = 95746, details = "Segment 38"},
            {id = 26370, details = "Segment 39"},
            {id = 67842, details = "Segment 40"},
            {id = 706558, details = "Segment 41"},
            {id = 77314, details = "Platform area of LSIA terminal 4 station"},
            {id = 10856, details = "Upper area of LSIA terminal 4 station"},
            {id = 163329, details = "Entrance area of LSIA terminal 4 station"},
            {id = 40706, details = "Segment 43"},
            {id = 112130, details = "Segment 44"},
            {id = 76546, details = "Segment 45"},
            {id = 98050, details = "Segment 46"},
            {id = 32514, details = "Segment 47"},
            {id = 9218, details = "Segment 48"},
            {id = 15362, details = "Segment 49"},
            {id = 119554, details = "Segment 50"},
            {id = 11522, details = "Segment 51"},
            {id = 44034, details = "Segment 52"},
            {id = 51202, details = "Segment 53"},
            {id = 24834, details = "Segment 54"},
            {id = 34562, details = "Segment 55"},
            {id = 79362, details = "Segment 56"},
            {id = 88578, details = "Segment 57"},
            {id = 59650, details = "Segment 58"},
            {id = 40706, details = "Segment 59"}
        }
    },
    {
        id = 3,
        groupName = "Northern Subway System",
        interiors = {

            {id = 23298, details = "Pillbox North tunnel, segment 1 (Highway breach)"},
            {id = 59906, details = "Pillbox North tunnel, segment 2 (Surface craning area)"},
            {id = 36610, details = "Pillbox North tunnel, segment 3"},
            {id = 120322, details = "Pillbox North tunnel, segment 4"},
            {id = 9986, details = "Pillbox North tunnel, segment 5"},

            {id = 14082, details = "Sewer tunnel, segment 1 (North exit to LS river)"},
            {id = 42242, details = "Sewer tunnel, segment 2"},
            {id = 45826, details = "Sewer tunnel, segment 3"},
            {id = 55810, details = "Sewer tunnel, segment 4"},
            {id = 57346, details = "Sewer tunnel, segment 5"},
            {id = 109826, details = "Sewer tunnel, segment 6"},
            {id = 10498, details = "Sewer tunnel, segment 7 (East fork)"},
            {id = 71938, details = "Sewer tunnel, segment 8"},
            {id = 43266, details = "Sewer tunnel, segment 9"},
            {id = 26114, details = "Sewer tunnel, segment 10 (Maintenance tunnel)"},

            {id = 67586, details = "Eastern tunnel, segment 1"},
            {id = 57602, details = "Eastern tunnel, segment 2"},
            {id = 5378, details = "Eastern tunnel, segment 3"},
            {id = 89346, details = "Eastern tunnel, segment 4"},
            {id = 7426, details = "Eastern tunnel, segment 5"},
            {id = 19970, details = "Eastern tunnel, segment 6"},
            {id = 38914, details = "Eastern tunnel, segment 7"},
            {id = 113154, details = "Eastern tunnel, segment 8"},
            {id = 65026, details = "Eastern tunnel, segment 9"},
            {id = 63490, details = "Eastern tunnel, segment 10"},
            {id = 105986, details = "Eastern tunnel, segment 11"},
            {id = 88322, details = "Eastern tunnel, segment 12"},
            {id = 78850, details = "Eastern tunnel, segment 13"},
            {id = 82946, details = "Eastern tunnel, segment 14"},
            {id = 73730, details = "Eastern tunnel, segment 15"},
            {id = 98562, details = "Eastern tunnel, segment 16"},
            {id = 91138, details = "Eastern tunnel, segment 17"},
            {id = 51714, details = "Eastern tunnel, segment 18 (East exit near LS river)"},

            {id = 72194, details = "Western tunnel, segment 1"},
            {id = 103426, details = "Western tunnel, segment 2"},
            {id = 57858, details = "Western tunnel, segment 3"},
            {id = 94466, details = "Western tunnel, segment 4"},
            {id = 41218, details = "Western tunnel, segment 5"},
            {id = 68354, details = "Western tunnel, segment 6"},
            {id = 105474, details = "Western tunnel, segment 7"},
            {id = 59394, details = "Western tunnel, segment 8"},
            {id = 102402, details = "Western tunnel, segment 9"},
            {id = 65794, details = "Western tunnel, segment 10"},
            {id = 82434, details = "Western tunnel, segment 11"},
            {id = 47618, details = "Western tunnel, segment 12"},
            {id = 13570, details = "Western tunnel, segment 13"},
            {id = 11010, details = "Western tunnel, segment 14"},
            {id = 72962, details = "Western tunnel, segment 15"},
            {id = 20738, details = "Western tunnel, segment 16"},
            {id = 4610, details = "Western tunnel, segment 17"},
            {id = 5634, details = "Platform area of Burton Station"},
            {id = 32770, details = "Upper area of Burton Station"},
            {id = 233473, details = "Entrance area of Burton Station"},
            {id = 23810, details = "Western tunnel, segment 19"},
            {id = 64258, details = "Western tunnel, segment 20"},
            {id = 33794, details = "Western tunnel, segment 21"},
            {id = 44546, details = "Western tunnel, segment 22"},
            {id = 63234, details = "Western tunnel, segment 23"},
            {id = 2818, details = "Western tunnel, segment 24"},
            {id = 67330, details = "Western tunnel, segment 25"},
            {id = 48898, details = "Western tunnel, segment 26"},
            {id = 107522, details = "Western tunnel, segment 27"},
            {id = 101890, details = "Western tunnel, segment 28"},
            {id = 74498, details = "Western tunnel, segment 29"},
            {id = 42498, details = "Western tunnel, segment 30"},
            {id = 41730, details = "Western tunnel, segment 31"},
            {id = 96514, details = "Western tunnel, segment 32"},
            {id = 87298, details = "Western tunnel, segment 33"},
            {id = 45314, details = "Western tunnel, segment 34"},
            {id = 99330, details = "Western tunnel, segment 35"},
            {id = 37634, details = "Western tunnel, segment 36"},
            {id = 18434, details = "Western tunnel, segment 37"},
            {id = 92418, details = "Western tunnel, segment 38"},
            {id = 87438, details = "Western tunnel, segment 39"},
            {id = 8962, details = "Western tunnel, segment 40"},
            {id = 84482, details = "Platform area of Portola Station"},
            {id = 91650, details = "Upper area of Portola Station)"},
            {id = 166913, details = "Entrance area of Portola Station"},
            {id = 14594, details = "Western tunnel, segment 44"},
            {id = 77826, details = "Western tunnel, segment 45"},
            {id = 17410, details = "Western tunnel, segment 46"},
            {id = 51458, details = "Western tunnel, segment 47"},
            {id = 120066, details = "Western tunnel, segment 48"},
            {id = 68098, details = "Western tunnel, segment 49"},
            {id = 111874, details = "Western tunnel, segment 50"},
            {id = 35842, details = "Western tunnel, segment 51"},
            {id = 57090, details = "Western tunnel, segment 52"},
            {id = 27906, details = "Western tunnel, segment 53"},
            {id = 76034, details = "Western tunnel, segment 54"},
            {id = 75266, details = "Western tunnel, segment 55"},
            {id = 18946, details = "Western tunnel, segment 56"},
            {id = 12290, details = "Western tunnel, segment 57"},
            {id = 2306, details = "Western tunnel, segment 58"},
            {id = 52738, details = "Western tunnel, segment 59"},
            {id = 24322, details = "Western tunnel, segment 60"},
            {id = 115202, details = "Western tunnel, segment 61"},
            {id = 110594, details = "Western tunnel, segment 62"},
            {id = 118786, details = "Western tunnel, segment 63"},
            {id = 6402, details = "Western tunnel, segment 64"},
            {id = 10710, details = "Western tunnel, segment 65"},
            {id = 38146, details = "Western tunnel, segment 66"},
            {id = 116738, details = "Western tunnel, segment 67"},
            {id = 116482, details = "Western tunnel, segment 68"},
            {id = 26882, details = "Western tunnel, segment 69"},
            {id = 38402, details = "Western tunnel, segment 70"},
            {id = 770, details = "Western tunnel, segment 71"},
            {id = 117250, details = "Western tunnel, segment 72"},
            {id = 4098, details = "Western tunnel, segment 73"},
            {id = 54274, details = "Western tunnel, segment 74"},
            {id = 54530, details = "Western tunnel, segment 75"},
            {id = 98306, details = "Platform area of Del Perro Station"},
            {id = 5122, details = "Upper area of Del Perro Station"},
            {id = 168705, details = "Entrance area of Del Perro Station"},
            {id = 109058, details = "Western tunnel, segment 77"},
            {id = 43010, details = "Western tunnel, segment 78"},
            {id = 99586, details = "Western tunnel, segment 79"},
            {id = 53762, details = "Western tunnel, segment 80"},
            {id = 48386, details = "Western tunnel, segment 81"},
            {id = 91906, details = "Western tunnel, segment 82"},
            {id = 50434, details = "Western tunnel, segment 83"},
            {id = 58370, details = "Western tunnel, segment 84"},
            {id = 109314, details = "Western tunnel, segment 85"},
            {id = 85506, details = "Western tunnel, segment 86"},
            {id = 93954, details = "Western tunnel, segment 87"},
            {id = 65282, details = "Western tunnel, segment 88"},
            {id = 66818, details = "Western tunnel, segment 89"},
            {id = 74242, details = "Western tunnel, segment 90"},
            {id = 58114, details = "Western tunnel, segment 91"},
            {id = 44802, details = "Western tunnel, segment 92"},
            {id = 103682, details = "Western tunnel, segment 93"},
            {id = 44290, details = "Western tunnel, segment 94"},
            {id = 68610, details = "Western tunnel, segment 95"},
            {id = 24066, details = "Western tunnel, segment 96"},
            {id = 100098, details = "Western tunnel, segment 97"},
            {id = 92930, details = "Western tunnel, segment 98"},
            {id = 43778, details = "Western tunnel, segment 99"},
            {id = 92162, details = "Western tunnel, segment 100"},
            {id = 75522, details = "Western tunnel, segment 101"},
            {id = 56322, details = "Western tunnel, segment 102"},
            {id = 25346, details = "Western tunnel, segment 103"},
            {id = 46082, details = "Western tunnel, segment 104"},
            {id = 120578, details = "Western tunnel, segment 105"},
            {id = 97794, details = "Western tunnel, segment 106"},
            {id = 114434, details = "Western tunnel, segment 107"},
            {id = 47106, details = "Western tunnel, segment 108"},
            {id = 30210, details = "Western tunnel, segment 109"},
            {id = 28930, details = "Western tunnel, segment 110"},
            {id = 107266, details = "Western tunnel, segment 111"},
            {id = 68866, details = "Platform area of Little Seoul Station"},
            {id = 20482, details = "Upper area of Little Seoul Station"},
            {id = 167681, details = "Entrance area of Little Seoul Station"},
            {id = 36098, details = "Western tunnel, segment 113"},
            {id = 106754, details = "Western tunnel, segment 114"},
            {id = 21506, details = "Western tunnel, segment 115"},
            {id = 84994, details = "Western tunnel, segment 116"},
            {id = 86786, details = "Western tunnel, segment 117"},
            {id = 56066, details = "Western tunnel, segment 118"},
            {id = 78594, details = "Western tunnel, segment 119"},
            {id = 23554, details = "Western tunnel, segment 120"},
            {id = 54786, details = "Western tunnel, segment 121"},
            {id = 46594, details = "Western tunnel, segment 122"},
            {id = 1026, details = "Western tunnel, segment 123"},
            {id = 71426, details = "Western tunnel, segment 124"},
            {id = 52994, details = "Western tunnel, segment 125"},
            {id = 14850, details = "Western tunnel, segment 126"},
            {id = 56834, details = "Western tunnel, segment 127"},
            {id = 31234, details = "Western tunnel, segment 128"},
            {id = 83458, details = "Western tunnel, segment 129"},
            {id = 81410, details = "Western tunnel, segment 130"},
            {id = 55298, details = "Western tunnel, segment 131 (Pillbox Hill South Station)"}
        }
    }
}
Citizen.CreateThread(function()
    while true do
        currentInteriorId = GetInteriorFromEntity(GetPlayerPed(-1))
        print("currentInteriorId = " .. currentInteriorId)
        if currentInteriorId ~= 0 then
            print("fasz")
        end
        Wait(5000)
    end
end)


local isShow = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, 244) then
            if isShow == false then
                SetNuiFocus(true,true)
                isShow = true
            if isShow == true then
                SetNuiFocus(false,true)
                isShow = false
            end
            end
        end
    end
end)

