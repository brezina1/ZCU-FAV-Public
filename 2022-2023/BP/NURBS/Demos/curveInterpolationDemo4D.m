function curveInterpolationDemo4D(animate)
% tohle celý je hnus
x = linspace(0, 2 * pi, 25)';

w_container{1} = [0, 100, 200];
w = w_container{1};
z_container{1} = [10, 0, 20];
Q{1} = [x, sin(x), ones(size(x)) * 10, ones(size(x)) * w(1)];
Q{2} = [x, -sin(x), ones(size(x)) * 0, ones(size(x)) * w(2)];
Q{3} = [x, sin(x), ones(size(x)) * 20, ones(size(x)) * w(3)];
Qcontainer{1} = Q;

w_container{2} = [0, 50, 200];
w = w_container{2};
z_container{2} = [10, 0, 20];
Q{1} = [x, sin(x), ones(size(x)) * 10, ones(size(x)) * w(1)];
Q{2} = [x, -sin(x), ones(size(x)) * 0,  ones(size(x)) * w(2)];
Q{3} = [x, sin(x), ones(size(x)) * 20, ones(size(x)) * w(3)];
Qcontainer{2} = Q;

w_container{3} = [0, 100, 200];
w = w_container{3};
z_container{3} = [10, "2.5 + 2.5\cdot  \cos(2x)", "17.5 + 2.5\cdot \cos(2x)"];
Q{1} = [x, sin(x), ones(size(x)) * 10, ones(size(x)) * w(1)];
Q{2} = [x, -sin(x), ones(size(x)) * 2.5 + cos(x * 2) * 2.5, ones(size(x)) * w(2)];
Q{3} = [x, sin(x), ones(size(x)) * 17.5 - cos(x * 2) * 2.5, ones(size(x)) * w(3)];
Qcontainer{3} = Q;

zlims{1} = [-0.5, 20.1];
zlims{2} = [-2, 20.1];
zlims{3} = [-0.5, 20.1];
function plot_strand_points()
    hold off;

    for q_i = 1:length(Q)
        point = Q{q_i}(highlighted_x, :);
        plot3(point(1), point(2), point(3), '.', MarkerSize = 20, Color = colors{q_i});
        hold on;
    end

    plot3(single_strand_points(:, 1), single_strand_points(:, 2), single_strand_points(:, 3), highlighted_x_style{:});
    view(270, 0);

    ylabel("$y$");
    zlabel("$z$");
    grid on;
end

for container_i = 1:length(Qcontainer)
    Q = Qcontainer{container_i};
    z = z_container{container_i};
    w = w_container{container_i};
    dim_4_min = nan;
    dim_4_max = nan;
    highlighted_x = 7;
    highlighted_x_style = {"LineWidth", 1.5, "Color", [0.5, 1, 0]};

    %% ukázka interpolace mezi bodama ve 4. dimenzi
    oldFig = figure("Name", "Interpolace 4D křivky - Interpolace mezi body ve 4. dimenzi č. " + container_i);
    % interpolace ve 4. dimenzi
    colors = {[0 0.4470 0.7410], [0.8500 0.3250 0.0980], [0.4940 0.1840 0.5560], [0.4940 0.1840 0.5560]};
    legendEntries = {};

    for l = 1:length(Q{1})
        Q_4thDim = nan(length(Q), 4);

        for q_i = 1:length(Q)
            Q_4thDim(q_i, :) = Q{q_i}(l, :);
            legendEntries{q_i} = plot3(Q_4thDim(q_i, 1), Q_4thDim(q_i, 2), Q_4thDim(q_i, 3), '.', "Color", colors{q_i}, MarkerSize = 20);
            hold on;
        end

        dim_4_min = min(dim_4_min, min(Q_4thDim(:, 4)));
        dim_4_max = max(dim_4_max, max(Q_4thDim(:, 4)));

        p = 2;
%         Q_4thDim_unique = unique(Q_4thDim, 'rows');
        % vyhoď stejný, po sobě jdoucí body
        Q_4thDim_unique = Q_4thDim(max([Q_4thDim(1, :); diff(Q_4thDim)] ~= 0, [], 2), :);
        Q_4thDim_unique = Q_4thDim;
        if (size(Q_4thDim_unique, 1) > 1)
            [n, U, P] = globalCurveInterpolation(Q_4thDim_unique, p, "ChordLength");
            points = nurbsCurveEval(n, p, U, P);
            interpolated_4D_points{l} = points;

            if (highlighted_x == l)
                plot3(points(:, 1), points(:, 2), points(:, 3), highlighted_x_style{:});
            else
                plot3(points(:, 1), points(:, 2), points(:, 3));
            end

            interpolation_results{l} = {n, p, U, P};
        else
            interpolation_results{l} = {1, nan, nan, Q_4thDim_unique};
        end

    end

    grid on;
    title(latexify(["Interpolace 4D křivky č. " + container_i, "Interpolace mezi body ve 4. dimenzi $w$", ...
                    "$\bf Q = [x,y,z,w]\quad {\bf x}$ = linspace($0, 2\cdot\pi, 25$)"]));
    legendEntries{end + 1} = plot3(nan, nan, nan, 'Color', [0.75, 0.75, 0.75]);
    legendEntries{end + 1} = plot3(nan, nan, nan, highlighted_x_style{:});
    legendHandle = legend([legendEntries{:}], ["${\bf Q}_1 = [\bf x, \rm\sin({\bf x}), "+ z(1)+ ", " + w(1) + "]$", ...
                                                    "${\bf Q}_2 = [\bf x, \rm-\sin({\bf x}), "+ z(2)+ ", " + w(2) + "]$", ...
                                                    "${\bf Q}_3 = [\bf x, \rm\sin({\bf x}), "+ z(3)+ "," + w(3) + "]$", ...
                                                    "NURBS interpolace $p = " + p + "$", ...
                                                    "$x = " + x(highlighted_x) + "$"], ...
        "Position", [0.535349720616913 0.029531621092461 0.316793257934482 0.185714281740643]);
    if (container_i == 2)
        legendHandle.Position = [0.5818 0.0843 0.3168 0.1857];
    elseif (container_i == 3)
        legendHandle.Position = [0.4641 0.6795 0.4664 0.1857];
    end
    transparentLegend(legendHandle, [1, 1, 1, 0.90]);
    xlabel("$x$");
    ylabel("$y$");
    zlabel("$z$");
    zlim(zlims{container_i});
    campos([-6.232465375281299 -16.151455895161639 77.603644291031003]);

    newFig = figure("Name", "Interpolace 4D křivky - Interpolace mezi body ve 4. dimenzi (shora) č. " + container_i);
    cloneFig(oldFig, newFig);
    title(latexify(["Interpolace 4D křivky č. " + container_i, "Interpolace mezi body ve 4. dimenzi $w$ (pohled shora)", ...
                    "$\bf Q = [x,y,z,w]\quad {\bf x}$ = linspace($0, 2\cdot\pi, 25$)"]));
    legendHandle = legend;
    legendHandle.Position = [0.615706863474056 0.024769716330556 0.316793257934482 0.185714281740643];
    if (container_i == 3)
        legendHandle.Position = [0.0087 0.0200 0.4664 0.1857];
    end
    view(0, 90)

    %% jedno "vlákno"
    figure("Name", "Interpolace 4D křivky - Interpolace mezi body ve 4. dimenzi 1 vlákno č. " + container_i);
    [n, p, U, P] = interpolation_results{highlighted_x}{:};
    single_strand_points = nurbsCurveEval(n, p, U, P);

    plot_strand_points();
    legendHandle = legend(["${\bf Q}_1 = [" + x(highlighted_x) + ", \sin(" + x(highlighted_x) + "), "+ z(1)+ ", " + w(1) + "]$", ...
                                "${\bf Q}_2 = [" + x(highlighted_x) + ", \sin(" + x(highlighted_x) + "), "+ z(2)+ ", " + w(2) + "]$", ...
                                "${\bf Q}_3 = [" + x(highlighted_x) + ", \sin(" + x(highlighted_x) + "), "+ z(3)+ ", " + w(3) + "]$", ...
                                "NURBS interpolace $p = " + p + "$"], ...
        "Location", "northeast");
    transparentLegend(legendHandle, [1, 1, 1, 0.75]);
    view(270, 0);
    title(latexify(["Interpolace 4D křivky č. " + container_i, "Interpolace bodů ve 4. dimenzi $w$ pro $x = " + x(highlighted_x) + "$"]));
    ylabel("$y$");
    zlabel("$z$");

    
    %% subplot tentononc
    if ~animate
        continue;
    end

    filename = "./Dokumentace/Generated/4D curve demo " + container_i + ".gif";
    targetDir = replace(filename, ".gif", "/");
    delete(filename);
    cmd_rmdir(targetDir);

    figure;
    subplot(3, 2, 1);
    plot_strand_points();
    point_w = plot3(nan, nan, nan, 'kx', MarkerSize = 10);
    title(latexify(["Interpolace bodů ve 4. dimenzi $w$", "$x = " + x(highlighted_x) + "$"]));
    subplot(3, 2, 2);

    for i = 1:length(interpolated_4D_points)
        points = interpolated_4D_points{i};

        if (i == highlighted_x)
            plot3(points(:, 1), points(:, 2), points(:, 3), highlighted_x_style{:});
        else
            plot3(points(:, 1), points(:, 2), points(:, 3));
        end

        points_w{i} = plot3(nan, nan, nan, 'kx', MarkerSize = 5);
        hold on;
    end

    xlabel("$x$");
    ylabel("$y$");
    title(latexify(["Průběh interpolace jednotlivých bodů", "Pohled shora"]));
    view(0, 90)

    subplot(3, 2, [3, 4, 5, 6]);

    for q_i = 1:length(Q)
        points = Q{q_i}(:, :);
        [n, U, P] = globalCurveInterpolation(points, p, "ChordLength");
        interpolated_lines{q_i} = nurbsCurveEval(n, p, U, P);
    end

    Q_ = nan(size(Q{1}));
%% animace
    for w_ = linspace(dim_4_min, dim_4_max, 200)
        subplot(3, 2, 1);
        [n, p, U, P] = interpolation_results{highlighted_x}{:};
        u = findKnotValueForFunctionValue(n, p, U, P, w_, 4, 0.001);
        single_strand_point = nurbsEvalSinglePoint(n, p, U, P, u);
        point_w.XData = single_strand_point(1);
        point_w.YData = single_strand_point(2);
        point_w.ZData = single_strand_point(3);

        subplot(3, 2, [3, 4, 5, 6]);

        for c_i = 1:size(Q{1}, 1)
            interpolation_result = interpolation_results{c_i};
            % pouze jeden řídíc bod, znamená to, že tento bod se nemění v
            % závislosti na 4. dimenzi
            n = interpolation_result{1};

            Q_(c_i, :) = nurbsEvalSinglePoint(n, interpolation_result{2}, interpolation_result{3}, interpolation_result{4}, u);
        end

        for q_i = 1:size(Q_, 1)
            points_w{q_i}.XData = Q_(q_i, 1);
            points_w{q_i}.YData = Q_(q_i, 2);
            points_w{q_i}.ZData = Q_(q_i, 3);
        end

        for i = 1:length(interpolated_lines)
            points = interpolated_lines{i};
            plot3(points(:, 1), points(:, 2), points(:, 3), '--', "Color", colors{i});
            hold on;
        end

        p = 3;

        [n, U, P] = globalCurveInterpolation(Q_, p, "ChordLength");
        points = nurbsCurveEval(n, p, U, P);
        plot3(points(:, 1), points(:, 2), points(:, 3));
%         current_w = dim_4_min + u * (dim_4_max - dim_4_min);

        ylim([-1.8, 1.8]);
        xlim([0, 2 * pi]);
        zlim(zlims{container_i});
        xlabel("$x$");
        ylabel("$y$");
        zlabel("$z$");
        hold off;
        legendHandle = legend(["${\bf Q}_1 = [\bf x, \rm\sin({\bf x}), "+ z(1)+ ", " + w(1) + "]$", ...
                    "${\bf Q}_2 = [\bf x, \rm-\sin({\bf x}), "+ z(2)+ ", " + w(2) + "]$", ...
                    "${\bf Q}_3 = [ \bf x, \rm\sin({\bf x}), "+ z(3)+ ", " + w(3) + "]$", ...
                    "NURBS Interpolace $p = " + p + "$"], ...
            "Position", [0.6671 0.0660 0.3079 0.1434]);

        if (container_i == 3)
            legendHandle.Position = [0.5472 0.0914 0.4477 0.1434];
        end
        grid on;
        sgtitle(latexify(["Interpolace 4D křivky č. " + container_i, "Detailní průběh - $w = " + w_ + "$"]));
        drawnow
        %     pause(0.05);
        
        exportgraphics(gcf, filename, 'Append', true, "Resolution", 300);
%         return;
        %break;
    end

    % převedení gifu na obrázky
    mkdir(targetDir);
    system("magick " + '"' + filename + '"' + " " + '"' + targetDir + "/frame.png" + '"')   
end

end
