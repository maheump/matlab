function rgb = imagesc2image( v, map )
%IMAGESC2IMAGE turns a heat map (with "v" values and "map" colormap) into an
%image (a AxBx3 matrix).
%
%Inputs:
%   - "v" a AxB matrix specifying the values behind the colormap.
%   - "map" a Nx3 matrix specifying the colormap.
%
%Outputs:
%   - "rgb": a AxBx3 matrix entailing the converted heatmap.
%
%Copyright 2016 Maxime Maheu

% Get the precision of the colormap
ncol = size(map,1);

% Scale the heatmap accordingly
s = round(1+(ncol-1)*(v-min(v(:)))/(max(v(:))-min(v(:))));

% Convert indexed image to RGB image
rgb = ind2rgb(s, map);

end