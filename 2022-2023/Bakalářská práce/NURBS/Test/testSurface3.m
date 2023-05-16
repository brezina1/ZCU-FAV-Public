clc;
clear;
close all;

minX = -2*pi;
maxX = 2*pi;

minY = 0;
maxY = 2*pi;

minZ = nan;
maxZ = nan;
[X, Y] = meshgrid(minY : 0.35 : maxY, minX : 0.35 : maxX);
tmp = X;
X = Y;
Y = tmp;
Z = cos(X) + Y;
Q_ = nan(size(X, 1), size(X, 2), 4);
Q_(:, :, 1) = X;
Q_(:, :, 2) = Y;
Q_(:, :, 3) = Z;
Q_(:, :, 4) = ones(size(X)) * 10;
minZ = min(minZ, min(min(Z)));
maxZ = max(maxZ, max(max(Z)));
Q{1} = Q_;

Z = cos(Y) + X;
Q_ = nan(size(X, 1), size(X, 2), 4);
Q_(:, :, 1) = X;
Q_(:, :, 2) = Y;
Q_(:, :, 3) = Z;
Q_(:, :, 4) = ones(size(X)) * 20;
Q{2} = Q_;
minZ = min(minZ, min(min(Z)));
maxZ = max(maxZ, max(max(Z)));

Z = cos(2*Y) + cos(2*X);
Q_ = nan(size(X, 1), size(X, 2), 4);
Q_(:, :, 1) = X;
Q_(:, :, 2) = Y;
Q_(:, :, 3) = Z;
Q_(:, :, 4) = ones(size(X)) * 30;
Q{3} = Q_;
minZ = min(minZ, min(min(Z)));
maxZ = max(maxZ, max(max(Z)));


minW = 10;
maxW = 30;

Q_approx(1, :) = [1, 1, 1, 15];
Q_approx(2, :) = [1, 1, 3, 25];

data = approximateBetweenSurfaces(Q, Q_approx, 3, 3, 1, minW, maxW, 50);
figure;
for i = 1 : length(data)
    n = data{i}{1};
    m = data{i}{2};
    p = data{i}{3};
    q = data{i}{4};
    U = data{i}{5};
    V = data{i}{6};
    P = data{i}{7};
    u = data{i}{8};
    w = data{i}{9};

    points = nurbsSurfaceEval(n, U, m, V, p, q, P, [65, 65]);
    surf(points(:, :, 1), points(:, :, 2), points(:, :, 3));
    xlim([minX, maxX]);
    ylim([minY, maxY]);
    zlim([minZ, maxZ]);
    
    title(latexify(["Interpolace mezi povrchy č. 2", "$p = 3, q = 3, g = 2$", "$w = " + num2str(w, "%.3f") + "$"]));
    xlabel("$x$")
    ylabel("$y$")
    zlabel("$z$")
    colorbar();
    drawnow;

    pause(0.05);
end