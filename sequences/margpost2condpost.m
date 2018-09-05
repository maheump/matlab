function pA = margpost2condpost( pAgB, pBgA, seq )
%MARGPOST2CONDPOST turns the two marginal distributions p(A|B) and p(B|A)
%into a single marginal conditional distribution p(A). In the case of an
%observer that entertain distinct beliefs about both transitions (e.g. an
%observer with fixed beliefs assuming no change points) it allows to fuse
%the beliefs without loosing any information (because when one transition
%is not observed, the corresponding posterior distribution will not be
%updated). For instance (numbers are just for illustration), if:
% seq    = A A A B B B A (input)
% cond   = _ A A A B B B (in the function)
% p(A|B) = 5 5 5 5 4 3 4 (input)
% p(B|A) = 5 4 3 4 4 4 3 (input)
% p(A)   = 5 6 7 6 4 3 4 (output)
%
%Inputs:
%   - "pAgB": a PxN matrix specifying the marginal distribution of p(A|B).
%   - "pBgA": a PxN matrix specifying the marginal distribution of p(B|A).
%   - "seq":  a 1xN array specifying the sequence of binary observations.
%
%Copyright 2018 Maxime Maheu

% Get dimensions
P = size(pAgB,1); % precision of the posterior
N = size(pAgB,2); % number of observations in the sequence

% Check that the dimensions match accross the inputs
if ~all(size(pAgB) == size(pAgB))
    error('The marginal distributions do not have the same size.');
end
if numel(seq) ~= N
    error('The sequences does not have the same size than the distributions.');
end

% Create a conditional vector
cond = [NaN, seq(1:end-1)];

% Prepare the output variable
pA = NaN(P,N);

% For the first observation, it does not matter, both marginal
% distributions should be similar
pA(:,1) = pAgB(:,1);

% For each observation type
for it = 1:2
    
    % Get indices of observations that come after that stimulus
    idx = cond == it;
    
    % Get belief in the frequency of A given the previous observation
    if     it == 1, pA(:,idx) = flipud(pBgA(:,idx)); % inverse
    elseif it == 2, pA(:,idx) =        pAgB(:,idx);
    end
end

end