function patterns = GenPats( len )
%GENPATS generates all possible patterns whose length(s) correspond to the
%one(s) specifid as input.
%
%Input:
%   - "len": a scalar (e.g. 3) or double-array (e.g. 4:6) specifying of
%   which length the patterns must be produced.
%
%Copyright 2016 Maxime Maheu

% Indexing variables
k = 2.^len;
i = [0, cumsum(k)];
n = sum(k);

% Prepare output
patterns = cell(n,1);

% For each patterns' length
for j = 1:numel(len)

    % Patterns' length
    L = len(j);

    % Find patterns' permutations
    patarray = ff2n(L);

    % Convert it into a cell array
    patcell = mat2cell(patarray, ones(2^L,1), L);

    % Save the patterns in the output variablej(i)+1:j(i+1)
    patterns(i(j)+1:i(j+1)) = patcell;
end

% If there is a single length
if numel(len) == 1
    
    % Return the output as a matrix
    patterns = cell2mat(patterns);
end

end