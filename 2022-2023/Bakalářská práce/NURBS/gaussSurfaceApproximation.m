function [Q] = gaussSurfaceApproximation(Q, Q_approx, weights, sigma_x, sigma_y)
%GAUSSSURFACEAPPROXIMATION Aproximace povrchu existujících bodů pomocí
%gaussovi funkce, váhy existujícíh bodů = 1
%   Q        = body popisující povrch
%   Q_approx = aproximační body
%   weights  = váhy aproximačních bodů
%   sigma_x  = rozptyl aproximace ve směru osy x
%   sigma_y  = rozptyl aproximace ve směru osy y


for i = 1 : size(Q_approx, 1)
    point = Q_approx(i, :);
    point_weight = weights(i);

    for j = 1 : size(Q, 1)
        for k = 1 : size(Q, 2)
            x = Q(j, k, 1);
            y = Q(j, k, 2);
            z = Q(j, k, 3);

            scoped_weight = gaussianFunction2D(x, y, point(1), point(2), sigma_x, sigma_y) * point_weight;

            % weighted mean
            z_new = (z + point(3) * scoped_weight) / (1 + scoped_weight);
            Q(j, k, 3) = z_new;
        end
    end
end
        
end

