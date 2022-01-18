return {
	getDropSquare = function(player, window)

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
}
