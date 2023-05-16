function [str] = tfVar2latex(var)
% var
% je to jen číslo
% if (~hasSymType(var,'variable'))
%     str = num2str(double(var), 4);
%     return;
% end

[num, den] = numden(var);
% proměnná je ve tvaru např. z^-5
isNegativeExp = isequal(symvar(den),symvar(var));
% isNegativeExp
% symtopoly = sym2poly(var)
if (isNegativeExp)
    coef = double(subs(var, symvar(var), 1));
else
    coef = double(coeffs(var));
end

if (coef == 1)
    coef_str = "";
else
%     coef
    coef_str = num2str(coef, 4);    
end

% pro z^5 vrátí z
var_name = string(symvar(var));

if (isNegativeExp)
    % stupeň polynomu
    order = length(sym2poly(den)) - 1;
    str = sprintf("%s%s^{-%d}", coef_str, var_name, order);
    return;
else
    order = length(sym2poly(var)) - 1;
    if (order == 1)
        str = sprintf("%s%s", coef_str, var_name);
    else
       str = sprintf("%s%s^{%d}", coef_str, var_name, order); 
    end
end

end


