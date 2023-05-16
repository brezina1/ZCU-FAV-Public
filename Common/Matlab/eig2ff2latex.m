function [tex_string] = eig2ff2latex(poles)
 syms t;
 tex_string = "";
%  poles = round(poles, 2);
 for i = 1 : length(poles)
     if (isreal(poles(i)))
         y = exp(poles(i)*t);
     else
         y = exp(real(poles(i))*t);
         c = imag(poles(i));
         if (c > 0)
             y = y * cos(c*t);
         else
             y = y * sin(abs(c)*t);
         end
     end
     if (i < length(poles))
        tex_string = tex_string + latex(vpa(y, 5)) + "\label{" + "ff_" + i + "}\\";
     else
         tex_string = tex_string + latex(vpa(y, 5)) + "\label{" + "ff_" + i + "}";
     end
 end
end