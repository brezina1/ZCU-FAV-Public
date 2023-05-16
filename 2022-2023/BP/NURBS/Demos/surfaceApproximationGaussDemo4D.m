function [] = surfaceApproximationGaussDemo4D(animate)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
min_X = -2*pi;
max_X = 2*pi;

min_Y = -2*pi;
max_Y = 2*pi;
[Y, X] = meshgrid(min_Y : 0.15 : max_Y, min_X : 0.15 : max_X);

min_Z = nan;
max_Z = nan;

Z = cos(X) + Y;
Q_ = nan(size(X, 1), size(X, 2), 4);
Q_(:, :, 1) = X;
Q_(:, :, 2) = Y;
Q_(:, :, 3) = Z;
Q_(:, :, 4) = ones(size(X, 1), size(X, 2)) * 10;
min_Z = min(min_Z, min(min(Z)));
max_Z = max(max_Z, max(max(Z)));
Q{1} = Q_;

Z = cos(Y) + X;
Q_ = nan(size(X, 1), size(X, 2), 4);
Q_(:, :, 1) = X;
Q_(:, :, 2) = Y;
Q_(:, :, 3) = Z;
Q_(:, :, 4) = ones(size(X, 1), size(X, 2)) * 20;
Q{2} = Q_;
min_Z = min(min_Z, min(min(Z)));
max_Z = max(max_Z, max(max(Z)));

Z = cos(2*Y) + cos(2*X);
Q_ = nan(size(X, 1), size(X, 2), 4);
Q_(:, :, 1) = X;
Q_(:, :, 2) = Y;
Q_(:, :, 3) = Z;
Q_(:, :, 4) = ones(size(X, 1), size(X, 2)) * 30;
Q{3} = Q_;
min_Z = min(min_Z, min(min(Z)));
max_Z = max(max_Z, max(max(Z)));

Q_approx(1, :) = Q{2}(end/2, end/2, :);
Q_approx(1, 3) = 5;
Q_approx(1, 4) = 15;

Q_approx(2, :) = [-4, 1.5, 4, 16];
Q_approx(3, :) = [-4, -4, 6, 20];
Q_approx(4, :) = [4, -3, 7, 25];


str2file(mat2latex(Q_approx(1, :)), "Dokumentace/Generated/Gauss Approximace 4D approx bod 1.tex", true);
str2file(mat2latex(Q_approx(2, :)), "Dokumentace/Generated/Gauss Approximace 4D approx bod 2.tex", true);
str2file(mat2latex(Q_approx(3, :)), "Dokumentace/Generated/Gauss Approximace 4D approx bod 3.tex", true);
str2file(mat2latex(Q_approx(4, :)), "Dokumentace/Generated/Gauss Approximace 4D approx bod 4.tex", true);
% return;
weights = [1, 1, 1, 1];
min_w = 10;
max_w = 30;

% sigma_x = (max_X - min_X)/20;
% sigma_y = (max_Y - min_Y)/20;
% sigma_w = 1;

sigma_x = 0.5;
sigma_w = 1.5;
fig_index = 1;
for sigma_y = [0.5, 1]
    data = approximateBetweenSurfaces(Q, Q_approx, weights, 3, 3, 2, min_w, max_w, 90, sigma_x, sigma_y, sigma_w);
    
    figure;
    filename = sprintf("./Dokumentace/Generated/4D surface gauss approx demo %s.gif", num2str(fig_index));
    targetDir = replace(filename, ".gif", "/");
    if (animate)
        delete(filename);
        cmd_rmdir(targetDir);
    end
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
        hold on;
        for q_i = 1 : size(Q_approx, 1)
            alpha = (abs(w - Q_approx(q_i, 4)));
            alpha = 1 - remapValue(min(alpha, 3.5), 0, 3.5, 0, 1);
            scatter3(Q_approx(q_i, 1), Q_approx(q_i, 2), Q_approx(q_i, 3), 50,...
                               "MarkerEdgeColor", [1,1,1], ...
                               "MarkerFaceColor", [0,0,0], ...
                               MarkerEdgeAlpha=alpha, ...
                               MarkerFaceAlpha=alpha);
        end
        hold off;
        xlim([min_X, max_X]);
        ylim([min_Y, max_Y]);
        zlim([min_Z, max_Z]);
        
        title(latexify(["Aproximace bodů mezi povrchy č. " + fig_index, "$p = 3, q = 3, g = 2$", ...
                        sprintf("$\\sigma_x=%s, \\sigma_y=%s,\\sigma_w=%s$", num2str(sigma_x), num2str(sigma_y), num2str(sigma_w)), ...
                        "$w = " + num2str(w, "%.3f") + "$"]));
        xlabel("$x$")
        ylabel("$y$")
        zlabel("$z$")
        colorbar();
        drawnow;
%         return;
        if (~animate)
            break
        end
        exportgraphics(gcf, filename, 'Append', true, "Resolution", 250);
    end
    if (animate)
        mkdir(targetDir);
        system("magick " + '"' + filename + '"' + " " + '"' + targetDir + "/frame.png" + '"')  
    end
%     return;
    fig_index = fig_index + 1;
end
end

