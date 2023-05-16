function [output_str] = latexify(input_str)
if (isstring(input_str))
    output_str = input_str;
    
    output_str = replace(output_str, "%", "\%");
    
    output_str = replace(output_str, "ě", "\v{e}");
    output_str = replace(output_str, "š", "\v{s}");
    output_str = replace(output_str, "č", "\v{c}");
    output_str = replace(output_str, "ř", "\v{r}");
    output_str = replace(output_str, "ž", "\v{z}");
    output_str = replace(output_str, "ť", "\v{t}");

    output_str = replace(output_str, "á", "\'{a}");
    output_str = replace(output_str, "ý", "\'{y}");
    output_str = replace(output_str, "í", "\'{i}");
    output_str = replace(output_str, "ó", "\'{o}");
    output_str = replace(output_str, "é", "\'{e}");
    output_str = replace(output_str, "ú", "\'{u}");

    output_str = replace(output_str, "ů", "\r{u}");
    
    
    output_str = replace(output_str, "Ě", "\v{E}");
    output_str = replace(output_str, "Š", "\v{S}");
    output_str = replace(output_str, "Č", "\v{C}");
    output_str = replace(output_str, "Ř", "\v{R}");
    output_str = replace(output_str, "Ž", "\v{Z}");
    output_str = replace(output_str, "Ť", "\v{T}");

    output_str = replace(output_str, "Á", "\'{A}");
    output_str = replace(output_str, "Ý", "\'{Y}");
    output_str = replace(output_str, "Í", "\'{I}");
    output_str = replace(output_str, "Ó", "\'{O}");
    output_str = replace(output_str, "É", "\'{E}");
    output_str = replace(output_str, "Ú", "\'{U}");

    output_str = replace(output_str, "Ů", "\r{U}");
end
% ěščřžýáíé ťůú

end

