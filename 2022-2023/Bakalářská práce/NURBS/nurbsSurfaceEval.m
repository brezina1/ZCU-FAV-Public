function [points] = nurbsSurfaceEval(n, U, m, V, p, q, P, point_count_per_direction, custom_u, custom_v)
%NURBSSURFACEEVAL Summary of this function goes here
%   Detailed explanation goes here
% upravený algoritmus A3.5
% počet bodů v každé ose => celkkový počet bodů = count^2

if ~exist('point_count_per_direction', 'var')
    point_count_per_direction = [max(size(P, 1), 50), max(size(P, 2), 50)];
end

count = point_count_per_direction;

% n = length(U) - 1;
% m = length(V) - 1;


if (exist('custom_u', 'var'))
    u = custom_u;
    count(1) = length(u);
else
    u = linspace(0, 1, count(1));
end

if (exist('custom_v', 'var'))
    v = custom_v;
    count(2) = length(v);
else
    v = linspace(0, 1, count(2));
end

points = nan(count(1), count(2), size(P, 3));
for u_i = 1 : count(1)
    for v_i = 1 : count(2)
        u_span = findSpan(n, p, u(u_i), U);
        N_u = basisFunctions(u_span, u(u_i), p, U);
    
        v_span = findSpan(m, q, v(v_i), V);
        N_v = basisFunctions(v_span, v(v_i), q, V);
    
        u_ind = u_span - p;
    
        S = 0;
        for l = 0 : q
            temp = 0;
            v_ind = v_span - q + l;
            for k = 0 : p
                temp = temp + N_u(k + 1) * squeeze(P(u_ind + k + 1, v_ind + 1, :));
            end
            S = S + N_v(l + 1) * temp;
        end

        points(u_i, v_i, :) = S';
    end
end
end

