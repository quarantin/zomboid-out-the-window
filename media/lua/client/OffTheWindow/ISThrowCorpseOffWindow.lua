require 'TimedActions/ISBaseTimedAction'
require 'OffTheWindow/OffTheWindow'

ISThrowCorpseOffWindow = ISBaseTimedAction:derive('ISThrowCorpseOffWindow')

function ISThrowCorpseOffWindow:isValid()
	return true
end

function ISThrowCorpseOffWindow:waitToStart()
	self.character:faceThisObject(self.window)
	return self.character:shouldBeTurning()
end

function ISThrowCorpseOffWindow:update()
	self.character:faceThisObject(self.window)
end

function ISThrowCorpseOffWindow:start()
	self:setActionAnim('Loot')
	self.character:SetVariable('LootPosition', 'Mid')
end

function ISThrowCorpseOffWindow:stop()
	ISBaseTimedAction.stop(self);
end

function ISThrowCorpseOffWindow:perform()
	local square = nil

	if self.character:getSquare():isOutside() then
		square = getWindowInsideSquare(self.window)
	else
		square = getWindowOutsideSquare(self.window)
	end

	self.character:setPrimaryHandItem(nil)
	self.character:setSecondaryHandItem(nil)
	self.character:getInventory():Remove(self.corpse)
	local floor = getWindowFloorSquare(square)
	floor:AddWorldInventoryItem(self.corpse, 0.0, 0.0, 0.0)
end

function ISThrowCorpseOffWindow:new(character, window, corpse, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.window = window
	o.corpse = corpse
	o.maxTime = time
	if o.character:isTimedActionInstant() then o.maxTime = 1 end
	return o
end
