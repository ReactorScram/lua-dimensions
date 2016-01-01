local UnitsRealm = require "units"

local unitRealm = UnitsRealm ()

local unitsToAdd = {
	"centimeters",
	"hours",
	"inches",
	"meters",
	"miles",
	"minutes",
	"seconds",
}
local units = {}

for _, unit in ipairs (unitsToAdd) do
	units [unit] = unitRealm:addLegalUnit (unit)
end

print (unitRealm:value (88) * units.miles / units.hours)
