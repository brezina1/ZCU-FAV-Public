function [u, function_value] = findKnotValueForFunctionValue(n, p, U, P, function_value, dimension, epsilon)
%FINDKNOTVALUEFORFUNCTIONVALUE Funkce k nalezení hodnoty uzlu, kde křivka
% nabývá dané funkční hodnoty pro danou dimenzi s přesností epsilon

test_point_1 = nurbsEvalSinglePoint(n, p, U, P, 0); 
test_point_2 = nurbsEvalSinglePoint(n, p, U, P, 1);
if (test_point_2(dimension) > test_point_1(dimension))
    direction = 1;
else
    direction = -1;
end

min_u = 0;
max_u = 1;

mid_u = (min_u + max_u)/2;
current_function_value = nurbsEvalSinglePoint(n, p, U, P, mid_u);
while(abs(current_function_value(dimension) - function_value) > epsilon)
    if (direction == 1)
        if (current_function_value(dimension) > function_value)
            max_u = mid_u;
        else
            min_u = mid_u;
        end
    else
        if (current_function_value(dimension) < function_value)
            max_u = mid_u;
        else
            min_u = mid_u;
        end
    end

    mid_u = (min_u + max_u)/2;
    current_function_value = nurbsEvalSinglePoint(n, p, U, P, mid_u);
end

u = mid_u;
function_value = current_function_value;
end

