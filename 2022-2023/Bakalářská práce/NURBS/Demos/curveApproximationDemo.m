function curveApproximationDemo()
%CURVEAPPROXIMATIONDEMO Summary of this function goes here
%   Detailed explanation goes here
% 2D 
% Q = [10,0;22,104;318,258;379,195;441,130;688,194;750,64];

control_points = [10, 14, 17, 18, 10];
samples = [20, 20, 20, 20, 200];
for i = 1 : length(samples) 
    % reset rng to generate same sequence every time
    rng('default')
    
    x = linspace(-pi, pi, samples(i));
    y = sin(x) + rand(1, length(x)) * 0.25;
    Q = [x',y'];
    figure("Name","Demo aproximace křivky " + i);
    plot(Q(:, 1), Q(:, 2), 'o');
    hold on;
    
    p = 3;
    n = control_points(i);
    
    [U, P] = leastSquaresCurveApproximation(Q, n, p, ones(1, length(Q) - 2));
    points = nurbsCurveEval(n, p, U, P);
    plot(points(:, 1), points(:, 2));

    title(["$f(x) = \sin(x) + 0.25\cdot rand()$", ...
            "$\bf x =\rm linspace(-\pi, \pi, " + samples(i) + ")$", ...
            "$p = " + p + ", m = " + (samples(i)-1) + ", n = " + control_points(i) + ", r = " + (control_points(i)/(samples(i))) + "$"]);
    legend(latexify(["Aproximační body $\omega = 1$", "NURBS Aproximace"]), "Location", "southeast");
    xlabel("$x$")
    ylabel("$y$")
    grid on;
end


x_1 = 1 : 11;
x_2 = 1.5 : 10.5;

y_1 = ones(1, length(x_1)) * 2;
y_2 = ones(1, length(x_2));

Q = [[x_1'; x_2'], [y_1'; y_2']];
Q = sortPoints(Q);
% první a poslední bod jsou interpolovaný
Q_approx = Q(2 : end - 1, :);


W{1} = ones(1, length(Q_approx));

W_ = ones(1, length(Q_approx));
W_(end - 1: -2 : end - 5) = 5;
W_(2 : 2 : 6) = 5;
W_([floor(end/2), floor(end/2) + 2]) = 5;
W{2} = W_;

W_ = ones(1, length(Q_approx));
W_(end: -1 : end - 5) = 5;
W_(1 : 2 : 5) = 5;
W_(floor(end/2) - 1) = 100;
W{3} = W_;


for i = 1 : length(W)
    figure("Name", "Ukázka aproximace pro různé váhy bodů " + i);
    plot(Q([1,end], 1), Q([1, end], 2), 'x', "MarkerSize", 10);
    hold on;
    legendEntries = ["${\bf Q}_0, {\bf Q}_m$"];

    Q_w = Q_approx(W{i} == 1, :);
    plot(Q_w(:, 1), Q_w(:, 2), '.', 'Color', [0 0.4470 0.7410], "MarkerSize", 15);
    if (~isempty(Q_w))
        legendEntries = [legendEntries, "${\bf Q}_k; \omega_k = 1$"];
    end

    Q_w = Q_approx(W{i} == 5, :);
    plot(Q_w(:, 1), Q_w(:, 2), '.', 'Color', [0.8500 0.3250 0.0980], "MarkerSize", 15);
    if (~isempty(Q_w))
        legendEntries = [legendEntries, "${\bf Q}_k; \omega_k = 5$"];
    end

    Q_w = Q_approx(W{i} == 100, :);
        plot(Q_w(:, 1), Q_w(:, 2), '.', 'Color', [0.4660 0.6740 0.1880], "MarkerSize", 15);
    if (~isempty(Q_w))
        legendEntries = [legendEntries, "${\bf Q}_k; \omega_k = 100$"];
    end

    ylim([0, 3]);
    xlim([0, 12]);
    
    [U, P] = leastSquaresCurveApproximation(Q, 8, p, W{i});
    points = nurbsCurveEval(8, p, U, P);
    plot(points(:, 1), points(:, 2), 'Color', [0.4940 0.1840 0.5560]);
    
    legendEntries = [legendEntries, "NURBS aproximace"];
    legend(legendEntries);
    title(latexify(["Ukázka aproximace pro různé váhy bodů", "$n = 8, p = " + p + "$"]));
    xlabel("$x$");
    ylabel("$y$");
    grid on;
end

end

