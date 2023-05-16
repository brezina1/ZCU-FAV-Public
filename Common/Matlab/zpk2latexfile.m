function [] = zpk2latexfile(TF, path)
fid = fopen(path, 'wt');
str = zpk2latex(TF);
str = strrep(str,'\','\\');
str = strrep(str,'%','%%');
fprintf(fid, str);
fclose(fid);
end

