function [points] = nurbsSurfaceEvalSingleLine(n, U, m, V, p, q, P, constant_value, direction, point_count)
%NURBSSURFACEEVAL Summary of this function goes here
%   Detailed explanation goes here
% upravený algoritmus A3.5
% počet bodů v každé ose => celkkový počet bodů = count^2

% n = length(U) - 1;
% m = length(V) - 1;

if (direction == 'u')
    u = constant_value;
    v = linspace(0, 1, point_count);
elseif(direction == 'v')
    u = linspace(0, 1, point_count);
    v = constant_value;
end


points = nan(length(u), length(v), size(P, 3));
for u_i = 1 : length(u)
    for v_i = 1 : length(v)
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

