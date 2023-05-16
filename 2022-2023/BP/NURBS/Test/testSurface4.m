clc;
clear;
close all;

minX = -2*pi;
maxX = 2*pi;

minY = 0;
maxY = 2*pi;

minZ = nan;
maxZ = nan;
[Y, X] = meshgrid(minY : 0.1 : maxY, minX : 0.1 : maxX);
Z = cos(2*Y) + cos(2*X);
Q(:, :, 1) = X;
Q(:, :, 2) = Y;
Q(:, :, 3) = Z;

minZ = min(minZ, min(min(Z)));
maxZ = max(maxZ, max(max(Z)));


minW = 10;
maxW = 30;

% Q_approx = nan(0);
Q_approx(1, :) = [0, 3, 5];
Q_approx(2, :) = [1, 1, 5];
Q_approx(3, :) = [1, 4, 5];

figure;
surf(Q(:, :, 1), Q(:, :, 2), Q(:, :, 3));


Q_copy = cell(size(Q, [1, 2]));
for j = 1 : size(Q, 1)
    for k = 1 : size(Q, 2)
        Q_copy{j, k} = [squeeze(Q(j, k, :))'];
    end
end

for i = 1 : size(Q_approx, 1)
    current_min_distance = inf;
    current_min_j = nan;
    current_min_k = nan;

    for j = 1 : size(Q, 1)
        for k = 1 : size(Q, 2)
            % vzdálenost přes osy x a y
            difference = (squeeze(Q(j,k,1:2))' - Q_approx(i, 1:2));
            distance = sqrt(sum(difference.^2));
            if (current_min_distance > distance)
                current_min_distance = distance;
                current_min_j = j;
                current_min_k = k;
            end
        end
    end

    current_min_j
    current_min_k
    Q_copy{current_min_j, current_min_k}(end + 1, :) = Q_approx(i, :);
end

figure;
Q_eee = nan(size(Q));

for j = 1 : size(Q, 1)
    for k = 1 : size(Q, 2)
        % todo weighted mean 
        Q_eee(j,k,:) = Q_copy{j, k}(1, :);
        Q_eee(j,k,3) = mean(Q_copy{j, k}(:, 3), 1);
        plot3(Q_copy{j, k}(:, 1), Q_copy{j, k}(:, 2), Q_copy{j, k}(:, 3), '.');
        hold on;
    end
end
figure;
plot3(Q_eee(:,:,1), Q_eee(:,:,2), Q_eee(:,:,3), '.');
title("eeeeeee");



figure;
p = 3;
q = 3;
[n, m, U, V, P] = globalSurfaceInterpolation(Q_eee, p, q);
points = nurbsSurfaceEval(n, U, m, V, p, q, P, [100, 100]);
surf(points(:,:,1), points(:,:,2), points(:,:,3));
hold on;
plot3(Q_approx(:,1), Q_approx(:,2), Q_approx(:,3), 'r.');
return;
p = 3;
q = 3;
n = 26;
m = 8;

[U, V, P] = leastSquaresSurfaceApproximation2(Q_copy, p, q, n, m, ones(size(Q_copy)));
points = nurbsSurfaceEval(n, U, m, V, p, q, P, [200, 200]);
figure;
plot3(points(:,:,1), points(:,:,2), points(:,:,3), '.');
figure;
surf(points(:,:,1), points(:,:,2), points(:,:,3));
hold on;
plot3(Q_approx(:,1), Q_approx(:,2), Q_approx(:,3), 'r.', MarkerSize=10);
