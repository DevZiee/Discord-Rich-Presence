
ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function SetRP()
    local name = GetPlayerName(PlayerId())
    local id = GetPlayerServerId(PlayerId())
    SetDiscordAppId(Config.ClientID)
	SetDiscordRichPresenceAsset(Config.Asset)
	SetDiscordRichPresenceAssetText('[SERVER NAME]')
	SetDiscordRichPresenceAssetSmall('small')
	SetDiscordRichPresenceAssetSmallText('[SET SMALL TEXT]')
	
	SetDiscordRichPresenceAction(0, Config.button1.text, Config.button1.url)
	SetDiscordRichPresenceAction(1, Config.button2.text, Config.button2.url)
end

RegisterNetEvent('updatePlayerCountDiscord')
AddEventHandler('updatePlayerCountDiscord', function(playerCount)
	local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))))
	if VehName == "NULL" then 
		VehName = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))) 
	end
	local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(),true))
	local StreetHash = GetStreetNameAtCoord(x, y, z)
	local pId = GetPlayerServerId(PlayerId())
	local pName = GetPlayerName(PlayerId())
	
	Citizen.Wait(Config.WaitTime)
	SetRP()
	if StreetHash ~= nil then
		StreetName = GetStreetNameFromHashKey(StreetHash)
		if IsPedOnFoot(PlayerPedId()) and not IsEntityInWater(PlayerPedId()) then
			if IsPedSprinting(PlayerPedId()) then
				SetRichPresence(playerCount.."/128 - ID: "..pId.." | "..pName.." is sprinting down "..StreetName)
			elseif IsPedRunning(PlayerPedId()) then
				SetRichPresence(playerCount.."/128 - ID: "..pId.." | "..pName.." is running down "..StreetName)
			elseif IsPedWalking(PlayerPedId()) then
				SetRichPresence(playerCount.."/128 - ID: "..pId.." | "..pName.." is walking down "..StreetName)
			elseif IsPedStill(PlayerPedId()) then
				SetRichPresence(playerCount.."/128 - ID: "..pId.." | "..pName.." is standing on "..StreetName.."")
			end
		elseif GetVehiclePedIsUsing(PlayerPedId()) ~= nil and not IsPedInAnyHeli(PlayerPedId()) and not IsPedInAnyPlane(PlayerPedId()) and not IsPedOnFoot(PlayerPedId()) and not IsPedInAnySub(PlayerPedId()) and not IsPedInAnyBoat(PlayerPedId()) then
			local MPH = math.ceil(GetEntitySpeed(GetVehiclePedIsUsing(PlayerPedId())) * 2.236936)
			if MPH > 50 then
				SetRichPresence(playerCount.."/128 - ID: "..pId.." | "..pName.." is speeding down "..StreetName.." at "..MPH.."MPH in a "..VehName)
			elseif MPH <= 50 and MPH > 0 then
				SetRichPresence(playerCount.."/128 - ID: "..pId.." | "..pName.." is cruising down "..StreetName.." at "..MPH.."MPH in a "..VehName)
			elseif MPH == 0 then
				SetRichPresence(playerCount.."/128 - ID: "..pId.." | "..pName.." is parked on "..StreetName.." in a "..VehName)
			end
		elseif IsPedInAnyHeli(PlayerPedId()) or IsPedInAnyPlane(PlayerPedId()) then
			if IsEntityInAir(GetVehiclePedIsUsing(PlayerPedId())) or GetEntityHeightAboveGround(GetVehiclePedIsUsing(PlayerPedId())) > 5.0 then
				SetRichPresence(playerCount.."/128 - ID: "..pId.." | "..pName.." is flying over "..StreetName.." in a "..VehName)
			else
				SetRichPresence(playerCount.."/128 - ID: "..pId.." | "..pName.." is landed at "..StreetName.." in a "..VehName)
			end
		elseif IsEntityInWater(PlayerPedId()) then
			SetRichPresence(playerCount.."/128 - ID: "..pId.." | "..pName.." is swimming")
		elseif IsPedInAnyBoat(PlayerPedId()) and IsEntityInWater(GetVehiclePedIsUsing(PlayerPedId())) then
			SetRichPresence(playerCount.."/128 - ID: "..pId.." | "..pName.." is sailing in a "..VehName)
		elseif IsPedInAnySub(PlayerPedId()) and IsEntityInWater(GetVehiclePedIsUsing(PlayerPedId())) then
			SetRichPresence(playerCount.."/128 - ID: "..pId.." | "..pName.." is in a yellow submarine")
		end
	end
end)