function [tex_string] = tf2latex(TF)
% pak někdy přepsat na kratší kód
[num,den] = tfdata(TF);
variable = str2sym(TF.Variable);
[num_var, den_var] = numden(variable);


% tf je ve formátu z^-1
if (den_var ~= 1)
    num = cell2mat(num);
    den = cell2mat(den);
    num_str = format_negative_exp(num);
    den_str = format_negative_exp(den);
    
    tex_string = sprintf("\\frac{%s}{%s}", num_str, den_str);
    if (TF.IODelay > 0)
        tex_string = sprintf("z^{-%d} \\cdot", TF.IODelay) + tex_string;
    end
    
    return;
end

% přenos je spojitý
num = cell2mat(num);
den = cell2mat(den);
num_str = format_positive_exp(num);
den_str = format_positive_exp(den);

tex_string = sprintf("\\frac{%s}{%s}", num_str, den_str);

if (TF.IODelay > 0)
    delay = num2str(TF.IODelay, 4);
    tex_string = sprintf("e^{-%s%s} \\cdot", delay, TF.Variable) + tex_string;
end
tex_string = regexprep(tex_string, 'e\+0*(\d+)', '\\cdot 10^{$1}');

    function str = format_positive_exp(items)
        str = "";
        is_first = true;
        for i = 1 : length(items)
            if (items(i) == 0)
                continue;
            end
            
            if (items(i) == 1 && i ~= length(items))
                i_str = "";
            else
                i_str = num2str(items(i), 4);
            end
            
            
            % znamínko mínus dodá matlab sám
            if (items(i) > 0 && i > 1 && ~is_first)
                str = str + "+";
            end
            if (length(items) - i > 1)
                str = str + i_str+ TF.Variable +"^{" + (length(items) - i) + "}";
            elseif (length(items) - i == 1)
                str = str + i_str+ TF.Variable;
            else
                str = str + i_str;
            end
            
            is_first = false;
        end
    end

    function str = format_negative_exp(items)
        str = "";
        for i = 1:length(items)
            if (items(i) == 0)
                continue;
            end
            i_str = num2str(items(i), 4);
            if (i > 1)
                % znamínko mínus dodá matlab sám
                if (items(i) > 0 && items(i - 1) ~= 0)
                    str = str + "+";
                end
                str = str + i_str+ "z^{-" + (i-1) + "}";
            else
                str = str + i_str;
            end
        end
    end

end

