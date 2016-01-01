## Lua dimensional analysis

Copyright 2016 ReactorScram

Licensed under the GNU Affero AGPLv3

### Exposed functions

makeUnitsTable  
Takes a sequence of strings  
Returns a table mapping from a string to a Unit of the same string  

All the standard Lua math operators are overloaded for Units:  
Add, substract, multiply, divide, modulo, and power.  
Power only works if the resulting dimensions are integral,  
e.g. taking the square root of a square meter results in a meter,  
but taking the square root of a meter throws an error.  

Multiplying or dividing a Unit by another Unit or by a Lua number results in a  
new Unit with the expected values and dimensions.  

Units can only be added or subtracted if they have the same dimensions,  
otherwise an error is thrown.  

__tostring is overloaded too, so Units can be printed.  
However, there is no concept of plurals, so the results are not  
grammatically correct. e.g. "65 miles / hours"