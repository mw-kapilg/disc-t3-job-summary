function y = movingAverage(x, windowSize)
%MOVINGAVERAGE Trailing moving average of a vector.
%   Y = MOVINGAVERAGE(X, WINDOWSIZE) returns the mean of the last WINDOWSIZE
%   samples at each position of X. Early samples use the available history.

arguments
    x (:,1) double
    windowSize (1,1) double {mustBeInteger, mustBePositive}
end

y = zeros(size(x));
for k = 1:numel(x)
    first = max(1, k - windowSize + 1);
    y(k) = mean(x(first:k));
end
end
