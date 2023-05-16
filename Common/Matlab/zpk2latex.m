function [tex_string] = zpk2latex(ZPK)
% todo - neumí to nuly a póly v nule
var = str2sym(ZPK.Variable);
% is_discrete = ZPK.Ts ~= 0;
[num, den] = numden(var);
isNegativeExp = isequal(symvar(den),symvar(var));

% seřadit vzestupně
p = sort(cell2mat(ZPK.P));
p_real = p(imag(p) == 0);
p_imag = p(imag(p) ~= 0);
p = [p_real; p_imag];

z = sort(cell2mat(ZPK.Z));
z_real = z(imag(z) == 0);
z_imag = z(imag(z) ~= 0);
z = [z_real; z_imag];


num_str = format_row(z);
den_str = format_row(p);
% num_str
% den_str

if (ZPK.K ~= 1)
    tex_string = sprintf("\\frac{%s\\cdot%s}{%s}", num2str(ZPK.K, 5) , num_str, den_str);
else
    tex_string = sprintf("\\frac{%s}{%s}" , num_str, den_str);
end

if (ZPK.IODelay > 0)
    delay = num2str(ZPK.IODelay, 4);
    tex_string = sprintf("e^{-%s%s} \\cdot", delay, ZPK.Variable) + tex_string;
end

tex_string = regexprep(tex_string, 'e\+0*(\d+)', '\\cdot 10^{$1}');
tex_string = replace(tex_string, "--", "+");
tex_string = replace(tex_string, "+-", "-");


    function str = format_row(items)
        str = "";
        skip_next = false;
        is_first = true;
        for i = 1:length(items)
            if (skip_next)
                skip_next = false;
                continue;
            end
            
            % pole or zero
            pz = items(i);
            if (~is_first)
                cdot = "\cdot ";
            else
                cdot = "";
            end
            if (isreal(pz))
                if (isNegativeExp)
                    if (pz == 0)
                        str = str + sprintf("%s%s", cdot, tfVar2latex(var));
                    else
                        str = str + sprintf("%s(1+%s)", cdot, tfVar2latex(var * -pz));
                    end
                else
                    if (pz == 0)
                        str = str + sprintf("%s%s", cdot, tfVar2latex(var));
                    else
                        str = str + sprintf("%s(%s+%s)", cdot, tfVar2latex(var), num2str(-pz,4));
                    end
                    
                end
            else
                if (isNegativeExp)
                    b = tfVar2latex(2*real(-pz)*var);
                    c = tfVar2latex(-pz * items(i+1) * var ^ 2);
                    
                    str = str + sprintf("%s(1+%s+%s)", cdot, b, c);
                else
                    a = tfVar2latex(var^2);
                    b = tfVar2latex(2*real(-pz)*var);
                    c = num2str(pz * items(i+1), 4);
                    str = str + sprintf("%s(%s+%s+%s)", cdot, a, b, c);
                end
                
                % tohle není v matlabu podporovaný, fuck you matlabe :-)
                % i = i + 1;
                % krása :-))
                skip_next = true;
            end
            is_first = false;
        end
    end
end

