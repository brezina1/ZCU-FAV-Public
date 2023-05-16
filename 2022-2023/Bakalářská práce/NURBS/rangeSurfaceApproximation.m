function [n, U, P] = rangeSurfaceApproximation(Q, p, q, range_approx, n_approx, m_approx, W_approx, plot_data)
%REGIONCURVEAPPROXIMATION Aproximuje rozsah bodů, poté vyvoří interpolaci
% přes aproximované body a zbytek bodů Q
%   Q = všechny body
%   p = stupeň bázových funkcí ve směru u
%   q = stupeň bázových funkcí ve směru v
%   range_approx = rohové body obdelníku bodů pro aproximaci 
%                   např. rohy (1,1) a (4,4): [1,1,4,4;...]
%                  - rohové body rozsahu jsou zafixované
%   n_approx = počet řídících bodů pro aproximaci ve směru u - např: [4;...]
%   m_approx = počet řídících bodů pro aproximaci ve směru v - např: [3;...]
%   W_approx = váhy bodů pro aproximaci (cell array)
%   plot_data = true => plotne aproximační body a aproximační funkci
if ~exist('plot_data', 'var')
    plot_data = false;
end


for i = 1 : size(range_approx, 1)
    range = range_approx(i, :);
    Q_approx = Q(range(1) : range(3), range(2) : range(4), :);

    [U_approx, V_approx, P_approx] = leastSquaresSurfaceApproximation(Q_approx, p, q, n_approx(i), m_approx(i), W_approx{i});
end

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

