local hudVisible = true
local notifiedHunger = false
local notifiedThirst = false
local inVehicle = false

local currentHunger, currentWater, currentStress = 0, 0, 0

RegisterCommand('hud', function()
    hudVisible = not hudVisible
    SendNUIMessage({ type = "toggleHUD", show = hudVisible })
    DisplayRadar(false)
end)

Citizen.CreateThread(function()
    local isBloodEffectActive = false
    
    DisplayRadar(false)

    while true do
        local ped = PlayerPedId()
        local playerId = PlayerId()
        local veh = GetVehiclePedIsIn(ped, false)
        
        inVehicle = (veh ~= 0)
        local speed = 0
        local fuelLevel = 0

        if inVehicle then
            speed = math.ceil(GetEntitySpeed(veh) * 3.6)
            fuelLevel = exports['mg_bridge']:GetFuel(veh)
        end
        
        local proximityData = LocalPlayer.state.proximity or {index = 1}
        local pmaLevel = proximityData.index or 1
        local voiceLevel = (pmaLevel == 1 and 33) or (pmaLevel == 2 and 66) or 100
        local isTalking = NetworkIsPlayerTalking(playerId)

        local hp = GetEntityHealth(ped) - 100
        if hp <= 20 and hp > 0 and hudVisible then
            if not isBloodEffectActive then
                AnimpostfxPlay("DeathFailOut", 0, true)
                isBloodEffectActive = true
            end
        elseif isBloodEffectActive then
            AnimpostfxStop("DeathFailOut")
            isBloodEffectActive = false
        end

        if Config.Framework == 'esx' then
            TriggerEvent('esx_status:getStatus', 'hunger', function(s) currentHunger = s.getPercent() end)
            TriggerEvent('esx_status:getStatus', 'thirst', function(s) currentWater = s.getPercent() end)
            if Config.EnableStress then 
                TriggerEvent('esx_status:getStatus', 'stress', function(s) currentStress = s.getPercent() end) 
            end
        elseif Config.Framework == 'qb' then
            local PlayerData = exports['qb-core']:GetCoreObject().Functions.GetPlayerData()
            if PlayerData and PlayerData.metadata then
                currentHunger = PlayerData.metadata["hunger"] or 0
                currentWater = PlayerData.metadata["thirst"] or 0
                currentStress = Config.EnableStress and (PlayerData.metadata["stress"] or 0) or 0
            end
        end

        if currentHunger <= 10 and not notifiedHunger then
            exports['mg_bridge']:Notify(Config.Locales['hunger_notif'], Config.NotificationType, Config.NotificationTime)
            notifiedHunger = true
        elseif currentHunger > 10 then 
            notifiedHunger = false 
        end

        if currentWater <= 10 and not notifiedThirst then
            exports['mg_bridge']:Notify(Config.Locales['thirst_notif'], Config.NotificationType, Config.NotificationTime)
            notifiedThirst = true
        elseif currentWater > 10 then 
            notifiedThirst = false 
        end

        SendNUIMessage({
            type = "updateHUD",
            isPaused = IsPauseMenuActive() or not hudVisible,
            logoURL = Config.ServerLogoURL,
            logoPos = Config.LogoPosition,
            colors = Config.Colors,
            
            hp = hp,
            armor = GetPedArmour(ped),
            hunger = currentHunger,
            water = currentWater,
            stamina = 100 - GetPlayerSprintStaminaRemaining(playerId),
            stress = currentStress,
            oxygen = GetPlayerUnderwaterTimeRemaining(playerId) * 10,
            
            inVehicle = inVehicle,
            speed = speed,
            fuel = fuelLevel,
            
            inWater = IsPedSwimmingUnderWater(ped),
            enableStress = Config.EnableStress,
            
            voiceLevel = voiceLevel,
            isTalking = isTalking,
            playerId = GetPlayerServerId(playerId)
        })

        if IsRadarEnabled() then 
            DisplayRadar(false) 
        end

        Citizen.Wait(inVehicle and 16 or 500)
    end
end)