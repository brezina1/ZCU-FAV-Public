function [tex_string] = mat2latex(mat, number_format)
tex_string = "\begin{bmatrix}";
[rows, cols] = size(mat);

if (exist("number_format", "var"))
    num2latex_ = @(x)num2latex(x, number_format);
else
    num2latex_ = @(x)num2latex(x);
end

for row = 1 : rows
    for col = 1 : cols
        value = mat(row, col);
        if (isnumeric(value))
            texValue = num2latex_(value);
        else
            texValue = latex(value);
        end
        if (col == 1)
            tex_string = tex_string + texValue;
        else
            tex_string = tex_string + "&" + texValue;
        end
    end
    tex_string = tex_string + "\\";
end

tex_string = tex_string  + "\end{bmatrix}";
end