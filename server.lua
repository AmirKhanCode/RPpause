ESX = nil
local blips = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("AdminArea:setCoords")
AddEventHandler("AdminArea:setCoords", function(id, coords)

    if not coords then return end
    
    if blips[id] then
        blips[id].coords = coords
    else
        print("Exception Happened Blip ID: " .. tostring(id) .. " Na Motabar")
    end

end)

RegisterCommand('rpp', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.permission_level > 2 then

        if xPlayer.get('aduty') then
            local radius = tonumber(args[1])
            if radius then radius = radius / 1.0 else radius = 50.0 end
            local index = math.floor(TableLength() + 1)
            local blip = {id = 269, name = "Admin Area [" .. index .. "] ", radius = radius, color = 32, index = tostring(index), coords = 0}
            table.insert(blips, blip)
			if radius >= 4 then
            TriggerClientEvent("Fax:AdminAreaSet", -1, blip, source, GetEntityCoords(GetPlayerPed(source)))
			TriggerClientEvent("ah:blipon", -1, source)
			else
			 TriggerClientEvent('esx:showNotification', source, "[ System ]  ", {255, 0, 0}, " ^0Blip ID Bayad Bishtar Az 4 Bashad!")
			end
        else
            TriggerClientEvent('esx:showNotification', source, "[ System ]  ", {255, 0, 0}, " ^0Shoma Nemitavanid Dar Halat ^1OffDuty ^0Az Command Haye Admini Estefade Konid!")
        end

    else
        TriggerClientEvent('esx:showNotification', source, "[ System ]  ", {255, 0, 0}, " ^0Shoma Admin Nistid!")
    end
end)

RegisterCommand('rps', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
	
    if xPlayer.permission_level > 2 then

        if xPlayer.get('aduty') then

            if args[1] then
                if tonumber(args[1]) then
                    local blipID = tonumber(args[1])
                     TriggerClientEvent("ah:blipoff", -1, source)
                    if findArea(blipID) then
					
					    
                        TriggerClientEvent("Fax:AdminAreaClear", -1, tostring(blipID))
                        SRemoveBlip(blipID)
						
						
                    else
                        TriggerClientEvent('esx:showNotification', source, "[ System ]  ", {255, 0, 0}, " ^0Blip ID Vared Shode Eshtebah Ast!")
                    end

                else
                    TriggerClientEvent('esx:showNotification', source, "[ System ]  ", {255, 0, 0}, " ^0Shoma Dar Ghesmat ID Blip Faghat Mitavanid Adad Vared Konid!")
                end
            else
                TriggerClientEvent('esx:showNotification', source, "[ System ]  ", {255, 0, 0}, " ^0Shoma Dar Ghesmat ID Blip Chizi Vared Nakardid!")
            end
        else
              TriggerClientEvent('esx:showNotification', source, "[ System ]  ", {255, 0, 0}, " ^0Shoma Nemitavanid Dar Halat ^1OffDuty ^0Az Command Haye Admini Estefade Konid!")
        end
    else
        TriggerClientEvent('esx:showNotification', source, "[ System ]  ", {255, 0, 0}, " ^0Shoma Admin Nistid!")
    end
end)

AddEventHandler('esx:playerLoaded', function(source)
    
    if #blips ~= 0 then
        for k,v in pairs(blips) do
            if v.coords ~= 0 then
                TriggerClientEvent("Fax:AdminAreaSet", source, v)
            end
        end
    end

end)

function findArea(areaID)
    for k,v in pairs(blips) do
        if k == areaID then
            return true
        end
    end

    return false
end

function SRemoveBlip(areaID)
    blips[areaID] = nil
end

function TableLength()

    if #blips == 0 then
        return 0
    else
        return blips[#blips].index
    end

end