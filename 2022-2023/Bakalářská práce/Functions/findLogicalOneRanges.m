function [ranges] = findLogicalOneRanges(logical_values, min_range_length)
%FINDLOGICALONERANGES Summary of this function goes here
%   Detailed explanation goes here
previous_logical = 0;
counter = 0;
current_index = 1;
ranges = nan(1, 2);
for i = 1 : length(logical_values)
    if (previous_logical ~= logical_values(i) && counter > min_range_length)
        ranges(current_index, :) = [i - counter, i];
        counter = 0;
        current_index = current_index + 1;
    elseif (logical_values(i))
        counter = counter + 1;
    else
        counter = 0;
    end


    previous_logical = logical_values(i);
end

if (previous_logical && counter > min_range_length)
    ranges(current_index, :) = [i - counter, i];
end
end

