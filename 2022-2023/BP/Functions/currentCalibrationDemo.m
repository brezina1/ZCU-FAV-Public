function currentCalibrationDemo()
path_template = "SAM_CleaCARC_MotionTrace.*CurrentDeviationAndServoErrorTest_CArc_PVT_%i\\.txt";
directory = "Materiály/DataSet_29SEP2022/";
files = dir(directory);
files = {files.name};

original_data_container = cell(4, 1);
container = cell(4, 1);
container_i = 1;

for start_num = 1 : 4
    original_table_container = cell(8, 1);
    table_container = cell(8, 1);
    table_container_i = 1;
    for i = start_num : 4 : 32
        path = sprintf(path_template, i);
        matches = regexp(files, path);
        index = find(~cellfun(@isempty, matches), 1);
        file = files{index};
        
        table = readtable(directory + file, ...
                        'NumHeaderLines', 3);%
    
        data = table{:, :};
        setV = data(:, 3);

        candidates = findLogicalOneRanges(abs(diff(setV)) < 10^-10, 50);
     
        low = candidates(1, 1);
        high = candidates(1, 2);
        
        data(:, 3) = data(:, 3) / max(abs(data(:, 3)));
        data(:, 6) = rescale(data(:, 6));
        data(:, 4) = rescale(data(:, 4));
       

        original_table_container{table_container_i} = data;
        table_container{table_container_i} = data(low:high, :);

        table_container_i = table_container_i + 1;
    end
    container{container_i} = table_container;
    original_data_container{container_i} = original_table_container;
    container_i = container_i + 1;
end
forward895 = container{1};
backward895 = container{2};

forward1170 = container{3};
backward1170 = container{4};


load RealData.mat Q_k
Q = Q_k{1};

% přehození hodnot
tmp = container{2};
container{2} = container{3};
container{3} = tmp;

tmp = original_data_container{2};
original_data_container{2} = original_data_container{3};
original_data_container{3} = tmp;

titles = {"Dopředný pohyb $Ids = 0$",...
    "Dopředný pohyb $Ids = 1$",...
    "Zpětný pohyb $Ids = 0$",...
    "Zpětný pohyb $Ids = 1$"};

for i = 1 : 4
    original_data_cells = original_data_container{i};
    data_cells = container{i};

    figure("Name", "Proudová odchylka - poloha rychlost - " + i);
    tiledlayout(2,1);
    sgtitle(latexify(titles{i}), "Interpreter", "latex");
%     for c_i = 1 : length(data_cells)
    for c_i = 1
        original_data = original_data_cells{c_i};
        data = data_cells{c_i};

        t = data(:, 1);
        original_t = original_data(:, 1);
        
        actP = data(:, 6);
        original_actP = original_data(:, 6);
    
        actV = data(:, 3);
        original_actV = original_data(:, 3);
    
        nexttile(1);
        plot(original_t, original_actP);
        hold on;
        grid on;
        plot(t, actP, 'r.');
        title("Poloha");
        axis tight
        ylim([min(original_actP) - 0.1, max(original_actP) + 0.1]);


        nexttile(2);
        plot(original_t, original_actV);
        hold on;
        grid on;
        plot(t, actV, 'r.');
        title("Rychlost");
        axis tight
        ylim([min(original_actV) - 0.1, max(original_actV) + 0.1]);
    end
    legendHandle = legend(latexify(["Celý záznam", "Vyfiltrované hodnoty"]));
    legendHandle.Layout.Tile = 'north';
end

sum_smoothed = cell(2, 1);
sum_smoothed{1} = zeros(1, 4);
sum_smoothed{2} = zeros(1, 4);
%% originální data a matlab smooth
smoothing_functions = {@(z) z, @(z) smooth(z, 0.05), @(z) nurbsApproximationAsSmoothingFunction(size(Q_k{1},1), 3, z, length(z))};
legend_values = {"Nezpracovaná data", "", ["Plovoucí průměr", "NURBS aproximace"]};
figure_names = ["Analýza odchylky proudu - nezpracovaná data - ",...
    "Analýza odchylky proudu - zpracovaná data - ", ...
    "Analýza odchylky proudu - zpracovaná data - "];
line_widths = [1, 1, 1];
line_colors = {[0.4940 0.1840 0.5560], [0.4940 0.1840 0.5560], [0.4660 0.6740 0.1880]};

cct_plot_functions = {@(Q) surf(Q(:, :, 1), Q(:, :, 2), Q(:, :, 3)), ...
                       @(Q) plot3(Q(:, :, 1), Q(:, :, 2), Q(:, :, 3), Color=[0 0.4470 0.7410]), ...
                       @(Q) plot3(Q(:, :, 1), Q(:, :, 2), Q(:, :, 3), Color=[0 0.4470 0.7410])};

smoothed_Q = cell([3, 4]);
% smoothed_Q{1} = nan(size(Q));
% smoothed_Q{2} = nan(size(Q));
% smoothed_Q{3} = nan(size(Q));

for s_i = 1 : length(smoothing_functions)
    for q_i  = 1 : length(Q_k)
        Q = Q_k{q_i};
        if (s_i <= 2)
            figure("Name", figure_names(s_i) + q_i, "Tag", "HighResolutionImage");
            previous_figures{q_i} = gcf;
        else
            set(0, 'currentfigure', previous_figures{q_i});
        end
        cct_plot_functions{s_i}(Q);
        alpha 0.65
        hold on;
    
        Y_values = rescale([-180, -120, -90, -60, 0, 60, 90, 120]);
        rawData = container{q_i};
        for i = 1 : length(rawData)
            data = rawData {i};
            setP = data(:, 4);
            setI = data(:, 7);
            actI = data(:, 8);
            cucI = data(:, 9);
    
            Y = ones(size(setP,1), 1) * Y_values(i);
            X = setP;
            Z = rescale(cucI + setI - actI);
    
            Z = smoothing_functions{s_i}(Z);
            smoothed_Q{s_i, q_i}(:,i,:) = [X,Y,Z];
            plot3(X, Y, Z, 'LineWidth', line_widths(s_i), 'Color', line_colors{s_i});
            if (s_i >= 2)
                min_X = min(X);
                max_X = max(X);
                 % výpočet chyby 
                cct_row = squeeze(Q(:, i, :));
                smoothed_row = nan(size(cct_row));
        
                for row_i = 1 : length(cct_row)
                    x = cct_row(row_i, 1);
                    % bod kalibrační tabulky leží mimo ručně zpracovaný data
                    if (x < min_X || x > max_X)
                        smoothed_row(row_i, :) = nan(size(cct_row(row_i, :)));
                        continue;
                    end
                    [~, index] = min(abs((X - x)));
                
                    smoothed_row(row_i, :) = [X(index), Y(index), Z(index)];
                end
                % nastav všechny nan hodnoty na 0, ať nejsou počítány do
                % vyhodnocení
                cct_row(isnan(smoothed_row)) = 0;
                smoothed_row(isnan(smoothed_row)) = 0;
        
                sums = sum(((cct_row - smoothed_row)).^2, 1);
                sum_smoothed{s_i - 1}(q_i) = sum_smoothed{s_i - 1}(q_i) + sums(3)/size(smoothed_row, 1);
            end
        end
        xlabel("$C_{Arc}$");
        ylabel("$Prop$");
        zlabel("Proud");
        title(latexify(titles{q_i}))
        if (s_i == 1)
            campos([-4.7585   -4.5718    5.1503]);
        else
            campos([-4.2732   -4.1522    6.0293]);
        end
        
        grid on;
        if (s_i > 2)
            legend([plot3(nan,nan,nan, Color=[0 0.4470 0.7410]), ...
                    plot3(nan,nan,nan, Color=[0.4940 0.1840 0.5560]), ...
                    plot3(nan,nan,nan, Color=[0.4660 0.6740 0.1880])], ...
                latexify(["Kalibrační tabulka", legend_values{s_i}]), ...
                    "Position", [0.632076735507272 0.821904763494219 0.269107527195331 0.079285712696257]);
        else
            legend(latexify(["Kalibrační tabulka", legend_values{s_i}]), ...
            "Position", [0.632076735507272 0.821904763494219 0.269107527195331 0.079285712696257]);
        end
        
%         return;
    end
end

sum_smoothed{1}
sum_smoothed{2}
% return
%% povrchy

for i = 2 : size(smoothed_Q, 1)
    for q_i = 1 : size(smoothed_Q, 2)
        if (i == 2)
            figure("Name", "Interpolace CCT - smooth - " + q_i, "Tag", "HighResolutionImage");
        else
            figure("Name", "Interpolace CCT - nurbs approx - " + q_i, "Tag", "HighResolutionImage");
        end
        
        Q = smoothed_Q{i, q_i};
        downsample_factor = floor(size(Q, 1)/ size(Q_k{1},1));
        Q_(:,:,1) = downsample(Q(:,:,1), downsample_factor);
        Q_(:,:,2) = downsample(Q(:,:,2), downsample_factor);
        Q_(:,:,3) = downsample(Q(:,:,3), downsample_factor);
        [n, m, U, V, P] = globalSurfaceInterpolation(Q_, 3, 3);
        points = nurbsSurfaceEval(n, U, m, V, 3, 3, P, [size(Q_k{1}, 1), 50]);
        surf(points(:, :, 1), points(:, :, 2), points(:, :, 3));

        xlabel("$C_{Arc}$");
        ylabel("$Prop$");
        zlabel("Proud");
        colorbar();

        if (i == 2)
            t = "Interpolace výsledků funkce smooth";
        else
            t = "Interpolace výsledků NURBS approximace";
        end
        title(latexify([titles{q_i}, t]));
        zlim([0, 1]);
    end
end
%% otestování aktualizace CCT na základě naměřených dat
% zpětný pohyb Ids = 1
smoothed_values = smoothed_Q{3, 4};
Q = Q_k{4};
figure("Name", "CCT před aktualizací", "Tag", "HighResolutionImage");
[n, m, U, V, P] = globalSurfaceInterpolation(Q, 3, 3);
points = nurbsSurfaceEval(n, U, m, V, 3, 3, P, [size(Q, 1), 50]);
surf(points(:, :, 1), points(:, :, 2), points(:, :, 3));
title(latexify(["CCT před aktualizací", "Zpětný pohyb, $Ids=1$"]));
xlim([0,1]);
ylim([0,1]);
zlim([0,1]);
campos([-4.4589   -3.6023    6.2948]);
xlabel("$C_{Arc}$");
ylabel("$Prop$");
zlabel("Proud");

figure("Name", "CCT před aktualizací s aktualizačními hodnotami", "Tag", "HighResolutionImage");
[n, m, U, V, P] = globalSurfaceInterpolation(Q, 3, 3);
points = nurbsSurfaceEval(n, U, m, V, 3, 3, P, [size(Q, 1), 50]);
mesh(points(:, :, 1), points(:, :, 2), points(:, :, 3));
alpha 0.5

downsample_factor = floor(size(smoothed_values, 1)/ size(Q_k{4},1));
smoothed_values_downsampled(:,:,1) = downsample(smoothed_values(:,:,1), downsample_factor);
smoothed_values_downsampled(:,:,2) = downsample(smoothed_values(:,:,2), downsample_factor);
smoothed_values_downsampled(:,:,3) = downsample(smoothed_values(:,:,3), downsample_factor);
% surf(smoothed_values_downsampled(:, :, 1), smoothed_values_downsampled(:, :, 2), smoothed_values_downsampled(:, :, 3));

Q_approx = squeeze(smoothed_values_downsampled(130:180, 1, :));
Q_approx(end + 1: end + 41, :) = squeeze(smoothed_values_downsampled(80:120, 2, :));
Q_approx(end + 1: end + 41, :) = squeeze(smoothed_values_downsampled(50:90, 3, :));
Q_approx(end + 1: end + 100, :) = squeeze(smoothed_values_downsampled(1:100, 4, :));
Q_approx(end + 1: end + 110, :) = squeeze(smoothed_values_downsampled(1:110, 5, :));
Q_approx(end + 1: end + 41, :) = squeeze(smoothed_values_downsampled(50:90, 6, :));
Q_approx(end + 1: end + 51, :) = squeeze(smoothed_values_downsampled(1:51, 7, :));
Q_approx(end + 1: end + 51, :) = squeeze(smoothed_values_downsampled(130:180, 8, :));
hold on;
plot3(Q_approx(:, 1), Q_approx(:, 2), Q_approx(:, 3), 'r.');
xlim([0,1]);
ylim([0,1]);
zlim([0,1]);
campos([-4.4589   -3.6023    6.2948]);
xlabel("$C_{Arc}$");
ylabel("$Prop$");
zlabel("Proud");
title(latexify(["CCT před aktualizací s aktualizačními hodnotami", "Zpětný pohyb, $Ids=1$"]));
legend(latexify(["Původní kalibrační tabulka", "Hodnoty využité pro aktualizaci"]), Position=[0.5395 0.8203 0.3965 0.0793]);

figure("Name", "Zdrojová tabulka aktualizačních hodnot", "Tag", "HighResolutionImage");
[n, m, U, V, P] = globalSurfaceInterpolation(smoothed_values_downsampled, 3, 3);
points = nurbsSurfaceEval(n, U, m, V, 3, 3, P, [size(smoothed_values_downsampled, 1), 50]);
mesh(points(:, :, 1), points(:, :, 2), points(:, :, 3));
hold on;
plot3(Q_approx(:, 1), Q_approx(:, 2), Q_approx(:, 3)+ 0.02, 'r.');
xlim([0,1]);
ylim([0,1]);
zlim([0,1]);
campos([-4.4589   -3.6023    6.2948]);
xlabel("$C_{Arc}$");
ylabel("$Prop$");
zlabel("Proud");
title(latexify(["Zdrojová tabulka aktualizačních hodnot", "Zpětný pohyb, $Ids=1$"]));
legend(latexify(["Zdrojová tabulka", "Hodnoty využité pro aktualizaci"]), Position=[0.5395 0.8203 0.3965 0.0793]);

distance_x = (Q(2,1,1) - Q(1,1,1))/3;
distance_y = (Q(1,2,2) - Q(1,1,2))/2;
Q_new = gaussSurfaceApproximation(Q, Q_approx, 3*ones(size(Q_approx, 1)), distance_x, distance_y);
% figure;
% mesh(Q_new(:, :, 1), Q_new(:, :, 2), Q_new(:, :, 3));
figure("Name", "Výsledek aktualizace CCT", "Tag", "HighResolutionImage");
[n, m, U, V, P] = globalSurfaceInterpolation(Q_new, 3, 3);
points = nurbsSurfaceEval(n, U, m, V, 3, 3, P, [size(Q_new, 1), 50]);
surf(points(:, :, 1), points(:, :, 2), points(:, :, 3));
xlim([0,1]);
ylim([0,1]);
zlim([0,1]);
campos([-4.4589   -3.6023    6.2948]);
xlabel("$C_{Arc}$");
ylabel("$Prop$");
zlabel("Proud");
title(latexify(["Výsledek aktualizace CCT --- zpětný pohyb, $Ids=1$", "Interpolace výsledků Gaussovo aproximace", "$\omega = 3,\sigma_x = 0.33, \sigma_y = 0.1$"]));
end

