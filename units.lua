local Object = require "classic"
local M = Object:extend ()

local Wrapped = require "wrapped"

function M:new ()
	self.legalUnits = {}
end

function M:addLegalUnit (u)
	self.legalUnits [u] = Wrapped.newUnit (u)
	return self:unit (u)
end

function M:removeLegalUnit (u)
	self.legalUnits [u] = nil
end

function M:isLegal (u)
	return self.legalUnits [u]
end

function M:value (value)
	return Wrapped.newValue (value)
end

function M:unit (unit)
	return self:isLegal (unit)
end

return M