function out = convertTemperature(value, fromUnit, toUnit)
%CONVERTTEMPERATURE Convert temperatures between Celsius, Fahrenheit, and Kelvin.
%   OUT = CONVERTTEMPERATURE(VALUE, FROMUNIT, TOUNIT) converts VALUE from
%   FROMUNIT to TOUNIT. Units are "C", "F", or "K".

arguments
    value {mustBeNumeric}
    fromUnit (1,1) string {mustBeMember(fromUnit, ["C","F","K"])}
    toUnit (1,1) string {mustBeMember(toUnit, ["C","F","K"])}
end

switch fromUnit
    case "C"
        celsius = value;
    case "F"
        celsius = (value - 32) * 5/9;
    case "K"
        celsius = value - 273.15;
end

switch toUnit
    case "C"
        out = celsius;
    case "F"
        out = celsius * 9/5 + 32;
    case "K"
        out = celsius + 273.15;
end
end
