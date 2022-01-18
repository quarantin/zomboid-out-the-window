local OutTheWindow = require('OutTheWindow/OutTheWindow')

function OutTheWindow.OnFillWorldObjectContextMenu(playerId, context, worldobjects, test)

	local player = getSpecificPlayer(playerId)
	local inventory = player:getInventory()
	local corpses = inventory:getAllEvalRecurse(function(item, player)
		return item:getType() == 'CorpseMale' or item:getType() == 'CorpseFemale'
	end, ArrayList.new())

	if corpses:size() <= 0 then
		return
	end

	for _, object in ipairs(worldobjects) do

		local objects = object:getSquare():getObjects()
		for i = 0, objects:size() - 1 do

			local window = objects:get(i)

			if instanceof(window, 'IsoWindow') then

				if (window:IsOpen() or window:isSmashed()) and not window:isBarricaded() then
					context:addOption(getText('ContextMenu_ThrowCorpseOutTheWindow'), worldobjects, OutTheWindow.onThrowCorpse, player, window, corpses:get(0))
					return
				end

			elseif instanceof(window, 'IsoThumpable') and not window:isDoor() then

				if window:isWindow() and window:canClimbThrough(player) then
					context:addOption(getText('ContextMenu_ThrowCorpseOutTheWindow'), worldobjects, OutTheWindow.onThrowCorpse, player, window, corpses:get(0))
					return

				elseif window:isHoppable() and window:canClimbOver(player) then
					context:addOption(getText('ContextMenu_ThrowCorpseOverFence'), worldobjects, OutTheWindow.onThrowCorpse, player, window, corpses:get(0))
					return
				end

			elseif instanceof(window, 'IsoObject') then

				local hoppable = OutTheWindow.findHoppable(window:getSquare())
				if hoppable then
					context:addOption(getText('ContextMenu_ThrowCorpseOverFence'), worldobjects, OutTheWindow.onThrowCorpse, player, hoppable, corpses:get(0))
					return
				end
			end
		end
	end
end

Events.OnFillWorldObjectContextMenu.Add(OutTheWindow.OnFillWorldObjectContextMenu)
