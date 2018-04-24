function [ alpha, beta ] = betaparams2betacounts( mu, sigma )
%BETAPARAMS2BETACOUNTS converts the summary statistics of a beta
%distribution (its mean and its variance) into paramaters (alpha and beta)
%
%Inputs:
%   - "mu": a scalar specifying the mean of the beta distribution.
%   - "sigma": a scalar specifying the variance of the beta distribution.
%
%Copyright 2016 Maxime Maheu

alpha = ((1-mu)/sigma - 1/mu) * mu^2;
beta  = alpha * (1/mu - 1);

end

% Chunk of code to check that the function works correctly:
% alpha = 10;
% beta  = 8;
% mu    = alpha / (alpha+beta); % see Gelman et al., p.579
% sigma = (alpha*beta) / ((alpha+beta)^2 * (alpha+beta+1));
% [alpha, beta] = betaparams2betacounts(mu, sigma);