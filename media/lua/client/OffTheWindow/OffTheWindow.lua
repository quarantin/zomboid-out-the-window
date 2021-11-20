function getDropSquare(player, window)

	local dropSquare, floorSquare
	local playerSquare = player:getSquare()
	local windowSquare = window:getSquare()
	local oppositeSquare = window:getOppositeSquare()

	local x, y, z = windowSquare:getX(), windowSquare:getY(), windowSquare:getZ()

	if window:getNorth() then
		dropSquare = getSquare(x, y + 1, z)
	else
		dropSquare = getSquare(x + 1, y, z)
	end

	local dropSquare = playerSquare:equals(windowSquare) and oppositeSquare or dropSquare

	x = dropSquare:getX()
	y = dropSquare:getY()

	for z = dropSquare:getZ(), 0, -1 do
		floorSquare = getSquare(x, y, z)
		if floorSquare:isSolidFloor() then
			return floorSquare
		end
	end

	error('This should never happen!')
end
