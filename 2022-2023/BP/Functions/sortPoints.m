function [Q] = sortPoints(Q)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[~, I] = sort(Q(:, 1));
Q = Q(I, :);
end

