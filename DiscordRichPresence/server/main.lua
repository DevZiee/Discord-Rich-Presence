ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()
	while true do
	  TriggerClientEvent("updatePlayerCountDiscord", -1, GetNumPlayerIndices())
	  Citizen.Wait(30 * 1000)
	end 
end)