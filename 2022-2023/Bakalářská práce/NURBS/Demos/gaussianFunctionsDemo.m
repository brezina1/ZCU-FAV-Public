function [] = gaussianFunctionsDemo(animate)
%GAUSSFUNCTIONSDEMO Summary of this function goes here
%   Detailed explanation goes here
[X, Y] = meshgrid(-10 : 0.35 : 10);
x_0 = 0;
y_0 = 0;
sigma_x = 3.5;
sigma_y = 3.5;
Z = gaussianFunction2D(X, Y, x_0, y_0, sigma_x, sigma_y);

figure("Name", "Ukázka Gaussovo funkce 3D", "Tag", "HighResolutionImage");
surf(X,Y,Z);
colorbar();
xlabel("$x$");
ylabel("$y$");
zlabel("$z$");
title(latexify(["Ukázka Gaussovo funkce $f(x,y)$", sprintf("$x_0 =%s, y_0 = %s, \\sigma_x = %s, \\sigma_y = %s$", ...
                                        num2str(x_0), ...
                                        num2str(y_0), ...
                                        num2str(sigma_x), ...
                                        num2str(sigma_y))]));
% return;
w_0 = 0;
sigma_w = 4;
figure("Name", "Ukázka Gaussovo funkce 4D");
filename = sprintf("./Dokumentace/Generated/Ukázka Gaussovo funkce 4D.gif");
targetDir = replace(filename, ".gif", "/");
if (animate)
    delete(filename);
    cmd_rmdir(targetDir);
end

for w = 10 : -0.5 : -10
    Z = gaussianFunction3D(X, Y, w, x_0, y_0, w_0, sigma_x, sigma_y, sigma_w);
    
    surf(X,Y,Z);
    zlim([0, 1]);
    colorbar();
    title(latexify(["Ukázka Gaussovo funkce $f(x,y,w)$", sprintf("$x_0 =%s, y_0 = %s, w_0 = %s$", ...
                                            num2str(x_0), ...
                                            num2str(y_0), ...
                                            num2str(w_0)), ...
                                        sprintf("$\\sigma_x = %s, \\sigma_y = %s, \\sigma_w = %s$",...
                                            num2str(sigma_x), ...
                                            num2str(sigma_y), ...
                                            num2str(sigma_w)), ...
                                        sprintf("$w = %.2f$", w)]));
    xlabel("$x$");
    ylabel("$y$");
    zlabel("$z$");
    drawnow;
%     pause(0.1);
    if (~animate)
        break
    end
        exportgraphics(gcf, filename, 'Append', true, "Resolution", 250);
end

if (animate)
        mkdir(targetDir);
        system("magick " + '"' + filename + '"' + " " + '"' + targetDir + "/frame.png" + '"')  
end
end

