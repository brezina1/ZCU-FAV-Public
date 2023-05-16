function [] = surfaceApproximationGaussDemo()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
minX = -2*pi;
maxX = 2*pi;

minY = 0;
maxY = 2*pi;

[Y, X] = meshgrid(minY : 0.15 : maxY, minX : 0.15 : maxX);
Z = ones(size(X, 1), size(X, 2)) * 2;
Q(:, :, 1) = X;
Q(:, :, 2) = Y;
Q(:, :, 3) = Z;
Q_{1} = Q;
Q(:, :, 3) = cos(2 * Y) + cos(2 * X);
Q_{2} = Q;

% figure;
% surf(Q(:, :, 1), Q(:, :, 2), Q(:, :, 3));

Q_approx(1, :) = [1, 4.7, 4];
Q_approx(3, :) = [0, 2, 4];
Q_approx(2, :) = [-4, 1.5, 4];


weights = [5, 3, 1];


titles = {["Aproximace pro povrch ${\bf Z} = 2$ s užitím Gaussovo funkce",...
                "Aproximačními body: ${\bf Q}_1, {\bf Q}_2, {\bf Q}_3$"],...
          ["Aproximace pro povrch ${\bf Z} = \cos(2{\bf Y}) + \cos(2{\bf X})$ s užitím Gaussovo funkce",...
                "Aproximačními body: ${\bf Q}_1, {\bf Q}_2, {\bf Q}_3$"]};

title_index = 1;
fig_index = 1;
for tmp = Q_
    Q = cell2mat(tmp);
    Q_copy = Q;
    for sigma_x = [0.25, 0.5]
        for sigma_y = [0.25, 0.5]
            Q = Q_copy;
            figure("Name", "Ukázka aproximace s užitím Gaussovo funkce č. " + fig_index, "Tag", "HighResolutionImage");

            Q = gaussSurfaceApproximation(Q, Q_approx, weights, sigma_x, sigma_y);
            hold off;
            surf(Q(:, :, 1), Q(:, :, 2), Q(:, :, 3));
            hold on;
            points_legend = cell(size(Q_approx, 1));
            for p_i = 1 : size(Q_approx, 1)
                plot3(Q_approx(p_i, 1), Q_approx(p_i, 2), Q_approx(p_i, 3), 'o', LineWidth=3, MarkerSize=7, MarkerFaceColor=[1,1,1]);
                points_legend{p_i} = sprintf("${\\bf Q}_%s = [%s, %s, %s], \\omega = %s$", ...
                                                                                    num2str(p_i),...
                                                                                    num2str(Q_approx(p_i, 1)), ...
                                                                                    num2str(Q_approx(p_i, 2)), ...
                                                                                    num2str(Q_approx(p_i, 3)), ...
                                                                                    num2str(weights(p_i)));
            end
            
            title( latexify([titles{title_index} sprintf("$\\sigma_x = %s$, $\\sigma_y = %s$", num2str(sigma_x), num2str(sigma_y))]));
            xlabel("$x$");
            ylabel("$y$");
            zlabel("$z$");
            legend_handle = legend(latexify(["Výsledná aproximace", points_legend{:}]), "Position", [0.6531 0.6620 0.3079 0.2454]);
            transparentLegend(legend_handle, [1, 1, 1, 0.75])
            fig_index = fig_index + 1;
%             return;
        end
    end
    title_index = title_index + 1;
end
end

