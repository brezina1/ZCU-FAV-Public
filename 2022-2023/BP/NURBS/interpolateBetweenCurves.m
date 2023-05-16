function [interpolated_curves_data] = interpolateBetweenCurves(Q_container, steps)
%INTERPOLATEBETWEENCURVES Interpoluje mezi křivkami, které jsou popsaný
%body v Q containeru, každá křivka musí být popsána stejným počtem bodů
%   steps = počet křivek ve výsledné interpolaci

point_dim = size(Q_container{1}(1, :), 2);
interpolation_results = cell(length(Q_container{1}), 1);
for l = 1:length(Q_container{1})
    Q_int_dim = nan(length(Q_container), point_dim);

    for q_i = 1:length(Q_container)
        Q_int_dim(q_i, :) = Q_container{q_i}(l, :);
        hold on;
    end

    p = 2;
    [n, U, P] = globalCurveInterpolation(Q_int_dim, p, "ChordLength");

    interpolation_results{l} = {n, p, U, P};
end


result_index = 1;
result = cell(steps, 1);

for u = linspace(0, 1, steps)
    Q = nan(size(Q_container{1}, 1), point_dim);
    for c_i = 1:size(Q_container{1}, 1)
        interpolation_result = interpolation_results{c_i};
        
        n = interpolation_result{1};

        Q(c_i, :) = nurbsEvalSinglePoint(n, interpolation_result{2}, interpolation_result{3}, interpolation_result{4}, u);
    end

    p = 3;

    [n, U, P] = globalCurveInterpolation(Q, p, "ChordLength");

    result{result_index} = {n, p, U, P, u};
    result_index = result_index + 1;
end

interpolated_curves_data = result;
end

