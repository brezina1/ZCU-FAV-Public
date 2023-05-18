function surfaceInterpolationDemo4D(animate)
%CURVEINTERPOLATIONDEMO4D Summary of this function goes here
%   Detailed explanation goes here

minXY = -2*pi;
maxXY =  2*pi;
minZ = nan;
maxZ = nan;
[X, Y] = meshgrid(minXY : 0.35 : maxXY);

Z = cos(X) + Y;
Q_ = nan(length(X), length(X), 4);
Q_(:, :, 1) = X;
Q_(:, :, 2) = Y;
Q_(:, :, 3) = Z;
Q_(:, :, 4) = ones(length(X), length(X)) * 10;
minZ = min(minZ, min(min(Z)));
maxZ = max(maxZ, max(max(Z)));
Q{1} = Q_;

Z = cos(Y) + X;
Q_ = nan(length(X), length(X), 4);
Q_(:, :, 1) = X;
Q_(:, :, 2) = Y;
Q_(:, :, 3) = Z;
Q_(:, :, 4) = ones(length(X), length(X)) * 20;
Q{2} = Q_;
minZ = min(minZ, min(min(Z)));
maxZ = max(maxZ, max(max(Z)));

Z = cos(2*Y) + cos(2*X);
Q_ = nan(length(X), length(X), 4);
Q_(:, :, 1) = X;
Q_(:, :, 2) = Y;
Q_(:, :, 3) = Z;
Q_(:, :, 4) = ones(length(X), length(X)) * 30;
Q{3} = Q_;
minZ = min(minZ, min(min(Z)));
maxZ = max(maxZ, max(max(Z)));


minW = 10;
maxW = 30;
data = interpolateBetweenSurfaces(Q, 3, 3, 2, minW, maxW, 90);

for i = 1 : length(Q)
    figure("Name", "Interpolace 4d povrchu část " + i + " č. 1", "Tag", "MediumResolutionImage");
    surf(Q{i}(:,:,1), Q{i}(:,:,2), Q{i}(:,:,3));
    title(latexify("Interpolační povrch, $w = " + Q{i}(1,1,4) + "$"));
    xlim([minXY, maxXY]);
    ylim([minXY, maxXY]);
    zlim([minZ, maxZ]);
    xlabel("$x$")
    ylabel("$y$")
    zlabel("$z$")
end

figure();
filename = "./Dokumentace/Generated/4D surface demo 1.gif";
targetDir = replace(filename, ".gif", "/");
if (animate)
    delete(filename);
    cmd_rmdir(targetDir);
end
for i = 1 : length(data)
    n = data{i}{1};
    m = data{i}{2};
    p = data{i}{3};
    q = data{i}{4};
    U = data{i}{5};
    V = data{i}{6};
    P = data{i}{7};
    u = data{i}{8};
    w = data{i}{9};

    points = nurbsSurfaceEval(n, U, m, V, p, q, P, [65, 65]);
    surf(points(:, :, 1), points(:, :, 2), points(:, :, 3));
    xlim([minXY, maxXY]);
    ylim([minXY, maxXY]);
    zlim([minZ, maxZ]);
    
    title(latexify(["Interpolace mezi povrchy č. 1", "$p = 3, q = 3, g = 2$", "$w = " + num2str(w, "%.3f") + "$"]));
    xlabel("$x$")
    ylabel("$y$")
    zlabel("$z$")
    colorbar();
    drawnow;

    if (~animate)
        break
    end
    exportgraphics(gcf, filename, 'Append', true, "Resolution", 250);
end
if (animate)
    mkdir(targetDir);
    system("magick " + '"' + filename + '"' + " " + '"' + targetDir + "/frame.png" + '"')  
end
%% Interpolace dopředného pohybu
load RealData.mat Q_k

% dim_4_values = [895, 1170];
dim_4_values = [0, 1];
minZ = nan;
maxZ = nan;

clear Q
Q{1} = Q_k{1};
Q{2} = Q_k{2};
for i = 1 : length(Q)
    Q{i}(:, :, 4) = ones(size(Q{i}, 1), size(Q{i}, 2)) * dim_4_values(i); 
    minZ = min(minZ, min(min(Q{i}(:, :, 3))));
    maxZ = max(maxZ, max(max(Q{i}(:, :, 3))));
end

data = interpolateBetweenSurfaces(Q, 3, 3, 1, min(dim_4_values), max(dim_4_values), 60);

for i = 1 : length(Q)
    figure("Name", "Interpolace 4d povrchu část " + i + " č. 2", "Tag", "MediumResolutionImage");
    [n, m, U, V, P] = globalSurfaceInterpolation(Q{i}, 3, 3);
    points = nurbsSurfaceEval(n, U, m, V, 3, 3, P, [size(P, 1) + 1, 50]);
    surf(points(:,:,1), points(:,:,2), points(:,:,3));
    title(latexify("Interpolační povrch, $Ids = " + Q{i}(1,1,4) + "$"));
%     xlim([minXY, maxXY]);
%     ylim([minXY, maxXY]);
    zlim([minZ, maxZ]);
    xlabel("$C_{Arc}$");
    ylabel("$Prop$");
    zlabel("Proud");
end

figure();
minW = min(dim_4_values);
maxW = max(dim_4_values);
filename = "./Dokumentace/Generated/4D surface demo 2.gif";
targetDir = replace(filename, ".gif", "/");
if (animate)
    delete(filename);
    cmd_rmdir(targetDir);
end
for i = 1 : length(data)
    n = data{i}{1};
    m = data{i}{2};
    p = data{i}{3};
    q = data{i}{4};
    U = data{i}{5};
    V = data{i}{6};
    P = data{i}{7};
    u = data{i}{8};
    w = data{i}{9};
    points = nurbsSurfaceEval(n, U, m, V, p, q, P, [size(P, 1) + 1, 50]);
    surf(points(:, :, 1), points(:, :, 2), points(:, :, 3));
%     xlim([minXY, maxXY]);
%     ylim([minXY, maxXY]);
    zlim([minZ, maxZ]);
    
    title(latexify(["Interpolace mezi kalibračními tabulkami - dopředný pohyb", "$p = 3, q = 3, g = 1$", "$Ids = " + num2str(w, "%.3f") + "$"]));
    xlabel("$C_{Arc}$");
    ylabel("$Prop$");
    zlabel("Proud");
    colorbar();
    drawnow;

    if (~animate)
        break
    end
    exportgraphics(gcf, filename, 'Append', true, "Resolution", 250);
end
if (animate)
    mkdir(targetDir);
    system("magick " + '"' + filename + '"' + " " + '"' + targetDir + "/frame.png" + '"')  
end
%% Interpolace zpětného pohybu
dim_4_values = [1, 0];
minZ = nan;
maxZ = nan;

clear Q
Q{1} = Q_k{3};
Q{2} = Q_k{4};
for i = 1 : length(Q)
    Q{i}(:, :, 4) = ones(size(Q{i}, 1), size(Q{i}, 2)) * dim_4_values(i); 
    minZ = min(minZ, min(min(Q{i}(:, :, 3))));
    maxZ = max(maxZ, max(max(Q{i}(:, :, 3))));
end

data = interpolateBetweenSurfaces(Q, 3, 3, 1, min(dim_4_values), max(dim_4_values), 60);

for i = 1 : length(Q)
    figure("Name", "Interpolace 4d povrchu část " + i + " č. 3", "Tag", "MediumResolutionImage");
    [n, m, U, V, P] = globalSurfaceInterpolation(Q{i}, 3, 3);
    points = nurbsSurfaceEval(n, U, m, V, 3, 3, P, [size(P, 1) + 1, 50]);
    surf(points(:,:,1), points(:,:,2), points(:,:,3));
    title(latexify("Interpolační povrch, $Ids = " + Q{i}(1,1,4) + "$"));
%     xlim([minXY, maxXY]);
%     ylim([minXY, maxXY]);
    zlim([minZ, maxZ]);
    xlabel("$C_{Arc}$");
    ylabel("$Prop$");
    zlabel("Proud");
end

figure();
minW = min(dim_4_values);
maxW = max(dim_4_values);
filename = "./Dokumentace/Generated/4D surface demo 3.gif";
targetDir = replace(filename, ".gif", "/");
if (animate)
    delete(filename);
    cmd_rmdir(targetDir);
end
for i = 1 : length(data)
    n = data{i}{1};
    m = data{i}{2};
    p = data{i}{3};
    q = data{i}{4};
    U = data{i}{5};
    V = data{i}{6};
    P = data{i}{7};
    u = data{i}{8};
    w = data{i}{9};
    points = nurbsSurfaceEval(n, U, m, V, p, q, P, [size(P, 1) + 1, 50]);
    surf(points(:, :, 1), points(:, :, 2), points(:, :, 3));
%     xlim([minXY, maxXY]);
%     ylim([minXY, maxXY]);
    zlim([minZ, maxZ]);
    
    title(latexify(["Interpolace mezi kalibračními tabulkami - zpětný pohyb", "$p = 3, q = 3, g = 1$", "$Ids = " + num2str(w, "%.3f") + "$"]));
    xlabel("$C_{Arc}$");
    ylabel("$Prop$");
    zlabel("Proud");
    colorbar();
    drawnow;
    
    if (~animate)
        break
    end
    exportgraphics(gcf, filename, 'Append', true, "Resolution", 250);    
end
if (animate)
    mkdir(targetDir);
    system("magick " + '"' + filename + '"' + " " + '"' + targetDir + "/frame.png" + '"')  
end






