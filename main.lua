local Units = require "units"

local unitRealm = Units ()

local miles = unitRealm:addLegalUnit "miles"
local hours = unitRealm:addLegalUnit "hours"

print (unitRealm:value (88) * miles / hours)