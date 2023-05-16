function curveInterpolationDemo()
%ALGORITHMCOMPARISON Summary of this function goes here
%   Detailed explanation goes here

% 2D 
Q = [10,0;22,104;318,258;379,195;441,130;688,194;750,64];
plotFcn = @(points, style) (plot(points(:, 1), points(:, 2), style));
legendArgs = ["Location","southeast"];

algorithms = ["EquallySpaced", "ChordLength", "CentripetalMethod"];
styles = ["-", "--", "-."];
degree = 3;

for dim = ["2D", "3D"]
    if (dim == "3D")
        Q = [[3; 1; 8; 0; 2; 7; 3], Q(:, :)];
        plotFcn = @(points, style) (plot3(points(:, 1), points(:, 2), points(:, 3), style));
        zlabel("$z$")
        legendArgs = {"Position", [0.612678169102553 0.275873015873016 0.275059926135542 0.150238092059181]};

        % matlab can't export dashed lines in 3D as vector image
        styles = ["-", "-", "-"];
%         continue;
    end

    str2file(mat2latex(Q), "./Dokumentace/Generated/Interpolační body demo " + dim + ".tex", 1);
    figure("Name", "Demo interpolace křivky " + dim);
    plotFcn(Q, 'o');
    
    title(latexify("Ukázka " + dim + " interpolace"))
    hold on;
    grid on;
    
    for i = 1 : length(algorithms)
        [n, U, P] = globalCurveInterpolation(Q, degree, algorithms(i));
    
        points = nurbsCurveEval(n, degree, U, P);
%         plotFcn(P, '--');
        plotFcn(points, styles(i));
    end
    
    xlabel("$x$");
    ylabel("$y$");
    zlabel("$z$");
    
    legend(latexify(["$\bf{Q}_k$", "Equally spaced", "Chord length", "Centripetal method"]), legendArgs{:});
end
% exportAllNamedFigures("./Dokumentace/Generated/")
end

