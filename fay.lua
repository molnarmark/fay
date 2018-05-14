local Sertify = {}
Sertify.__index = Sertify

function Sertify.new(testInfo) 
	local self = setmetatable({}, Sertify)
	self.__ReportCache = {
		succeeded = {},
		failed = {}
	}
		
	self.__getFayPrefix = function(self)
		return "#E8B305[Fay] "
	end
	
	self.__Report = function(self, evaluation, testName)
		if evaluation then
			if not self.__ReportCache.succeeded[testName] then
				outputChatBox(self:__getFayPrefix() .. "#FFFFFFTest called " .. testName .. " #37A600PASSED.", 0, 255, 255, true)
				self.__ReportCache.succeeded[testName] = true
			end
		else
			if not self.__ReportCache.failed[testName] then
				outputChatBox(self:__getFayPrefix() .. "#FFFFFFTest called " .. testName .. " #FF0000FAILED.", 0, 255, 255, true)
				self.__ReportCache.failed[testName] = true
			end
		end
	end
	
	self.expect = function(self, initialValue)
		local self = setmetatable(self, {})
		self.initialValue = initialValue
		
		self.atIndex = function(self, indexNumber)
			if type(self.initialValue) == "string" then
				self.initialValue = self.initialValue:sub(indexNumber, indexNumber > 1 and indexNumber or 1)
			elseif type(self.initialValue) == "table" then
				self.initialValue = self.initialValue[indexNumber]
			end
			
			return self
		end
		
		self.toBe = function(self, right)
			return self:toEqual(right)
		end
		
		self.toEqual = function(self, right)
			return self:__Report(self.initialValue == right, testInfo.description)
		end
		
		self.toBeTrue = function(self)
			return self:__Report(self.initialValue == true, testInfo.description)
		end
		
		self.toBeFalse = function(self)
			return self:__Report(self.initialValue == false, testInfo.description)
		end
	
		self.toBeNil = function(self)
			return self:__Report(self.initialValue == nil, testInfo.description)
		end		
		
		self.toBeEmpty = function(self)
			local evaluation
			if type(self.initialValue) == "string" or type(self.initialValue) == "table" then
				evaluation = #self.initialValue == 0
			else
				evaluation = true
			end
			
			return self:__Report(self.initialValue, testInfo.description)
		end	
	
		self.toBeOfLength = function(self, right)
			local evaluation
			if type(self.initialValue) == "string" or type(self.initialValue) == "table" then
				evaluation = #self.initialValue == right
			else
				evaluation = true
			end
			return self:__Report(self.initialValue, testInfo.description)
		end		
		
		self.toBeLessThan = function(self, right)
			local evaluation
			if type(self.initialValue) == "string" or type(self.initialValue) == "table" then
				evaluation = #self.initialValue < right
			else
				evaluation = true
			end
			
			return self:__Report(self.initialValue, testInfo.description)		
		end
		
		self.toBeGreaterThan = function(self, right)
			local evaluation
			if type(self.initialValue) == "string" or type(self.initialValue) == "table" then
				evaluation = #self.initialValue > right
			else
				evaluation = true
			end
			
			return self:__Report(self.initialValue, testInfo.description)		
		end	
					
		self.toBeOfType = function(self, right)
			local evaluation
			
			if isElement(self.initialValue) then
				evaluation = getElementType(self.initialValue) == right
			else
				evaluation = type(self.initialValue) == right
			end
			
			return self:__Report(evaluation, testInfo.description)
		end	
		
		self.toBeAnElement = function(self)
			return self:__Report(isElement(self.initialValue), testInfo.description)
		end	
	
		self.toBeAt = function(self, targetX, targetY, targetZ)
			local posX, posY, posZ = getElementPosition(self.initialValue)
			return self:__Report(posX == targetX and posY == targetY and posZ == targetZ, testInfo.description)
		end
	
		self.toBeInDimension = function(self, targetDimension)
			return self:__Report(getElementDimension(self.initialValue) == targetDimension, testInfo.description)
		end
		
		self.toBeInInterior = function(self, targetInterior)
			return self:__Report(getElementInterior(self.initialValue) == targetInterior, testInfo.description)
		end
		
		self.toBeInColshape = function(self, targetColShape)
			return self:__Report(isElementWithinColShape(self.initialValue, targetColShape), testInfo.description)
		end
						
		self.toHaveRotation = function(self, targetX, targetY, targetZ)
			local rotX, rotY, rotZ = getElementRotation(self.initialValue)
			return self:__Report(rotX == targetX and rotY == targetY and rotZ == targetZ, testInfo.description)
		end
	
		self.toHaveCameraMatrix = function(self, targetX, targetY, targetZ, targetRotX, targetRotY, targetRotZ)
			local posX, posY, posZ, rotX, rotY, rotZ = getCameraMatrix()
			local evaluation = posX == targetX and posY == targetY and posZ == targetZ and rotX == targetRotX and rotY == targetRotY and rotZ == targetRotZ
			return self:__Report(evaluation, testInfo.description)
		end
		
		self.toHaveData = function(self, key, targetValue)
			local value = getElementData(self.initialValue, key)
			return self:__Report(targetValue == value, testInfo.description)
		end
				
		self.toHaveSkin = function(self, targetSkinId)
			local skinId = getElementModel(self.initialValue)
			return self:__Report(skinId == targetSkinId, testInfo.description)
		end
		
		self.toBeDriving = function(self, targetVehicle)
			return self:__Report(getPedOccupiedVehicle(self.initialValue) == targetVehicle and getPedOccupiedVehicleSeat(self.initialValue) == 0, testInfo.description)
		end
		
		self.toBeInVehicle = function(self, targetVehicle)
			return self:__Report(getPedOccupiedVehicle(self.initialValue) == targetVehicle, testInfo.description)
		end
		
		self.toBeFrozen = function(self)
			return self:__Report(isElementFrozen(self.initialValue), testInfo.description)
		end
	
		self.toNotBeFrozen = function(self)
			return self:__Report(not isElementFrozen(self.initialValue), testInfo.description)
		end
						
		self.toBeAPed = function(self)
			return self:toBeOfType("ped")
		end
	
		self.toBeAVehicle = function(self)
			return self:toBeOfType("vehicle")
		end

		self.toBeAPlayer = function(self)
			return self:toBeOfType("player")
		end
		
		self.toHaveHealth = function(self, right)
			return self:__Report(isElement(self.initialValue) and getElementHealth(self.initialValue) == right, testInfo.description)	
		end
	
		self.toHaveArmor = function(self, right)
			return self:__Report(isElement(self.initialValue) and getPedArmor(self.initialValue) == right, testInfo.description)	
		end
		
		self.toHaveAlpha = function(self, right)
			return self:__Report(isElement(self.initialValue) and getElementAlpha(self.initialValue) == right, testInfo.description)	
		end
		
		self.toBeDead = function(self)
			return self:__Report(isPedDead(self.initialValue), testInfo.description)
		end
						
		return self
	end
	
	return self
end

local function Fay(tests)
	-- addCommandHandler("fay", function()
		for i = 0, 20 do
			outputChatBox(" ")	
		end
		
		local testCounter = 0
		for _, testData in pairs(tests) do
			testData.fun(Sertify.new(testData))
			testCounter = testCounter + 1
		end
		
		outputChatBox("\n#E8B305Fay #FFFFFFfinished running a total of #E8B305" .. testCounter .. "#FFFFFF tests.", 0, 255, 255, true)	
	-- end)
end

local function it(description, callback)
	return {
		description = description,
		fun = function(sertify)
			return callback(sertify)
		end
	}
end

Fay {
	it("should check if Fay is working correctly", function(sertify)
		sertify:expect(5):toBe(5)
	end)
}
