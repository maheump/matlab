function l = circle( x, y, r, clr )
%CIRCLE plots a circle on the current MATLAB figure.
%
%Inputs:
%   - "x": horizontal coordinate of the circle center.
%   - "y": vertical coordinate of the circle center.
%   - "r": the radius of the circle.
%   - "clr": is the RGB color array.
%
%Copyright 2015 Maxime Maheu

% Get the number of circles to plot
n = numel(x);

% Define default parameters
if nargin < 4, clr = repmat({'k'}, 1, n); end % black circle
if ~iscell(clr), clr = {clr}; end

% Define the angle step size. Bigger values will draw the circle faster but
% with imperfections (not very smooth).
anglestep = 0.01;

% Compute the circle coordinates
ang = 0:anglestep:(2*pi);
xp = r.*cos(ang);
yp = r.*sin(ang);

% Plot the circle
l = NaN(1,n);
for i = 1:n
    l(i) = plot(x(i)+xp(i,:), y(i)+yp(i,:), 'Color', clr{i}); hold('on');
end

% Scale the axes correctly
axis('equal');

end