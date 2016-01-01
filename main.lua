local UnitWrapper = require "units"
local Conversion = require "conversion"

local units = UnitWrapper.makeUnitsTable {
	"centimeters",
	"feet",
	"hours",
	"inches",
	"kilometers",
	"meters",
	"miles",
	"minutes",
	"seconds",
}

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
-- Speed of sound  767.26914817466 miles / (hours)

print ("Inches per cm", cmPerInch ^ -1)

-- Output:
-- Inches per cm   0.39370078740157 inches / (centimeters)

print ("Hypotenuse of right triangle with sides 3 cm and 4 cm",
	((3 * units.centimeters) ^ 2 +
	(4 * units.centimeters) ^ 2) ^ 0.5)

-- Output:
-- Hypotenuse of right triangle with sides 3 cm and 4 cm   5.0 centimeters

print ("Area of 8.5 by 11 inch letter paper",
	8.5 * units.inches * 11 * units.inches)

-- Output:
-- Area of 8.5 by 11 inch letter paper     93.5 inches * inches

print ("Speed of a paint roller",
	8 * units.seconds / units.feet / units.feet)

-- Output:
-- Speed of a paint roller 8 seconds / (feet * feet)

local converter = Conversion.new ()

converter:addConversion (1000, units.meters, units.kilometers)
converter:addConversion (100, units.centimeters, units.meters)
converter:addConversion (2.54, units.centimeters, units.inches)
converter:addConversion (12, units.inches, units.feet)
converter:addConversion (5280, units.feet, units.miles)

print ("Kilometers per mile", converter:solveWithoutSubdividing (
	units.miles, units.kilometers))
print ("Inches per mile", converter:solveWithoutSubdividing (
	units.miles, units.inches))
print ("Inches per kilometer", converter:solveWithoutSubdividing (
	units.kilometers, units.inches))