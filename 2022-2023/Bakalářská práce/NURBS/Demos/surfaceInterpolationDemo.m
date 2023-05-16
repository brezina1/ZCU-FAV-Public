function surfaceInterpolationDemo()
%INTERPOLATIONSURFACEDEMO Summary of this function goes here
%   Detailed explanation goes here
range = -5 : 2 : 5;
[X,Y] = meshgrid(range);
Z = cos(X) + Y;
Q = nan(length(X), length(X), 3);
Q(:, :, 1) = X;
Q(:, :, 2) = Y;
Q(:, :, 3) = Z;

Q_k{1} = Q;

[X, Y, Z] = peaks(6);
Q(:, :, 1) = X;
Q(:, :, 2) = Y;
Q(:, :, 3) = Z;

Q_k{2} = Q;

titles = {["Interpolace funkce $f(x,y) = cos(x) + y$",...
            "$x, y\in\{" + strjoin(cellstr(num2str((range)')),',') + "\}$"],...
            "Interpolace funkce Matlab peaks(6)"};
for i = 1 : 2
    Q = Q_k{i};
    [n,m,U, V, P] = globalSurfaceInterpolation(Q, 3, 3);

    points = nurbsSurfaceEval(n, U, m, V, 3, 3, P);
    
    X = points(:, :, 1);
    Y = points(:, :, 2);
    Z = points(:, :, 3);
    figure("Name", "Demo interpolace povrchu " + i, "Tag", "HighResolutionImage");
    
    entries{1} = plot3(Q(:, :, 1), Q(:, :, 2), Q(:, :, 3), '.', "MarkerSize", 20, Color=[1,0,0]);
    entries{1} = entries{1}(1);
    hold on;
    grid on;
    entries{2} = surf(X,Y,Z);
    alpha 0.85;
%     shading interp  

    title(titles{i});
    xlabel("$x$");
    ylabel("$y$");
    zlabel("$z$");
    legend([entries{:}], latexify(["Interpolační body", "NURBS interpolace"]), "Location", "northeast");
end


% exportAllNamedFigures("./Dokumentace/Generated/")

end

