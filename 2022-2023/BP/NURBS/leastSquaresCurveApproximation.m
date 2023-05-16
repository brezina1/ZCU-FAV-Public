function [U, P] = leastSquaresCurveApproximation(Q, n, p, W)
%LEASTSQUARESCURVEAPPROXIMATION Summary of this function goes here
%   Detailed explanation goes here
W = diag(W);
m = length(Q) - 1;
[~, dim_Q] = size(Q);

if (m <= n)
    error("m <= n");
end

% Eq. 9.5
U_bar = computeU_bar(Q, "ChordLength");
% Eq. 9.68
d = (m + 1)/(n - p + 1);
% Eq. 9.69
U = zeros(1, 2*(p + 1) + n - p);

for j = 1 : n - p
    i = floor(j * d);
    alpha = j * d - i;
    U(p + j + 1) = (1 - alpha) * U_bar(i) + alpha * U_bar(i + 1);
end
U(n + 1 + 1 : end) = ones(1, p + 1);

% U_bar = computeU_bar(Q, "EquallySpaced");
% % technique of averaging Eq. 9.8
% U = zeros(1, 2*(p + 1) + n - p);
% 
% for j = 1 : n - p
%     U(j + p + 1) = 1/p * sum(U_bar(j + 1 : j + p));
% end
% U(n + 2 : end) = ones(1, p + 1);


%% Eq. 9.66
N = nan(m - 1, n - 1);
for m_i = 1 : m - 1
    m_temp = nan(1, n - 1);
    for n_i = 1 : n - 1
        m_temp(n_i) = singleBasisFunction(p, U, n_i, U_bar(m_i + 1));
    end
    N(m_i, :) = m_temp;
end


%% Eq. 9.67
R_k = nan(m - 1, dim_Q);
for k = 1 : m - 1
    R_k(k, :) = Q(k + 1, :) - singleBasisFunction(p, U, 0, U_bar(k + 1)) * Q(1, :) ...
                             - singleBasisFunction(p, U, n, U_bar(k + 1)) * Q(m + 1, :);
end

R = nan(n - 1, dim_Q);
for n_i = 1 : n - 1
    R_ = 0;
    for m_i = 1 : m - 1
        R_ = R_ + singleBasisFunction(p, U, n_i, U_bar(m_i + 1))* W(m_i, m_i) * R_k(m_i, :);
    end
    R(n_i, :) = R_;
end

% P = N' * N \ R;
P = (N' * W * N) \ R;

% Eq. 9.61... satisfying that Q(0) = C(0) and Q(m) = C(1)
P = [Q(1, :); P ; Q(end, :)];

