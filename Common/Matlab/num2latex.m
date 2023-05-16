function [tex_string] = num2latex(number, number_format)
if exist("number_format", "var")
    tex_string = num2str(number, number_format);
else
    tex_string = num2str(number);
end
tex_string = regexprep(tex_string, 'e\+0*(\d+)', '\\cdot 10^{$1}');
tex_string = regexprep(tex_string, 'e\-0*(\d+)', '\\cdot 10^{-$1}');
end


