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
			local throwType, window = OutTheWindow.getThrowType(player, objects:get(i))
			if throwType then
				context:addOption(getText('ContextMenu_ThrowCorpse' .. throwType), worldobjects, OutTheWindow.onThrowCorpse, player, window, corpses:get(0))
				return
			end
		end
	end
end

Events.OnFillWorldObjectContextMenu.Add(OutTheWindow.OnFillWorldObjectContextMenu)
