function [] = str2file(str, path, escape_backslash)
if (~exist("escape_backslash", "var"))
    escape_backslash = false;
end

[fid, msg] = fopen(path, 'wt');
msg
if (escape_backslash)
    str = strrep(str, '\','\\');
end
str = strrep(str,'%','%%');
fprintf(fid, str);
fclose(fid);
end

