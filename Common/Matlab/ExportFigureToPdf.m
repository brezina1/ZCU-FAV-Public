function [] = ExportFigureToPdf(fig, path)
global EnableExportFigureToPdf;

if (~EnableExportFigureToPdf)
    % backwards compatibility
    enabled = evalin('base', 'EnableExportFigureToPdf');
    if (enabled == false)
        return;
    end
end

% ořízne figure se subplot a i normální plot, ale neumí český znaky (místo
% č hodí #, atd...)
exportgraphics(fig, path, 'ContentType', 'vector');
% exportni to oříznutý ještě jednou, starým, ale funkčním způsobem
set(fig, 'Units', 'Inches');
pos = get(fig,'Position');
% set(fig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)], 'Renderer', 'painters')
set(fig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)], 'Renderer', 'painters')
print(fig, path,'-dpdf','-r0')
end

