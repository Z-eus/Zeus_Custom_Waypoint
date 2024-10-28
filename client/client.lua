local blip = nil

CreateThread(function()
	while true do
        Wait(Config.WaypointColorChangeDelay)
	local WaypointCoords = GetWaypointCoords()

        if IsWaypointActive() then
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
        end

	if IsUiappActiveByHash(`MAP`) ~= 0 then
	   local mapFocus = DatabindingAddUiItemListFromPath("", "MapFocus")
	   local hoveredName = DatabindingAddDataString(mapFocus, "HoveredName", "")
	   DatabindingWriteDataString(hoveredName, "")
	   DatabindingAddDataBool(mapFocus, "ItemHovered", false)
	end

	if Config.WaypointClearWithKey then
	   if IsControlJustPressed(0,Config.WaypointClearKey) and IsControlJustPressed(0,Config.WaypointClearKey2) then
		SetWaypointOff()
		ClearGpsMultiRoute()
		SetGpsMultiRouteRender(false)

		if blip then
		RemoveBlip(blip)
		blip = nil
		end

		if Config.Notification.Enable then
		   TriggerEvent("chat:addMessage", {color = Config.Notification.TitleColor, multiline = true, args = {Config.Notification.Title, Config.Notification.Text}}) -- You can use different notification scripts
		end
	    end
	end
    end
end)

RegisterCommand(Config.WaypointClearCommand, function() -- Clear/Remove Route
	SetWaypointOff()
	ClearGpsMultiRoute()
	SetGpsMultiRouteRender(false)

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
	RemoveBlip(blip)
		--print("All waypoint/route things cleared")
    end
end)
