local UnitWrapper = require "units"

local unitsToAdd = {
	"centimeters",
	"feet",
	"hours",
	"inches",
	"meters",
	"miles",
	"minutes",
	"seconds",
}
local units = {}

for _, unit in ipairs (unitsToAdd) do
	units [unit] = UnitWrapper.newUnit (unit)
end

print (88 * units.miles / units.hours)
-- Output:
-- 88 miles / hours

local cmPerM = 100 * units.centimeters / units.meters
local secondsPerHour = 3600 * units.seconds / units.hours
local cmPerInch = 2.54 * units.centimeters / units.inches
local inchesPerFoot = 12 * units.inches / units.feet
local feetPerMile = 5280 * units.feet / units.miles

-- Calculate the speed of sound in air, in MPH
print ("Speed of sound", 343 * units.meters / units.seconds
	* cmPerM
	* secondsPerHour
	/ cmPerInch
	/ inchesPerFoot
	/ feetPerMile)

-- Output:
-- Speed of sound  767.26914817466 miles / hours