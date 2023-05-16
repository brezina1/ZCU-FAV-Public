function [n, m, U, V, P] = globalSurfaceInterpolation(Q, p, q)
%GLOBALSURFACEINTERPOLATION Summary of this function goes here
%   Detailed explanation goes here
[u_k, v_l] = surfaceMeshParameters(Q);

[n, m, ~] = size(Q);
n = n - 1;
m = m - 1;

U = zeros(1, 2*(p + 1) + n - p);
for j = 1 : n - p
    U(j + p + 1) = 1/p * sum(u_k(j + 1 : j + p));
end
U(n + 2 : end) = ones(1, p + 1);


V = zeros(1, 2*(q + 1) + m - q);
for j = 1 : m - q
    V(j + q + 1) = 1/q * sum(v_l(j + 1 : j + q));
end
V(m + 2 : end) = ones(1, q + 1);

R = nan(size(Q));
for l = 0 : m
    Q_ = squeeze(Q(1 : n + 1, l + 1, :));
    [~, ~, R_] = globalCurveInterpolation(Q_, p, "EquallySpaced");
    R(1 : n + 1, l + 1, :) = R_;
end

% figure;
% plot3(R(:,:,1), R(:,:,2), R(:,:,3));


P = nan(size(Q));
for l = 0 : n
    Q_ = squeeze(R(l + 1, 1 : m + 1, :));
    [~, ~, P_] = globalCurveInterpolation(Q_, q, "EquallySpaced");
    P(l + 1, 1 : m + 1, :) = P_;
end
% figure;
% plot3(P(:,:,1), P(:,:,2), P(:,:,3));
end

