function [ condpos, id ] = CondPos( seq, id )
%CONDPOS returns indices of observations that come after a particular
%observation (i.e. what are the positions of observations conditionaly
%on the identity of a particular observation). This is very useful for e.g.
%average quantities (that are in a separate array/matrix) conditionaly on a
%particular observation. The function can handle sequences without
%limitations regarding the number of different identities.
%
%Inputs:
%   - "s": a sequence of observations.
%   - "id": the (facultative) list of identities to look for in the input
%   sequence.
%
%Ouputs:
%   - "condpos": a cell-array in which each cell (e.g. condpos{2}) entails
%   an exhaustive list of positions corresponding to the observations that
%   come after observations with a particular identity (i.e. id(2).)
%   - "id": the exhaustive list of different identities from the input
%   sequence.
%
%Usage:
%   >> s = [2 1 2 1 2 2 2 2 1 2];
%   >> [condpos, identities] = CondPos(s);
%   >> identities % will return [1 2]
%   >> condpos{1} % will return positions of observations preceded by
%                   identities(1), here a 1.
%   >> condpos{2} % will return positions of observations preceded by
%                   identities(2), here a 2.
%
%Copyright 2016 Maxime Maheu

% Get the different identities of observations in the sequence
if nargin < 2, id = unique(seq); end
Nid = numel(id);

% For each of these different observations
condpos = cell(1,Nid);
for o = 1:Nid
    
    % Find the positions corresponding to the current observation in the
    % sequence
    pos = find(seq == id(o));
    
    % Get the positions of the next observation
    idxcond = pos + 1;
    
    % Make sure not to look for a position larger than the sequence's
    % length
    idxcond = idxcond(idxcond <= numel(seq));
    
    % Return these indices
    condpos{o} = idxcond;
end

end