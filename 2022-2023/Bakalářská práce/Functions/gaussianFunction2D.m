function [result] = gaussianFunction2D(X, Y, x_0, y_0, sigma_x, sigma_y)
%GAUSSIANFUNCTION Summary of this function goes here
%   Detailed explanation goes here
result = exp(-((X - x_0).^2/(2*sigma_x^2) + (Y - y_0).^2/(2*sigma_y^2)));
end

