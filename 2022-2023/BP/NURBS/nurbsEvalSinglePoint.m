function [point] = nurbsEvalSinglePoint(n, p, U, P, u)
%NURBSEVALSINGLEPOINT Summary of this function goes here
%   Detailed explanation goes here
span = findSpan(n, p, u, U);
N = basisFunctions(span, u, p, U);
C = 0;
for i_2 = 0 : p
    C = C + N(i_2 + 1) * P(span - p + i_2 + 1, :);
end
point = C;
end
