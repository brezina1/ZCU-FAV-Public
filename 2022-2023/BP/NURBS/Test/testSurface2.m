clc;
clear;
close all;

load RealData.mat Q_k

Q = Q_k{1};
figure;
surf(Q(:, :, 1), Q(:, :, 2), Q(:, :, 3));

Q_new(1, :) = [75.5, -50.5, 400];
Q_new(2, :) = [45.5, -30.5, 400];
Q_new(3, :) = [45.5, -35.5, 400];
Q_new(4, :) = [45.5, -25.5, 400];
Q_new(5, :) = [0, 0, 300];
W_new(1:5) = 10;

[Q_combined, W] = insertPointsIntoSurfaceGrid(Q, Q_new, ones(size(Q, [1, 2])), W_new);

figure;
surf(Q_combined(:, :, 1), Q_combined(:, :, 2), Q_combined(:, :, 3));
% plot3(Q_combined(:, :, 1), Q_combined(:, :, 2), Q_combined(:, :, 3), '.');

[n, m, U, V, P] = globalSurfaceInterpolation(Q, 3,3);
points = nurbsSurfaceEval(n, U, m, V, 3, 3, P, [190, 50]);
figure;
surf(points(:, :, 1), points(:, :, 2), points(:, :, 3));


n = 100;
m = 4;
[U, V, P] = leastSquaresSurfaceApproximation(Q_combined, 3,3, n, m, W);

points = nurbsSurfaceEval(n, U, m, V, 3, 3, P, [190, 50]);

figure;
surf(points(:, :, 1), points(:, :, 2), points(:, :, 3));
hold on;
plot3(Q_new(:, 1), Q_new(:, 2), Q_new(:, 3), 'r.', MarkerSize=20);

return;
[U, V, P] = leastSquaresSurfaceApproximation(Q, 3,3, n, m, ones(size(Q, [1, 2])));

points = nurbsSurfaceEval(n, U, m, V, 3, 3, P, [190, 50]);

figure;
surf(points(:, :, 1), points(:, :, 2), points(:, :, 3));