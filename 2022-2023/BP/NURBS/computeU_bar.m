function [U_bar] = computeU_bar(Q, method)
%COMPUTEU_BAR Vypočítá U_bar na základě bodů a zvolené metody výpočtu
%   Q      = body
%   method = metoda výpočtu uzlového vektoru 
%            možné hodnoty:
%               EquallySpaced/ChordLength/CentripetalMethod (recommended)

n = size(Q, 1) - 1;
switch method
    case "EquallySpaced"
        U_bar = linspace(0, 1, n + 1);
    case "ChordLength"
        d = 0;
        for k = 2 : n + 1
            d = d + norm(Q(k, :) - Q(k - 1, :));
        end
        
        U_bar = zeros(1, n + 1);
        
        for k = 2 : n
            U_bar(k) = U_bar(k - 1) + (norm(Q(k, :) - Q(k - 1, :))) / d;
        end
        U_bar(end) = 1;
    case "CentripetalMethod"
        d = 0;
        for k = 2 : n + 1
            d = d + sqrt(norm(Q(k, :) - Q(k - 1, :)));
        end 

        U_bar = zeros(1, n + 1);
        U_bar(end) = 1;
        
        for k = 2 : n
            U_bar(k) = U_bar(k - 1) + (sqrt(norm(Q(k, :) - Q(k - 1, :)))) / d;
        end
    otherwise
        error("Unknown method - " + method);
end
end

