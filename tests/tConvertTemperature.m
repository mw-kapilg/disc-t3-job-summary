classdef tConvertTemperature < matlab.unittest.TestCase
    % Tests for convertTemperature.

    methods (Test)
        function freezingPoint(testCase)
            testCase.verifyEqual(convertTemperature(0, "C", "F"), 32, "AbsTol", 1e-12);
            testCase.verifyEqual(convertTemperature(0, "C", "K"), 273.15, "AbsTol", 1e-12);
        end

        function roundTrip(testCase)
            value = [-40 0 37 100];
            back = convertTemperature(convertTemperature(value, "C", "F"), "F", "C");
            testCase.verifyEqual(back, value, "AbsTol", 1e-12);
        end

        function invalidUnitErrors(testCase)
            testCase.verifyError(@() convertTemperature(1, "X", "C"), ...
                "MATLAB:validators:mustBeMember");
        end
    end
end
