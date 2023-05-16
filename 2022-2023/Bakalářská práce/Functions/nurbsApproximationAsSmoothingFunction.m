function [smoothed_points] = nurbsApproximationAsSmoothingFunction(n, p, Q, point_count)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[U, P] = leastSquaresCurveApproximation(Q, n, p, ones(1, length(Q) - 2));
smoothed_points = nurbsCurveEval(n, p, U, P, point_count);
end

