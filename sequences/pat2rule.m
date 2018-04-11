function rules = pat2rule( pats )
%PAT2RULE finds a restricted set of rules that can reproduce all the input
%(binary) patterns according to the 3 following princinples:
%   - Principle 1: repetition principle  => ABB = AABAAB = AABAABAAB
%   - Principle 2: circularity principle => ABB = BAB = BBA
%   - Principle 3: negative principle    => AAB = BBA (i.e. XXY)
%
%Inputs:
%   - "pats": a cell-array in which each cell entails a binary pattern
%   (the 2 different identities can be coded with any scalar values).
%
%Outputs:
%   - "rules": a cell-array in which each cell entails a binary rule. When
%   the 3 principles listed above are applied on these rules, one can
%   reproduce, at least, all the patterns that were given as input to that
%   function.
%
%Copyright 2016 Maxime Maheu

% Make sure "pats" is a column cell-array
if ~iscell(pats), error('The patterns must be stored in a cell-array.'); end
pats = pats(:);

% Get the number of patterns
nPat = numel(pats);

% Get the patterns' length, and the longest length
patlen = cellfun(@numel, pats);
L = max(patlen);

% Compute the number of siblings a pattern can generate
nsibperpat = patlen .* 2;
cnsibperpat = [0; cumsum(nsibperpat)];

% Prepare output variables
nSib = cnsibperpat(end);
sibs = NaN(nSib,L);
patidx = NaN(nSib,1);

% For each of the provided patterns
for i = 1:nPat
    
    % Get the current pattern and its length
    pat = pats{i};
    N = numel(pat);
    
    % For each observation in that pattern
    for j = 1:N*2
        
        % Get the type of sibling to generate
        p = zeros(1,N);
        if     j <= N, p(pat == max(pat)) = 1; % normal sibling
        elseif j >  N, p(pat == min(pat)) = 1; % reversed sibling
        end
        
        % Create one (the j-th) of all the possible circularity-based siblings
        sib = circshift(p, j);
        
        % Replicate it until it matches the length of the longest pattern(s)
        repsib = repmat(sib, [1, ceil(L/N) + 1]);
        repsib = repsib(1:L);
        
        % Save...
        k = cnsibperpat(i) + j; % ...at position k...
        sibs(k,1:L) = repsib(1:L); % ...the newly created sibling...
        patidx(k) = i; % ...and the index of the pattern from which it has been generated from
    end
end

% Find a restriced set of siblings (unique siblings without doubles)
[~,uniqidx] = unique(sibs, 'rows');

% Get the indices of the patterns from which these siblings were generated from
restpatidx = patidx(uniqidx);

% Remove duplicated patterns' indices
restpatidx = unique(restpatidx);

% Get the patterns from which it is possible to regenerate each and every
% possible siblings we derived in the loop (based on the 3 principles).
% These are the so-called rules.
rules = pats(restpatidx);

end