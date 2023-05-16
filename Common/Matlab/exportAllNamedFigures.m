function exportAllNamedFigures(outputDir, fixed_file_extension)
figures = findall(groot, 'Type', 'figure');

for i = 1 : length(figures)
    fig = figures(i);
    tag = get(fig, 'Tag');
    % ignore open simulink scopes, etc.
    if (contains(lower(tag), "simulink"))
        continue;
    end

    name = get(fig, 'Name');
    if (isempty(name))
        continue;
    end

    if (~exist('fixed_file_extension', "var"))
        fixed_file_extension = ".pdf";
    end
%     tag
%     continue;
    if any(strcmpi(tag,'HighResolutionImage'))
        exportgraphics(fig, fullfile(outputDir, name + fixed_file_extension), 'ContentType','image', "Resolution", 394);
    elseif any(strcmpi(tag,'MediumResolutionImage'))
        exportgraphics(fig, fullfile(outputDir, name + fixed_file_extension), 'ContentType','image', "Resolution", 300);
    else
        exportgraphics(fig, fullfile(outputDir, name + fixed_file_extension), 'ContentType','vector');
    end

end
end

