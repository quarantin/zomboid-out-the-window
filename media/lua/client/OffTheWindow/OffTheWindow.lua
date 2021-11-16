function getWindowFloorSquare(square)

	if square:isSolidFloor() then
		return square
	end

	local x = square:getX()
	local y = square:getY()

	for z = square:getZ() - 1, 0, -1 do
		local floorSquare = getSquare(x, y, z)
		if floorSquare:isSolidFloor() then
			return floorSquare
		end
	end

	error('This should never happen!')
end

function getWindowInsideSquare(window)

	local square = window:getSquare()
	local facing = window:getProperties():Val('Facing')

	local x = square:getX()
	local y = square:getY()
	local z = square:getZ()

	-- East and South oriented windows are always inside.
	if not square:isOutside() then
		return square
	end

	if facing == 'N' then
		return getSquare(x, y - 1, z)
	end

	if facing == 'W' then
		return getSquare(x - 1, y, z)
	end

	error('This should never happen!')
end

function getWindowOutsideSquare(window)

	local square = window:getSquare()
	local facing = window:getProperties():Val('Facing')

	local x = square:getX()
	local y = square:getY()
	local z = square:getZ()

	-- North and West oriented windows are always outside.
	if square:isOutside() then

		if facing == 'N' then
		-- TODO
			return getSquare(x, y + 1, z)
		end

		-- TODO
		if facing == 'W' then
			return getSquare(x + 1, y, z)
		end
	end

	-- BUG: Wrong values for the `Facing` property of IsoWindow objects.
	-- https://theindiestone.com/forums/index.php?/topic/41753-wrong-values-for-the-facing-property-of-isowindow-objects/

	-- When a window is facing South, the `Facing` property is `N`.
	-- But if someday the bug is fixed, then it would break the
	-- mod, so we're also checking if the value is `S`.
	if facing == 'S' or facing == 'N' then
		return getSquare(x, y - 1, z)
	end

	-- When a window is facing East, the `Facing` property is `W`.
	-- But if someday the bug is fixed, then it would break the
	-- mod, so we're also checking if the value is `E`.
	if facing == 'E' or facing == 'W' then
		return getSquare(x - 1, y, z)
	end

	error('This should never happen!')
end
