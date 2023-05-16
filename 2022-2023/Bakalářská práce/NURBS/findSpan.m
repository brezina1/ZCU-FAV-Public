function [startIndex] = findSpan(n, p, u, U)
%FINDSPAN Najde index segmentu v uzlovém vektoru U podle parametru u
% Stránka 68
%   n = počet řídících bodů - 1
%   p = stupeň B-spline bázové funkce (degree of B-spline basis function)
%   u = uzel
%   U = uzlový vektor (knot vector)

% speciální případ
if (u == U(n + 2))
    startIndex = n;
    return;
end

% binární hledání
low = p;
high = n + 2;
mid = floor((low + high)/2);

while(u < U(mid + 1) || u >= U(mid + 2))
    if(u < U(mid + 1))
        high = mid;
    else
        low = mid;
    end

    mid = floor((low + high)/2);
end

startIndex = mid;
end

