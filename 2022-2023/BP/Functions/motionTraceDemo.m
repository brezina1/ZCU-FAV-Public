function [outputArg1,outputArg2] = motionTraceDemo(inputArg1,inputArg2)
%MOTIONTRACEDEMO Summary of this function goes here
%   Detailed explanation goes here
% close all
% relTime [S], setA [au/s^2], setV [au/s], setP [au], actV [au/s], loadP-AV [au], setI [A], actI [A], cucI [A], MMS, MSS
data = parseMotionTrace(".\Materiály\DataSet_29SEP2022\SAM_CleaCARC_MotionTrace[20220929_090502].txt");
smoothed_diff_data = smoothdata([data(1, 5); diff(data(:, 5))]);
time = data(:, 1);
%% konstantní rychlost
constant_velocity_logical = abs(smoothed_diff_data) < 5 * 10^-4;

combined_conditions = constant_velocity_logical;
% nalezení x po sobě jdoucích hodnot, které splňují předchozí požadavky
candidates = findLogicalOneRanges(combined_conditions, 50);
plot_data("Aplikace filtru konstatní rychlosti", candidates)
% return;
%% konstantní, nenulová, nemaximální rychlost
nonstationary_logical = abs(data(:, 5)) > 1;
speed_limits = [-7, 7];
nontopspeed_logical = abs(data(:, 5)) < 7;
constant_velocity_logical = abs(smoothed_diff_data) < 5 * 10^-4;

combined_conditions = nonstationary_logical & nontopspeed_logical & constant_velocity_logical;
% nalezení x po sobě jdoucích hodnot, které splňují předchozí požadavky
candidates = findLogicalOneRanges(combined_conditions, 50);
plot_data("Aplikace všech filtrů", candidates, speed_limits)

    function plot_data(title_, highlighted_values, velocity_limits)
        figure(Name=title_);
        layout = tiledlayout(4, 1, "TileSpacing","loose");
        nexttile(1);
        legend_entry_1 = plot(time, data(:, 5));
        hold on;
        grid on;
        axis manual
        % xticks([]);
        xlim('tight')
        xlabel(latexify("Čas $[s]$"));
        title(latexify("Měřená rychlost kloubu $C_{Arc}$"));
        ylabel("Rychlost $v~[^\circ/s]$")
        if (exist("velocity_limits","var"))
            plot(time, velocity_limits(1)*ones(size(time)), 'r--');
            plot(time, velocity_limits(2)*ones(size(time)), 'r--');
        end


        nexttile(2);
        plot(time, smoothed_diff_data);
        hold on;
        title(latexify("Rozdíl posobějdoucích měřených rychlostí"));
        ylabel("$\Delta v$")
        xlabel(latexify("Čas $[s]$"));
        grid on;

        nexttile(3);
        plot(time, data(:, 6));
        title(latexify("Měřená poloha"));
        xlabel(latexify("Čas $[s]$"));
        ylabel("Poloha $[^\circ]$")
        grid on;
        hold on;

        nexttile(4);
        setI = data(:, 7);
        actI = data(:, 8);
        cucI = data(:, 9);

        cucI_new = cucI + setI - actI;
        plot(time, cucI_new);
        title(latexify("Vypočtený kompenzační proud"));
        xlabel(latexify("Čas $[s]$"));
        ylabel("Proud $[A]$");
        hold on;
        grid on;
        
        for i = 1 : length(highlighted_values)
            startIndex = highlighted_values(i, 1);
            endIndex = highlighted_values(i, 2);
            nexttile(1);
            plot(time(startIndex : endIndex), data(startIndex : endIndex, 5), 'r.');

            nexttile(2);
            plot(time(startIndex : endIndex), smoothed_diff_data(startIndex : endIndex), 'r.');

            nexttile(3);
            plot(time(startIndex : endIndex), data(startIndex : endIndex, 6), 'r.');
            
            nexttile(4);
            plot(time(startIndex : endIndex), cucI_new(startIndex : endIndex), 'r.');
        end

        linkaxes(layout.Children, "x");
        nexttile(1);
        xlim('tight');
        set(gcf, "Position", [1 49 1000*1.5 1000]);

        legendHandle = legend([legend_entry_1, plot(nan, nan, 'r.')], latexify(["Celý záznam", "Vyfiltrované hodnoty"]));
        legendHandle.Layout.Tile = 'north';
        sgtitle(latexify(title_), "Interpreter", "latex");
    end


setI = data(:, 7);
actI = data(:, 8);
cucI = data(:, 9);

cucI_new = cucI + setI - actI;%(actI - setI + cucI);

selected_candidates = candidates(end - 4 : end - 2, :);
% selected_candidates = candidates;
selected_cucI = nan(1, sum(selected_candidates(:, 2) -selected_candidates(:, 1)));
selected_carc = nan(1, sum(selected_candidates(:, 2) -selected_candidates(:, 1)));
c_i = 1;
for i = 1 : size(selected_candidates, 1)
    count = selected_candidates(i, 2) - selected_candidates(i, 1);
    selected_cucI(c_i : c_i + count) = cucI_new(selected_candidates(i, 1): selected_candidates(i, 2)) * 1000;
    selected_carc(c_i : c_i + count) = data(selected_candidates(i, 1): selected_candidates(i, 2), 6);
    c_i = c_i + count;
end


if ~exist("RealData_OriginalScale.mat", "file")
    return;
end

load RealData_OriginalScale.mat Q_k
% CCT pro zpětné pohyby
q_indexes = [3, 4];
ids_values = [0 1];
ids_index = 1;

for q_i = q_indexes
    figure("Name", "Dosazené hodnoty kompenzačního proudu do CCT - " + ids_index, "Tag", "HighResolutionImage");
    Q = Q_k{q_i};
    [n, m, U, V, P] = globalSurfaceInterpolation(Q, 3, 3);
    points = nurbsSurfaceEval(n, U, m, V, 3, 3, P, [size(P,1), 50]);
    surf(points(:, :, 1), points(:, :, 2), points(:, :, 3));
    hold on;

    min_prop = min(Q(:, :, 2), [], 'All');
    max_prop = max(Q(:, :, 2), [], 'All');

    for prop = linspace(min_prop, max_prop, 8)
        plot3(selected_carc, ones(size(selected_carc)) * prop, smooth(selected_cucI), 'r');
    end

    xlabel("$C_{Arc}$");
    ylabel("$Prop$");
    zlabel("Proud~$[mA]$");
    title(latexify(["Dosazené hodnoty kompenzačního proudu do CCT", sprintf("Zpětný pohyb Ids = %s m", num2str(ids_values(ids_index)))]));
%     rescaleFigureAxis(gcf);
    legend(latexify(["NURBS interpolace CCT", "Dosazené hodnoty"]), "Position",[0.6330 0.8283 0.3292 0.0831]);
    figs{ids_index} = gcf;
    rescaleFigureAxis(gcf);
    ids_index = ids_index + 1;
end

%% aktualizace CCT
newFig = figure("Name", "Dosazené hodnoty kompenzačního proudu do CCT - 1 přiblíženo", "Tag", "HighResolutionImage");
cloneFig(figs{1}, newFig);
title(latexify(["Dosazené hodnoty kompenzačního proudu do CCT (přiblíženo)", "Zpětný pohyb Ids = 0 m"]));
xlim([-20, 25]);
ylim([50, 100]);
rescaleFigureAxis(gcf, true)


Q = Q_k{3};
[n, m, U, V, P] = globalSurfaceInterpolation(Q, 3, 3);
Q = nurbsSurfaceEval(n, U, m, V, 3, 3, P, [size(P,1), 100]);

Prop = ones(size(selected_carc)) * 75;

figure("Name", "Dosazené hodnoty kompenzačního proudu do CCT - 1 Gauss aprox", "Tag", "HighResolutionImage");
Q_approx(:, :) = [selected_carc', Prop', selected_cucI'];
Q_approx = downsample(Q_approx, 20);
Q_new = gaussSurfaceApproximation(Q, Q_approx, ones(size(Prop)) * 1, 0.2, 3);
[n, m, U, V, P] = globalSurfaceInterpolation(Q_new, 3, 3);
points = nurbsSurfaceEval(n, U, m, V, 3, 3, P, [size(P,1), 100]);
surf(points(:, :, 1), points(:, :, 2), points(:, :, 3));
hold on;
plot3(selected_carc, Prop, smooth(selected_cucI), 'r');

xlim([-20, 25]);
ylim([50, 100]);
title(latexify(["Dosazené hodnoty kompenzačního proudu do CCT (přiblíženo)", ...
    "Zpětný pohyb Ids = 0 m", ...
    "Gaussova aproximace $\sigma_x = 0.2, \sigma_y = 3$"]));
legend(latexify(["Výsledný povrch", "Aproximační hodnoty"]), "Position",[0.6259 0.7664 0.3292 0.0831]);
xlabel("$C_{Arc}$");
ylabel("$Prop$");
zlabel("Proud~$[mA]$");

rescaleFigureAxis(gcf, true)
end

