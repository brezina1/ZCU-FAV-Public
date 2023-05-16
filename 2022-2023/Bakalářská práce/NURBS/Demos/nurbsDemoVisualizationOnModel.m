function nurbsDemoVisualizationOnModel(torque_target, g, l, m, k, b, g_new, l_new, m_new, k_new, b_new)
%NURBSVISUALIZATIONONMODEL Fukce k vykreslení ukázky NURBS interpolace a aproximace na modelu
%   g = Gravitační zrychlení
%   l = Délka ramene
%   m = Hmotnost ramene
%   k = Tuhost pružiny
%   b = Koeficient tlumení
%-------------------------------
%   g_new = Gravitační zrychlení
%   l_new = Délka ramene
%   m_new = Hmotnost ramene
%   k_new = Tuhost pružiny
%   b_new = Koeficient tlumení


range = [-pi , pi];
samples = 20;

varphi_target = linspace(range(1), range(2), samples);

figure("Name", "Ukázka cílené aproximace na 1DoF modelu");
plot(varphi_target, torque_target(g, l, m, k, b, varphi_target,0,0), '.', MarkerSize=25);
xlim([range(1), range(2)]);
xlabel("$\varphi$", "Interpreter", "latex");
ylabel("$T(\varphi)$", "Interpreter", "latex");

hold on;

Q = [varphi_target' torque_target(g, l, m, k, b, varphi_target,0,0)'];
d = 3;

[n, U, P] = globalCurveInterpolation(Q, d, "EquallySpaced");
p = nurbsCurveEval(n, d, U, P);

plot(p(:, 1), p(:, 2));

%% upravenej model
% body mezi bodama
test_phis = ((Q(3 : 9, 1) + Q(4 : 10, 1)) / 2);

% test_phis = [((Q(7, 1) + Q(8, 1)) / 3); ((Q(6, 1) + Q(7, 1)) / 3)];
Q_added = [test_phis, torque_target(g_new, l_new, m_new, k_new, b_new, test_phis,0,0)];
Q_new = [Q; Q_added];
Q_new = sortPoints(Q_new);


Q_added_indexes = find(ismember(Q_new, Q_added, 'rows'));

plot(test_phis, torque_target(g_new, l_new, m_new, k_new, b_new, test_phis,0,0), '.', MarkerSize=25);
% plot(Q_new(:, 1), Q_new(:, 2), 'o');

Q_1 = Q_new(min(Q_added_indexes) - 2 : max(Q_added_indexes) + 1, :);
% w = ones(1, length(Q_1) - 2);
w = ones(1, length(Q_new));
w(Q_added_indexes) = 0.4;
w = w(min(Q_added_indexes) - 1 : max(Q_added_indexes));
[n, U, P] = rangeCurveApproximation(Q_new, d, [min(Q_added_indexes) - 2, max(Q_added_indexes) + 1], length(Q_1) - length(Q_added) - 2, w);
p = nurbsCurveEval(n, d, U, P);
plot(p(:, 1), p(:, 2), '--');


w = ones(1, length(Q_new));
w(Q_added_indexes) = 2;
w = w(min(Q_added_indexes) - 1 : max(Q_added_indexes));
[n, U, P] = rangeCurveApproximation(Q_new, d, [min(Q_added_indexes) - 2, max(Q_added_indexes) + 1], length(Q_1) - length(Q_added) - 2, w);
p = nurbsCurveEval(n, d, U, P);
plot(p(:, 1), p(:, 2), '--');


grid on;
legend(latexify(["Původní model, $\omega = 1$", ...
        "NURBS Int. - Ekvidistantní", ...
        "Model s upravenými parametry", ...
        "NURBS cílená aprox. - $\omega_{new} = 0.4$",...
        "NURBS cílená aprox. - $\omega_{new} = 2$"]), ...
        Location="southeast");

title(latexify(["Interpolace funkce $T(\varphi)$ a její cílená aproximace", ...
        "po změně fyzikálních parametrů modelu pro různé váhy bodů", ...
        sprintf("$g=%.2f, l=%.2f, m=%.2f, k=%.2f, b=%.2f$", g, l, m, k, b), ...
        sprintf("$g_{new}=%.2f, l_{new}=%.2f, m_{new}=%.2f, k_{new}=%.2f, b_{new}=%.2f$", g_new, l_new, m_new, k_new, b_new)]), "Interpreter", "latex");
end

