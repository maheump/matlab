function f = plotMSEM( x, M, SEM, alpha, colM, colSEM, lwM, lwSEM, ltM, ltSEM )
%PLOTMSEM plot the mean as a line and the SEM as a shaded area around it.
%
%Inputs:
%   - "x": the [1 x n] vector of x-values.
%   - "M": the [1 x n] vector of mean values.
%   - "SEM": the [1 x n] vector of error values.
%   - "alpha": transparenct coefficient of the shadding (>0 and <1).
%   - "colM": the color [R G B] for the mean.
%   - "colSEM": the color [R G B] of the shading ([] set to colM).
%   - "lwM": the line width of the mean ([] set to 1).
%   - "lwSEM": the line width of the mean ([] set to 1).
%   - "ltM": the contour style '-', '--', ':', '-.' or 'none' ([] set to 'none').
%   - "ltSEM": the contour style '-', '--', ':', '-.' or 'none' ([] set to 'none').
%
%Copyright 2015 Maxime Maheu

% Fill the inputs
if isempty(x), x = 1:numel(M); end
if nargin <  4 || isempty(alpha),  alpha = 0.5;      end
if nargin <  5 || isempty(colM),   colM = rand(1,3); end
if nargin <  6 || isempty(colSEM), colSEM = colM;    end
if nargin <  7 || isempty(lwM),    lwM = 1;          end
if nargin <  8 || isempty(lwSEM),  lwSEM = 1;        end
if nargin <  9 || isempty(ltM),    ltM = '-';     end
if nargin < 10 || isempty(ltM),    ltSEM = 'none';   end

% Deal with wrong inputs orientations
if size(x,  1) > size(x,  2), x   = x';   end
if size(M,  1) > size(M,  2), M   = M';   end
if size(SEM,1) > size(SEM,2), SEM = SEM'; end

% Compute the limits of the shaded area
AZ = M + SEM;
BZ = M - SEM;

% Remove NaN values
AZ_ind = find(~isnan(AZ));
x  = x(AZ_ind);
AZ = AZ(AZ_ind);
BZ = BZ(AZ_ind);
M = M(AZ_ind);

% Plot the shaded SEM area
if ~isempty(SEM)
    fill([x, flipud(x')'], [AZ, flipud(BZ')'],...
        'k', ...
        'EdgeColor', colSEM, ... 
        'LineWidth', lwSEM,...
        'LineStyle', ltSEM,...
        'FaceColor', colSEM,...
        'FaceAlpha', alpha); hold('on');
end

% Plot the mean
f = plot(x, M, ltM, 'LineWidth', lwM, 'Color', colM); hold('on');

end