local OutTheWindow = {}

OutTheWindow.hasFence = function(window)

	local sq = window:getSquare()
	for i = 0, sq:getObjects():size() - 1 do
		local obj = sq:getObjects():get(i)
		if obj:isHoppable() then
			return obj
		end
	end
end

OutTheWindow.onFillWorldObjectContextMenu = function(playerId, context, worldobjects, test)

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

		elseif instanceof(window, 'IsoObject') and (window:isHoppable() or OutTheWindow.hasFence(window)) then
			context:addOption(getText('ContextMenu_ThrowCorpseOverFence'), worldobjects, OutTheWindow.onThrowCorpse, player, (window:isHoppable() and window or OutTheWindow.hasFence(window)), corpses:get(0))
			return
		end
	end
end

OutTheWindow.onThrowCorpse = function(worldobjects, player, window, corpse)
	if luautils.walkAdj(player, window:getSquare(), false) then
		local primary, twoHands = true, true
		ISWorldObjectContextMenu.equip(player, player:getPrimaryHandItem(), corpse, primary, twoHands)
		ISTimedActionQueue.add(ISThrowCorpse:new(player, window, corpse, 100))
	end
end

Events.OnFillWorldObjectContextMenu.Add(OutTheWindow.onFillWorldObjectContextMenu)
