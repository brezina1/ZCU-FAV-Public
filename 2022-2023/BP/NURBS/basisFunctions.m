function [N] = basisFunctions(i, u, p, U)
%BASISFUNCTIONS Vypočte všechny bázové funkce: N_{0, p} ... N_{i, p}
%   i = index uzlového segmentu
%   u = uzel
%   p = stupeň B-spline bázové funkce
%   U = uzlový vektor

% algoritmus A2.2 - str. 70
N = zeros(1, p + 1);
N(1) = 1;

left = zeros(1, p + 1);
right = zeros(1, p + 1);
for j = 1 : p
    left(j + 1) = u - U(i + 2 - j);
    right(j + 1) = U(i + j + 1) - u;
    saved = 0;

    for r = 1 : j
        temp = N(r)/(right(r + 1) + left(j - r + 2));
        N(r) = saved + right(r + 1) * temp;
        saved = left(j - r + 2) * temp;
    end

    N(j + 1) = saved;
end
end

