classdef tMovingAverage < matlab.unittest.TestCase
    % Tests for movingAverage.

    methods (Test)
        function constantSignal(testCase)
            y = movingAverage(ones(10,1), 3);
            testCase.verifyEqual(y, ones(10,1));
        end

        function knownValues(testCase)
            y = movingAverage([1;2;3;4], 2);
            testCase.verifyEqual(y, [1;1.5;2.5;3.5]);
        end

        function windowLargerThanSignal(testCase)
            y = movingAverage([2;4], 5);
            testCase.verifyEqual(y, [2;3]);
        end
    end
end
