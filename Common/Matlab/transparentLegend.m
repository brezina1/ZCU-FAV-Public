function [] = transparentLegend(legend_handle, color_rgba)
set(legend_handle.BoxFace, 'ColorType','truecoloralpha', 'ColorData',uint8(255*color_rgba'));
end

