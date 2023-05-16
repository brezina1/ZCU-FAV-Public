function [U, V, P] = leastSquaresSurfaceApproximation(Q, p, q, n, m, W)
%LEASTSQUARESSURFACEAPPROXIMATION Summary of this function goes here
%   Q_(k,l) = aproximančí body
%   p = stupeň bázových funkcí ve směru k
%   q = stupeň bázových funkcí ve směru l
%   n = počet řídídích bodů ve směru k
%   m = počet řídících bodů ve směru l
%   W = matice obsahující váhy bodů (váhy pro rohové body nehrají roli)
%   U = uzlový vektor ve směru k
%   V = uzlový vektor ve směru l
%   P = řídící body

[r, s, dim_Q] = size(Q);
r = r - 1;
s = s - 1;

if (n >= r)
    error("n >= r");
end
if (m >= s)
    error("m >= s");
end

[u_k, v_l] = surfaceMeshParameters(Q);

%% výpočet U
% Eq. 9.68
d = (r + 1)/(n - p + 1);
% Eq. 9.69
U = zeros(1, 2*(p + 1) + n - p);

for j = 1 : n - p
    i = floor(j * d);
    alpha = j * d - i;
    U(p + j + 1) = (1 - alpha) * u_k(i) + alpha * u_k(i + 1);
end
U(n + 1 + 1 : end) = ones(1, p + 1);

%% výpočet V
% Eq. 9.68
d = (s + 1)/(m - q + 1);
% Eq. 9.69
V = zeros(1, 2*(q + 1) + m - q);

for j = 1 : m - q
    i = floor(j * d);
    alpha = j * d - i;
    V(q + j + 1) = (1 - alpha) * v_l(i) + alpha * v_l(i + 1);
end
V(m + 1 + 1 : end) = ones(1, q + 1);

%% výpočet N_u
% Eq. 9.66
N_u = nan(r - 1, n - 1);
for r_i = 1 : r - 1
    r_temp = nan(1, n - 1);
    for n_i = 1 : n - 1
        r_temp(n_i) = singleBasisFunction(p, U, n_i, u_k(r_i + 1));
    end
    N_u(r_i, :) = r_temp;
end

%% výpočet Temp
temp = nan(n + 1, s + 1, dim_Q);
for s_i = 0 : s
    % váhy pro aktuální křivku
    W_ = diag(W(2 : end - 1, s_i + 1));
    max(max(W_))
    R_k = nan(r - 1, dim_Q);
    for r_i = 1 : r - 1
        R_k(r_i, :) = Q(r_i + 1, s_i + 1, :) - singleBasisFunction(p, U, 0, u_k(r_i + 1)) * Q(1, s_i + 1, :) ...
                                 - singleBasisFunction(p, U, n, u_k(r_i + 1)) * Q(r + 1, s_i + 1, :);
    end

    R_u = nan(n - 1, dim_Q);
    for n_i = 1 : n - 1
        R_ = 0;
        for r_i = 1 : r - 1
%             R_ = R_ + singleBasisFunction(p, U, n_i, u_k(r_i + 1)) * R_k(r_i, :);
            R_ = R_ + singleBasisFunction(p, U, n_i, u_k(r_i + 1)) * W_(r_i, r_i) * R_k(r_i, :);
        end
        R_u(n_i, :) = R_;
    end
    
    temp(1, s_i + 1, :) = Q(1, s_i + 1, :);
    temp(n + 1, s_i + 1, :) = Q(r + 1, s_i + 1, :);

    % výpočet řídích bodů po směru u
    temp(2 : n, s_i + 1, :) = (N_u' * W_ * N_u) \ R_u;
%     temp(2 : n, s_i + 1, :) = (N_u'  * N_u) \ R_u;
end

% figure;
% plot3(temp(:,:,1), temp(:,:,2), temp(:,:,3));

%% výpočet N_v
% Eq. 9.66
N_v = nan(s - 1, m - 1);
for s_i = 1 : s - 1
    s_temp = nan(1, m - 1);
    for m_i = 1 : m - 1
        s_temp(m_i) = singleBasisFunction(q, V, m_i, v_l(s_i + 1));
    end
    N_v(s_i, :) = s_temp;
end
% disp("aaaaaaaaa")
%% výpočet P
P = nan(n + 1, m + 1, dim_Q);

W = imresize(W, [n + 1, size(W, 2)]);
W = max(W,1);
for n_i = 0 : n
    % váhy pro aktuální křivku
    W_ = diag(W(n_i + 1, 2 : end - 1));

    R_k = nan(s - 1, dim_Q);
    for s_i = 1 : s - 1
        R_k(s_i, :) = temp(n_i + 1, s_i + 1, :) - singleBasisFunction(q, V, 0, v_l(s_i + 1)) * temp(n_i + 1, 1, :)...
                                 - singleBasisFunction(q, V, m, v_l(s_i + 1)) * temp(n_i + 1, s + 1, :);
    end

    R_v = nan(m - 1, dim_Q);
    for m_i = 1 : m - 1
        R_ = 0;
        for s_i = 1 : s - 1
            R_ = R_ + singleBasisFunction(q, V, m_i, v_l(s_i + 1)) * W_(s_i, s_i) * R_k(s_i, :);
        end
        R_v(m_i, :) = R_;
    end
    
    P(n_i + 1, 1, :) = temp(n_i + 1, 1, :);
    P(n_i + 1, m + 1, :) = temp(n_i + 1, s + 1, :);
    % výpočet řídích bodů ve směru v
    P(n_i + 1, 2 : m, :) = (N_v' * W_ * N_v) \ R_v;
end


% figure
% plot3(P(:,:,1), P(:,:,2), P(:,:,3));
end

