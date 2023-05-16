clc;
clear;
close all;

minX = -2*pi;
maxX = 2*pi;

minY = 0;
maxY = 2*pi;

[Y, X] = meshgrid(minY : 0.1 : maxY, minX : 0.1 : maxX);
Z = cos(2*Y) + cos(2*X);
Q(:, :, 1) = X;
Q(:, :, 2) = Y;
Q(:, :, 3) = Z;
figure;
surf(Q(:, :, 1), Q(:, :, 2), Q(:, :, 3));

Q_approx(1, :) = [0, 3.9, 5];
Q_approx(2, :) = [1.3, 1, 5];
Q_approx(3, :) = [1, 4.7, 5];

weights = [1,1,1];
sigma_x = 0.2;
sigma_y = 0.2;
for i = 1 : size(Q_approx, 1)
    point = Q_approx(i, :);
    point_weight = weights(i);

    for j = 1 : size(Q, 1)
        for k = 1 : size(Q, 2)
            x = Q(j, k, 1);
            y = Q(j, k, 2);
            z = Q(j, k, 3);

            scoped_weight = gaussianFunction2D(x, y, point(1), point(2), sigma_x, sigma_y) * point_weight;

            % weighted mean
            z_new = (z + point(3) * scoped_weight) / (1 + scoped_weight);
            Q(j, k, 3) = z_new;
        end
    end
end
figure;
surf(Q(:, :, 1), Q(:, :, 2), Q(:, :, 3));
hold on;
plot3(Q_approx(:, 1), Q_approx(:, 2), Q_approx(:, 3), 'r.', MarkerSize=20);

return;




figure
size2 = 0;
[X, Y] = meshgrid(-5 : 0.1: 5);
sigma_x = 2;
sigma_y = 1;
Z = exp(-(X.^2/(2*sigma_x^2) + Y.^2/(2*sigma_y^2)));
% Z = exp(-1/(sigma^2)*((Y-size2/2).^2 + (X-size2/2).^2));
surf(X,Y,Z);

figure;
Z = gaussianFunction2D(X,Y, 2, 1,5, 1);
surf(X,Y,Z);
return;
