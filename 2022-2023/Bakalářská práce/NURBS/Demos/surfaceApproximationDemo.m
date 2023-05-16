function surfaceApproximationDemo()
%SURFACEAPPROXIMATIONDEMO Summary of this function goes here
%   Detailed explanation goes here

rng('default');

range = -5 : 0.5 : 5;
[X,Y] = meshgrid(range);
Z = cos(X) + Y + rand(size(X)) * 3;
Q = nan(length(X), length(X), 3);
Q(:, :, 1) = X;
Q(:, :, 2) = Y;
Q(:, :, 3) = Z;

Q_k{1} = Q;

[X, Y, Z] = peaks(15);
Q = nan(length(X), length(X), 3);
Q(:, :, 1) = X;
Q(:, :, 2) = Y;
Q(:, :, 3) = Z;

Q_k{2} = Q;

titles = {"Aproximace funkce $f(x,y) = cos(x) + y + 3\cdot rand()$",...
            "Aproximace funkce Matlab peaks(15)"};
control_points = {[1,4], [7,7]};
basis_degree = {[1,3], [3,3]};
camera_positions = {'auto', [-55.8898  -40.1612   15.9252]};
for i = 1 : length(Q_k)
    Q = Q_k{i};
    
    n = control_points{i}(1);
    m = control_points{i}(2);
    p = basis_degree{i}(1);
    q = basis_degree{i}(2);

    [U, V, P] = leastSquaresSurfaceApproximation(Q, p, q, n, m, ones(size(Q, 1:2)));

    points = nurbsSurfaceEval(n, U, m, V, p, q, P);
    
    X = points(:, :, 1);
    Y = points(:, :, 2);
    Z = points(:, :, 3);
    figure("Name", "Demo aproximace povrchu " + i, "Tag", "HighResolutionImage");
    
    entries{1} = plot3(Q(:, :, 1), Q(:, :, 2), Q(:, :, 3), '.', "MarkerSize", 20, Color=[1,0,0]);
    entries{1} = entries{1}(1);
    hold on;
    grid on;
    Q_int = [Q(1, 1, :), Q(end, 1, :), Q(end, end, :), Q(1, end, :)];
    entries{2} = plot3(Q_int(:, :, 1), Q_int(:, :, 2), Q_int(:, :, 3), 'o', "MarkerSize", 7, Color=[1,1,1], MarkerFaceColor=[0.5,0,0.75]);
    entries{3} = surf(X,Y,Z);
   
    alpha 0.85;
    colorbar
%     shading interp  

    title([titles{i}, "$p=" + p + ",q=" + q + ",n=" + n + ",m=" + m + ", \omega_{i,j} = 1$"]);
    xlabel("$x$");
    ylabel("$y$");
    zlabel("$z$");
    legend([entries{:}], latexify(["Aproximační body", "Interpolační body", "NURBS interpolace"]), "Location", "northeast");
    campos(camera_positions{i});
end


[X,Y] = meshgrid(-5 : 0.5 : 5);
% X = [X1, X2; X1, X2];
% Y = [Y1, Y1; Y2, Y2];
Z = nan(size(X));
for x_i = 1 : length(X)
    for y_i = 1 : length(Y)
        x = X(x_i, y_i);
        y = Y(x_i, y_i);
        if mod(y, 1) == 0
            Z(x_i, y_i) = 0;
        else
            Z(x_i, y_i) = 1;
        end
        
    end
end

Q = nan(size(X, 1), size(X, 2), 3);
Q(:, :, 1) = X;
Q(:, :, 2) = Y;
Q(:, :, 3) = Z;
% Q(:,5,3) = cos(X(5,:)) * 0.25 + 0.5;

Q(1,:,3) = 0.5;
Q(end, :,3) = 0.5;
Q(:,1,3) = 0.5;
Q(:,end,3) = 0.5;

Q_corners = [Q(1,1,:); Q(1,end,:); Q(end,1,:); Q(end,end,:)];

W_ = ones(size(Q, 1:2));
w = 30;
W{1} = W_;

W_(ceil(end/2  -1) :2: ceil(end/2  +1), ceil(end/2  -1) : ceil(end/2  +1)) = w;
W{2} = W_;

W_(3,3) = w;
W_(16,5) = w;
W_(6,16) = w;
W{3} = W_;

W_ = ones(size(Q, 1:2));
W_(2:6:end, 2 : end - 1) = w;
W{4} = W_;
ctrl_points = {[3,3], [3,3], [7,7], [10,10]};
cam_pos = {[-44.066329577634505 -58.921845400341859   5.067685116307284], ...
            [-50.771467625353466 -68.768010292930057   1.890031782079654], ...
            [-39.832068514049112 -75.079849589101372   2.162595872634177], ...
            [ -78.766946785243647 -34.971093774175770   3.135603785661069]};

for i = 1 : length(W)
    n = ctrl_points{i}(1);
    m = ctrl_points{i}(2);
    clear entries;

    figure("Name", "Ukázka aproximace povrchu pro různé váhy bodů " + i, "Tag", "HighResolutionImage");
    entries{1} = plot3(Q_corners(:, :, 1), Q_corners(:, :, 2), Q_corners(:, :, 3), 'o', "MarkerSize", 7, Color=[1,1,1], MarkerFaceColor=[0.5,0,0.75]);
    hold on;
    legendEntries = ["Interpolační body"];

    Q_w = Q.*(W{i} == 1);
   
    entries{2} = plot3(Q_w(:, :, 1), Q_w(:, :, 2), Q_w(:, :, 3), '.', 'Color', [0 0.4470 0.7410], "MarkerSize", 15);
    entries{2}  = entries{2}(1);
    if (~isempty(Q_w))
        legendEntries = [legendEntries, "$\bf{Q}_{\rm i,j};\rm \omega_{i,j} = 1$"];
    end

    hits = W{i} == w;
    clear Q_w
    [r, c] = size(hits);
    index = 1;
    for r_i = 1 : r
        for c_i = 1 : c
            if (hits(r_i, c_i))
                Q_w{index} = Q(r_i, c_i, :);
                index = index + 1;
            end
        end
    end

    if (index > 1)
        Q_w = cell2mat(Q_w);
        entries{end + 1} = plot3(Q_w(:, :, 1), Q_w(:, :, 2), Q_w(:, :, 3), '.', 'Color', [0.8500 0.3250 0.0980], "MarkerSize", 15);
        legendEntries = [legendEntries, "$\bf{Q}_{\rm i,j};\rm \omega_{i,j} = " + w + "$"];
    end
    [U, V, P] = leastSquaresSurfaceApproximation(Q, 3,3, n,m, W{i});
    points = nurbsSurfaceEval(n, U, m, V, 3, 3, P);
    entries{end + 1} = surf(points(:, :, 1), points(:, :, 2), points(:, :, 3));
    
    legendEntries = [legendEntries, "NURBS aproximace"];
    legendHandle = legend([entries{:}], latexify(legendEntries), "Location", "southeast");
    transparentLegend(legendHandle, [1, 1, 1, 0.92]);
    title(latexify(["Ukázka aproximace povrchu pro různé váhy bodů", "$p=" + 3 + ",q=" + 3 + ",n=" + n + ",m=" + m + "$"]));
    colorbar;
    xlabel("$x$");
    ylabel("$y$");
    campos(cam_pos{i});
    grid on;
end
end

