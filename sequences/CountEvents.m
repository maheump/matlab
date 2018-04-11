function [ nX, nXgY, pX, pXgY ] = CountEvents( seq, id )
%COUNTEVENTS returns counts and frequencies for each identity and each
%transition between each observations' identity that are in the input
%sequence. The function can handle sequences without limitations regarding
%the number of different identities.
%
%Input:
%   - "s": a sequence of observation.
%   - "id": the (facultative) list of identities to look for in the input
%   sequence.
%
%Outputs:
%   - "nX" and "pX":     e.g.       | Ag_ | Bg_ | Cg_ |
%                                   |  -  |  -  |  -  |
%
%   - "nXgY" and "pXgY": e.g.       | Ag_ | Bg_ | Cg_ |
%                             | _gA |  -  |  -  |  -  |
%                             | _gB |  -  |  -  |  -  |
%                             | _gC |  -  |  -  |  -  |
%   => "n_" refers to counts
%   => "p_" refers to probabilities/frequencies.
%   To extract e.g. the transition p(B|C) that is C=>B one must call pXgY(3,2)
%
%Copyright 2016 Maxime Maheu

% Intialization
% =============

% Make sure the sequence is a row vector
seq = seq(:)';

% Get the total number of observations in the sequence
N = numel(seq);

% Get the different identities of observations in the sequence
if nargin < 2, id = unique(seq); end
Nid = numel(id);

% Items frequency
% ===============

% Prepare the output
nX = NaN(1,Nid);

% Get the number of observations for each identity
for i = 1:Nid
    nX(i) = sum(seq == id(i));
end

% Convert it into a probability (i.e. a frequency)
pX = nX ./ N;

% Transitions frequency
% =====================

% Get the position of observations that follow (it gives iXgA, iXgB, iXgC)
cidx = CondPos(seq, id);

% Prepare the output
nXgY = NaN(Nid);

% Get the number of observations for each transition
for i = 1:Nid
    for j = 1:Nid
        
        % Get the ist of observations conditionaly on the identity "id(i)"
        cond = seq(cidx{i});
        
        % Count the number of observation whos identity is "id(j)" among
        % that list
        nXgY(i,j) = sum(cond == id(j));
    end
end

% Convert it into a probability (i.e. a frequency)
pXgY = nXgY ./ sum(nXgY,2);

end