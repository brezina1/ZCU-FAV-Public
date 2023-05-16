function [outputArg1,outputArg2] = curveApproximationDemo4D()
%CURVEAPPROXIMATIONDEMO4D Summary of this function goes here
%   Detailed explanation goes here
x1 = linspace(0, 2 * pi, 200)';
x2 = linspace(0, 2 * pi, 150)';
x3 = linspace(0, 2 * pi, 250)';

rng("default");
w_container{1} = [0, 100, 200];
w = w_container{1};

Q{1} = [x1+0.25*rand(size(x1)), sin(x1) + 0.25*rand(size(x1)), ones(size(x1)) * 10 , ones(size(x1)) * w(1)];
Q{2} = [x2+0.25*rand(size(x2)), -sin(x2) + 0.25*rand(size(x2)), ones(size(x2)) * 0, ones(size(x2)) * w(2)];
Q{3} = [x3+0.25*rand(size(x3)), sin(x3) + 0.25*rand(size(x3)), ones(size(x3)) * 20, ones(size(x3)) * w(3)];



end


