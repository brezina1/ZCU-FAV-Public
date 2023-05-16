function [Q_container_result] = insertInterpolatedSurfacesBetweenSurfaces4D(Q_container, p, q, g, w_coordinates)
%INSERTPOINTINTOSURFACEGRID Summary of this function goes here
%   Detailed explanation goes here
%   Q_container = surfaces described by grid of points each
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
      
        [n, U, P] = globalCurveInterpolation(Q_int_dim, g, "ChordLength");

        interpolation_results{i, j} = {n, g, U, P};   
    end
end

x = Q_container{1}(:, 1, 1);
x_min = min(x);
x_max = max(x);

y = Q_container{1}(1, :, 2);
y_min = min(y);
y_max = max(y);

u = nan(1, length(x));
v = nan(1, length(y));

for u_i = 1 : length(u)
    u(u_i) = remapValue(x(u_i), x_min, x_max, 0, 1);
end

for v_i = 1 : length(v)
    v(v_i) = remapValue(y(v_i), y_min, y_max, 0, 1);
end

w_coordinates = sort(unique(w_coordinates));
Q_container_result = cell(1, length(w_coordinates) + length(Q_container));
Q_container_result(1 : length(Q_container)) = Q_container;

result_index = length(Q_container) + 1;

for w = w_coordinates'
    Q = nan(rows, cols, point_dim);
    for i = 1 : rows
        for j = 1 : cols
            interpolation_result = interpolation_results{i, j};      
            n = interpolation_result{1};
            u_ = findKnotValueForFunctionValue(n, interpolation_result{2}, interpolation_result{3}, interpolation_result{4}, w, 4, 0.001);
            Q(i, j, :) = nurbsEvalSinglePoint(n, interpolation_result{2}, interpolation_result{3}, interpolation_result{4}, u_);
        end
    end

    [n, m, U, V, P] = globalSurfaceInterpolation(Q, p, q);

    points = nurbsSurfaceEval(n, U, m, V, p, q, P, -1, u, v);
    Q_container_result{result_index} = points;
    result_index = result_index + 1;
end

% sort by 4th dim
w = nan(1, length(Q_container_result));
for i = 1 : length(Q_container_result)
    w(i) = Q_container_result{i}(1, 1, 4);
end
[~, I] = sort(w);

tmp = cell(size(Q_container_result));

for i = 1 : length(I)
    tmp{i} = Q_container_result{I(i)};
end
Q_container_result = tmp;
end

