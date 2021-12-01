function onFillWorldObjectContextMenu(playerId, context, worldobjects, test)

	local player = getSpecificPlayer(playerId)
	local inventory = player:getInventory()
	local corpses = inventory:getAllEvalRecurse(function(item, player)
		return item:getType() == 'CorpseMale' or item:getType() == 'CorspeFemale'
	end, ArrayList.new())

	if corpses:size() <= 0 then
		return
	end

	for _, window in ipairs(worldobjects) do

		if instanceof(window, 'IsoWindow') then

			if (window:IsOpen() or window:isSmashed()) and not window:isBarricaded() then
				context:addOption(getText('ContextMenu_ThrowCorpseOutTheWindow'), worldobjects, onThrowCorpse, player, window, corpses:get(0))
				return
			end

		elseif instanceof(window, 'IsoThumpable') and not window:isDoor() then

			--if window:isWindow() and window:canClimbThrough(player) and not window:getSquare():getWindow(window:getNorth()) then
			if window:isWindow() and window:canClimbThrough(player) then
				context:addOption(getText('ContextMenu_ThrowCorpseOutTheWindow'), worldobjects, onThrowCorpse, player, window, corpses:get(0))
				return

			elseif window:isHoppable() and window:canClimbOver(player) then
				context:addOption(getText('ContextMenu_ThrowCorpseOverFence'), worldobjects, onThrowCorpse, player, window, corpses:get(0))
				return
			end

		elseif instanceof(window, 'IsoObject') and window:isHoppable() then
			context:addOption(getText('ContextMenu_ThrowCorpseOverFence'), worldobjects, onThrowCorpse, player, window, corpses:get(0))
			return
		end
	end
end

function onThrowCorpse(worldobjects, player, window, corpse)
	if luautils.walkAdj(player, window:getSquare(), false) then
		local primary, twoHands = true, true
		ISWorldObjectContextMenu.equip(player, player:getPrimaryHandItem(), corpse, primary, twoHands)
		ISTimedActionQueue.add(ISThrowCorpse:new(player, window, corpse, 100))
	end
end

Events.OnFillWorldObjectContextMenu.Add(onFillWorldObjectContextMenu)
