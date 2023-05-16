function [result] = gaussianFunction3D(X, Y, w, x_0, y_0, w_0, sigma_x, sigma_y, sigma_w)
%GAUSSIANFUNCTION Summary of this function goes here
%   Detailed explanation goes here
result = exp(-((X - x_0).^2/(2*sigma_x^2) + (Y - y_0).^2/(2*sigma_y^2) + (w - w_0).^2/(2*sigma_w^2)));
end

