function [sys] = getStateSpaceRepresentation(g, l, m, k, b)
%GETSTATESPACEREPRESENTATION Funkce která vrátí linearizovaný model v
%podobě stavového popisu
%   g = Gravitační zrychlení
%   l = Délka ramene
%   m = Hmotnost ramene
%   k = Tuhost pružiny
%   b = Koeficient tlumení

A = [0                   1
     (-k-g*l*m)/(l^2*m) -b/(l^2*m)];
B = [0 ;1/(l^2*m)];
C = eye(2);
D = [0;0];

sys = ss(A, B, C, D);
end

