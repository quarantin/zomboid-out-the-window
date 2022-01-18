OutTheWindow = require('OutTheWindow/OutTheWindow')
ISThrowCorpse = ISBaseTimedAction:derive('ISThrowCorpse')

function ISThrowCorpse:isValid()
	return true
end

function ISThrowCorpse:waitToStart()
	self.character:faceThisObject(self.window)
	return self.character:shouldBeTurning()
end

function ISThrowCorpse:update()
	self.character:faceThisObject(self.window)
end

function ISThrowCorpse:start()
	self:setActionAnim('Loot')
	self.character:SetVariable('LootPosition', 'Mid')
end

function ISThrowCorpse:stop()
	ISBaseTimedAction.stop(self);
end

function ISThrowCorpse:perform()

	self.character:setPrimaryHandItem(nil)
	self.character:setSecondaryHandItem(nil)
	self.character:getInventory():Remove(self.corpse)

	local dropSquare = OutTheWindow.getDropSquare(self.character, self.window)
	dropSquare:AddWorldInventoryItem(self.corpse, 0.0, 0.0, 0.0)
end

function ISThrowCorpse:new(character, window, corpse, time)
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
