function demo1DoF(torqueFcn)
%DEMO1DOF Summary of this function goes here
%   Detailed explanation goes here

%g l m k b -p-h-i- dphi ddphi
params{1} = {9.81, 0.5, 1, 0.9, 3, 0, 0};
params{2} = {9.81, 0.5, 1.5, 0.9, 3, 0, 0};
params{3} = {9.81, 0.75, 1.5, 0.9, 3, 0, 0};
params{4} = {9.81, 0.75, 1.5, 3, 5, 0, 0};
legendData{length(params)} = "";

range = [-pi , pi];

phi_target = linspace(range(1), range(2), 100);
figure("Name", "1 DoF model - změny parametrů");
for i = 1 : length(params)
    param = params{i};
    plot(phi_target, torqueFcn(param{1}, param{2}, param{3}, param{4}, param{5}, phi_target, param{6}, param{7}));
    hold on;
    xlim([range(1), range(2)]);

    legendData{i} = sprintf("$[g, l, m, k, b] = [%s,%s,%s,%s,%s]$", ...
                            num2str(param{1}),...
                            num2str(param{2}),...
                            num2str(param{3}),...
                            num2str(param{4}),...
                            num2str(param{5}));
end

grid on;
title(latexify(["1 DoF model - potřebný točivý moment pro různé parametry", "$\dot\varphi = \ddot\varphi = 0$"]))
xlabel("$\varphi$")
ylabel("$T$")
legend([legendData{:}], "Location", "Southeast");

end

