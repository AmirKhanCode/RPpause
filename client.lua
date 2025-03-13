ESX = nil


Citizen.CreateThread(function()
    while ESX == nil do
        Wait(10)
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end
end)

local blips = {}
function missionTextDisplay(text, time)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(time, 1)
end

local function RGBRainbow( frequency )
	local result = {}
	local curtime = GetGameTimer() / 1000

	result.r = math.floor( math.sin( curtime * frequency + 0 ) * 127 + 128 )
	result.g = math.floor( math.sin( curtime * frequency + 2 ) * 127 + 128 )
	result.b = math.floor( math.sin( curtime * frequency + 4 ) * 127 + 128 )
	
	return result
end


function Draw3DText(x,y,z, text,scl) 

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local xcale = (1/dist)*scl
    local fov = (1/GetGameplayCamFov())*100
    local xcale = xcale*fov
   
    if onScreen then
        SetTextScale(0.0*xcale, 1.1*xcale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString("~a~"..text)
        DrawText(_x,_y)
    end
end

RegisterNetEvent('Fax:AdminAreaSet')
AddEventHandler("Fax:AdminAreaSet", function(blip, s, p)
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
    ax = x
    ay = y
    az = z
    
    
    if s ~= nil then
        src = s
        coords = p
		coordss = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(-1)))
    else
        coords = p
    end
    
    if not blips[blip.index] then
        blips[blip.index] = {}
    end
    
    if not givenCoords then
        TriggerServerEvent('AdminArea:setCoords', tonumber(blip.index), coords)
    end

    
    blips[blip.index]["blip"] = AddBlipForCoord(coords.x, coords.y, coords.z)
    blips[blip.index]["radius"] = AddBlipForRadius(coords.x, coords.y, coords.z, blip.radius)
    SetBlipSprite(blips[blip.index].blip, 269)
    SetBlipAsShortRange(blips[blip.index].blip, true)
    SetBlipColour(blips[blip.index].blip, 3)
    SetBlipScale(blips[blip.index].blip, 0.9)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(blip.name)
    EndTextCommandSetBlipName(blips[blip.index].blip)
    blips[blip.index]["coords"] = coords


    SetBlipAlpha(blips[blip.index]["radius"], 50)
    SetBlipColour(blips[blip.index]["radius"], 49)
	blips[blip.index]["active"] = true

    if s ~= nil then
        source = s
        missionTextDisplay("~b~RP Pause ~o~| ~w~Mantaghe ~w~:~p~ Admin Area ~r~[~w~" .. tonumber(blip.index) .."~r~] ~o~| ~r~Admin~w~: " .. GetPlayerName(GetPlayerFromServerId(source)), 7000)
    end
	while blips[blip.index]["active"] do
	 Wait(1)
	 local rainbow = RGBRainbow( 1 )
	 local radius = blip.radius
	 local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
	 DrawMarker(28, blips[blip.index]["coords"], 0.0, 0.0, 0.0, 0, 0.0, 0.0, blip.radius, blip.radius, blip.radius, 255, 0, 255, 50, false, false, 2, false, false, false, false)
	 DrawMarker(28, blips[blip.index]["coords"], 0.0, 0.0, 0.0, 0, 0.0, 0.0, blip.radius, blip.radius, blip.radius, 255, 0, 255, 50, false, false, 2, false, false, false, false)
        if blips[blip.index]["coords"] ~= nil then
            source = s
			if GetDistanceBetweenCoords(x, y, z, blips[blip.index]["coords"], true) <= radius then
				SetCurrentPedWeapon(GetPlayerPed(-1),GetHashKey("WEAPON_UNARMED"),true)
                SetCurrentPedWeapon(GetPlayerPed(-1),GetHashKey("WEAPON_UNARMED"),true)
				DisableControlAction(0,37,true) 
				DisableControlAction(0,24,true) 
				DisableControlAction(0,205,true) 
				DisableControlAction(0,200,true) 
				DisableControlAction(0,170,true) 
                missionTextDisplay("~w~∑ ~r~Dar In Mantaghe RP Pause Shode Ast ~w~∑", 10)
				if GetDistanceBetweenCoords(x, y, z, blips[blip.index]["coords"], true) >= radius-1.5 then
                SetPedCoordsKeepVehicle(GetPlayerPed(-1), blips[blip.index]["coords"])
				end
				qx = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(-1)))
				if GetDistanceBetweenCoords(x, y, z, blips[blip.index]["coords"], true) >= radius-1 then
				SetPedCoordsKeepVehicle(GetPlayerPed(-1), qx.x-radius, qx.y+radius+1, qx.z)
				end
		    end
        end
    end
end)
			
RegisterNetEvent('xd:blipon')
AddEventHandler("xd:blipon", function(src)
    xdshahab = true
end)

RegisterNetEvent('xd:blipoff')
AddEventHandler("xd:blipoff", function(src)
    xdshahab = false
end)

RegisterNetEvent('Fax:AdminAreaClear')
AddEventHandler("Fax:AdminAreaClear", function(blipID)
    if blips[blipID] then
	    blips[blipID]["active"] = false
		RemoveBlip(blips[blipID].blip)
        RemoveBlip(blips[blipID].radius)
        blips[blipID] = nil
		missionTextDisplay("~g~ RP Unpause ~o~| ~w~ Mantaghe ~w~:~r~ Admin Area [~w~" .. blipID .. "~r~] ~o~| ~b~Mantaghe Azad Shod", 7000) 
    else
    end
end)