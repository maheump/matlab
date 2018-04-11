function pats = rule2pat( rule, maxlen )
%RULE2PAT derives all the possible patterns than a given rule can produce
%according to the 3 following princinples:
%   - Principle 1: repetition principle  => ABB = AABAAB = AABAABAAB
%   - Principle 2: circularity principle => ABB = BAB = BBA
%   - Principle 3: negative principle    => AAB = BBA (i.e. XXY)
%
%Inputs:
%   - "rule": a double-array 
%   - "maxlen": the maximum length of patterns to produce (it set a limit
%   for the replication property).
%
%Copyright 2016 Maxime Maheu

% Useful variables
n = numel(rule);
nrep = floor(maxlen/n);

% Prepare patterns' list
pats1 = cell(nrep*2,1);
pats2 = cell(nrep*2*(n-1),1);

% Principle 1: negative-based patterns
for l = 1:2

    % Principle 2: replicated patterns
    for m = 1:nrep
        pats1{m+nrep*(l-1)} = repmat(rule,[1,m]);
    end
end

% Principle 3: circularity principle
for m = 1:numel(pats1)
    for o = 1:(n-1)
        pats2{o+(n-1)*(m-1)} = circshift(pats1{m},o);
    end
end

% Combine the two lists of patterns
pats = [pats1; pats2];
len = cellfun(@numel, pats);

% Sort the patterns
[~,idx] = sort(len);
pats = pats(idx);

end