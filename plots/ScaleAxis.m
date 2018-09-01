function ScaleAxis( axtosc, sptosc, lim )
%SCALEAXIS scales similarly a particular axis across all subplots of a
% figure. It handles "x", "y", "z" and c axes.
%
%Inputs:
%   - "axtosc": the axis to scale across subplots ('x', 'y', ...).
%   - "sptosc": subplots that need to be scaled (default: all).
%   - "lim": the limits used to scaled the axes (default: min and max of
%     current limits).
%
%Copyright 2014 Maxime Maheu

% Fill inputs
if nargin < 1, axtosc = 'y'; end

% Get subplots
h = get(gcf, 'children');
t = get(h, 'type');
ax = find(strcmp(t, 'axes'));

% Select subplots to scale
if nargin < 2 || isempty(ax) || isempty(sptosc)
    sptosc = 1:numel(ax);
end

% Get axis limits
axlim = NaN(numel(sptosc),2);
for sp = 1:numel(sptosc)
    axlim(sp,:) = get(h(ax(sptosc(sp))), [axtosc, 'lim']);
end

% Scale axis according to extreme values
if nargin < 3
    lim = [nanmin(axlim(:)), nanmax(axlim(:))];
end
for sp = 1:numel(sptosc)
    set(h(ax(sptosc(sp))), [axtosc, 'lim'], lim);
end

end