function [n, U, P] = rangeCurveApproximation(Q, p, range_approx, n_approx, W_approx, plot_data)
%REGIONCURVEAPPROXIMATION Aproximuje rozsah bodů, poté vyvoří interpolaci
% přes aproximované body a zbytek bodů Q
%   Q = všechny body
%   p = stupeň bázových funkcí
%   range_approx = interval bodů pro aproximace např.: [4, 9]
%                  - okrajové body rozsahu jsou zafixované
%   n_approx = počet řídících bodů pro aproximaci
%   W_approx = váhy bodů pro aproximaci
%   plot_data = true => plotne aproximační body a aproximační funkci
if ~exist('plot_data', 'var')
    plot_data = false;
end


Q_approx = Q(range_approx(1) : range_approx(2), :);
[U_approx, P_approx] = leastSquaresCurveApproximation(Q_approx, n_approx, p, W_approx);

if plot_data
    points = nurbsCurveEval(n_approx, p, U_approx, P_approx);
%     plot(Q_approx(:, 1), Q_approx(:, 2), 'o');
    hold on
    plot(points(:, 1), points(:, 2));
    points = nurbsCurveEval(n_approx, p, U_approx, P_approx, length(Q_approx));
    plot(points(:, 1), points(:, 2), '.', "MarkerSize", 15);
else
    points = nurbsCurveEval(n_approx, p, U_approx, P_approx, length(Q_approx));
end

Q_int = [Q(1 : range_approx(1) - 1, :); points; Q(range_approx(2) + 1 : end, :)];

[n, U, P] = globalCurveInterpolation(Q_int, p, "EquallySpaced");
end

