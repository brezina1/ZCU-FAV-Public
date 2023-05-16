function [Q_k] = nurbsDemoVisualizationOnRealData()
%NURBSDEMOVISUALIZATIONONREALDATA Summary of this function goes here
%   Detailed explanation goes here

files = ["Forward Z=0.txt", "Forward Z=1.txt", "Reverse Z=0.txt", "Reverse Z=1.txt"];
 
titles = {["Kompenzační proud pro osu $C_{Arc}$","Dopředný pohyb, $Ids = 0$"],...
            ["Kompenzační proud pro osu $C_{Arc}$","Dopředný pohyb, $Ids = 1$"],...
            ["Kompenzační proud pro osu $C_{Arc}$","Zpětný pohyb, $Ids = 0$"],...
            ["Kompenzační proud pro osu $C_{Arc}$","Zpětný pohyb, $Ids = 1$"]};

for index = 1 : length(files)
    data = readmatrix(files(index));

    x_ = data(:, 1)/100;
    y_ = [-18000, -12000, -9000, -6000, 0, 6000, 9000, 12000]/100;
    y = nan(length(x_), length(y_));
    for i = 1 : length(x_)
        y(i, :)  = y_;
    end
    
    x = nan(length(x_), length(y_));
    for i = 1 : length(y_)
        x(:, i)  = x_;
    end
    
    z = data(:, 2 : end);
    
    x = rescale(x);
    y = rescale(y);
    z = rescale(z);

    figure("Name", "Plot kompenzace proudu - reálná data " + index, "Tag", "HighResolutionImage");
    surf(x, y, z);
    title(latexify(titles{index}));
    xlabel("$C_{Arc}$", Interpreter="latex");
    ylabel("$Prop$", Interpreter="latex");
    zlabel("Proud", Interpreter="latex");
    colorbar();

    Q = nan(length(x_), length(y_), 3);

    Q(:,:,1) = x;
    Q(:,:,2) = y;
    Q(:,:,3) = z;
%     Q(:,:,4) = [ones(length(x), 8) *10; ones(length(x), 8) *20];


    figure("Name", "Plot kompenzace proudu - reálná data - interpolace" + index, "Tag", "HighResolutionImage");
    [n, m, U, V, P] = globalSurfaceInterpolation(Q, 3, 3);
    points = nurbsSurfaceEval(n, U, m, V, 3, 3, P, [length(x), 50]);
    surf(points(:, :, 1), points(:, :, 2), points(:, :, 3));
%     shading interp
    title(latexify([titles{index}, "NURBS interpolace, $p, q = 3$"]));
    xlabel("$C_{Arc}$");
    ylabel("$Prop$");
    zlabel("Proud");
    colorbar();

    Q_k{index} = Q; 
end

%% řez na y = -9000
% Forward Z=8950
data = Q_k{1};
oldFigure = figure("Name", "Ukázka cílené aproximace na reálných datech");

% řez na y = -9000 (y_i = 3)
x_orig = data(:, 3, 1);
z_orig = data(:, 3, 3);

plot(x_orig, z_orig, '.', 'MarkerSize', 15);
hold on;
    
Q_orig = [x_orig, z_orig];

d = 3;
[n, U, P] = globalCurveInterpolation(Q_orig, d, "EquallySpaced");
p = nurbsCurveEval(n, d, U, P);

plot(p(:, 1), p(:, 2));

% Forward Z=11700
data_2 = Q_k{2};

% výběr pár hodnot 
% řez na y = -9000 (y_i = 3)
x_new = data_2(floor(end/2) + 3 : floor(end/2) + 13, 3, 1);
z_new = data_2(floor(end/2) + 3: floor(end/2) + 13, 3, 3);

plot(x_new, z_new, '.', 'MarkerSize', 15);
hold on;

Q_added = [x_new, z_new];
Q_new = [Q_orig; Q_added];

Q_new = sortPoints(Q_new);
w = ones(1, length(Q_new) - 2);

Q_added_indexes = find(ismember(Q_new, Q_added, 'rows'));

Q_approx = Q_new(min(Q_added_indexes) - 2 : max(Q_added_indexes) + 2, :);
% w(Q_added_indexes) = 5;
w = w(min(Q_added_indexes) - 1 : max(Q_added_indexes) + 1);
% 

[n, U, P] = rangeCurveApproximation(Q_new, d, [min(Q_added_indexes) - 2, max(Q_added_indexes) + 2], length(Q_approx) - length(Q_added) - 1, w, true);

% n = length(Q_new) - 2;
% [U, P] = leastSquaresCurveApproximation(Q_new, n, d, w);
% p = nurbsCurveEval(length(Q_orig) - 2, d, U, P);
p = nurbsCurveEval(n, d, U, P);
plot(p(:, 1), p(:, 2), '--');
grid on;
legend(latexify(["Interpolační body", ...
        "NURBS interp. - Ekvidistantní", ...
        "Nové body",...
        "Cílená aproximace",...
        "Body z aproximace", ...
        "Výsledná aproximace"...
    ]), ...
    Location="northwest");
xlabel("$C_{Arc}$")
ylabel("Proud")
title(latexify("Ukázka cílené aproximace na reálných datech"));

newFig = figure("Name", "Ukázka cílené aproximace na reálných datech přiblíženo");
cloneFig(oldFigure, newFig);
title(latexify("Ukázka cílené aproximace na reálných datech (přiblíženo)"));
xlim([0.49, 0.62]);
ylim([0.46, 0.6])
legend(latexify(["Interpolační body", ...
        "NURBS interp. - Ekvidistantní", ...
        "Nové body",...
        "Cílená aproximace",...
        "Body z aproximace", ...
        "Výsledná aproximace"...
    ]), ...
    Location="southeast");
grid on;
% xlim([-2.5, 30]);
% ylim([110, 230]);
end

