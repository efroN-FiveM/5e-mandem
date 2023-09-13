ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- NUI Callback
RegisterNUICallback("exit", function()
  TriggerScreenblurFadeOut(0)
  SendNUIMessage({
    display = false
  })
  SetNuiFocus(false, false) 
end)

RegisterNUICallback("washMoney", function()
  ESX.TriggerServerCallback('5e_moneywash:getblackmoney', function(result, blackMoney)
    if result == true then
      TriggerEvent('esx:showNotification', 'You have washed $'..blackMoney)
      TriggerScreenblurFadeOut(0)
      SendNUIMessage({
        display = false
      })
      SetNuiFocus(false, false) 
    end
  end)
end)

function openNUI() 
  ESX.TriggerServerCallback('5e_moneywash:getblackmoney', function(blackMoneyAmount)
    if blackMoneyAmount < 0 then
      TriggerScreenblurFadeIn(0)
      SendNUIMessage({
        display = true,
        notificationdisplay = true,
        blackmoney = blackMoneyAmount
      })
      SetNuiFocus(true, true) 
    else
      TriggerEvent('esx:showNotification', 'You don\'t have black money!')
    end
  end)
end

-- Thread
CreateThread(function()
  local alreadyEnteredZone = false
    while true do
        wait = 5
        local ped = PlayerPedId()
        local inZone = false
        for k, v in pairs(Config.Locations) do
            local dist = #(GetEntityCoords(ped)-vector3(v.coords.x,v.coords.y,v.coords.z))
            if dist <= 5.0 then
                wait = 5
                inZone  = true
                if IsControlJustReleased(0, 38) then
                    openNUI()
                end
                break
            else
                wait = 2000
            end
        end
        
        if inZone and not alreadyEnteredZone then
            alreadyEnteredZone = true
            SendNUIMessage({
              notificationdisplay = true
            })
        end

        if not inZone and alreadyEnteredZone then
            alreadyEnteredZone = false
            SendNUIMessage({
              notificationdisplay = false
            })
        end
        Citizen.Wait(wait)
    end
end)