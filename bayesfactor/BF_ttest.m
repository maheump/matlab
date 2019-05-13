function [ bf10, bf01, t, pval, ci ] = BF_ttest( X, Y, r )
%BF_TTEST quantifies the evidence in favour of the alternative hypothesis
%using  Bayes factor. See Rouder et al. (2009) Psychon Bull Rev for details.
%
%Inputs:
%   - "X": a Nx1 array specifying the values of the first group.
%   - "Y": a Nx1 (optional) array specifying the values of the second
%       group.
%   - "r": a scalar specifying the scaling factor of the Cauchy prior.
%
%Copyright 2016 Maxime Maheu

% Default scale factor
if nargin < 3 || isempty(r), r = 0.707; end

% Get the type of t-test to run
if nargin > 1 && ~isempty(Y)
    
    % One-sample t-test
    if numel(Y) == 1
        M = Y;
        if isnan(M), error(''); end
        
    % Paired t-test
    elseif numel(Y) > 1
        X = X - Y;
        M = 0;
    end
    
% One-sample t-test
else
    M = 0;
end

% Number of observations
n = numel(X);

% Value of t-statistic
[~,pval,ci,stats] = ttest(X,M);
t = stats.tstat;

% Function to be integrated
F = @(g,t,n,r) (1+n.*g.*r.^2).^(-1./2) .* (1 + t.^2./((1+n.*g.*r.^2).*...
    (n-1))).^(-n./2) .* (2.*pi).^(-1./2) .* g.^(-3./2) .* exp(-1./(2.*g));

% Bayes factor for the alternative hypothesis
bf01 = (1 + t^2/(n-1))^(-n/2) / integral(@(g) F(g,t,n,r), 0, Inf);

% Bayes factor for the null hypothesis
bf10 = 1 / bf01;

end