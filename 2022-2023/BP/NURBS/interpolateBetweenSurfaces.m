function [interpolated_surfaces_data] = interpolateBetweenSurfaces(Q_container, p, q, g, min_w, max_w, steps)
%INTERPOLATEBETWEENSURFACES Summary of this function goes here
%   Detailed explanation goes here
%   p = stupeň polynomu bázových funkcí povrchů ve směru u
%   q = stupeň polynomu bázových funkcí povrchů ve směru v
%   g = stupeň polynomu interpolace mezi povrchy

point_dim = size(Q_container{1}, 3);

rows = size(Q_container{1}, 1);
cols = size(Q_container{1}, 2);

interpolation_results = cell(rows, cols);
for i = 1 : rows
    for j = 1 : cols
        Q_int_dim = nan(length(Q_container), point_dim);
    
        for q_i = 1:length(Q_container)
            Q_int_dim(q_i, :) = Q_container{q_i}(i, j, :);
            hold on;
        end
%       Q_int_dim
        [n, U, P] = globalCurveInterpolation(Q_int_dim, g, "ChordLength");

        interpolation_results{i, j} = {n, g, U, P};   
    end
end


result_index = 1;
result = cell(steps, 1);


for w = linspace(min_w, max_w, steps)
    Q = nan(rows, cols, point_dim);
    for i = 1 : rows
        for j = 1 : cols
            interpolation_result = interpolation_results{i, j};      
            n = interpolation_result{1};
            u = findKnotValueForFunctionValue(n, interpolation_result{2}, interpolation_result{3}, interpolation_result{4}, w, 4, 0.005);
            Q(i, j, :) = nurbsEvalSinglePoint(n, interpolation_result{2}, interpolation_result{3}, interpolation_result{4}, u);
        end
    end

    [n, m, U, V, P] = globalSurfaceInterpolation(Q, p, q);

    result{result_index} = {n, m, p, q, U, V, P, u, w};
    result_index = result_index + 1;
end

interpolated_surfaces_data = result;
end

