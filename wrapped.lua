local M = {}

M.mt = {}

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
	assert (M.unitEquality (a.units, b.units))
	
	return setmetatable ({
		value = a.value + b.value,
		units = a.units,
	}, M.mt)
end

function M.mt.__sub (a, b)
	assert (M.unitEquality (a.units, b.units))
	
	return setmetatable ({
		value = a.value - b.value,
		units = a.units,
	}, M.mt)
end

function M.mt.__mul (a, b)
	return setmetatable ({
		value = a.value * b.value,
		units = M.unitMultiply (a.units, b.units),
	}, M.mt)
end

function M.mt.__div (a, b)
	return setmetatable ({
		value = a.value / b.value,
		units = M.unitDivide (a.units, b.units),
	}, M.mt)
end

function M.mt.__tostring (wrapped)
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
	
	if #negUnits >= 1 then
		return tostring (wrapped.value) .. " " .. 
		  table.concat (posUnits, " * ") .. " / " .. 
		  table.concat (negUnits, " * ")
	else
		return tostring (wrapped.value) ..
		  table.concat (posUnits, " * ")
	end
end

function M.newValue (value)
	return setmetatable ({
		value = value,
		units = {},
	}, M.mt)
end

function M.newUnit (unit)
	return setmetatable ({
		value = 1.0,
		units = {
			[unit] = 1,
		},
	}, M.mt)
end

return M