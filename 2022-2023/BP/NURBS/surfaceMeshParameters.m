function [uk, vl] = surfaceMeshParameters(Q)
%SURFACEMESHPARAMETERS Summary of this function goes here
%   Detailed explanation goes here
[n, m, ~] = size(Q);

n = n - 1;
m = m - 1;

num = m + 1;

uk(1) = 0;
uk(n + 1) = 1;

for k = 1 : n - 1
    uk(k + 1) = 0;
end


for l = 0 : m
    total = 0;
    for k = 1 : n
        cds(k + 1) = norm(squeeze(Q(k + 1, l + 1, :) - Q(k, l + 1, :)));
        total = total + cds(k + 1);
    end
    if (total == 0)
        num = num - 1;
    else
        d = 0;
        for k = 1 : n - 1
            d = d + cds(k + 1);
            uk(k + 1) = uk(k + 1) + d/total;
        end
    end
end

if num == 0
    error("num == 0");
end

for k = 1 : n - 1
    uk(k + 1) = uk(k + 1) / num;
end






num2 = n + 1;

vl(1) = 0;
vl(m + 1) = 1;

for k = 1 : m - 1
    vl(k + 1) = 0;
end


for k = 0 : n
    total = 0;
    for l = 1 : m
        cds(l + 1) = norm(squeeze(Q(k + 1, l + 1, :) - Q(k + 1, l, :)));
        total = total + cds(l + 1);
    end
    if (total == 0)
        num2 = num2 - 1;
    else
        d = 0;
        for l = 1 : m - 1
            d = d + cds(l + 1);
            vl(l + 1) = vl(l + 1) + d/total;
        end
    end
end

if num == 0
    error("num2 == 0");
end

for k = 1 : m - 1
    vl(k + 1) = vl(k + 1) / num2;
end

end

