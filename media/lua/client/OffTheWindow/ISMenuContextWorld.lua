require 'luautils'
require 'ISUI/ISWorldObjectContextMenu'
require 'TimedActions/ISTimedActionQueue'
require 'OffTheWindow/ISThrowCorpseOffWindow'

OffTheWindowMenu = {}

function OffTheWindowMenu.OnFillWorldObjectContextMenu(playerId, context, worldobjects, test)

	for _, window in ipairs(worldobjects) do

		if instanceof(window, 'IsoWindow') then

			if window:IsOpen() and not window:isBarricaded() then
				local player = getSpecificPlayer(playerId)
				local inventory = player:getInventory()
				local corpses = inventory:getAllEvalRecurse(function(item, player)
					return item:getType() == 'CorpseMale' or item:getType() == 'CorspeFemale'
				end, ArrayList.new())

				if corpses:size() <= 0 then
					return
				end

				context:addOption(getText('ContextMenu_ThrowCorpseOffWindow'), worldobjects, OffTheWindowMenu.onThrowCorpseOffWindow, player, window, corpses:get(0))
				return
			end
		end
	end
end

function OffTheWindowMenu.onThrowCorpseOffWindow(worldobjects, player, window, corpse)
	if luautils.walkAdj(player, window:getSquare(), false) then
		local primary = true
		local twoHands = true
		ISWorldObjectContextMenu.equip(player, player:getPrimaryHandItem(), corpse, primary, twoHands)
		ISTimedActionQueue.add(ISThrowCorpseOffWindow:new(player, window, corpse, 100))
	end
end

Events.OnFillWorldObjectContextMenu.Add(OffTheWindowMenu.OnFillWorldObjectContextMenu)
