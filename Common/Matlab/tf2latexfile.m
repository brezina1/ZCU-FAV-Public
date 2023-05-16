function [] = tf2latexfile(TF, path)
[fid, msg] = fopen(path, 'wt');
str = tf2latex(TF);
str = strrep(str,'\','\\');
str = strrep(str,'%','%%');
fprintf(fid, str);
fclose(fid);
end

