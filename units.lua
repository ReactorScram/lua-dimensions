local M = {}

M.mt = {}
M.mt.__index = M.mt

function M.unitEquality (unitsA, unitsB)
	for unit, dimension in pairs (unitsA) do
		if unitsB [unit] ~= dimension then
			return false
		end
	end
	
	for unit, dimension in pairs (unitsB) do
		if unitsA [unit] ~= dimension then
			return false
		end
	end
	
	return true
end

function M.unitInverse (units)
	local rtn = {}
	
	for unit, dimension in pairs (units) do
		rtn [unit] = -dimension
	end
	
	return rtn
end

function M.unitMultiply (unitsA, unitsB)
	local rtn = {}
	
	for unit, dimension in pairs (unitsA) do
		local sum = unitsA [unit] + (unitsB [unit] or 0)
		if sum ~= 0 then
			rtn [unit] = sum
		end
	end
	for unit, dimension in pairs (unitsB) do
		local sum = unitsB [unit] + (unitsA [unit] or 0)
		if sum ~= 0 then
			rtn [unit] = sum
		end
	end
	
	return rtn
end

function M.unitDivide (unitsA, unitsB)
	return M.unitMultiply (unitsA, M.unitInverse (unitsB))
end

function M.mt.__add (a, b)
	a = M.newValue (a)
	b = M.newValue (b)
	
	assert (M.unitEquality (a.units, b.units))
	
	return setmetatable ({
		value = a.value + b.value,
		units = a.units,
	}, M.mt)
end

function M.mt.__sub (a, b)
	a = M.newValue (a)
	b = M.newValue (b)
	
	assert (M.unitEquality (a.units, b.units))
	
	return setmetatable ({
		value = a.value - b.value,
		units = a.units,
	}, M.mt)
end

function M.mt.__mul (a, b)
	a = M.newValue (a)
	b = M.newValue (b)
	
	return setmetatable ({
		value = a.value * b.value,
		units = M.unitMultiply (a.units, b.units),
	}, M.mt)
end

function M.mt.__pow (a, b)
	a = M.newValue (a)
	b = M.newValue (b)
	
	assert (M.unitEquality ({}, b.units))
	
	local newUnits = {}
	
	for unit, dimension in pairs (a.units) do
		local newDimension = dimension * b.value
		
		assert (newDimension == math.floor (newDimension), 
			"Cannot have fractional dimensions")
		
		newUnits [unit] = newDimension
	end
	
	return setmetatable ({
		value = a.value ^ b.value,
		units = newUnits,
	}, M.mt)
end

function M.mt.__div (a, b)
	a = M.newValue (a)
	b = M.newValue (b)
	
	return setmetatable ({
		value = a.value / b.value,
		units = M.unitDivide (a.units, b.units),
	}, M.mt)
end

function M.mt.__mod (a, b)
	a = M.newValue (a)
	b = M.newValue (b)
	
	return setmetatable ({
		value = a.value % b.value,
		units = M.unitDivide (a.units, b.units),
	}, M.mt)
end

function M.mt.splitUnitsBySign (wrapped)
	local allUnits = {}
	for unit, dimension in pairs (wrapped.units) do
		table.insert (allUnits, unit)
	end
	
	table.sort (allUnits, function (a, b)
		return wrapped.units [a] > wrapped.units [b]
	end)
	
	local posUnits = {}
	local negUnits = {}
	
	for _, unit in ipairs (allUnits) do
		local dimension = wrapped.units [unit]
		if dimension > 0 then
			for i = 1, dimension do
				table.insert (posUnits, unit)
			end
		elseif dimension < 0 then
			for i = 1, -dimension do
				table.insert (negUnits, unit)
			end
		end
	end
	
	return posUnits, negUnits
end

function M.mt.__tostring (wrapped)
	local posUnits, negUnits = wrapped:splitUnitsBySign ()
	
	if #negUnits >= 1 then
		return tostring (wrapped.value) .. " " .. 
		  table.concat (posUnits, " * ") .. " / (" .. 
		  table.concat (negUnits, " * ") .. ")"
	else
		return tostring (wrapped.value) .. " " .. 
		  table.concat (posUnits, " * ")
	end
end

function M.newValue (value)
	if type (value) == "number" then
		return setmetatable ({
			value = value,
			units = {},
		}, M.mt)
	else 
		return value
	end
end

function M.newUnit (unit)
	return setmetatable ({
		value = 1.0,
		units = {
			[unit] = 1,
		},
	}, M.mt)
end

function M.makeUnitsTable (unitsToAdd)
	local units = {}

	for _, unit in ipairs (unitsToAdd) do
		units [unit] = M.newUnit (unit)
	end
	return units
end

return M