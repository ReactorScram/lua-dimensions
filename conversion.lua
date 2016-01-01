local M = {}
M.__index = M

local UnitWrapper = require "units"

function M.new ()
	local self = setmetatable ({}, M)
	
	self.conversions = {}
	
	return self
end

--[[

Arguments:
value, unitA, unitB

such that

there are value unitAs per unitB

e.g. (100, units.centimeters, units.meters)
or   (5280, units.feet, units.miles)

Conversions are automatically inversed to produce a bidirectional graph
from / to all commensurable units

--]]
function M:addConversion (value, unitA, unitB)
	--[[
	Re-use existing units if possible
	Units are objects, so they're harder to intern than
	numbers or strings
	--]]
	local unitA = self:getUnit (unitA) or unitA
	local unitB = self:getUnit (unitB) or unitB
	
	local unitBConversions = self.conversions [unitB] or {}
	unitBConversions [unitA] = (value * unitA) / unitB
	
	local unitAConversions = self.conversions [unitA] or {}
	unitAConversions [unitB] = unitB / (value * unitA)
	
	self.conversions [unitB] = unitBConversions
	self.conversions [unitA] = unitAConversions
end

-- Does a linear search for a unit key
function M:getUnit (wrapped)
	if self.conversions [wrapped] then
		return wrapped
	end
	
	for unit, _ in pairs (self.conversions) do
		if UnitWrapper.unitEquality (unit, wrapped.units) then
			return unit
		end
	end
	
	return nil
end

--[[
Recursively finds a path from srcUnits to destUnits
closedUnits is used by recursive calls
This is NOT tailcall-optimized
--]]
function M:solveWithoutSubdividing (srcUnits, destUnits, closedUnits)
	closedUnits = closedUnits or {}
	
	local srcUnits = self:getUnit (srcUnits)
	local destUnits = self:getUnit (destUnits)
	
	closedUnits [srcUnits] = true
	
	local srcConversions = self.conversions [srcUnits]
	local baseCase = srcConversions [destUnits]
	if baseCase then
		return baseCase
	else
		for middleUnit, value in pairs (srcConversions) do
			if closedUnits [middleUnit] then
				-- Can't go there
			else
				local middleResult = self:solveWithoutSubdividing (
					middleUnit, destUnits, closedUnits)
				
				if middleResult then
					return value * middleResult
				end
			end
		end
	end
	
	return nil
end

return M