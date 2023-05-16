function [N_ip] = singleBasisFunction(p, U, i, u)
%SINGLEBASISFUNCTION Summary of this function goes here
%   Detailed explanation goes here
% Algoritmus A2.4

m = length(U) - 1;
% speciální případy
if (i == 0 && u == U(1)) || (i == m - p - 1 && u == U(m))
    N_ip = 1;
    return;
end

if (u < U(i + 1) || u >= U(i + p + 1 + 1))
    N_ip = 0;
    return;
end

for j = 0 : p
    if (u >= U(i + j + 1) && u < U(i + j + 2))
        N(j + 1) = 1;
    else
        N(j + 1) = 0;
    end
end

for k = 1 : p
    if (N(1) == 0)
        saved = 0;
    else
        saved = ((u - U(i + 1)) * N(1))/(U(i + k + 1) - U(i + 1));
    end

    for j = 0 : p - k
        U_left = U(i + j + 2);
        U_right = U(i + j + k + 2);

        if N(j + 2) == 0
            N(j + 1) = saved;
            saved = 0;
        else
            temp = N(j + 2)/(U_right - U_left);
            N(j + 1) = saved + (U_right - u) * temp;
            saved = (u - U_left) * temp;
        end
    end
end

N_ip = N(1);
end
