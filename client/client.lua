local blip = nil
local waypoints = {}
local marker = true

function SaveWaypoint(coords)
    if waypoints == nil then
        waypoints = {}
    end

    if #waypoints > 0 then
        waypoints[1] = {x = coords.x, y = coords.y, z = coords.z}

	if Config.Debug then
        print("Waypoint updated! New Coordinates:", coords.x, coords.y, coords.z)
	end
    else
        table.insert(waypoints, {x = coords.x, y = coords.y, z = coords.z})

	if Config.Debug then
        print("Waypoint saved! Coordinates", coords.x, coords.y, coords.z)
	end
    end
end

function AddMarker(coords)
     if marker then
	local WaypointSaveCoord = vector3(waypoints[1].x, waypoints[1].y, waypoints[1].z)
        Citizen.InvokeNative(0x2A32FAA57B937173,Config.MarkerStyle, WaypointSaveCoord.x, WaypointSaveCoord.y, WaypointSaveCoord.z - 1,0,0,0,0,0,0,1.0,1.0,500.0,Config.MarkerColor.r,Config.MarkerColor.g,Config.MarkerColor.b,Config.MarkerColor.a,0, 0, 2, 0, 0, 0, 0)
    end
end

CreateThread(function()
    while true do
        Wait(Config.WaypointColorChangeDelay)
		
        if IsWaypointActive() then
            local WaypointCoords = GetWaypointCoords()
            SaveWaypoint(WaypointCoords)
            SetWaypointOff()
            ClearGpsMultiRoute()
            StartGpsMultiRoute(GetHashKey(Config.WaypointColor), true, true)
            AddPointToGpsMultiRoute(WaypointCoords.x, WaypointCoords.y, WaypointCoords.z)

            if blip then
                RemoveBlip(blip)
            end

            if Config.AddBlipWaypointEndPoint then
                blip = N_0x554d9d53f696d002(1664425300, WaypointCoords.x, WaypointCoords.y, WaypointCoords.z)
                SetBlipSprite(blip, Config.BlipSprite, true)
                SetBlipScale(blip, 0.2)
                Citizen.InvokeNative(0x9CB1A1623062F402, blip, Config.BlipName)
                BlipAddModifier(blip, GetHashKey(Config.BlipColor))
            end
            
            SetGpsMultiRouteRender(true)
	    marker = true
        end

        local PlayerCoords = GetEntityCoords(PlayerPedId())
        if waypoints and #waypoints > 0 then
            local WaypointSaveCoord = vector3(waypoints[1].x, waypoints[1].y, waypoints[1].z)
            local distance = math.sqrt((PlayerCoords.x - WaypointSaveCoord.x)^2 + (PlayerCoords.y - WaypointSaveCoord.y)^2)

	   if Config.Debug then
            print(string.format("Player Coords: x=%.2f, y=%.2f z=%.2f", PlayerCoords.x, PlayerCoords.y, PlayerCoords.z))
            print(string.format("Waypoint Coords: x=%.2f, y=%.2f", WaypointSaveCoord.x, WaypointSaveCoord.y))
            print(string.format("Distance: %.2f", distance))
	    end

            if distance < Config.WaypointAutoClearDistance then
                SetWaypointOff()
                ClearGpsMultiRoute()
                SetGpsMultiRouteRender(false)
				marker = false

                if blip then
                    RemoveBlip(blip)
                    blip = nil
                end

		if Config.Debug then
                print("Waypoint has been reached and removed.")
		end
            end
        else
	    if Config.Debug then
            print("There are no waypoints saved yet.")
	    end
        end
		
        if Config.AddMarkerWaypointEndPoint and waypoints and #waypoints > 0 and marker then
	   AddMarker(SaveWaypoint)
	end
		
        if IsUiappActiveByHash(`MAP`) ~= 0 then
            local mapFocus = DatabindingAddUiItemListFromPath("", "MapFocus")
            local hoveredName = DatabindingAddDataString(mapFocus, "HoveredName", "")
            DatabindingWriteDataString(hoveredName, "")
            DatabindingAddDataBool(mapFocus, "ItemHovered", false)
        end

        if Config.WaypointClearWithKey then
            if IsControlJustPressed(0, Config.WaypointClearKey) and IsControlJustPressed(0, Config.WaypointClearKey2) then
                SetWaypointOff()
                ClearGpsMultiRoute()
                SetGpsMultiRouteRender(false)
				marker = false

                if blip then
                    RemoveBlip(blip)
                    blip = nil
                end

                if Config.Notification.Enable then
                    TriggerEvent("chat:addMessage", {color = Config.Notification.TitleColor, multiline = true, args = {Config.Notification.Title, Config.Notification.Text}})
                end
            end
        end
    end
end)

RegisterCommand(Config.WaypointClearCommand, function()
	SetWaypointOff()
	ClearGpsMultiRoute()
	SetGpsMultiRouteRender(false)
	marker = false

	if blip then
	RemoveBlip(blip)
	blip = nil
	end

	if Config.Notification.Enable then
	TriggerEvent("chat:addMessage", {color = Config.Notification.TitleColor, multiline = true, args = {Config.Notification.Title, Config.Notification.Text}}) -- You can use different notification scripts
	end
end, false)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
	SetWaypointOff()
	ClearGpsMultiRoute()
	SetGpsMultiRouteRender(false)
	marker = false
	RemoveBlip(blip)
	if Config.Debug then
	print("All waypoint/route things cleared")
	end
    end
end)
