function [points] = nurbsCurveEval(n, p, U, P, point_count)
%NUBSB Summary of this function goes here
%   Detailed explanation goes here
% upravený algoritmus A3.1 pro celou křivku
if ~exist('point_count', 'var')
    point_count = 1000;
end

u = linspace(0, 1, point_count);

[~, dim] = size(P);
points = nan(point_count, dim);

for i = 1 : length(u)
    span = findSpan(n, p, u(i), U);
    N = basisFunctions(span, u(i), p, U);
    C = 0;
    for i_2 = 0 : p
        C = C + N(i_2 + 1) * P(span - p + i_2 + 1, :);
    end
    points(i, :) = C;
end
end

