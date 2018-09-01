function [ RMtbl, RM ] = rmANOVA( mat, faclab )
%RMANOVA runs a repeated measures ANOVA on an N-dimensional matrix
%supposing the first dimension (i.e. the number of rows) corresponds to the
%subjects' identity and the remaining dimensions to factors of the repeated
%measures design.
%
%Inputs:
%   - "mat": a N-dimensional matrix (with N > 1).
%   - "faclab": an optional 1x(N-1) cell-array.
%
%Copyright 2015 Maxime Maheu

% Get the number of subjects
nsub = size(mat,1);

% Get design factors
fac = size(mat); % dimensions of the input matrix
fac = fac(2:end); % the first one is the subject dimension
k = numel(fac); % number of design factors
ff = fullfact(fac); % matric of the full factorial design

% Number of repeated measures (i.e. this is a non-mixed model)
r = prod(fac);

% Convert the n-dimensional input matrix into a table whose number of rows
% is the number of subjects and the number of columns equal the number of
% repeated measure by subject (i.e. the product of the number of levels
% across all design factors)
T = array2table(reshape(mat, [nsub, r]));

% Create a table specifying the within-subjects factors
W = array2table(ff); % full factorial design as a table

% By default, use "FacX" factor names
if nargin < 2 || isempty(faclab)
    faclab = cellfun(@(x) sprintf('Fac%1.0f', x), num2cell(1:k), 'UniformOutput', 0);

% If factor names have been defined, make sure they match the number of
% desifn factors
else
    if ~iscell(faclab), faclab = {faclab}; end
    if numel(faclab) ~=k, error('The number of factor labels is not correct.'); end
    
    % If there are spaces in factor names, remove them
    faclab = cellfun(@(x) strrep(x, ' ', ''), faclab, 'UniformOutput', 0);
end

% Specify the name of the factors
W.Properties.VariableNames = faclab; % rename variables
for i = 1:k % turn each factor to a categorial one
    W.(faclab{i}) = categorical(W.(faclab{i}));
end

% Estimate a repeated measure model
try
F = sprintf('Var1-Var%1.0f ~ 1', r);
RM = fitrm(T, F, 'WithinDesign', W);

% Derive corresponding F- and p-values
F = join(W.Properties.VariableNames, '*');
RMtbl = ranova(RM, 'WithinModel', F{:});

% Display an error message if the functions are not available
catch 
warning(['It appears that you do not own the Statistics Toolbox. ', ...
    'The ANOVA functions cannot be evaluated.']);
RMtbl = []; RM = [];
end

end