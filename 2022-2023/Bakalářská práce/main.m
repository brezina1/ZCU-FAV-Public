clc;
clear;
close all;

addpath("../../Common/Matlab");
addpath("Functions\")
addpath("NURBS\")
addpath("NURBS\Demos\")
addpath("Materiály\")
mkdir("Dokumentace/Generated")
set(groot,'defaulttextinterpreter','latex');  
% set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');

syms l varphi(t) m g T b k

% moment síly M = derivace moment hybnosti H - https://cs.wikipedia.org/wiki/Moment_hybnosti
% moment síly M = r x F
% moment hybnosti H = r x m*v

M = -m*g*l*sin(varphi) - b*diff(varphi,t) -k*(varphi) + T;
H = m*l^2*diff(varphi, t);

eq = M == diff(H, t);
eq = isolate(eq, diff(varphi, t, t));

% parametry 
syms g l m b k

% výsledná rovnice pro zrychlení varphi (prozatím jen zkopírovaný z eq)
eq1 = diff(varphi(t), t, t) == -(b*diff(varphi(t), t) - T + k*varphi(t) + g*l*m*sin(varphi(t)))/(l^2*m);

% vyjádření T
syms phi dphi ddphi
eq2 = subs(eq1, {varphi, diff(varphi,t,t), diff(varphi,t)}, {phi, ddphi, dphi});

torque_target_fcn = solve(eq2, T);
torque_target = matlabFunction(torque_target_fcn, 'vars', [g, l, m, k, b, phi, dphi, ddphi]);

demo1DoF(torque_target);
str2file(latex(eq1), "./Dokumentace/Generated/výchozí rovnice pro zrychlení varphi.tex", true);


g = 9.81;
l = 0.5;
m = 1;
k = 0.9;
b = 3;

nurbsDemoVisualizationOnModel(torque_target,g, l, m, k, b, g, l, m * 1.25, k*1.1, b*0.9);

if exist("Materiály\", "dir")
    Q_k = nurbsDemoVisualizationOnRealData();
    save("RealData", "Q_k");
end

animate = false;

curveInterpolationDemo();
%curveInterpolationDemo4D(animate);
curveApproximationDemo();

surfaceInterpolationDemo();
% return;
surfaceInterpolationDemo4D(animate);
surfaceApproximationDemo();

surfaceApproximationGaussDemo();
surfaceApproximationGaussDemo4D(true);

gaussianFunctionsDemo(true);
motionTraceDemo();
currentCalibrationDemo();
exportAllNamedFigures("./Dokumentace/Generated/")






