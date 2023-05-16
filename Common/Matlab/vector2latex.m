function [tex_string] = vector2latex(vec, varargin)
vec
varargin
nargin
switch(nargin - 1)
    case 0
        appendLabels = false;
        symbol = "";
        labelSymbol = "";
    case 1
        symbol = varargin{1};
        appendLabels = false;
        labelSymbol = "";
    case 2
        symbol = varargin{1};
        labelSymbol = varargin{2};
        appendLabels = true;
    otherwise
        error("Unknown arguments");
end

% vec = sort(vec, 'ComparisonMethod', "real");
tex_string = "";
for i = 1:length(vec)
if strlength(symbol) == 0
    tex_string =  tex_string + num2str(vec(i));
else
    tex_string =  tex_string + symbol +"_" + i + "=" + num2str(vec(i));
end

if (appendLabels == true)
    tex_string = tex_string + "\label{" + labelSymbol + "_" + i + "}";
end
if (i < length(vec))
    tex_string = tex_string + "\\";
end
end