function [n, U, P] = globalCurveInterpolation(Q, p, knotVectorMethod)
%GLOBALCURVEINTERPOLATION Summary of this function goes here
% Strana 364
%   Q_k = vektor bodů k interpolaci
%   p   = stupeň bázových funkcí
%   knotVectorMethod = metoda výpočtu uzlového vektoru 
%                      možné hodnoty:
%                      EquallySpaced/ChordLength/CentripetalMethod (recommended)

% algoritmus A9.1 - str. 369
n = size(Q, 1) - 1;
% U_bar = uzlový vektor před průměrováním

U_bar = computeU_bar(Q, knotVectorMethod);
% technique of averaging Eq. 9.8
U = zeros(1, 2*(p + 1) + n - p);

for j = 1 : n - p
    U(j + p + 1) = 1/p * sum(U_bar(j + 1 : j + p));
end
U(n + 2 : end) = ones(1, p + 1);

A = nan(n + 1, n + 1);
for i = 1 : n + 1
    span = findSpan(n, p, U_bar(i), U);
    
    N = basisFunctions(span, U_bar(i), p, U);
    A(i, :) = [zeros(1, span - p) N zeros(1, n - span)];
end

P = A\Q;