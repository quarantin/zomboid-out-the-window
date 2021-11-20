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

	self.character:setPrimaryHandItem(nil)
	self.character:setSecondaryHandItem(nil)
	self.character:getInventory():Remove(self.corpse)

	local dropSquare = getDropSquare(self.character, self.window)
	dropSquare:AddWorldInventoryItem(self.corpse, 0.0, 0.0, 0.0)
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
