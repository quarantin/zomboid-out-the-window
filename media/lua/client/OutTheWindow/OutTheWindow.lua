local OutTheWindow = {}

function OutTheWindow.findHoppable(square)
	local objects = square:getObjects()
	for i = 0, objects:size() - 1 do
		local object = objects:get(i)
		if instanceof(object, 'IsoObject') and object:isHoppable() then
			return object
		end
	end
end

function OutTheWindow.getDropSquare(player, window)

	local sq1, sq2, selected

	local playerSquare = player:getSquare()
	local px, py, pz = playerSquare:getX(), playerSquare:getY(), playerSquare:getZ()

	local windowSquare = window:getSquare()
	local wx, wy, wz = windowSquare:getX(), windowSquare:getY(), windowSquare:getZ()

	if window.getNorth and window:getNorth() or window:isNorthHoppable() then
		sq1 = getSquare(wx, wy + 1, wz)
		sq2 = getSquare(wx, wy - 1, wz)
		selected = (py >= wy) and sq2 or sq1
	else
		sq1 = getSquare(wx + 1, wy, wz)
		sq2 = getSquare(wx - 1, wy, wz)
		selected = (px >= wx) and sq2 or sq1
	end

	x = selected:getX()
	y = selected:getY()

	for z = selected:getZ(), 0, -1 do
		local floorSquare = getSquare(x, y, z)
		if floorSquare:isSolidFloor() then
			return floorSquare
		end
	end

	error('This should never happen!')
end

function OutTheWindow.onThrowCorpse(worldobjects, player, window, corpse)
	if luautils.walkAdjWindowOrDoor(player, window:getSquare(), window) then
		local primary, twoHands = true, true
		ISWorldObjectContextMenu.equip(player, player:getPrimaryHandItem(), corpse, primary, twoHands)
		ISTimedActionQueue.add(ISThrowCorpse:new(player, window, corpse, 100))
	end
end

return OutTheWindow
