function [remappedValue] = remapValue(x, in_min, in_max, out_min, out_max)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
remappedValue = (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
end

% long map(long x, long in_min, long in_max, long out_min, long out_max) {
%   return 
% }