function curveInterpolationDemo4D_basic()
%CURVEINTERPOLATIONDEMO4D_BASIC Summary of this function goes here
%   Detailed explanation goes here
x = linspace(0, 2 * pi, 25)';
w = [0, 100, 200];
Q{1} = [x, sin(x), ones(size(x)) * 10, ones(size(x)) * w(1)];
Q{2} = [x, -sin(x), ones(size(x)) * 0, ones(size(x)) * w(2)];
Q{3} = [x, sin(x), ones(size(x)) * 20, ones(size(x)) * w(3)];
output_data = interpolateBetweenCurves(Q, 200);


figure;
points = Q{1};
plot3(points(:,1), points(:, 2), points(:, 3));
hold on;
points = Q{2};
plot3(points(:,1), points(:, 2), points(:, 3));
points = Q{3};
plot3(points(:,1), points(:, 2), points(:, 3));

for i = 1: length(output_data)
    output = output_data{i};
    n = output{1};
    p = output{2};
    U = output{3};
    P = output{4};
    u = output{5};
    
    points = nurbsCurveEval(n, p, U, P);
    
    plot3(points(:,1), points(:, 2), points(:, 3));
    pause(0.05);
end

end

