function out = sem(X, dim)
%SEM computes the standard error of the mean along one particular
%dimension.
%
%Inputs:
%   - "X": an array or N-dimensionsal matrix.
%   - "dim": a scalar specifying along which dimension to compute the SEM.
%
%Output:
%   - "out': scalar, array or matrix (depending on the dimension(s) of X)
%   specifying the SEM.
%
%Copyright 2015 Maxime Maheu

% By default, compute along the first existing dimension
if nargin < 2 || isempty(dim)
    d = size(X);
    dim = find(d > 1, 1, 'first');
end

% The SEM is the standard deviation divided by the number of observations.
% If there are NaNs in the input, we ignore them both when computing the
% sandard deviation and when counting the number of observations.
out = std(X, [], dim, 'OmitNaN') ./ sqrt(sum(~isnan(X), dim));

end