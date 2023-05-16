function [] = rescaleFigureAxis(fig, respect_data_values)
%RESCALEFIGUREAXIS Summary of this function goes here
%   Detailed explanation goes here
allAxesInFigure = findall(fig,'type','axes');
axNoLegendsOrColorbars = allAxesInFigure(~ismember(get(allAxesInFigure,'Tag'),{'legend','Colobar'}));

if ~exist("respect_data_values", "var")
    respect_data_values = false;
end

tick_labels = ["XTickLabel", "YTickLabel", "ZTickLabel"];
for axis_i = 1 :  length(axNoLegendsOrColorbars)
    axis = axNoLegendsOrColorbars(axis_i);
    ticks = {axis.XTick, axis.YTick, axis.ZTick};
%     limits = {axis.XLim, axis.YLim, axis.ZLim};
    
    children = get(axis,'Children');
    x_data = get(children, 'XData');
    y_data = get(children, 'YData');
    z_data = get(children, 'ZData');
    
    [x_min, x_max] = getAxisExtremes(x_data);
    [y_min, y_max] = getAxisExtremes(y_data);
    [z_min, z_max] = getAxisExtremes(z_data);

    
    min_max_values = [[x_min, x_max]; [y_min, y_max]; [z_min, z_max]];
    for i = 1 : length(ticks)
        data_min = min_max_values(i, 1);
        data_max = min_max_values(i, 2);
        if (respect_data_values)
            axis_ticks = remapValue(ticks{i}, data_min, data_max, 0, 1);
        else
            axis_ticks = rescale(ticks{i});
        end

        new_labels = cell(length(axis_ticks), 1);
        for j = 1 : length(axis_ticks)
            new_labels{j} = sprintf("%.2g", axis_ticks(j));
        end

        set(axis, tick_labels(i), new_labels);
    end
end
end
function [data_min, data_max] = getAxisExtremes(axis_data)
    data_max = nan;
    data_min = nan;
    for i = length(axis_data)
        data = axis_data{i};
        tmp_min = min(data, [], 'All');
        tmp_max = max(data, [], 'All');
        
        data_max = max(data_max, tmp_max);
        data_min = min(data_min, tmp_min);
    end
end

