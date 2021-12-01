local function getNorth(window)
	return window.getNorth and window:getNorth() or window:isNorthHoppable()
end

local function getOppositeSquare(window, x, y, z)
	return getNorth(window) and getSquare(x, y - 1, z) or getSquare(x - 1, y, z)
end

local function getDropSquare(player, window)

	local dropSquare, floorSquare, oppositeSquare

	local playerSquare = player:getSquare()
	local windowSquare = window:getSquare()
	local x, y, z = windowSquare:getX(), windowSquare:getY(), windowSquare:getZ()
	local oppositeSquare = getOppositeSquare(window, x, y, z)

	if getNorth(window) then
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

return {
	getDropSquare = getDropSquare,
}
