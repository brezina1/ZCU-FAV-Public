function [Q_result, W_result] = insertPointsIntoSurfaceGrid(Q, Q_new, W, W_new)
%INSERTPOINTINTOSURFACEGRID Summary of this function goes here
%   Detailed explanation goes here
% min_X = min(Q(:, :, 1), [], 'all');
% min_Y = min(Q(:, :, 2), [], 'all');
% min_Z = min(Q(:, :, 3), [], 'all');
% 
% max_X = max(Q(:, :, 1), [], 'all');
% max_Y = max(Q(:, :, 2), [], 'all');
% max_Z = max(Q(:, :, 3), [], 'all');

p = 1;
q = 1;
% points = nurbsSurfaceEval(n, U, m, V, 1, 1, P, [size(Q, 1), size(Q, 2)]);
% figure;
% surf(Q(:, :, 1), Q(:, :, 2), Q(:, :, 3));

% figure;
% surf(points(:, :, 1), points(:, :, 2), points(:, :, 3));
% surf(Q(:, :, 1), Q(:, :, 2), Q(:, :, 3));
% hold on;
% doplnění křivek 
dim = size(Q_new, 2);
for q_i = 1 : size(Q_new, 1)
    [n, m, U, V, P] = globalSurfaceInterpolation(Q, 1, 1);
    point = Q_new(q_i, :);
    point(4) = P(1, 1, 4);
%     v = remapValue(point(2), min_Y, max_Y, 0, 1);
    
    [u, ~] = findKnotValueForFunctionValue(n, 1, U, squeeze(P(:, 1,:)), point(1), 1, 0.001);
    [v, ~] = findKnotValueForFunctionValue(m, 1, V, squeeze(P(1, :,:)), point(2), 2, 0.001);

    values_u = P(:, 1, 1);
    ticks_u = nan(size(values_u));
    for i = 1 : length(values_u)
        ticks_u(i) = findKnotValueForFunctionValue(n, 1, U, squeeze(P(:, 1,:)), values_u(i), 1, 0.001);
    end


    % ticks v
    values_v = P(1, :, 2);
    ticks_v = nan(size(values_v));
    for i = 1 : length(values_v)
        ticks_v(i) = findKnotValueForFunctionValue(m, 1, V, squeeze(P(1, :,:)), values_v(i), 2, 0.001);
    end

    curve_u = nurbsSurfaceEvalSingleLineAtPoints(n, U, m, V, 1, 1, P, v, 'v', ticks_u);
    curve_v = nurbsSurfaceEvalSingleLineAtPoints(n, U, m, V, 1, 1, P, u, 'u', ticks_v);
    
%      aaa = nurbsSurfaceEvalSingleLine(n, U, m, V, 1, 1, P, u, 'u', 1000);
    % vlož bod do křivky
%     [~, insert_before_index] = max(Q(:, 1, 1) > point(1));
%     bbb = nurbsSurfaceEvalSingleLine(n, U, m, V, 1, 1, P, v, 'v', size(Q, 1));
    
%     plot3(curve_u(:, :, 1), curve_u(:, :, 2), curve_u(:, :, 3), 'y.', 'MarkerSize', 20);
%     plot3(curve_v(:, :, 1), curve_v(:, :, 2), curve_v(:, :, 3), 'r.', 'MarkerSize', 10);

%     plot3(aaa(:, :, 1), aaa(:, :, 2), aaa(:, :, 3), 'r.', 'MarkerSize', 10);

    
%     insert_before_index_u = insert_before_index_u +1;
    [~, insert_before_index_v] = max(curve_v(1, :, 2) > point(2));
    [~, insert_before_index_u] = max(curve_u(:, 1, 1) > point(1));
%     insert_before_index_v = insert_before_index_v +1;

%     inserted_point(:, :, :) = point;
    curve_u_new = nan(size(Q, 1) + 1 , 1, dim);
    curve_u_new(1 : insert_before_index_u - 1, 1, :) = curve_u(1 : insert_before_index_u - 1, 1, :);
    curve_u_new(insert_before_index_u, 1, :) = point;
    curve_u_new(insert_before_index_u + 1 : end, 1, :) = curve_u(insert_before_index_u:end, :, :);

    curve_v_new = nan(1 , size(Q, 2) + 1, dim);
    curve_v_new(1, 1 : insert_before_index_v - 1, :) = curve_v(1, 1 : insert_before_index_v - 1, :);
    curve_v_new(1, insert_before_index_v, :) = point;
    curve_v_new(1, insert_before_index_v + 1 : end, :) = curve_v(1, insert_before_index_v:end, :);

   
    Q_result = nan(size(Q, 1) + 1, size(Q, 2) + 1, dim);
    Q_result(1 : insert_before_index_u - 1, 1 : insert_before_index_v - 1, :) = Q(1 : insert_before_index_u - 1, 1 : insert_before_index_v - 1, :);
    Q_result(1 : insert_before_index_u - 1, insert_before_index_v + 1 : end, :) = Q(1 : insert_before_index_u - 1, insert_before_index_v : end, :);

    Q_result(insert_before_index_u + 1 : end, 1 : insert_before_index_v - 1, :) = Q(insert_before_index_u : end, 1 : insert_before_index_v - 1, :);
    Q_result(insert_before_index_u + 1 : end, insert_before_index_v + 1 : end, :) = Q(insert_before_index_u : end, insert_before_index_v : end, :);

    Q_result(insert_before_index_u, :, :) =  curve_v_new;
    Q_result(:, insert_before_index_v, :) =  curve_u_new;
    
    W_result = nan(size(Q, 1) + 1, size(Q, 2) + 1);
    W_result(1 : insert_before_index_u - 1, 1 : insert_before_index_v - 1) = W(1 : insert_before_index_u - 1, 1 : insert_before_index_v - 1);
    W_result(1 : insert_before_index_u - 1, insert_before_index_v + 1 : end) = W(1 : insert_before_index_u - 1, insert_before_index_v : end);

    W_result(insert_before_index_u + 1 : end, 1 : insert_before_index_v - 1) = W(insert_before_index_u : end, 1 : insert_before_index_v - 1);
    W_result(insert_before_index_u + 1 : end, insert_before_index_v + 1 : end) = W(insert_before_index_u : end, insert_before_index_v : end);

    W_result(insert_before_index_u, :) =  0.001;
    W_result(:, insert_before_index_v) =  0.001;
    W_result(insert_before_index_u, insert_before_index_v) = W_new(q_i);
%     surf(Q_result(:, :, 1), Q_result(:, :, 2), Q_result(:, :, 3));
%      figure
%     [~, insert_before_index] = max(Q(1, :, 2) > point(2));
%     Q_new_new = [Q_new_new(:, 1 : insert_before_index - 1, :), bbb ,Q_new_new(:, insert_before_index : end, :)];
%     surf(Q_new_new(:, :, 1), Q_new_new(:, :, 2), Q_new_new(:, :, 3));
% 
%     p = 3;
%     q = 3;
%     [n, m, U, V, P] = globalSurfaceInterpolation(Q, p, q);
%     n = 130;
%     m = m - 2;
%     [U, V, P] = leastSquaresSurfaceApproximation(Q_result, p, q, n, m , ones(size(Q_result, 1), size(Q_result, 2)));
%     points = nurbsSurfaceEval(n, U, m, V, p, q, P, [183, 50]);
%     figure;
%     surf(points(:, :, 1), points(:, :, 2), points(:, :, 3));
%     disp aaa
    Q = Q_result;
    W = W_result;
end
end

